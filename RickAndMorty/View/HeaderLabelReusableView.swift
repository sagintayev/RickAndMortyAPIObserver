//
//  HeaderLabelReusableView.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-25.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class HeaderLabelReusableView: UICollectionReusableView {
    // Properties
    static let identifier = "header-label-reusable-view"
    var labelText: String? {
        didSet {
            headerLabel.text = labelText
        }
    }
    var openSectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(UIConstants.highlightColor, for: .normal)
        return button
    }()
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.mainTextColor
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
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
        activateConstraints()
    }
    
    private func activateConstraints() {
        headerLabel.embedIn(self, fromLeading: 15, fromTrailing: nil)
        headerLabel.setContentHuggingPriority(.defaultLow-1, for: .horizontal)
        openSectionButton.embedIn(self, fromLeading: nil, fromTrailing: -15)
        openSectionButton.centerXAnchor.constraint(equalTo: headerLabel.centerXAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        openSectionButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}
