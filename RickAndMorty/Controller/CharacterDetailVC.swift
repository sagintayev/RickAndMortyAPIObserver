//
//  CharacterDetailVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-20.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterDetailVC: UIViewController {
    
    // MARK: - Properties
    var character: Character? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray6
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        activateConstraints()
    }
    
    // MARK: - UI Stuff
    private var scrollView = UIScrollView()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    private var labelsStack = LabelsStack()
    private func addSubviews() {
        scrollView.addSubview(imageView)
        scrollView.addSubview(labelsStack)
        view.addSubview(scrollView)
    }
    
    private func turnOffAutoresizingMask() {
        for view in [scrollView, imageView, labelsStack] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let imageViewTopToScrollViewTop = CGFloat(10)
        let labelsStackTopToImageViewBottom = CGFloat(25)
        let labelsStackWidthToScrollViewWidthMultiplier = CGFloat(0.9)

        turnOffAutoresizingMask()
        
        NSLayoutConstraint.activate([
            // MARK: - scrollView constraints
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            // MARK: - imageView constraints
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: imageViewTopToScrollViewTop),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            // MARK: - labelsStack constraints
            labelsStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: labelsStackTopToImageViewBottom),
            labelsStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: labelsStackWidthToScrollViewWidthMultiplier),
            labelsStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func updateViews() {
        guard let character = character else { return }
        var labelsTexts = [(String, String)]()
        for (text1, text2) in [
            ("Name", character.name),
            ("Status", character.status.rawValue),
            ("Species", character.species),
            ("Type", character.type),
            ("Gender", character.gender.rawValue),
            ("Origin location", character.origin.name),
            ("Current location", character.location.name),
            ] {
                guard let text2 = text2 else { continue }
                labelsTexts.append((text1, text2))
        }
        
        labelsStack.createLabelStacks(with: labelsTexts)
        
        // TODO: - Transfer image from previous VC
        character.getImage(completion: { (imageData) in
            self.imageView.image = UIImage(data: imageData)
        })
    }
}
