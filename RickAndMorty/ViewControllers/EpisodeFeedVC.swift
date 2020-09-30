//
//  EpisodeFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-29.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class EpisodeFeedVC: UIViewController {
    // MARK: - Properties
    var episodes: EpisodesDividedBySeasons?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        activateConstraints()
        Episode.getAll { (episodes) in
            self.episodes = EpisodesDividedBySeasons(episodes)
            self.tableView.reloadData()
        }
    }
    
    // MARK: UI Stuff
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func turnOffAutoresizingMask() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func activateConstraints() {
        turnOffAutoresizingMask()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

// MARK: - Data source
extension EpisodeFeedVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodes?.seasons ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let season = section + 1
        return episodes?[season]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let season = indexPath.section + 1
        let episode = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let episode = episodes?[season]?[episode] {
            cell.textLabel?.text = "E\(episode.episode): \(episode.name)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let season = section + 1
        let title = "Season \(season)"
        return title
    }
}

// MARK: - Delegate
extension EpisodeFeedVC: UITableViewDelegate {
    
}
