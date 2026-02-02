//
//  NetworkService.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    /// Fetch videos from Pexels API
    func fetchVideos(page: Int, perPage: Int = 80, completion: @escaping (Result<VideoResponse, NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: "\(Constants.baseURL)\(Constants.Endpoints.videoSearch)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: Constants.VideoFetch.query),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Print the URL being called
        print("🌐 Calling API: \(url.absoluteString)")
        print("📋 Page: \(page), Per Page: \(perPage)")
        
        var request = URLRequest(url: url)
        request.setValue(Constants.pexelsAPIKey, forHTTPHeaderField: "Authorization")
        print("🔑 API Key: \(Constants.pexelsAPIKey.prefix(10))...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let videoResponse = try decoder.decode(VideoResponse.self, from: data)
                
                // Log success
                print("✅ Successfully decoded \(videoResponse.videos.count) videos from page \(page)")
                
                completion(.success(videoResponse))
            } catch {
                print("❌ Decoding error: \(error)")
                
                // Print raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Raw JSON response (first 500 chars):")
                    print(String(jsonString.prefix(500)))
                }
                
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    /// Fetch all 200 videos across multiple pages (thread-safe and ordered)
    func fetchAllVideos(completion: @escaping (Result<[Video], NetworkError>) -> Void) {
        // Use a dictionary to store results by page index to preserve order
        var pages: [Int: [Video]] = [:]
        let group = DispatchGroup()
        let lock = NSLock() // For thread-safe access to pages dict and error
        var fetchError: NetworkError?
        
        // We want 200 videos, so we fetch 3 pages of 80 (240 total) and trim later
        // Page 1: 1-80
        // Page 2: 81-160
        // Page 3: 161-240
        let pagesToFetch = [1, 2, 3]
        
        for page in pagesToFetch {
            group.enter()
            fetchVideos(page: page, perPage: 80) { result in
                lock.lock()
                defer { lock.unlock() }
                
                switch result {
                case .success(let response):
                    pages[page] = response.videos
                case .failure(let error):
                    // Keep the first error found
                    if fetchError == nil {
                        fetchError = error
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
                return
            }
            
            // Combine pages in order
            var allVideos: [Video] = []
            for page in pagesToFetch.sorted() {
                if let videos = pages[page] {
                    allVideos.append(contentsOf: videos)
                }
            }
            
            // Trim to exactly 200 videos as requested
            let finalVideos = Array(allVideos.prefix(200))
            print("🎉 Completed fetching all videos. Total count: \(finalVideos.count)")
            
            completion(.success(finalVideos))
        }
    }
}
