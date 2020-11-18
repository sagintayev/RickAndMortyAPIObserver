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
    weak var delegate: SearchControllerDelegate?
    
    // MARK: - UI Properties
    private var filterView = CharacterFilterView()
    private var scrollView = UIScrollView()
    
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = UIConstants.mainBackgroundColor
        setupScrollView()
        setupFilterView()
    }
    
    // MARK: - Toggleable
    var toggleHandler: (() -> Void)?
    
    // MARK: - Private methods
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupFilterView() {
        scrollView.addSubview(filterView)
        
        filterView.delegate = self

        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        filterView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        filterView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}

// MARK: - Character Filter View Delegate
extension CharacterSearchController: CharacterFilterViewDelegate {
    func nameTextFieldValueChanged(_ name: String?) {
        filter.name = name
    }
    
    func speciesTextFieldValueChanged(_ species: String?) {
        if let species = species {
            filter.species = Character.Species(rawValue: species)
        }
    }
    
    func typeTextFieldValueChanged(_ type: String?) {
        filter.type = type
    }
    
    func statusSegmentedControlValueChanged(_ selectedIndex: Int) {
        guard let status = statusSegmentedControlValues[selectedIndex] else { return }
        filter.status = status
    }
    
    func genderSegmentedControlValueChanged(_ selectedIndex: Int) {
        guard let gender = genderSegmentedControlValues[selectedIndex] else { return }
        filter.gender = gender
    }
    
    func cancelButtonTapped() {
        toggleHandler?()
    }
    
    func searchButtonTapped() {
        toggleHandler?()
        delegate?.searchStarted(with: filter)
    }
}
