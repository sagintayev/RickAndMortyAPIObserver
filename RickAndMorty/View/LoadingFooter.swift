//
//  LoadingFooter.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-11-06.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LoadingCollectionFooter: UICollectionReusableView {
    static let identifier = "loading-collection-footer"
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private func commonInit() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.embedIn(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}


class LoadingTableFooter: UITableViewHeaderFooterView {
    static let identifier = "loading-table-footer"
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private func commonInit() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.embedIn(self)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
