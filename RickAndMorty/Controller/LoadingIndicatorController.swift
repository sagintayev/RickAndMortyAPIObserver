//
//  LoadingIndicatorController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-11-10.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LoadingIndicatorController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: LoadingIndicatorControllerDelegate?
    var errorTitle: String?
    var errorMessage: String? {
        didSet {
            if errorMessage != nil {
                loadingIndicator.isHidden = true
            }
        }
    }
    
    // MARK: - UI Components
    private var errorViewContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    private var errorImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private var errorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.mainTextColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26)
        label.numberOfLines = 0
        return label
    }()
    private var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.mainTextColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    private var tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        button.backgroundColor = UIConstants.highlightColor
        button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private var constraintsRegularHeight: [NSLayoutConstraint]?
    private var constraintsCompactHeight: [NSLayoutConstraint]?
    
    // MARK: - Methods
    func showError(withTitle title: String?, andMessage message: String?) {
        loadingIndicator.stopAnimating()
        errorViewContainer.isHidden = false
        errorImageView.image = UIImage(named: "ErrorImage0")
        errorTitleLabel.text = title
        errorMessageLabel.text = message
    }
    
    @objc
    private func tryAgainButtonTapped() {
        showLoading()
        delegate?.tryAgainButtonTapped()
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        errorViewContainer.isHidden = true
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.mainBackgroundColor
        setupSubviews()
        showLoading()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tryAgainButton.layer.cornerRadius = tryAgainButton.frame.height * 0.2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("change trait")
        activateConstraintsForCurrentSize()
    }
    
    private func setupSubviews() {
        loadingIndicator.embedIn(view)
        addSubviewsWithoutMasks()
        setCHCRPriorities()
        activateConstraints()
    }
    
    private func addSubviewsWithoutMasks() {
        for view in [errorImageView, errorTitleLabel, errorMessageLabel, tryAgainButton] {
            errorViewContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(errorViewContainer)
        errorViewContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setCHCRPriorities() {
        errorMessageLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)
    }
    
    private func activateConstraints() {
        let horizontalOffset: CGFloat = 15
        let verticalOffset: CGFloat = 15
        
        let errorViewContainerConstraints = [
            errorViewContainer.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: verticalOffset),
            errorViewContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorViewContainer.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorViewContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalOffset),
            errorViewContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorViewContainer.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ]
        let errorImageViewConstraints = [
            errorImageView.topAnchor.constraint(equalTo: errorViewContainer.topAnchor),
            errorImageView.centerXAnchor.constraint(equalTo: errorViewContainer.centerXAnchor)
        ]
        let errorTitleLabelConstraintsRegularHeight = [
            errorTitleLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: verticalOffset),
            errorTitleLabel.leadingAnchor.constraint(equalTo: errorViewContainer.leadingAnchor, constant: horizontalOffset),
            errorTitleLabel.trailingAnchor.constraint(equalTo: errorViewContainer.trailingAnchor, constant: -horizontalOffset)
        ]
        let errorTitleLabelConstraintsCompactHeight = [
            errorTitleLabel.topAnchor.constraint(equalTo: errorViewContainer.topAnchor),
            errorTitleLabel.leadingAnchor.constraint(equalTo: errorViewContainer.leadingAnchor, constant: horizontalOffset),
            errorTitleLabel.trailingAnchor.constraint(equalTo: errorViewContainer.trailingAnchor, constant: -horizontalOffset)
        ]
        let errorMessageLabelConstraints = [
            errorMessageLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: verticalOffset),
            errorMessageLabel.leadingAnchor.constraint(equalTo: errorViewContainer.leadingAnchor, constant: horizontalOffset),
            errorMessageLabel.trailingAnchor.constraint(equalTo: errorViewContainer.trailingAnchor, constant: -horizontalOffset)
        ]
        let tryAgainButtonConstraints = [
            tryAgainButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: verticalOffset),
            tryAgainButton.centerXAnchor.constraint(equalTo: errorViewContainer.centerXAnchor),
            tryAgainButton.widthAnchor.constraint(equalTo: errorViewContainer.widthAnchor, multiplier: 0.7),
            tryAgainButton.bottomAnchor.constraint(equalTo: errorViewContainer.bottomAnchor)
        ]
        
        constraintsCompactHeight = errorTitleLabelConstraintsCompactHeight
        constraintsRegularHeight = errorImageViewConstraints + errorTitleLabelConstraintsRegularHeight
        
        let commonConstraints = errorViewContainerConstraints
            + errorMessageLabelConstraints
            + tryAgainButtonConstraints
        
        NSLayoutConstraint.activate(commonConstraints)
        activateConstraintsForCurrentSize()
    }
    
    private func activateConstraintsForCurrentSize() {
        var constraintsToDeactivate: [NSLayoutConstraint]!
        var constraintsToActivate: [NSLayoutConstraint]!
        
        switch traitCollection.verticalSizeClass {
        case .regular:
            errorImageView.isHidden = false
            constraintsToDeactivate = constraintsCompactHeight
            constraintsToActivate = constraintsRegularHeight
        case .compact:
            errorImageView.isHidden = true
            constraintsToDeactivate = constraintsRegularHeight
            constraintsToActivate = constraintsCompactHeight
        default: break
        }
        
        NSLayoutConstraint.activate(constraintsToActivate)
        NSLayoutConstraint.deactivate(constraintsToDeactivate)
    }
}
