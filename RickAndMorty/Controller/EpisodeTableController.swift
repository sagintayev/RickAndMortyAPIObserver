//
//  EpisodeFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-29.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class EpisodeTableController: UIViewController {
    // MARK: - Properties
    var episodesDividedBySeasons: EpisodesDividedBySeasons?
    var episodes: [Episode]?
    var isLoadingAllEpisodes = true
    var isShowingLoadingFooter = true {
        didSet {
            tableView.tableFooterView?.isHidden = isShowingLoadingFooter ? false : true
        }
    }
        
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if isLoadingAllEpisodes {
            loadData()
        }
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
                self.episodesDividedBySeasons = EpisodesDividedBySeasons(episodes)
                self.episodes = self.episodesDividedBySeasons == nil ? episodes : nil
                self.isShowingLoadingFooter = false
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorController(title: "Can't load data", message: error.localizedDescription, tryAgainHandler: self.loadData)
            }
        }
    }
    
    // MARK: UI Stuff
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let tableCellIdentifier = "cell"
    private var errorController: UIAlertController?
    
    func setupTableView() {
        tableView.embedIn(view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.tableFooterView = LoadingTableFooter()
    }
    
    func showErrorController(title: String?, message: String?, tryAgainHandler: ((UIAlertAction?) -> Void)?) {
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
extension EpisodeTableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodesDividedBySeasons?.seasons ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let season = section + 1
        return episodesDividedBySeasons?[season]?.count ?? episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
        
        if let episodesDividedBySeasons = episodesDividedBySeasons {
            let season = indexPath.section + 1
            let episode = indexPath.row
            
            if let episode = episodesDividedBySeasons[season]?[episode] {
                let episodeNumber = episode.episode == nil ? "" : String(episode.episode!)
                cell.textLabel?.text = "E\(episodeNumber): \(episode.name)"
            }
        } else if let episodes = episodes {
            let episode = episodes[indexPath.row]
            cell.textLabel?.text = "\(episode.code): \(episode.name)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard episodesDividedBySeasons != nil else { return nil }
        let season = section + 1
        let title = "Season \(season)"
        return title
    }
}

// MARK: - Delegate
extension EpisodeTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var episode: Episode!
        if let episodesDividedBySeasons = episodesDividedBySeasons {
            let seasonNumber = indexPath.section + 1
            let episodeNumber = indexPath.row
            if let season = episodesDividedBySeasons[seasonNumber] {
                episode = season[episodeNumber]
            }
        } else if let episodes = episodes {
            episode = episodes[indexPath.row]
        }
        guard episode != nil else { return }
        let episodeController = EpisodeDetailController()
        episodeController.episode = episode
        navigationController?.pushViewController(episodeController, animated: true)
    }
}
