//
//  CharacterCollectionController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-26.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterCollectionController: UIViewController {
    // MARK: - Properties
    let spacingBetweenItems: CGFloat = 10
    let itemsPerRow: CGFloat = 3
    var characters: [Character]?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCharacterCollection()
    }
    
    var characterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIConstants.mainBackgroundColor
        return collectionView
    }()
    
    private func setupCharacterCollection() {
        characterCollection.embedIn(view)
        characterCollection.showsVerticalScrollIndicator = false
        characterCollection.delegate = self
        characterCollection.dataSource = self
        characterCollection.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
    }
}

// MARK: - Collection View Data Source
extension CharacterCollectionController: UICollectionViewDataSource {
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
}

// MARK: - Collection View Delegate
extension CharacterCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCharacter = characters?[indexPath.item] else { return }
        let characterDetailVC = CharacterDetailVC()
        characterDetailVC.character = selectedCharacter
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }
}

// MARK: - Flow Layout Delegate
extension CharacterCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenItems
    }
}
