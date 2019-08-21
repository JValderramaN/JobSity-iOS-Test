//
//  TableCellConfigurator.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit
import Kingfisher

typealias Cell = UIView

protocol CellsRegistrable {
    func registerCells()
}

protocol Configurable {
    associatedtype DataType
    func configure(data: DataType)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: Configurable, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: Cell  {
    
    static var reuseId: String {
        return String(describing: CellType.self)        
    }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
    
}

extension UITableView {
    
    func registerCell(_ cellClass: AnyClass) {
        let className = String(describing: cellClass)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
}

extension UICollectionView {
    
    func registerCell(_ cellClass: AnyClass) {
        let className = String(describing: cellClass)
        register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }
    
}

extension UITableViewCell {
    
    func configure(_ configurationTuple: (String?, Any?)) {
        textLabel?.text = configurationTuple.0
        detailTextLabel?.numberOfLines = 0
        
        if let stringText = configurationTuple.1 as? String {
            detailTextLabel?.text = stringText
        } else if let attributedStringText = configurationTuple.1 as? NSAttributedString {
            detailTextLabel?.attributedText = attributedStringText
        } else {
            detailTextLabel?.text = nil
        }        
    }
    
}
