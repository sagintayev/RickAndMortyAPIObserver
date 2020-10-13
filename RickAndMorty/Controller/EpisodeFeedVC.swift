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
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let errorController = errorController {
            present(errorController, animated: true) {
                self.errorController = nil
            }
        }
    }
    
    // MARK: - Private methods
    private func loadData(_ action: UIAlertAction? = nil) {
        Episode.getAll { (result) in
            switch result {
            case .success(let episodes):
                self.episodes = EpisodesDividedBySeasons(episodes)
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorController(title: "Can't load data", message: error.localizedDescription, tryAgainHandler: self.loadData)
            }
        }
    }
    
    // MARK: UI Stuff
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var errorController: UIAlertController?
    
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
    
    private func showErrorController(title: String?, message: String?, tryAgainHandler: ((UIAlertAction?) -> Void)?) {
        let errorController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "Try again", style: .default, handler: tryAgainHandler))
        errorController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if viewIfLoaded?.window != nil {
            present(errorController, animated: true)
        } else {
            self.errorController = errorController
        }
    }
}

// MARK: - Data source
extension EpisodeFeedVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodes?.seasons ?? 0
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
