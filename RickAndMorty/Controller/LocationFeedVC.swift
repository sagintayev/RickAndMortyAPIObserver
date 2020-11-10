//
//  LocationFeedVC.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-25.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit

class LocationFeedVC: UIViewController {
    
    // MARK: - Properties
    var locations: [Location]?
    var isShowingLoadingFooter = true {
        didSet {
            tableView.tableFooterView?.isHidden = isShowingLoadingFooter ? false : true
        }
    }
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIConstants.mainBackgroundColor
        return tableView
    }()
    private var loadingController = LoadingIndicatorController()
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIConstants.mainBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingController.delegate = self
        addChildController(loadingController)
        loadData()
    }
    
    private func setupTableView() {
        tableView.embedIn(view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.identifier)
        tableView.tableFooterView = LoadingTableFooter()
    }
    
    private func loadData(_ alert: UIAlertAction? = nil) {
        Location.getAll { (result) in
            switch result {
            case .success(let locations):
                self.locations = locations
                self.isShowingLoadingFooter = false
                self.tableView.reloadData()
                self.loadingController.removeFromParentController()
            case .failure(let error):
                self.loadingController.showError(withTitle: "Couldn't load locations", andMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension LocationFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let locations = locations else { return 0 }
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableCell.identifier, for: indexPath)
        if let location = locations?[indexPath.item], let cell = cell as? LocationTableCell {
            cell.name = location.name
            cell.type = location.type
            cell.dimension = location.dimension
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocationFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = locations?[indexPath.row] else { return }
        let locationDetailController = LocationDetailController()
        locationDetailController.location = location
        navigationController?.pushViewController(locationDetailController, animated: true)
    }
}

extension LocationFeedVC: LoadingIndicatorControllerDelegate {
    func tryAgainButtonTapped() {
        loadData()
    }
}
