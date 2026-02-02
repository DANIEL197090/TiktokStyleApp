//
//  ProfileView.swift
//  TikTokVideoFeed
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import SwiftUI
import AVKit
import AVFoundation
import CoreMedia

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedVideoURL: String?
    @State private var showVideoPlayer = false
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                profileHeader
                
                // Stats Section
                statsSection
                
                // Action Buttons
                actionButtons
                
                // Videos Grid
                videosGrid
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showVideoPlayer) {
            if let urlString = selectedVideoURL, let url = URL(string: urlString) {
                ProfileVideoPlayerView(url: url)
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.98, green: 0.27, blue: 0.42),
                                Color(red: 0.36, green: 0.35, blue: 0.95)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 106, height: 106)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 90, height: 90)
            }
            .padding(.top, 20)
            
            // Username
            Text("@\(viewModel.username)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            // Bio (optional, demo text)
            if !viewModel.demoVideoURLs.isEmpty {
                Text("Creating awesome content 🎥 ✨")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 0) {
            StatView(
                title: "Following",
                value: "\(formatCount(Int.random(in: 100...500)))"
            )
            
            Divider()
                .frame(height: 40)
                .background(Color.gray.opacity(0.3))
            
            StatView(
                title: "Followers",
                value: "\(formatCount(Int.random(in: 1000...100000)))"
            )
            
            Divider()
                .frame(height: 40)
                .background(Color.gray.opacity(0.3))
            
            StatView(
                title: "Likes",
                value: "\(formatCount(viewModel.getTotalLikes()))"
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 8) {
            Button(action: {
                // Edit profile action
            }) {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Edit Profile")
                        .font(.system(size: 15, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .foregroundColor(.white)
                .background(Color.white.opacity(0.15))
                .cornerRadius(4)
            }
            
            Button(action: {
                // Share profile action
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    // MARK: - Videos Grid
    private var videosGrid: some View {
        VStack(spacing: 0) {
            // Tab Bar
            HStack {
                Image(systemName: "square.grid.3x3.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
            }
            .padding(.vertical, 12)
            .overlay(
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 0)
                    .frame(width: UIScreen.main.bounds.width / 2),
                alignment: .bottom
            )
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Videos Grid
            if viewModel.demoVideoURLs.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "video.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No videos yet")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(Array(viewModel.demoVideoURLs.enumerated()), id: \.offset) { index, videoURL in
                        SimpleVideoThumbnailView(videoURL: videoURL, index: index)
                            .aspectRatio(9/16, contentMode: .fill)
                            .onTapGesture {
                                selectedVideoURL = videoURL
                                showVideoPlayer = true
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000.0)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        } else {
            return "\(count)"
        }
    }
}

// MARK: - Stat View Component
struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Video Thumbnail View
struct VideoThumbnailView: View {
    let video: Video
    @State private var isLiked: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Thumbnail Image
                AsyncImage(url: URL(string: video.image)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .tint(.white)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "video.slash")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                
                // Play icon overlay
                Image(systemName: "play.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4)
                
                // View count overlay
                HStack(spacing: 4) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                    Text("\(formatViewCount())")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.6))
                .cornerRadius(4)
                .padding(8)
            }
        }
    }
    
    private func formatViewCount() -> String {
        let count = Int.random(in: 1000...5000000)
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000.0)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        } else {
            return "\(count)"
        }
    }
}

// MARK: - Simple Video Thumbnail View (for URL strings)
struct SimpleVideoThumbnailView: View {
    let videoURL: String
    let index: Int
    @State private var thumbnail: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background/Thumbnail
                if let image = thumbnail {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    // Gradient placeholder while loading
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.1, green: 0.1, blue: 0.1),
                                    Color(red: 0.2, green: 0.2, blue: 0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            ProgressView()
                                .tint(.white)
                        )
                }
                
                // Play icon overlay
                Image(systemName: "play.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // View count overlay (random for demo)
                HStack(spacing: 4) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                    Text(randomViewCount())
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.6))
                .cornerRadius(4)
                .padding(8)
            }
        }
        .onAppear {
            generateThumbnail()
        }
    }
    
    private func randomViewCount() -> String {
        let count = Int.random(in: 1000...900000)
        return count > 1000 ? String(format: "%.1fK", Double(count)/1000.0) : "\(count)"
    }
    
    private func generateThumbnail() {
        guard let url = URL(string: videoURL) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            do {
                let time = CMTime(seconds: 1, preferredTimescale: 60)
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                
                DispatchQueue.main.async {
                    self.thumbnail = uiImage
                }
            } catch {
                print("Error generating thumbnail: \(error)")
            }
        }
    }
}

struct ProfileVideoPlayerView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: AVPlayer(url: url))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // Auto-play when view appears
                    NotificationCenter.default.post(name: NSNotification.Name("PlayVideo"), object: nil)
                }
            
            // Close button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
