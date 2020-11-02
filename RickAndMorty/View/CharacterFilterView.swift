//
//  CharacterFilterView.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterFilterView: UIView {
    // MARK: - Preperties
    var delegate: CharacterFilterViewDelegate?
    
    // MARK: - IB Outlets
    @IBOutlet private var contentView: CharacterFilterView!
    @IBOutlet private var nameTextFiled: UITextField! {
        didSet {
            nameTextFiled.delegate = self
        }
    }
    @IBOutlet private var speciesTextField: UITextField! {
        didSet {
            speciesTextField.delegate = self
        }
    }
    @IBOutlet private var typeTextField: UITextField! {
        didSet {
            typeTextField.delegate = self
        }
    }
    @IBOutlet private var statusSegmentedControl: UISegmentedControl! {
        didSet {
            statusSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private var genderSegmentedControl: UISegmentedControl! {
        didSet {
            genderSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
    }
    @IBOutlet private var searchButton: UIButton! {
        didSet {
            searchButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
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
        Bundle.main.loadNibNamed("CharacterFilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    // MARK: - Actions
    @objc
    private func segmentedControlValueChanged(sender: UISegmentedControl) {
        switch sender {
        case statusSegmentedControl: delegate?.statusSegmentedControlValueChanged(sender.selectedSegmentIndex)
        case genderSegmentedControl: delegate?.genderSegmentedControlValueChanged(sender.selectedSegmentIndex)
        default: break
        }
    }
    
    @objc
    private func buttonTapped(sender: UIButton) {
        switch sender {
        case cancelButton: delegate?.cancelButtonTapped()
        case searchButton: delegate?.searchButtonTapped()
        default: break
        }
    }
}

// MARK: - UITextFieldDelegate
extension CharacterFilterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let newValue = textField.text
        switch textField {
        case nameTextFiled:
            delegate?.nameTextFieldValueChanged(newValue)
        case speciesTextField:
            delegate?.speciesTextFieldValueChanged(newValue)
        case typeTextField:
            delegate?.typeTextFieldValueChanged(newValue)
        default:
            break
        }
    }
}
