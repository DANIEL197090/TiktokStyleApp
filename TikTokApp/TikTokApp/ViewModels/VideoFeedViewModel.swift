//
//  VideoFeedViewModel.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import Foundation

protocol VideoFeedViewModelDelegate: AnyObject {
    func didLoadVideos()
    func didFailToLoadVideos(error: String)
}

class VideoFeedViewModel {
    
    // MARK: - Properties
    weak var delegate: VideoFeedViewModelDelegate?
    
    private(set) var videos: [Video] = []
    private let networkService: NetworkService
    private let likeStore: LikeStore
    
    var isLoading = false
    
    // MARK: - Initialization
    init(networkService: NetworkService = .shared, likeStore: LikeStore = .shared) {
        self.networkService = networkService
        self.likeStore = likeStore
    }
    
    // MARK: - Public Methods
    
    func loadVideos() {
        guard !isLoading else { return }
        
        isLoading = true
        networkService.fetchAllVideos { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let videos):
                self.videos = videos
                self.delegate?.didLoadVideos()
                
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .invalidURL:
                    errorMessage = "Invalid URL"
                case .noData:
                    errorMessage = "No data received"
                case .decodingError:
                    errorMessage = "Failed to decode response"
                case .serverError(let message):
                    errorMessage = "Server error: \(message)"
                }
                self.delegate?.didFailToLoadVideos(error: errorMessage)
            }
        }
    }
    
    func toggleLike(for videoId: Int) {
        likeStore.toggleLike(videoId: videoId)
    }
    
    func isLiked(videoId: Int) -> Bool {
        return likeStore.isLiked(videoId: videoId)
    }
    
    func getLikeCount(for videoId: Int) -> Int {
        return likeStore.getLikeCount(for: videoId)
    }
    
    func numberOfVideos() -> Int {
        return videos.count
    }
    
    func video(at index: Int) -> Video? {
        guard index >= 0 && index < videos.count else { return nil }
        return videos[index]
    }
}
