//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    static let identifier = "Character"
    
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = self.image
                if self.image != nil {
                    self.activityIndicator.stopAnimating()
                } else {
                    self.activityIndicator.startAnimating()
                }
            }
        }
    }
    
    var labelText: String? {
        didSet {
            DispatchQueue.main.async {
                self.label.text = self.labelText
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        addSubviews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkerFelt-Thin", size: UIFont.systemFontSize)
        label.textAlignment = .center
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        indicator.startAnimating()
        return indicator
    }()
    
    private func configureCell() {
        layer.cornerRadius = 6
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(label)
        addSubview(activityIndicator)
    }
    
    private func turnOffAutoresizingMask() {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        let imageViewTopToCellTop = CGFloat(5)
        let imageViewLeadingToCellLeading = CGFloat(5)
        let imageViewTrailingToCellTrailing = CGFloat(-5)
        let labelTopToImageViewBottom = CGFloat(10)
        let labelBottomToCellBottom = CGFloat(-10)
        
        turnOffAutoresizingMask()
        
        NSLayoutConstraint.activate([
            // MARK: - ImageView constraints
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: imageViewTopToCellTop),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imageViewLeadingToCellLeading),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: imageViewTrailingToCellTrailing),
            
            // MARK: - Label constraints
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: labelTopToImageViewBottom),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: labelBottomToCellBottom),
            
            // MARK: - activityIndicator constraints
            activityIndicator.topAnchor.constraint(equalTo: imageView.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
    }
}
