//
//  LocationTableCell.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-26.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LocationTableCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "Location Table Cell"
    
    var name: String? {
        didSet {
            locationView.name = name
        }
    }
    
    var type: String? {
        didSet {
            locationView.type = type
        }
    }
    
    var dimension: String? {
        didSet {
            locationView.dimension = dimension
        }
    }
    
    var locationView = LocationDetailView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIConstants.mainBackgroundColor
        setupLocationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLocationView() {
        let horizontalPadding: CGFloat = 10
        let verticalPadding: CGFloat = 15
        locationView.embedIn(self, fromTop: verticalPadding, fromLeading: horizontalPadding, fromTrailing: -horizontalPadding, fromBottom: -verticalPadding)
        locationView.layer.cornerRadius = 10
        locationView.backgroundColor = UIConstants.secondBackgroundColor
    }
}
