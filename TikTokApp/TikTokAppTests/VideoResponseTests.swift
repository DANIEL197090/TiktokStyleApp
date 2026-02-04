//
//  VideoResponseTests.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import XCTest
@testable import TikTokApp

class VideoResponseTests: XCTestCase {
    
    func testVideoResponseDecoding() throws {
        // Given
        let json = """
        {
            "page": 1,
            "per_page": 80,
            "videos": [
                {
                    "id": 123,
                    "width": 1920,
                    "height": 1080,
                    "duration": 30,
                    "full_res": null,
                    "tags": ["nature", "people"],
                    "url": "https://example.com/video",
                    "image": "https://example.com/image.jpg",
                    "avg_color": "#000000",
                    "user": {
                        "id": 456,
                        "name": "John Doe",
                        "url": "https://example.com/user"
                    },
                    "video_files": [
                        {
                            "id": 789,
                            "quality": "hd",
                            "file_type": "video/mp4",
                            "width": 1920,
                            "height": 1080,
                            "fps": 30.0,
                            "link": "https://example.com/video.mp4",
                            "size": 1024000
                        }
                    ],
                    "video_pictures": [
                        {
                            "id": 1,
                            "nr": 0,
                            "picture": "https://example.com/thumb.jpg"
                        }
                    ]
                }
            ],
            "total_results": 200,
            "next_page": "https://api.pexels.com/videos/search?page=2",
            "url": "https://api.pexels.com/videos/search?page=1"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let response = try decoder.decode(VideoResponse.self, from: data)
        
        // Then
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.perPage, 80)
        XCTAssertEqual(response.videos.count, 1)
        XCTAssertEqual(response.totalResults, 200)
        XCTAssertEqual(response.nextPage, "https://api.pexels.com/videos/search?page=2")
        
        let video = response.videos[0]
        XCTAssertEqual(video.id, 123)
        XCTAssertEqual(video.width, 1920)
        XCTAssertEqual(video.height, 1080)
        XCTAssertEqual(video.duration, 30)
        XCTAssertEqual(video.tags, ["nature", "people"])
        XCTAssertEqual(video.user.name, "John Doe")
        XCTAssertEqual(video.videoFiles.count, 1)
        XCTAssertEqual(video.videoPictures.count, 1)
    }
    
    func testBestVideoURLSelection() {
        // Given
        let hdFile = VideoFile(
            id: 1,
            quality: "hd",
            fileType: "video/mp4",
            width: 1920,
            height: 1080,
            fps: 30.0,
            link: "https://example.com/hd.mp4",
            size: 2048000
        )
        
        let sdFile = VideoFile(
            id: 2,
            quality: "sd",
            fileType: "video/mp4",
            width: 640,
            height: 480,
            fps: 30.0,
            link: "https://example.com/sd.mp4",
            size: 512000
        )
        
        let user = VideoUser(id: 1, name: "Test User", url: "https://example.com")
        
        let video = Video(
            id: 1,
            width: 1920,
            height: 1080,
            duration: 30,
            fullRes: nil,
            tags: ["test"],
            url: "https://example.com",
            image: "https://example.com/image.jpg",
            avgColor: nil,
            user: user,
            videoFiles: [sdFile, hdFile], // SD first to test sorting
            videoPictures: []
        )
        
        // When
        let bestURL = video.bestVideoURL
        
        // Then
        XCTAssertEqual(bestURL, "https://example.com/hd.mp4")
    }
    
    func testBestVideoURLWithOnlySD() {
        // Given
        let sdFile = VideoFile(
            id: 1,
            quality: "sd",
            fileType: "video/mp4",
            width: 640,
            height: 480,
            fps: 30.0,
            link: "https://example.com/sd.mp4",
            size: 512000
        )
        
        let user = VideoUser(id: 1, name: "Test User", url: "https://example.com")
        
        let video = Video(
            id: 1,
            width: 640,
            height: 480,
            duration: 30,
            fullRes: nil,
            tags: ["test"],
            url: "https://example.com",
            image: "https://example.com/image.jpg",
            avgColor: nil,
            user: user,
            videoFiles: [sdFile],
            videoPictures: []
        )
        
        // When
        let bestURL = video.bestVideoURL
        
        // Then
        XCTAssertEqual(bestURL, "https://example.com/sd.mp4")
    }
    
    func testBestVideoURLWithNoFiles() {
        // Given
        let user = VideoUser(id: 1, name: "Test User", url: "https://example.com")
        
        let video = Video(
            id: 1,
            width: 640,
            height: 480,
            duration: 30,
            fullRes: nil,
            tags: ["test"],
            url: "https://example.com",
            image: "https://example.com/image.jpg",
            avgColor: nil,
            user: user,
            videoFiles: [],
            videoPictures: []
        )
        
        // When
        let bestURL = video.bestVideoURL
        
        // Then
        XCTAssertNil(bestURL)
    }
}
