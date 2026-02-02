//
//  VideoResponse.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//


import Foundation

// MARK: - Top-level response
struct VideoResponse: Codable {
    let page: Int?
    let perPage: Int?
    let videos: [Video]
    let totalResults: Int?
    let nextPage: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case videos
        case totalResults = "total_results"
        case nextPage = "next_page"
        case url
    }
}

// MARK: - Video
struct Video: Codable {
    let id: Int
    let width: Int
    let height: Int
    let duration: Int
    let fullRes: String?
    let tags: [String]
    let url: String
    let image: String
    let avgColor: String?
    let user: VideoUser
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]

    enum CodingKeys: String, CodingKey {
        case id, width, height, duration
        case fullRes = "full_res"
        case tags, url, image
        case avgColor = "avg_color"
        case user
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }
    
    // Helper to get best quality video URL
    var bestVideoURL: String? {
        // Filter out files without links
        let validFiles = videoFiles.filter { !$0.link.isEmpty }
        
        guard !validFiles.isEmpty else { return nil }
        
        // Sort by quality: hd > sd > nil, then by width
        let sortedFiles = validFiles.sorted { file1, file2 in
            let quality1 = file1.quality ?? ""
            let quality2 = file2.quality ?? ""
            let width1 = file1.width ?? 0
            let width2 = file2.width ?? 0
            
            // Prefer HD quality
            if quality1 == "hd" && quality2 != "hd" {
                return true
            }
            if quality1 != "hd" && quality2 == "hd" {
                return false
            }
            
            // If same quality, prefer larger width
            return width1 > width2
        }
        return sortedFiles.first?.link
    }
}

// MARK: - User
struct VideoUser: Codable {
    let id: Int
    let name: String
    let url: String
}

// MARK: - Video File
struct VideoFile: Codable {
    let id: Int
    let quality: String?  // Can be null in API
    let fileType: String
    let width: Int?       // Can be null
    let height: Int?      // Can be null
    let fps: Double?      // Can be null
    let link: String
    let size: Int?        // Can be null

    enum CodingKeys: String, CodingKey {
        case id, quality, width, height, fps, link, size
        case fileType = "file_type"
    }
}

// MARK: - Video Picture
struct VideoPicture: Codable {
    let id: Int
    let nr: Int
    let picture: String
}
