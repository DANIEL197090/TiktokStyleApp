//
//  VideoFeedViewController.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import UIKit

class VideoFeedViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: VideoFeedViewModel
    private var collectionView: UICollectionView!
    private let loadingView = UIActivityIndicatorView(style: .large)
    private var currentIndex: Int = 0
    
    // MARK: - Initialization
    init(viewModel: VideoFeedViewModel = VideoFeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.loadVideos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playCurrentVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseCurrentVideo()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.bounds.size
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Loading view
        loadingView.color = .white
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingView.startAnimating()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Video Playback
    private func playCurrentVideo() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoCell {
            cell.play()
        }
    }
    
    private func pauseCurrentVideo() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoCell {
            cell.pause()
        }
    }
    
    private func stopAllVideos() {
        for cell in collectionView.visibleCells {
            if let videoCell = cell as? VideoCell {
                videoCell.stop()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension VideoFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfVideos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as? VideoCell,
              let video = viewModel.video(at: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        let isLiked = viewModel.isLiked(videoId: video.id)
        let likeCount = viewModel.getLikeCount(for: video.id)
        
        cell.configure(with: video, isLiked: isLiked, likeCount: likeCount)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension VideoFeedViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)
        
        if pageIndex != currentIndex {
            // Stop previous video
            stopAllVideos()
            
            // Update current index
            currentIndex = pageIndex
            
            // Play new video
            playCurrentVideo()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - VideoCellDelegate
extension VideoFeedViewController: VideoCellDelegate {
    func didTapLike(on cell: VideoCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              let video = viewModel.video(at: indexPath.item) else {
            return
        }
        
        viewModel.toggleLike(for: video.id)
        
        // Update cell
        let isLiked = viewModel.isLiked(videoId: video.id)
        let likeCount = viewModel.getLikeCount(for: video.id)
        cell.configure(with: video, isLiked: isLiked, likeCount: likeCount)
    }
    
    func didTapUsername(on cell: VideoCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              let video = viewModel.video(at: indexPath.item) else {
            return
        }
        
        // Navigate to profile
        let profileViewModel = ProfileViewModel()
        profileViewModel.configure(with: video.user, from: viewModel.videos)
        
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - VideoFeedViewModelDelegate
extension VideoFeedViewController: VideoFeedViewModelDelegate {
    func didLoadVideos() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.collectionView.reloadData()
            
            // Play first video after reload completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playCurrentVideo()
            }
        }
    }
    
    func didFailToLoadVideos(error: String) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self.loadingView.startAnimating()
                self.viewModel.loadVideos()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}
