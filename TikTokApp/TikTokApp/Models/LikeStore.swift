//
//  LikeStore.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import Foundation

/// Local persistence layer for video likes using UserDefaults
class LikeStore {
    static let shared = LikeStore()
    
    private let defaults = UserDefaults.standard
    private let likesKey = "videoLikes"
    private let likeCountsKey = "videoLikeCounts"
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Check if a video is liked
    func isLiked(videoId: Int) -> Bool {
        let likedVideos = getLikedVideos()
        return likedVideos.contains(videoId)
    }
    
    /// Toggle like status for a video
    func toggleLike(videoId: Int) {
        var likedVideos = getLikedVideos()
        var likeCounts = getLikeCounts()
        
        if likedVideos.contains(videoId) {
            // Unlike
            likedVideos.removeAll { $0 == videoId }
            let currentCount = likeCounts[String(videoId)] ?? getDefaultLikeCount(for: videoId)
            likeCounts[String(videoId)] = max(0, currentCount - 1)
        } else {
            // Like
            likedVideos.append(videoId)
            let currentCount = likeCounts[String(videoId)] ?? getDefaultLikeCount(for: videoId)
            likeCounts[String(videoId)] = currentCount + 1
        }
        
        saveLikedVideos(likedVideos)
        saveLikeCounts(likeCounts)
    }
    
    /// Get like count for a video
    func getLikeCount(for videoId: Int) -> Int {
        let likeCounts = getLikeCounts()
        return likeCounts[String(videoId)] ?? getDefaultLikeCount(for: videoId)
    }
    
    private func getDefaultLikeCount(for videoId: Int) -> Int {
        // Deterministic initial count based on videoId for consistent demo data
        return 100 + (abs(videoId.hashValue) % 10000)
    }
    
    /// Get total likes for a user (across all videos)
    func getTotalLikes(for userId: Int, in videos: [Video]) -> Int {
        let userVideos = videos.filter { $0.user.id == userId }
        return userVideos.reduce(0) { total, video in
            total + getLikeCount(for: video.id)
        }
    }
    
    // MARK: - Private Methods
    
    private func getLikedVideos() -> [Int] {
        return defaults.array(forKey: likesKey) as? [Int] ?? []
    }
    
    private func saveLikedVideos(_ videos: [Int]) {
        defaults.set(videos, forKey: likesKey)
    }
    
    private func getLikeCounts() -> [String: Int] {
        return defaults.dictionary(forKey: likeCountsKey) as? [String: Int] ?? [:]
    }
    
    private func saveLikeCounts(_ counts: [String: Int]) {
        defaults.set(counts, forKey: likeCountsKey)
    }
}
