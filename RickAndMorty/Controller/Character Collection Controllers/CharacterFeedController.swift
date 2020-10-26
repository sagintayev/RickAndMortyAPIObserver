//
//  CharacterFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterFeedController: CharacterCollectionController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Getting Data
    private var nextPage = 1
    private var moreDataExists = true
    private var isDownloading = false
    private var erasePreviousData = false
    private var currentFilter: Filter = CharacterFilter()
    
    private func loadData(_ alert: UIAlertAction? = nil) {
        guard moreDataExists == true else { return }
        guard isDownloading == false else { return }
        isDownloading = true
        defer {
            isDownloading = false
        }
        Character.getByFilter(currentFilter) { (result) in
            switch result {
            case .success(let characters):
                if self.erasePreviousData == false, let existedCharacters = self.characters {
                    let newIndexPaths = (existedCharacters.count..<existedCharacters.count+characters.results.count).map { IndexPath(item: $0, section: 0) }
                    self.characters = existedCharacters + characters.results
                    self.characterCollection.insertItems(at: newIndexPaths)
                } else {
                    self.characters = characters.results
                    self.characterCollection.reloadData()
                    self.erasePreviousData = false
                }
                self.nextPage += 1
                self.currentFilter.setPage(self.nextPage)
                self.moreDataExists = self.nextPage <= characters.info.pages
            case .failure(let error):
                self.showErrorAlert(title: "Can't load data", message: error.localizedDescription, tryAgainHandler: self.loadData)
            }
        }
    }
    
    private func setNewFilter(_ filter: Filter) -> Bool {
        guard filter.queryString != currentFilter.queryString else { return false }
        currentFilter = filter
        nextPage = 1
        moreDataExists = true
        erasePreviousData = true
        return true
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let characters = characters, indexPath.item == characters.count - 1 {
            loadData()
        }
    }
}

// MARK: - Search Controller Delegate
extension CharacterFeedController: SearchControllerDelegate {
    func searchStarted(with filter: Filter) {
        if setNewFilter(filter) {
            loadData()
        }
    }
}
