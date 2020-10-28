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
    private var headerLabel: UILabel = {
       let label = UILabel()
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
        headerLabel.embedIn(self)
    }
}
