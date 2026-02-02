//
//  Constants.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//


import Foundation

enum Constants {
    static let pexelsAPIKey = "YOUR_PEXELS_API_KEY_HERE"
    static let baseURL = "https://api.pexels.com"
    
    enum Endpoints {
        static let videoSearch = "/videos/search"
    }
    
    enum VideoFetch {
        static let query = "people"
        static let perPage = 80
        static let totalVideos = 200
    }
}
