//
//  ShowDetailTableViewController.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 19/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

class ShowDetailTableViewController: UITableViewController, Representable, CellsRegistrable {
    
    // MARK: - Representable
    
    typealias Mask = Show
    var representation: Show!
    
    // MARK: - Instance
    
    static let segueIdentifier = "toShowDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {
        tableView.registerCell(ImageTableViewCell.self)
        tableView.registerCell(CollectionViewTableViewCell.self)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Showcase"
        default: return "Episodes"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : representation.episodesBySeason.keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let indexPathTuple = (indexPath.section, indexPath.row)
        switch indexPathTuple {
        case (0, 0):
            let cellConf = TableCellConfigurator<ImageTableViewCell, URL?>.init(item: representation.image)
            cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConf).reuseId)!
            cellConf.configure(cell: cell)
        case (0, 1):
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.configure(("Name:", representation.name))
        case (0, 2):
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.configure(("Summary:", representation.summary?.htmlToAttributedString))
        case (0, 3):
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.configure(("Genres:", representation.genres.joinedWithCommas))
        case (0, 4):
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)            
            cell.configure(("Schedule:", representation.schedule.description))
        case (1, let key):
            let seasonKey = key + 1
            guard let season = (representation.episodesBySeason.first { $0.key == seasonKey })
                else { return UITableViewCell() }
            
            let confTuple = CollectionViewTableViewCellConfigurationTuple("\(season.key)", season.value)
            let cellConf = TableCellConfigurator<CollectionViewTableViewCell, CollectionViewTableViewCellConfiguration>.init(item: (self, confTuple))
            cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConf).reuseId)!
            cellConf.configure(cell: cell)
            
        default:
            cell = UITableViewCell()            
        }

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueTuple = (segue.identifier, segue.destination, sender)
        switch segueTuple {
        case (let id, let episodeDetailVC as EpisodeDetailTableViewController, let episode as Episode)
            where id == EpisodeDetailTableViewController.segueIdentifier:
            episodeDetailVC.representation = episode
        default: break
        }
    }

}

// MARK: - CollectionViewTableViewCellDelegate

extension ShowDetailTableViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCell(_ collectionViewTableViewCell: CollectionViewTableViewCell, didSelect selection: Selectionable) {
        performSegue(withIdentifier: EpisodeDetailTableViewController.segueIdentifier, sender: selection)
    }
    
}
