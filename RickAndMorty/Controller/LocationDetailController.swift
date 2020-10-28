//
//  LocationDetailController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-24.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LocationDetailController: CharacterCollectionController {

    // MARK: - Model
    var location: Location? {
        didSet {
            updateLocationView()
            updateCharacterCollection()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.mainBackgroundColor
        collectionView.register(LocationDetailCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LocationDetailCollectionReusableView.identifier)
    }
    
    // MARK: - UI
    private var locationView: LocationDetailView = {
        let locationView = LocationDetailView()
        locationView.translatesAutoresizingMaskIntoConstraints = false
        return locationView
    }()
    
    private func updateLocationView() {
        locationView.name = location?.name
        locationView.type = location?.type
        locationView.dimension = location?.dimension
    }
    
    private func updateCharacterCollection() {
        guard let characterIDs = location?.residents.compactMap({Character.getIDFromUrl($0)}) else { return }
        Character.getByIDs(characterIDs) { (result) in
            switch result {
            case .success(let characters):
                self.characters[0] = characters
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let locationHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationDetailCollectionReusableView.identifier, for: indexPath)
        if let locationHeader = locationHeader as? LocationDetailCollectionReusableView {
            locationHeader.view = locationView
        }
        return locationHeader
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: 300)
    }
}

