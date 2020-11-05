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
    var characters = [Int: [Character]]()
    
    lazy var collectionView: UICollectionView = {
        let layout = getLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIConstants.mainBackgroundColor
        return collectionView
    }()
    
    // MARK: - Methods
    func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    
    func getCharacterBy(_ indexPath: IndexPath) -> Character? {
        return characters[indexPath.section]?[indexPath.row]
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCharacterCollection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func setupCharacterCollection() {
        collectionView.embedIn(view)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
    }
    
    // MARK: - Private methods
    private func configure(_ cell: inout UICollectionViewCell, with character: Character) {
        guard let cell = cell as? CharacterCell else { return }
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

// MARK: - Collection View Data Source
extension CharacterCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath)
        if let character = getCharacterBy(indexPath) {
            configure(&cell, with: character)
        }
        return cell
    }

}

// MARK: - Collection View Delegate
extension CharacterCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCharacter = getCharacterBy(indexPath) else { return }
        let characterDetailVC = CharacterDetailController()
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
