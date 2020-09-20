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
        let charactersVC = CharacterFeedVC()
        charactersVC.title = "Characters"
        let navController = UINavigationController(rootViewController: charactersVC)
        navController.tabBarItem = UITabBarItem(title: "Characters", image: nil, selectedImage: nil)
        return navController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [charactersVC]
        selectedIndex = 0
    }
}
