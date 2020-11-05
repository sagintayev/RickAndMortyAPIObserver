//
//  CharacterDetailController.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-20.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterDetailController: EpisodeTableController {
    // MARK: - Properties
    var character: Character? {
        didSet {
            updateCharacterDetailView()
            updateTableView()
        }
    }

    private var statuses: [Character.Status: String] = [
        .alive: Character.Status.alive.rawValue,
        .dead: Character.Status.dead.rawValue,
        .unknown: "Unknown if alive"
    ]
    private var statusIndicatorColors: [Character.Status: UIColor] = [
        .alive: .green,
        .dead: .red,
        .unknown: .yellow
    ]
    private var genders: [Character.Gender: String] = [
        .male: Character.Gender.male.rawValue,
        .female: Character.Gender.female.rawValue,
        .genderless: Character.Gender.genderless.rawValue,
        .unknown: "Unknown gender"
    ]
    private var characterDetailView = CharacterDetailView()
    
    private func updateCharacterDetailView() {
        guard let character = character else { return }
        character.getImage(completion: { (imageData) in
            self.characterDetailView.image = UIImage(data: imageData)
        })
        characterDetailView.name = character.name
        characterDetailView.status = statuses[character.status]
        characterDetailView.statusColor = statusIndicatorColors[character.status]
        characterDetailView.species = character.species.rawValue
        characterDetailView.type = character.type
        characterDetailView.gender = genders[character.gender]
        characterDetailView.origin = character.origin.name
        characterDetailView.currentLocation = character.location.name
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray6
    }

    override func viewDidLoad() {
        isLoadingAllEpisodes = false
        super.viewDidLoad()
    }
    
    // MARK: Table View Methods
    override func setupTableView() {
        super.setupTableView()
        tableView.register(CharacterDetailTableReusableView.self, forHeaderFooterViewReuseIdentifier: CharacterDetailTableReusableView.identifier)
        tableView.estimatedSectionHeaderHeight = 700
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    private func updateTableView() {
        guard let character = character  else { return }
        let ids = character.episodes.compactMap { Episode.getIDFromUrl($0) }
        Episode.getByIDs(ids) { (result) in
            switch result {
            case .success(let episodes):
                self.episodes = episodes
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorController(title: "Couldn't load episodes", message: error.localizedDescription) { _ in self.updateTableView()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CharacterDetailTableReusableView.identifier)
        if let header = header as? CharacterDetailTableReusableView {
            header.view = characterDetailView
        }
        return header
    }
}
