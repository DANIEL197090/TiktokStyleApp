//
//  ProfileHostingController.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//


import UIKit
import SwiftUI

/// UIHostingController wrapper for the SwiftUI ProfileView
/// This allows easy integration of the SwiftUI profile into the existing UIKit app
class ProfileHostingController: UIHostingController<ProfileView> {
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        let profileView = ProfileView(viewModel: viewModel)
        super.init(rootView: profileView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        title = "Profile"
        
        // Configure navigation bar for dark theme
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // MARK: - Public Methods
    
    /// Configure the profile with user data
    func configure(with user: VideoUser, from allVideos: [Video]) {
        viewModel.configure(with: user, from: allVideos)
    }
}
