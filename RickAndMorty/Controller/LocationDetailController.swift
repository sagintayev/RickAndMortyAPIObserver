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
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView
        if kind == UICollectionView.elementKindSectionFooter {
            reusableView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        } else if kind == UICollectionView.elementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationDetailCollectionReusableView.identifier, for: indexPath)
            if let reusableView = reusableView as? LocationDetailCollectionReusableView {
                reusableView.view = locationView
            }
        } else {
            reusableView = UICollectionReusableView()
        }
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: 300)
    }
}

