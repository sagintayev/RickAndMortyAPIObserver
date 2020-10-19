//
//  CharacterSearchController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-18.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterSearchController: UIViewController, Toggleable {
    // MARK: - Model
    private var filter = CharacterFilter()
    
    // MARK: - Delegate
    var delegate: SearchControllerDelegate?
    
    // MARK: - UI Properties
    var filterView = CharacterFilterView()
    var filterViewWidthMultiplier: CGFloat = 0.7
    
    private let statusSegmentedControlValues: [Int: Character.Status?] = [
        0: nil,
        1: .alive,
        2: .dead,
        3: .unknown
    ]
    
    private let genderSegmentedControlValues: [Int: Character.Gender?] = [
        0: nil,
        1: .male,
        2: .female,
        3: .genderless,
        4: .unknown
    ]
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        setupFilterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Toggable
    var toggleHandler: (() -> Void)?
    
    // MARK: - Private methods
    private func setupFilterView() {
        view.addSubview(filterView)
        
        filterView.delegate = self
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.frame.width*(1-filterViewWidthMultiplier)).isActive = true
        filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: - Character Filter View Delegate
extension CharacterSearchController: CharacterFilterViewDelegate {
    func nameTextFieldValueChanged(_ name: String?) {
        filter.setName(name)
    }
    
    func speciesTextFieldValueChanged(_ species: String?) {
        filter.setSpecies(species)
    }
    
    func typeTextFieldValueChanged(_ type: String?) {
        filter.setType(type)
    }
    
    func statusSegmentedControlValueChanged(_ selectedIndex: Int) {
        guard let status = statusSegmentedControlValues[selectedIndex] else { return }
        filter.setStatus(status)
    }
    
    func genderSegmentedControlValueChanged(_ selectedIndex: Int) {
        guard let gender = genderSegmentedControlValues[selectedIndex] else { return }
        filter.setGender(gender)
    }
    
    func cancelButtonTapped() {
        toggleHandler?()
    }
    
    func searchButtonTapped() {
        toggleHandler?()
        delegate?.searchStarted(with: filter)
    }
}
