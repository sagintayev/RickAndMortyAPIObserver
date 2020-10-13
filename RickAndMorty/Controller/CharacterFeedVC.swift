//
//  CharacterFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterFeedVC: UIViewController {
    // MARK: - Properties
    let spacingBetweenItems: CGFloat = 10
    let itemsPerRow: CGFloat = 3
    var characters: [Character]?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCharacterCollection()
        activateConstraints()
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
    
    private func loadData(_ alert: UIAlertAction? = nil) {
        guard moreDataExists == true else { return }
        guard isDownloading == false else { return }
        isDownloading = true
        defer {
            isDownloading = false
        }
        Character.getByPageNumber(nextPage) { (result) in
            switch result {
            case .success(let characters):
                if let existedCharacters = self.characters {
                    let newIndexPaths = (existedCharacters.count..<existedCharacters.count+characters.results.count).map { IndexPath(item: $0, section: 0) }
                    self.characters = existedCharacters + characters.results
                    self.characterCollection.insertItems(at: newIndexPaths)
                } else {
                    self.characters = characters.results
                    self.characterCollection.reloadData()
                }
                self.nextPage += 1
                self.moreDataExists = self.nextPage <= characters.info.pages
            case .failure(let error):
                self.showErrorAlert(title: "Can't load data", message: error.localizedDescription, tryAgainHandler: self.loadData)
            }
        }
    }
    
    // MARK: - UI Stuff
    private var characterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIConstants.mainBackgroundColor
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        return collectionView
    }()
    
    private var errorAlert: UIAlertController?
    
    private func setupCharacterCollection() {
        view.addSubview(characterCollection)
        characterCollection.showsVerticalScrollIndicator = false
        characterCollection.delegate = self
        characterCollection.dataSource = self
    }
    
    private func activateConstraints() {
        characterCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            characterCollection.topAnchor.constraint(equalTo: view.topAnchor),
            characterCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
}

// MARK: - Data Source
extension CharacterFeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath)
        if let cell = cell as? CharacterCell {
            if let character = characters?[indexPath.item] {
                let width = (collectionView.bounds.width - itemsPerRow * spacingBetweenItems) / itemsPerRow
                cell.cellWidth = width
                cell.labelText = character.name
                cell.tag = character.id
                character.getImage { (imageData) in
                    if character.id == cell.tag {
                        cell.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let characters = characters, indexPath.item == characters.count - 1 {
            loadData()
        }
    }
}

// MARK: - Delegate
extension CharacterFeedVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCharacter = characters?[indexPath.item] else { return }
        let characterDetailVC = CharacterDetailVC()
        characterDetailVC.character = selectedCharacter
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }
}

// MARK: - Flow Layout Delegate
extension CharacterFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenItems
    }
}
