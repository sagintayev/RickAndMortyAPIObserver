//
//  CharacterMainFeedController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-26.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterMainFeedController: CharacterFeedController {
    // MARK: - Overriden Methods
    override func createFilters() {
        for (sectionNumber, (filter, header)) in [getRandomGenderFilter(), getRandomSpeciesFilter(), getRandomSpeciesFilter(), getRandomSpeciesFilter(), getRandomStatusFilter()].compactMap({$0}).enumerated() {
            self.headersBySection[sectionNumber] = header
            self.filtersBySection[sectionNumber] = filter
        }
        collectionView.reloadData()
    }
    
    override func loadData() {
        for sectionNumber in 0..<filtersBySection.count {
            loadData(for: sectionNumber)
        }
    }
    
    override func setupCharacterCollection() {
        super.setupCharacterCollection()
        collectionView.register(HeaderLabelReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderLabelReusableView.identifier)
    }
    
    // MARK: - Layout
    override func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [ weak self ] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = self?.getSection(for: sectionNumber)
            return section
        }
        return layout
    }
    
    private func getSection(for number: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)), subitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        section.contentInsets.leading = 15
        return section
    }
    
    // MARK: Creating filters
    private var availableGenders: [String: Character.Gender] = ["Boys": .male, "Girls": .female, "Genderless": .genderless, "Unknown gender": .unknown]
    // use only species with reasonable amount of characters
    private var availableSpecies: [String: Character.Species] = ["Humans": .human, "Aliens": .alien, "Robots": .robot, "Humanoids": .humanoid, "Mythological Creatures": .mythologicalCreature, "Animals": .animal, "Unknown Species": .unknown]
    private var availableStatuses: [String: Character.Status] = ["Alive Characters": .alive, "Dead Characters": .dead, "Unknown if alive": .unknown]
    
    private func getRandomGenderFilter() -> (CharacterFilter, String)? {
        var filter = CharacterFilter()
        let randomKey = availableGenders.keys.randomElement()
        guard let headerString = randomKey else { return nil }
        let randomGender = availableGenders.removeValue(forKey: headerString)
        filter.gender = randomGender
        return (filter, headerString)
    }
    private func getRandomSpeciesFilter() -> (CharacterFilter, String)? {
        var filter = CharacterFilter()
        let randomKey = availableSpecies.keys.randomElement()
        guard let headerString = randomKey else { return nil }
        let randomSpecies = availableSpecies.removeValue(forKey: headerString)
        filter.species = randomSpecies
        return (filter, headerString)
    }
    private func getRandomStatusFilter() -> (CharacterFilter, String)? {
        var filter = CharacterFilter()
        let randomKey = availableStatuses.keys.randomElement()
        guard let headerString = randomKey else { return nil }
        let randomStatus = availableStatuses.removeValue(forKey: headerString)
        filter.status = randomStatus
        return (filter, headerString)
    }
    
    // MARK: Collection View Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filtersBySection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerLabel = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderLabelReusableView.identifier, for: indexPath)
        if let headerLabel = headerLabel as? HeaderLabelReusableView {
            headerLabel.labelText = headersBySection[indexPath.section]
            headerLabel.openSectionButton.tag = indexPath.section
            headerLabel.openSectionButton.addTarget(self, action: #selector(expandSection), for: .touchUpInside)
        }
        return headerLabel
    }
    
    @objc
    private func expandSection(_ sender: UIButton) {
        let characterCollectionController = CharacterCollectionController()
        characterCollectionController.characters[0] = characters[sender.tag]
        navigationController?.pushViewController(characterCollectionController, animated: true)
    }
}
