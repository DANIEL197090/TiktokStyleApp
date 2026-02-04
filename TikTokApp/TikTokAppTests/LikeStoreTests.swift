//
//  LikeStoreTests.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import XCTest
@testable import TikTokApp

class LikeStoreTests: XCTestCase {
    
    var likeStore: LikeStore!
    
    override func setUp() {
        super.setUp()
        likeStore = LikeStore.shared
        // Clear any previous data
        UserDefaults.standard.removeObject(forKey: "videoLikes")
        UserDefaults.standard.removeObject(forKey: "videoLikeCounts")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "videoLikes")
        UserDefaults.standard.removeObject(forKey: "videoLikeCounts")
        likeStore = nil
        super.tearDown()
    }
    
    func testToggleLikeAddsVideo() {
        // Given
        let videoId = 123
        
        // When
        likeStore.toggleLike(videoId: videoId)
        
        // Then
        XCTAssertTrue(likeStore.isLiked(videoId: videoId))
    }
    
    func testToggleLikeRemovesVideo() {
        // Given
        let videoId = 456
        likeStore.toggleLike(videoId: videoId) // Like first
        
        // When
        likeStore.toggleLike(videoId: videoId) // Unlike
        
        // Then
        XCTAssertFalse(likeStore.isLiked(videoId: videoId))
    }
    
    func testLikeCountIncrementsOnLike() {
        // Given
        let videoId = 789
        let initialCount = likeStore.getLikeCount(for: videoId)
        
        // When
        likeStore.toggleLike(videoId: videoId)
        let afterLikeCount = likeStore.getLikeCount(for: videoId)
        
        // Then
        XCTAssertEqual(afterLikeCount, initialCount + 1)
    }
    
    func testLikeCountDecrementsOnUnlike() {
        // Given
        let videoId = 101
        likeStore.toggleLike(videoId: videoId) // Like first
        let likedCount = likeStore.getLikeCount(for: videoId)
        
        // When
        likeStore.toggleLike(videoId: videoId) // Unlike
        let afterUnlikeCount = likeStore.getLikeCount(for: videoId)
        
        // Then
        XCTAssertEqual(afterUnlikeCount, likedCount - 1)
    }
    
    func testLikeCountNeverNegative() {
        // Given
        let videoId = 202
        
        // When - Unlike without ever liking
        likeStore.toggleLike(videoId: videoId) // Like
        likeStore.toggleLike(videoId: videoId) // Unlike
        likeStore.toggleLike(videoId: videoId) // Like again
        likeStore.toggleLike(videoId: videoId) // Unlike again
        let count = likeStore.getLikeCount(for: videoId)
        
        // Then
        XCTAssertGreaterThanOrEqual(count, 0)
    }
}
