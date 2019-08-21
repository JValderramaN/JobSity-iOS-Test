//
//  ShowsViewController.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 18/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController, SearchRepresentable {    

    // MARK: - SearchRepresentable
    
    typealias Mask = [Show]
    var representation: [Show]! = [] {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
    
    var resultRepresentation: [Show]? {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerCell(SimpleCell.self)
        }
    }
    
    // MARK: - Instance    
    
    private let showViewModel = ShowViewModel()
    private var isPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    private func getShows(paging: Bool = false) {
        var page =  0
        
        if paging,
            let lastShowID = representation.last?.id {
            page = Int(floor(Float(lastShowID)/ShowViewModel.maxResult)) + 1
            isPaging = true
        }
        
        toggleActivity()
        showViewModel.getShows(by: page) { [weak self] (shows, error) in
            guard let self = self else { return }
            self.isPaging = false
            self.toggleActivity(state: false)
            
            if let error = error {
                UIAlertController.showAlert(in: self, withError: error)
                return
            }
            
            guard let shows = shows else {
                return
            }
            
            if paging {
                self.representation.append(contentsOf: shows)
            } else {
                self.representation = shows
            }
        }
    }
    
    private func loadEpisodes(_ showID: Int) {
        view.endEditing(true)
        toggleActivity()
        showViewModel.getShowDetail(showID) { [weak self] (show, error) in
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ShowsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultRepresentation ?? representation).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = (resultRepresentation ?? representation)[indexPath.row]
        let cellConf = TableCellConfigurator<SimpleCell, SimpleDataSourceExposable>.init(item: show)
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConf).reuseId)!
        cellConf.configure(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = (resultRepresentation ?? representation)[indexPath.row]
        loadEpisodes(show.id)
    }
    
}

// MARK: - Reloadable

extension ShowsViewController: Reloadable {
    
    func reload() {
        getShows()
    }
    
}

// MARK: - UISearchBarDelegate

extension ShowsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            resultRepresentation = nil
            return
        }
        
        showViewModel.getShows(by: searchText) { [weak self] (shows, error) in
            guard let self = self else { return }
            
            if let error = error {
                UIAlertController.showAlert(in: self, withError: error)
                return
            }
            
            guard let shows = shows else {
                self.resultRepresentation = nil
                return
            }

            self.resultRepresentation = shows
        }        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

// MARK: - UIScrollViewDelegate

extension ShowsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let requestOffset = (scrollView.contentOffset.y + scrollView.bounds.size.height) - (scrollView.contentSize.height - 50)
        guard requestOffset > 0, !isPaging, resultRepresentation == nil else  { return }
        getShows(paging: true)
    }
    
}
