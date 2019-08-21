//
//  PeopleViewController.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, Representable {
    
    // MARK: - SearchRepresentable
    
    typealias Mask = [Person]
    var representation: [Person]! = [] {
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
    
    private let peopleViewModel = PeopleViewModel()
    
    private func loadShows(for person: Person) {
        view.endEditing(true)
        
        toggleActivity()
        peopleViewModel.getPersonDetail(person.id) { [weak self] (shows, error) in
            guard let self = self else { return }
            self.toggleActivity(state: false)
            
            if let error = error {
                UIAlertController.showAlert(in: self, withError: error)
                return
            }
            
            let personDetailed = Person(id: person.id, name: person.name, image: person.image, castShows: shows)
            self.performSegue(withIdentifier: PersonDetailTableViewController.segueIdentifier, sender: personDetailed)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueTuple = (segue.identifier, segue.destination, sender)
        switch segueTuple {
        case (let id, let personDetailVC as PersonDetailTableViewController, let person as Person)
            where id == PersonDetailTableViewController.segueIdentifier:
            personDetailVC.representation = person
        default: break
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = representation[indexPath.row]
        let cellConf = TableCellConfigurator<SimpleCell, SimpleDataSourceExposable>.init(item: person)
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConf).reuseId)!
        cellConf.configure(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = representation[indexPath.row]
        loadShows(for: person)
    }
    
}

// MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        peopleViewModel.getPeople(by: searchText) { [weak self]  (people, error) in
            guard let self = self else { return }
            
            if let error = error {
                UIAlertController.showAlert(in: self, withError: error)
                return
            }
            
            guard let people = people else { return }
            self.representation = people
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
