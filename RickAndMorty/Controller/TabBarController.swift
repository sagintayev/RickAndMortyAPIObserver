//
//  TabViewController.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private lazy var charactersVC: UINavigationController = {
        let charactersVC = CharacterMainFeedController()
        let characterSearchController = CharacterSearchController()
        characterSearchController.delegate = charactersVC
        let charactersContainer = ContainerWithSideController(contentController: charactersVC, sideController: characterSearchController)
        charactersContainer.title = "Characters"
        let navController = getNavController(withRoot: charactersContainer)
        navController.tabBarItem = UITabBarItem(title: "Characters", image: nil, selectedImage: nil)
        return navController
    }()
    
    private lazy var locationsVC: UINavigationController = {
        let locationsVC = LocationFeedVC()
        locationsVC.title = "Locations"
        let navController = getNavController(withRoot: locationsVC)
        navController.tabBarItem = UITabBarItem(title: "Locations", image: nil, selectedImage: nil)
        return navController
    }()
    
    private lazy var episodesVC: UINavigationController = {
        let episodesVC = EpisodeTableController()
        episodesVC.title = "Episodes"
        let navController = getNavController(withRoot: episodesVC)
        navController.tabBarItem = UITabBarItem(title: "Episodes", image: nil, selectedImage: nil)
        return navController
    }()
    
    private var tabBarAppearance: UITabBarAppearance = {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIConstants.mainBackgroundColor
        return appearance
    }()
    
    private var navBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIConstants.mainBackgroundColor
        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIConstants.mainTextColor
        tabBar.standardAppearance = tabBarAppearance
        viewControllers = [charactersVC, locationsVC, episodesVC]
        selectedIndex = 0
    }
    
    private func getNavController(withRoot rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.standardAppearance = navBarAppearance
        navController.navigationBar.tintColor = UIConstants.mainTextColor
        return navController
    }
}
