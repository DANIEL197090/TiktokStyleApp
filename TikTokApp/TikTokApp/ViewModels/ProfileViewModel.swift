//
//  ProfileViewModel.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    // MARK: - Properties
    private let likeStore: LikeStore
    @Published var userVideos: [Video] = []
    @Published var username: String = "Unknown"
    @Published var userId: Int = 0
    @Published var followerCount: Int = 0
    @Published var followingCount: Int = 0
    
    // Demo video URLs for profile display
    @Published var demoVideoURLs: [String] = [
        "https://videos.pexels.com/video-files/3722009/3722009-sd_960_540_24fps.mp4",
        "https://videos.pexels.com/video-files/3722009/3722009-hd_1920_1080_24fps.mp4",
        "https://videos.pexels.com/video-files/5104532/5104532-hd_1920_1080_30fps.mp4",
        "https://videos.pexels.com/video-files/5104532/5104532-sd_960_540_30fps.mp4"
    ]
    
    // MARK: - Initialization
    init(likeStore: LikeStore = .shared) {
        self.likeStore = likeStore
        self.followerCount = Int.random(in: 1000...100000)
        self.followingCount = Int.random(in: 100...500)
    }
    
    // MARK: - Public Methods
    
    func configure(with user: VideoUser, from allVideos: [Video]) {
        self.username = user.name
        self.userId = user.id
        
        // Get all videos from this user (or use random subset for demo)
        // Since API returns videos from different users, we'll create a mock profile
        // with random videos
        self.userVideos = Array(allVideos.shuffled().prefix(12))
    }
    
    func numberOfVideos() -> Int {
        return userVideos.count
    }
    
    func getTotalLikes() -> Int {
        return likeStore.getTotalLikes(for: userId, in: userVideos)
    }
    
    func video(at index: Int) -> Video? {
        guard index >= 0 && index < userVideos.count else { return nil }
        return userVideos[index]
    }
}
