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
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIConstants.mainBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationTable()
        activateConstraints()
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
                self.locationTable.reloadData()
            case .failure(let error):
                self.showErrorController(title: "Can't load data", message: error.localizedDescription, tryAgainHandler: self.loadData)
            }
        }
    }
    
    // MARK: - UI Stuff
    private var locationTable: UITableView = {
        let locationTable = UITableView(frame: .zero)
        locationTable.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.identifier)
        locationTable.translatesAutoresizingMaskIntoConstraints = false
        locationTable.separatorColor = .clear
        locationTable.backgroundColor = UIConstants.mainBackgroundColor
        return locationTable
    }()
    
    private var errorController: UIAlertController?
    
    private func setupLocationTable() {
        locationTable.dataSource = self
        locationTable.delegate = self
        view.addSubview(locationTable)
    }
    
    private func activateConstraints() {
        let views = ["locationTable": locationTable]
        NSLayoutConstraint.activate(
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[locationTable]|", options: [], metrics: nil, views: views)
        + NSLayoutConstraint.constraints(withVisualFormat: "V:|[locationTable]|", options: [], metrics: nil, views: views)
        )
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
