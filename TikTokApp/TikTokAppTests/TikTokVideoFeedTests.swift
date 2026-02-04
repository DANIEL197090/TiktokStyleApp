//
//  TikTokVideoFeedTests.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import XCTest
@testable import TikTokApp

class VideoFeedViewModelTests: XCTestCase {
    
    var viewModel: VideoFeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = VideoFeedViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertEqual(viewModel.numberOfVideos(), 0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testToggleLike() {
        // Given
        let videoId = 123
        
        // When - First toggle (like)
        viewModel.toggleLike(for: videoId)
        
        // Then
        XCTAssertTrue(viewModel.isLiked(videoId: videoId))
        
        // When - Second toggle (unlike)
        viewModel.toggleLike(for: videoId)
        
        // Then
        XCTAssertFalse(viewModel.isLiked(videoId: videoId))
    }
    
    func testGetLikeCount() {
        // Given
        let videoId = 456
        
        // When
        let initialCount = viewModel.getLikeCount(for: videoId)
        
        // Then - Should return a random count initially
        XCTAssertGreaterThan(initialCount, 0)
        
        // When - Like the video
        viewModel.toggleLike(for: videoId)
        let afterLikeCount = viewModel.getLikeCount(for: videoId)
        
        // Then - Count should increase
        XCTAssertEqual(afterLikeCount, initialCount + 1)
    }
    
    func testVideoAtIndex() {
        // Given - Empty videos
        
        // When
        let video = viewModel.video(at: 0)
        
        // Then
        XCTAssertNil(video)
    }
    
    func testVideoAtInvalidIndex() {
        // When
        let video = viewModel.video(at: -1)
        
        // Then
        XCTAssertNil(video)
    }
}
