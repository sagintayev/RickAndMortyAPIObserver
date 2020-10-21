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
    var sideController: (UIViewController&Toggleable)!
    private var sideControllerWidthMiltiplier: CGFloat = 0.7
    private var sideControllerWidth: CGFloat {
        view.bounds.width * sideControllerWidthMiltiplier
    }
    private var sideControllerWidthConstraint: NSLayoutConstraint!
    private var sideControllerLeadingConstraint: NSLayoutConstraint!
    private var isSideControllerShown = false
    
    private func setupSideController() {
        addChild(sideController)
        view.addSubview(sideController.view)
        sideController.didMove(toParent: self)
        activateSideControllerViewConstraints()
        sideController.toggleHandler = toggleSideController
    }
    
    private func activateSideControllerViewConstraints() {
        sideController.view.translatesAutoresizingMaskIntoConstraints = false
        sideControllerWidthConstraint = sideController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: sideControllerWidthMiltiplier)
        sideControllerLeadingConstraint = sideController.view.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([
            sideController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sideController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideControllerLeadingConstraint,
            sideControllerWidthConstraint
        ])
    }
    
    @objc
    private func toggleSideController() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            if self.isSideControllerShown {
                self.sideController.view.frame.origin.x = self.view.frame.width
                self.sideControllerLeadingConstraint.constant = 0
            } else {
                self.sideController.view.frame.origin.x = self.view.frame.width * (1-self.sideControllerWidthMiltiplier)
                self.sideControllerLeadingConstraint.constant = -self.view.frame.width * self.sideControllerWidthMiltiplier
            }
        }
        isSideControllerShown.toggle()
    }
    
    @objc
    private func hideSideController() {
        guard isSideControllerShown == true else { return }
        print("hide")
        toggleSideController()
    }
    
    // MARK: - Init
    init(contentController: UIViewController, sideController: UIViewController&Toggleable) {
        super.init(nibName: nil, bundle: nil)
        self.contentController = contentController
        self.sideController = sideController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentController()
        setupSideController()
        setupNavItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(hideSideController), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Navigation Item
    private func setupNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggleSideController))
    }
}
