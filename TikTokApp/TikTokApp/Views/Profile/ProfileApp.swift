
//
//  ProfileApp.swift

//  Created by Ifeanyi Mbata on 02/02/2026.
//
//  This file provides a standalone SwiftUI App for previewing the Profile screen
//  You can use this as an entry point for SwiftUI previews or standalone testing

import SwiftUI

/// Standalone SwiftUI App for Profile screen testing
/// This is useful for developing and previewing the profile screen independently
/// NOTE: To use this as the main entry point, remove @main from AppDelegate
/// and uncomment the @main attribute below
// @main
struct ProfileApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ProfileView()
                    .navigationBarHidden(true)
            }
            .preferredColorScheme(.dark)
        }
    }
}

/// Alternative: Profile screen with navigation bar
struct ProfileAppWithNav: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ProfileView()
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .preferredColorScheme(.dark)
        }
    }
}

/// For testing with sample data
struct ProfileWithDataApp: App {
    @StateObject private var viewModel: ProfileViewModel
    
    init() {
        let vm = ProfileViewModel()
        _viewModel = StateObject(wrappedValue: vm)
        
        // Configure with sample data
        let sampleUser = VideoUser(id: 1, name: "creator_user", url: "https://example.com")
        // Note: You would populate sampleVideos with actual Video objects
        // vm.configure(with: sampleUser, from: sampleVideos)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ProfileView(viewModel: viewModel)
            }
            .preferredColorScheme(.dark)
        }
    }
}
