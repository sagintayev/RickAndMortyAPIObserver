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
        view.backgroundColor = .systemGray6
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationTable()
        activateConstraints()
        Location.getAll { (locations) in
            self.locations = locations
            self.locationTable.reloadData()
        }
    }
    
    // MARK: - UI Stuff
    private var locationTable: UITableView = {
        let locationTable = UITableView(frame: .zero)
        locationTable.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.identifier)
        locationTable.translatesAutoresizingMaskIntoConstraints = false
        locationTable.separatorColor = .clear
        return locationTable
    }()
    
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
