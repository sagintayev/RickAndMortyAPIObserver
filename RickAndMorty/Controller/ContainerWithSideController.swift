//
//  ContainerWithSearchController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class ContainerWithSideController: UIViewController {
    
    // MARK: - Content Controller
    var contentController: UIViewController!
    
    private func setupContentController() {
        addChild(contentController)
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)
    }
    
    // MARK: - Side Controller
    var sideControllerWidthMiltiplier: CGFloat = 0.7
    
    private var sideController: (UIViewController&Toggleable)!
    private var isSideControllerShown = false
    
    private func setupSideController() {
        addChild(sideController)
        view.addSubview(sideController.view)
        sideController.didMove(toParent: self)
        sideController.view.frame.origin.x = view.frame.width
        sideController.toggleHandler = toggleSideController
    }
    
    @objc
    private func toggleSideController() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            if self.isSideControllerShown {
                self.sideController.view.frame.origin.x = self.view.frame.width
            } else {
                self.sideController.view.frame.origin.x = self.view.frame.width * (1-self.sideControllerWidthMiltiplier)
            }
        }
        isSideControllerShown.toggle()
    }
    
    //MARK: - Init
    init(contentController: UIViewController, sideController: UIViewController&Toggleable) {
        super.init(nibName: nil, bundle: nil)
        self.contentController = contentController
        self.sideController = sideController
        setupContentController()
        setupSideController()
        setupNavItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Navigation Item
    private func setupNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggleSideController))
    }
}
