//
//  LocationDetailView.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-24.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LocationDetailView: UIView {
    // MARK: - Properties
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    var type: String? {
        didSet {
            typeLabel.text = type
        }
    }
    var dimension: String? {
        didSet {
            dimensionLabel.text = dimension
        }
    }
    
    // MARK: - UI components
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.highlightTextColor
        label.font = .systemFont(ofSize: 36)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private var typeSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.secondTextColor
        label.text = "Type"
        return label
    }()
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.mainTextColor
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    private var dimensionSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.secondTextColor
        label.text = "Dimension"
        return label
    }()
    private var dimensionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.mainTextColor
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addSubviews()
        setMasks()
        activateConstraints()
        setPriorities()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        for view in [nameLabel, typeSubLabel, typeLabel, dimensionSubLabel, dimensionLabel] {
            addSubview(view)
        }
    }
    
    private func setMasks() {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        let verticalOffset: CGFloat = 15
        let padding: CGFloat = 10
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ]
        let typeSubLabelConstraints = [
            typeSubLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalOffset),
            typeSubLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            typeSubLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ]
        let typeLabelConstraints = [
            typeLabel.topAnchor.constraint(equalTo: typeSubLabel.bottomAnchor, constant: verticalOffset/3),
            typeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            typeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ]
        let dimensionSubLabelConstraints = [
            dimensionSubLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: verticalOffset),
            dimensionSubLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            dimensionSubLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ]
        let dimensionLabelConstraints = [
            dimensionLabel.topAnchor.constraint(equalTo: dimensionSubLabel.bottomAnchor, constant: verticalOffset/3),
            dimensionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            dimensionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            dimensionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ]
        
        NSLayoutConstraint.activate(
            nameLabelConstraints
            + typeSubLabelConstraints
            + typeLabelConstraints
            + dimensionSubLabelConstraints
            + dimensionLabelConstraints
        )
    }
    
    private func setPriorities() {
        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow - 1, for: .vertical)
    }
}

class LocationDetailCollectionReusableView: UICollectionReusableView {
    static let identifier = "Location Reusable View"
    var view: UIView? {
        didSet {
            view?.embedIn(self, fromBottom: nil)
            view?.bottomAnchor.constraint(equalTo: charactersLabel.topAnchor, constant: -15).isActive = true
            view?.setContentHuggingPriority(UILayoutPriority.defaultLow-1, for: .vertical)
        }
    }
    private let charactersLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.secondTextColor
        label.text = "Residents"
        label.font = .systemFont(ofSize: 38)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        charactersLabel.embedIn(self, fromTop: nil, fromLeading: 10, fromBottom: -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
