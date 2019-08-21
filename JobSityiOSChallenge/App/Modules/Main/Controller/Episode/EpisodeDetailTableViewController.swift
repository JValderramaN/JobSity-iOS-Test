//
//  EpisodeDetailTableViewController.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

class EpisodeDetailTableViewController: UITableViewController, Representable, CellsRegistrable {
    
    // MARK: - Representable
    
    typealias Mask = Episode
    var representation: Episode!
    
    // MARK: - Instance
    
    static let segueIdentifier = "toEpisodeDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {
        tableView.registerCell(ImageTableViewCell.self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            cell.configure(("Name:", "\(representation.number) - \(representation.name)"))
        case 2:
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.configure(("Season:", "\(representation.season)"))
        case 3:
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.configure(("Summary:", representation.summary?.htmlToAttributedString))
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
}
