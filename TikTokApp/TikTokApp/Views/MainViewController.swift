//
//  MainTabBarController.swift
//  TikTokVideoFeed
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureAppearance()
    }
    
    private func setupTabs() {
        // Feed Tab
        let feedViewModel = VideoFeedViewModel()
        let feedVC = VideoFeedViewController(viewModel: feedViewModel)
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        feedNav.navigationBar.isHidden = true
        
        // Profile Tab (SwiftUI version)
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileHostingController(viewModel: profileViewModel)
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [feedNav, profileNav]
    }
    
    private func configureAppearance() {
        tabBar.barStyle = .black
        tabBar.backgroundColor = .black
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
    }
}
