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
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIConstants.mainBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationTable()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let errorController = errorController {
            present(errorController, animated: true) {
                self.errorController = nil
            }
        }
    }
    
    // MARK: - Private methods
    private func loadData(_ alert: UIAlertAction? = nil) {
        Location.getAll { (result) in
            switch result {
            case .success(let locations):
                self.locations = locations
                self.isShowingLoadingFooter = false
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorController(title: "Can't load data", message: error.localizedDescription, tryAgainHandler: self.loadData)
            }
        }
    }
    
    // MARK: - UI Stuff
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIConstants.mainBackgroundColor
        return tableView
    }()
    
    private var errorController: UIAlertController?
    
    private func setupLocationTable() {
        tableView.embedIn(view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.identifier)
        tableView.tableFooterView = LoadingTableFooter()
    }
    
    private func showErrorController(title: String?, message: String?, tryAgainHandler: ((UIAlertAction?) -> Void)?) {
        let errorController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "Try again", style: .default, handler: tryAgainHandler))
        errorController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if viewIfLoaded?.window != nil {
            present(errorController, animated: true)
        } else {
            self.errorController = errorController
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
