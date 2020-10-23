//
//  EpisodeDetailController.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-10-21.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class EpisodeDetailController: CharacterCollectionController {
    // MARK: - Model
    var episode: Episode! {
        didSet {
            updateEpisodeView()
            updateCharacterCollection()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.mainBackgroundColor
        characterCollection.register(EpisodeDetailCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EpisodeDetailCollectionReusableView.identifier)
    }
    
    // MARK: - UI
    private var episodeView: EpisodeDetailView = {
        let episodeView = EpisodeDetailView()
        episodeView.translatesAutoresizingMaskIntoConstraints = false
        return episodeView
    }()
    
    private func updateEpisodeView() {
        episodeView.name = episode.name
        episodeView.season = episode.season
        episodeView.episode = episode.episode
        episodeView.airDate = episode.airDate
    }
    
    private func updateCharacterCollection() {
        let characterIDs = episode.characters.compactMap {Character.getIDFromUrl($0)}
        Character.getByIDs(characterIDs) { (result) in
            switch result {
            case .success(let characters):
                self.characters = characters
                self.characterCollection.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let episodeHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EpisodeDetailCollectionReusableView.identifier, for: indexPath)
        if let episodeHeader = episodeHeader as? EpisodeDetailCollectionReusableView {
            episodeHeader.view = episodeView
        }
        return episodeHeader
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: 500)
    }
}
