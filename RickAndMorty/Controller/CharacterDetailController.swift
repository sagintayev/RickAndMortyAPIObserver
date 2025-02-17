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
        view.backgroundColor = UIConstants.mainBackgroundColor
    }

    override func viewDidLoad() {
        isLoadingAllEpisodes = false
        super.viewDidLoad()
        characterDetailView.delegate = self
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
                self.isShowingLoadingFooter = false
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
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

extension CharacterDetailController: CharacterDetailViewDelegate {
    func currentLocationButtonTapped() {
        guard let character = character else { return }
        showLocationDetailController(for: character.location)
    }
    
    func originButtonTapped() {
        guard let character = character else { return }
        showLocationDetailController(for: character.origin)
    }
    
    private func showLocationDetailController(for location: Character.LocationShortVersion) {
        guard let locationURL = location.url else { return }
        guard let locationID = Location.getIDFromUrl(locationURL) else { return }
        let locationDetailController = LocationDetailController()
        Location.getByIDs([locationID]) { (result) in
            switch result {
            case .success(let locations):
                let origin = locations.first
                locationDetailController.location = origin
            case .failure(let error):
                print(error)
            }
        }
        navigationController?.pushViewController(locationDetailController, animated: true)
    }
}
