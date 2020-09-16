//
//  CharacterFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-16.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class CharacterFeedVC: UIViewController {
    
    var characterCollection: UICollectionView {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        return cv
    }
    
    override func loadView() {
        super.loadView()
        view = characterCollection
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CharacterFeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

extension CharacterFeedVC: UICollectionViewDelegate {
    
}
