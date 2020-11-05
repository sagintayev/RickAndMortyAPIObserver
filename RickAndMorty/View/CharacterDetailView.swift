//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-11-02.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterDetailView: UIView {
    // MARK: - Properties
    var image: UIImage? {
        didSet { imageView.image = image }
    }
    var name: String? {
        didSet { nameLabel.text = name }
    }
    var status: String? {
        didSet { statusLabel.text = status }
    }
    var statusColor: UIColor? {
        didSet { statusIndicator.backgroundColor = statusColor }
    }
    var species: String? {
        didSet { updateSpeciesTypeLabel() }
    }
    var type: String? {
        didSet { updateSpeciesTypeLabel() }
    }
    var gender: String? {
        didSet { genderLabel.text = gender }
    }
    var origin: String? {
        didSet { originLabel.text = origin }
    }
    var currentLocation: String? {
        didSet { currentLocationLabel.text = currentLocation }
    }
    
    // MARK: - UI components
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkerFelt-Thin", size: 30)
        label.numberOfLines = 0
        return label
    }()
    private var speciesTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray4
        return label
    }()
    private var statusIndicator: UIView = {
        let indicator = UIView()
        return indicator
    }()
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    private var genderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    private var originTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray4
        label.text = "Origin:"
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    private var originLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    private var currentLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray4
        label.text = "Current Location:"
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    private var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    private var episodesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Seen in the next episodes:"
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    // MARK: - Methods
    private func updateSpeciesTypeLabel() {
        if let species = species {
            if let type = type {
                speciesTypeLabel.text = species + " - " + type
            } else {
                speciesTypeLabel.text = species
            }
        } else if let type = type {
            speciesTypeLabel.text = type
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusIndicator.layer.cornerRadius = statusIndicator.bounds.width * 0.5
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubviews()
        turnOffAutoresizingMasks()
        activateConstraints()
        setPriorities()
    }
    
    private func addSubviews() {
        for view in [imageView, nameLabel, statusLabel, statusIndicator, speciesTypeLabel, genderLabel, originTitleLabel, originLabel, currentLocationTitleLabel, currentLocationLabel, episodesTitleLabel] {
            addSubview(view)
        }
    }
    
    private func turnOffAutoresizingMasks() {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setPriorities() {
        nameLabel.setContentHuggingPriority(.defaultLow-2, for: .vertical)
        statusLabel.setContentHuggingPriority(.defaultLow+1, for: .vertical)
    }
    
    private func activateConstraints() {
        //let safeArea = safeAreaLayoutGuide
        let verticalOffset: CGFloat = 15
        let horizontalOffset: CGFloat = 20
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: verticalOffset),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalOffset),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        let speciesTypeLabelConstraints = [
            speciesTypeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalOffset/2),
            speciesTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        let statusIndicatorConstraints = [
            statusIndicator.topAnchor.constraint(equalTo: statusLabel.topAnchor),
            statusIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            statusIndicator.bottomAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            statusIndicator.widthAnchor.constraint(equalTo: statusIndicator.heightAnchor)
        ]
        let statusLabelConstraints = [
            statusLabel.topAnchor.constraint(equalTo: speciesTypeLabel.bottomAnchor, constant: verticalOffset),
            statusLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: horizontalOffset/2),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ]
        let genderLabelConstraints = [
            genderLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: verticalOffset),
            genderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            genderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ]
        let originTitleLabelConstraints = [
            originTitleLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: verticalOffset),
            originTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            originTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ]
        let originLabelConstraints = [
            originLabel.topAnchor.constraint(equalTo: originTitleLabel.bottomAnchor, constant: verticalOffset/2),
            originLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            originLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ]
        let currentLocationTitleLabelConstraints = [
            currentLocationTitleLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: verticalOffset),
            currentLocationTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            currentLocationTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ]
        let currentLocationLabelConstraints = [
            currentLocationLabel.topAnchor.constraint(equalTo: currentLocationTitleLabel.bottomAnchor, constant: verticalOffset/2),
            currentLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            currentLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ]
        let episodesTitleLabelConstraints = [
            episodesTitleLabel.topAnchor.constraint(equalTo: currentLocationLabel.bottomAnchor, constant: verticalOffset*1.5),
            episodesTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            episodesTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalOffset)
        ]
        
        NSLayoutConstraint.activate(
            imageViewConstraints
            + nameLabelConstraints
            + speciesTypeLabelConstraints
            + statusIndicatorConstraints
            + statusLabelConstraints
            + genderLabelConstraints
            + originTitleLabelConstraints
            + originLabelConstraints
            + currentLocationTitleLabelConstraints
            + currentLocationLabelConstraints
            + episodesTitleLabelConstraints
        )
    }
}

class CharacterDetailTableReusableView: UITableViewHeaderFooterView {
    static let identifier = "character-detail-table-reusable-view"
    var view: UIView? {
        didSet {
            view?.embedIn(self)
        }
    }
}
