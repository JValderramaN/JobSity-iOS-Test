//
//  PersonDetailTableViewController.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

class PersonDetailTableViewController: UITableViewController, Representable, CellsRegistrable {
    
    // MARK: - Representable
    
    typealias Mask = Person
    var representation: Person!
    
    // MARK: - Instance
    
    static let segueIdentifier = "toPersonDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {
        tableView.registerCell(ImageTableViewCell.self)
        tableView.registerCell(CollectionViewTableViewCell.self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.row {
        case 0:
            let cellConf = TableCellConfigurator<ImageTableViewCell, URL?>.init(item: representation.image)
            cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConf).reuseId)!
            cellConf.configure(cell: cell)
        case 1:
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.configure(("Name:", representation.name))
        case 2:
            guard let shows = representation.castShows else {
                return UITableViewCell()
            }
            
            let confTuple = CollectionViewTableViewCellConfigurationTuple("Series", shows)
            let cellConf = TableCellConfigurator<CollectionViewTableViewCell, CollectionViewTableViewCellConfiguration>.init(item: (self, confTuple))
            cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConf).reuseId)!
            cellConf.configure(cell: cell)
        default:
            cell = UITableViewCell()
        }

        return cell
    }
    
    private func loadShowDetail(_ showID: Int) {
        toggleActivity()
        ShowViewModel().getShowDetail(showID) { [weak self] (show, error) in
            guard let self = self else { return }
            self.toggleActivity(state: false)
            
            if let error = error {
                UIAlertController.showAlert(in: self, withError: error)
                return
            }
            self.performSegue(withIdentifier: ShowDetailTableViewController.segueIdentifier, sender: show)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueTuple = (segue.identifier, segue.destination, sender)
        switch segueTuple {
        case (let id, let showDetailVC as ShowDetailTableViewController, let show as Show)
            where id == ShowDetailTableViewController.segueIdentifier:
            showDetailVC.representation = show
        default: break
        }
    }
    
}

//// MARK: - CollectionViewTableViewCellDelegate

extension PersonDetailTableViewController: CollectionViewTableViewCellDelegate {

    func collectionViewTableViewCell(_ collectionViewTableViewCell: CollectionViewTableViewCell, didSelect selection: Selectionable) {
        guard let show = selection as? Show else { return }
        loadShowDetail(show.id)
    }

}
