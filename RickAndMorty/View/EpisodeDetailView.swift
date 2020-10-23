//
//  EpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-21.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class EpisodeDetailView: UIView {
    // MARK: - Properties
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    var season: Int? {
        didSet {
            guard let season = season else { return }
            seasonLabel.text = "Season \(season)"
        }
    }
    var episode: Int? {
        didSet {
            guard let episode = episode else { return }
            episodeLabel.text = "Epsiode \(episode)"
        }
    }
    var airDate: Date? {
        didSet {
            guard let airDate = airDate else { return }
            airDateLabel.text = dateFormatter.string(from: airDate)
        }
    }
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter
    }
    
    // MARK: - UI properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 46)
        label.numberOfLines = 0
        return label
    }()
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.numberOfLines = 0
        return label
    }()
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.numberOfLines = 0
        return label
    }()
    private let wasAiredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray4
        label.text = "Aired on"
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26)
        label.numberOfLines = 0
        return label
    }()
    private let residentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Characters seen in the episode"
        label.textColor = .systemGray4
        label.font = .systemFont(ofSize: 34)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = UIConstants.mainBackgroundColor
        addSubviews()
        activateConstraints()
        setPriorities()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        for view in [nameLabel, seasonLabel, episodeLabel, wasAiredLabel, airDateLabel, residentsLabel] {
            addSubview(view)
        }
    }
    
    private func activateConstraints() {
        let horizontalOffset: CGFloat = 30
        let verticalOffset: CGFloat = 25
    
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: verticalOffset),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalOffset),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalOffset),
        ]
        let seasonLabelConstraints = [
            seasonLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalOffset*1.5),
            seasonLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalOffset),
            seasonLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalOffset)
        ]
        let episodeLabelConstrains = [
            episodeLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: verticalOffset),
            episodeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalOffset),
            episodeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalOffset)
        ]
        let wasAiredLabelConstraints = [
            wasAiredLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: verticalOffset),
            wasAiredLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalOffset),
            wasAiredLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalOffset)
        ]
        let airDateLabelConstraints = [
            airDateLabel.topAnchor.constraint(equalTo: wasAiredLabel.bottomAnchor, constant: verticalOffset/3),
            airDateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalOffset),
            airDateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalOffset)
        ]
        let residentsLabelConstraints = [
            residentsLabel.topAnchor.constraint(equalTo: airDateLabel.bottomAnchor, constant: verticalOffset),
            residentsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            residentsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            residentsLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -horizontalOffset)
        ]
        
        NSLayoutConstraint.activate(
            nameLabelConstraints
            + seasonLabelConstraints
            + episodeLabelConstrains
            + wasAiredLabelConstraints
            + airDateLabelConstraints
            + residentsLabelConstraints
        )
    }
    
    private func setPriorities() {
        nameLabel.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
    }
}

class EpisodeDetailCollectionReusableView: UICollectionReusableView {
    var view: UIView? {
        didSet {
            view?.embedIn(self)
        }
    }
    static let identifier = "Episode Reusable View"
}
