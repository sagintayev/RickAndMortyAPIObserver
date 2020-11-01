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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createFilters()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let errorAlert = errorAlert {
            present(errorAlert, animated: true) {
                self.errorAlert = nil
            }
        }
    }
    
    func createFilters() {
        filtersBySection[0] = CharacterFilter()
    }
    
    func loadData() {
        loadData(for: selectedSection)
    }
    
    // MARK: - Data Loading
    func loadData(for section: Int) {
        guard var filter = filtersBySection[section] else { return }
        guard filter.available == true else { return }
        filtersBySection[section]?.available = false
        Character.getByFilter(filter) { (result) in
            switch result {
            case .success(let characters):
                self.updateCollectionView(with: characters.results, for: section)
                filter.page += 1
                filter.available = filter.page <= characters.info.pages
            case .failure(let error):
                filter.available = true
                self.showErrorAlert(title: "Couldn't load data", message: error.localizedDescription) { (_) in
                    self.loadData(for: section)
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
        return true
    }
    
    // MARK: - Error Handling
    private var errorAlert: UIAlertController?
    
    private func showErrorAlert(title: String?, message: String?, tryAgainHandler: ((UIAlertAction?) -> Void)?) {
        let errorController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "Try again", style: .default, handler: tryAgainHandler))
        errorController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if viewIfLoaded?.window != nil {
            present(errorController, animated: true)
        } else {
            self.errorAlert = errorController
        }
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
            loadData(for: selectedSection)
        }
    }
}
