//
//  LabelsStack.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-23.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

/// Stack of stacks with 2 labels created with given strings
class LabelsStack: UIStackView {
    
    var labelsDistribution: UIStackView.Distribution = .fillEqually
    var labelsAlignment: UIStackView.Alignment = .fill
    var firstLabelFont = UIFont(name: "Futura-Bold", size: 26)
    var secondLabelFont = UIFont(name: "Futura-Medium", size: 26)
    
    func createLabelStacks(with texts: [(String, String)]) {
        for (text1, text2) in texts {
            createLabelStack(withText: text1, and: text2)
        }
    }
    
    func createLabelStack(withText text1: String, and text2: String) {
        let stackWithLabels = UIStackView(arrangedSubviews: [createFirstLabel(with: text1), createSecondLabel(with: text2)])
        stackWithLabels.axis = .horizontal
        stackWithLabels.distribution = labelsDistribution
        stackWithLabels.alignment = labelsAlignment
        addArrangedSubview(stackWithLabels)
    }
    
    init(with texts: [(String, String)]) {
        super.init(frame: .zero)
        createLabelStacks(with: texts)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMainStack()
    }
    
    private func createFirstLabel(with text: String?) -> UILabel {
        let label = createLabel(with: text)
        label.font = firstLabelFont
        return label
    }
    
    private func createSecondLabel(with text: String?) -> UILabel {
        let label = createLabel(with: text)
        label.font = secondLabelFont
        return label
    }
    
    private func createLabel(with text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray3.cgColor
        return label
    }
    
    private func configureMainStack() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
