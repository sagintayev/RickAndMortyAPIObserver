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
    
    var cellWidth: CGFloat = 100 {
        didSet {
            contentViewWidthConstraint.constant = cellWidth
        }
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
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
        label.textColor = UIConstants.mainTextColor
        label.font = UIFont(name: "MarkerFelt-Thin", size: UIFont.systemFontSize)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "placeholder text..." // to help collection view calculate cell height
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: cellWidth).withPriority(999)
    
    private func configureCell() {
        layer.cornerRadius = 6
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = UIConstants.secondBackgroundColor
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(activityIndicator)
    }
    
    private func turnOffAutoresizingMask() {
        for view in contentView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        let imageViewTopToCellTop = CGFloat(5)
        let labelTopToImageViewBottom = CGFloat(10)
        let labelBottomToCellBottom = CGFloat(-10)
        
        turnOffAutoresizingMask()
        
        NSLayoutConstraint.activate([
            // MARK: - ContentView constraints
            contentViewWidthConstraint,
            
            // MARK: - ImageView constraints
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: imageViewTopToCellTop),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).withPriority(999),
            
            // MARK: - Label constraints
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: labelTopToImageViewBottom),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: labelBottomToCellBottom),
            
            // MARK: - activityIndicator constraints
            activityIndicator.topAnchor.constraint(equalTo: imageView.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
    }
}
