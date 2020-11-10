//
//  CharacterFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterFeedController: CharacterCollectionController {
    // MARK: - Properties
    var headersBySection = [Int: String]()
    var filtersBySection = [Int: CharacterFilter]()
    let selectedSection = 0
    var showLoadingController = true
    private var loadingController: LoadingIndicatorController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if showLoadingController {
            setupLoadingController()
        }
        createFilters()
        loadData()
    }
    
    private func setupLoadingController() {
        loadingController = LoadingIndicatorController()
        addChildController(loadingController)
        loadingController.delegate = self
    }
    
    func createFilters() {
        filtersBySection[0] = CharacterFilter()
    }
    
    func loadData() {
        loadData(for: selectedSection)
    }
    
    // MARK: - Methods
    func loadData(for section: Int) {
        guard var filter = filtersBySection[section] else { return }
        guard filter.available == true else { return }
        filtersBySection[section]?.available = false
        Character.getByFilter(filter) { (result) in
            switch result {
            case .success(let characters):
                self.updateCollectionView(with: characters.results, for: section)
                filter.page += 1
                let isMoreDataExists = filter.page <= characters.info.pages
                filter.available = isMoreDataExists
                if !isMoreDataExists {
                    self.isLoading = false
                }
                if self.showLoadingController {
                    self.loadingController.view.isHidden = true
                }
            case .failure(let error):
                filter.available = true
                if self.showLoadingController {
                    self.loadingController.showError(withTitle: "Couldn't load characters", andMessage: error.localizedDescription)
                }
            }
            self.filtersBySection[section] = filter
        }
    }
    
    func updateCollectionView(with characters: [Character], for section: Int = 0) {
        var indexPathsToInsert: [IndexPath]
        if let existedCharacters = self.characters[section] {
            indexPathsToInsert = (existedCharacters.count..<existedCharacters.count + characters.count).map { IndexPath(item: $0, section: section) }
            self.characters[section]?.append(contentsOf: characters)
        } else {
            indexPathsToInsert = (0..<characters.count).map { IndexPath(item: $0, section: section) }
            self.characters[section] = characters
        }
        self.collectionView.insertItems(at: indexPathsToInsert)
    }
    
    private func setNewFilter(_ filter: Filter) -> Bool {
        guard filter.queryString != filtersBySection[selectedSection]?.queryString else { return false }
        guard let filter = filter as? CharacterFilter else { return false }
        filtersBySection[selectedSection] = filter
        characters[selectedSection] = nil
        collectionView.reloadSections([selectedSection])
        isLoading = true
        return true
    }
    
    // MARK: - Collection View Methods    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let characters = characters[indexPath.section], indexPath.item == characters.count - 1 {
            loadData(for: indexPath.section)
        }
    }
}

// MARK: - Search Controller Delegate
extension CharacterFeedController: SearchControllerDelegate {
    func searchStarted(with filter: Filter) {
        if setNewFilter(filter) {
            if showLoadingController {
                loadingController.view.isHidden = false
            }
            loadData(for: selectedSection)
        }
    }
}

// MARK: - Loading Indicator Controller Delegate
extension CharacterFeedController: LoadingIndicatorControllerDelegate {
    func tryAgainButtonTapped() {
        loadData()
    }
}
