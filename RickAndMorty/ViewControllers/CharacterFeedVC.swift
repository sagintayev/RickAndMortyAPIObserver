//
//  CharacterFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterFeedVC: UIViewController {
    let spacingBetweenItems = CGFloat(10)
    let itemsPerRow = CGFloat(3)
    
    var characters: [Character]?
    
    var characterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(characterCollection)
        characterCollection.frame = view.bounds
        characterCollection.delegate = self
        characterCollection.dataSource = self
        Character.getAll { (characters) in
            DispatchQueue.main.async {
                self.characters = characters
                self.characterCollection.reloadData()
            }
        }
    }
}

extension CharacterFeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath)
        if let cell = cell as? CharacterCell {
            let characterID = indexPath.item + 1
            Character.getByID(characterID) { (character) in
                cell.tag = characterID
                character.getImage { (imageData) in
                    if characterID == cell.tag {
                        cell.image = UIImage(data: imageData)
                        cell.labelText = character.name
                    }
                }
            }
        }
        return cell
    }
}

extension CharacterFeedVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCharacter = characters?[indexPath.item] else { return }
        let characterDetailVC = CharacterDetailVC()
        characterDetailVC.character = selectedCharacter
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }
}

extension CharacterFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - itemsPerRow * spacingBetweenItems) / itemsPerRow
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenItems
    }
}
