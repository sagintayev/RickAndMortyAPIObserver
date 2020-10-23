//
//  TabViewController.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var charactersVC: UINavigationController = {
        let charactersVC = CharacterFeedController()
        let characterSearchController = CharacterSearchController()
        characterSearchController.delegate = charactersVC
        let charactersContainer = ContainerWithSideController(contentController: charactersVC, sideController: characterSearchController)
        charactersContainer.title = "Characters"
        let navController = UINavigationController(rootViewController: charactersContainer)
        navController.tabBarItem = UITabBarItem(title: "Characters", image: nil, selectedImage: nil)
        return navController
    }()
    
    var locationsVC: UINavigationController = {
        let locationsVC = LocationFeedVC()
        locationsVC.title = "Locations"
        let navController = UINavigationController(rootViewController: locationsVC)
        navController.tabBarItem = UITabBarItem(title: "Locations", image: nil, selectedImage: nil)
        return navController
    }()
    
    var episodesVC: UINavigationController = {
        let episodesVC = EpisodeFeedVC()
        episodesVC.title = "Episodes"
        let navController = UINavigationController(rootViewController: episodesVC)
        navController.tabBarItem = UITabBarItem(title: "Episodes", image: nil, selectedImage: nil)
        return navController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [charactersVC, locationsVC, episodesVC]
        selectedIndex = 0
    }
}
