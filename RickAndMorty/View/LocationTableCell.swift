//
//  LocationTableCell.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-26.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LocationTableCell: UITableViewCell {
    static let identifier = "LocationTableCell"
    
    var name: String? {
        didSet {
            mainLabel.text = name
        }
    }
    
    var type: String? {
        didSet {
            guard let type = type else { return }
            labelsStack.createLabelStack(withText: "Type", and: type)
        }
    }
    
    var dimension: String? {
        didSet {
            guard let dimension = dimension else { return }
            labelsStack.createLabelStack(withText: "Dimension", and: dimension)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelsStack = LabelsStack()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.borderWidth = 1
        addSubviews()
        activateConstraints()
    }
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 30)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var labelsStack = LabelsStack()
    
    private func addSubviews() {
        addSubview(mainLabel)
        addSubview(labelsStack)
    }
    
    private func turnOffAutoresizingMask() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func activateConstraints() {
        turnOffAutoresizingMask()
        NSLayoutConstraint.activate([
            // MARK: - mainLabel constraints
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // MARK: - labelsStack constraints
            labelsStack.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
