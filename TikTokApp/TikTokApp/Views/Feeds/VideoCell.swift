//
//  VideoCell.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import UIKit

protocol VideoCellDelegate: AnyObject {
    func didTapLike(on cell: VideoCell)
    func didTapUsername(on cell: VideoCell)
}

class VideoCell: UICollectionViewCell {
    
    static let identifier = "VideoCell"
    
    // MARK: - Properties
    weak var delegate: VideoCellDelegate?
    
    private let playerView = VideoPlayerView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    
    // Overlay UI
    private let usernameButton = UIButton(type: .system)
    private let captionLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let likeCountLabel = UILabel()
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    private var video: Video?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .black
        
        // Player view
        contentView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Loading indicator
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        contentView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Error state
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        contentView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        retryButton.setTitle("Retry", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        retryButton.layer.cornerRadius = 8
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        contentView.addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Username button
        usernameButton.setTitleColor(.white, for: .normal)
        usernameButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameButton.contentHorizontalAlignment = .left
        usernameButton.addTarget(self, action: #selector(usernameTapped), for: .touchUpInside)
        contentView.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Caption
        captionLabel.textColor = .white
        captionLabel.font = .systemFont(ofSize: 14)
        captionLabel.numberOfLines = 2
        contentView.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Action buttons stack - right side
        let actionsStack = UIStackView()
        actionsStack.axis = .vertical
        actionsStack.spacing = 24
        actionsStack.alignment = .trailing
        contentView.addSubview(actionsStack)
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Like button
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        likeCountLabel.textColor = .white
        likeCountLabel.font = .systemFont(ofSize: 12)
        likeCountLabel.textAlignment = .center
        
        let likeStack = UIStackView(arrangedSubviews: [likeButton, likeCountLabel])
        likeStack.axis = .vertical
        likeStack.spacing = 4
        likeStack.alignment = .center
        
        // Comment button
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.tintColor = .white
        
        let commentCountLabel = UILabel()
        commentCountLabel.text = "\(Int.random(in: 10...500))"
        commentCountLabel.textColor = .white
        commentCountLabel.font = .systemFont(ofSize: 12)
        commentCountLabel.textAlignment = .center
        
        let commentStack = UIStackView(arrangedSubviews: [commentButton, commentCountLabel])
        commentStack.axis = .vertical
        commentStack.spacing = 4
        commentStack.alignment = .center
        
        // Share button
        shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        shareButton.tintColor = .white
        
        let shareCountLabel = UILabel()
        shareCountLabel.text = "\(Int.random(in: 5...200))"
        shareCountLabel.textColor = .white
        shareCountLabel.font = .systemFont(ofSize: 12)
        shareCountLabel.textAlignment = .center
        
        let shareStack = UIStackView(arrangedSubviews: [shareButton, shareCountLabel])
        shareStack.axis = .vertical
        shareStack.spacing = 4
        shareStack.alignment = .center
        
        actionsStack.addArrangedSubview(likeStack)
        actionsStack.addArrangedSubview(commentStack)
        actionsStack.addArrangedSubview(shareStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 44),
            
            usernameButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            usernameButton.bottomAnchor.constraint(equalTo: captionLabel.topAnchor, constant: -8),
            usernameButton.trailingAnchor.constraint(lessThanOrEqualTo: actionsStack.leadingAnchor, constant: -16),
            
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            captionLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captionLabel.trailingAnchor.constraint(equalTo: actionsStack.leadingAnchor, constant: -16),
            
            actionsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            commentButton.widthAnchor.constraint(equalToConstant: 44),
            commentButton.heightAnchor.constraint(equalToConstant: 44),
            shareButton.widthAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Configuration
    func configure(with video: Video, isLiked: Bool, likeCount: Int) {
        self.video = video
        
        usernameButton.setTitle("@\(video.user.name)", for: .normal)
        
        // Use first tag as caption
        let caption = video.tags.first ?? "Amazing video!"
        captionLabel.text = caption
        
        likeButton.isSelected = isLiked
        likeButton.tintColor = isLiked ? .systemPink : .white
        likeCountLabel.text = formatCount(likeCount)
        
        // Load video
        if let videoURL = video.bestVideoURL {
            showLoading()
            
            // Set callback to hide loader when video is ready
            playerView.onReadyToPlay = { [weak self] in
                self?.loadingIndicator.stopAnimating()
            }
            
            playerView.configure(with: videoURL)
        } else {
            showError("Video URL not available")
        }
    }
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func stop() {
        playerView.stop()
    }
    
    // MARK: - Actions
    @objc private func likeTapped() {
        delegate?.didTapLike(on: self)
    }
    
    @objc private func usernameTapped() {
        delegate?.didTapUsername(on: self)
    }
    
    @objc private func retryTapped() {
        if let video = video, let videoURL = video.bestVideoURL {
            showLoading()
            
            // Set callback to hide loader when video is ready
            playerView.onReadyToPlay = { [weak self] in
                self?.loadingIndicator.stopAnimating()
            }
            
            playerView.configure(with: videoURL)
        }
    }
    
    // MARK: - UI States
    private func showLoading() {
        loadingIndicator.startAnimating()
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
    
    private func showError(_ message: String) {
        loadingIndicator.stopAnimating()
        errorLabel.text = message
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }
    
    // MARK: - Helpers
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000.0)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        } else {
            return "\(count)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.stop()
        loadingIndicator.stopAnimating()
    }
}
