//
//  CollectionViewTableViewCell.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: class {
    func collectionViewTableViewCell(_ collectionViewTableViewCell: CollectionViewTableViewCell, didSelect selection: Selectionable)
}

typealias CollectionViewTableViewCellConfiguration = (delegate: CollectionViewTableViewCellDelegate?, dataTuple: CollectionViewTableViewCellConfigurationTuple)

typealias CollectionViewTableViewCellConfigurationTuple = (title: String, values: [SimpleDataSourceExposable])

class CollectionViewTableViewCell: UITableViewCell, Configurable {

    private final let aspectRatioForCellHeight: CGFloat = 0.6
    private final let minimumLineSpacing: CGFloat = 2
    private final let cellHeight: CGFloat = 130
    weak var delegate: CollectionViewTableViewCellDelegate?

    @IBOutlet weak var infoCollectionView: UICollectionView! {
        didSet {
            configureCollection()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var data: CollectionViewTableViewCellConfiguration! {
        didSet {
            titleLabel.text = "Season \(data.dataTuple.title)"
            infoCollectionView.reloadData()
        }
    }    
    
    func configure(data: CollectionViewTableViewCellConfiguration) {
        self.data = data
        delegate = data.delegate
    }
    
    private func configureCollection() {
        guard let layout = infoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        infoCollectionView.delegate = self
        infoCollectionView.dataSource = self
        
        // Spacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumLineSpacing
        
        let collectionHeight = cellHeight * aspectRatioForCellHeight
        let desireSize = CGSize(width: collectionHeight, height: collectionHeight)
        layout.itemSize = desireSize
        
        // Register cell
        infoCollectionView.registerCell(TileCollectionViewCell.self)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        infoCollectionView.layoutIfNeeded()
        infoCollectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: cellHeight)
        return infoCollectionView.collectionViewLayout.collectionViewContentSize
    }
    
}

// MARK: - UICollectionViewDelegate

extension CollectionViewTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selection = data.dataTuple.values[indexPath.row]
        delegate?.collectionViewTableViewCell(self, didSelect: selection)
    }
    
}

// MARK: - UICollectionViewDataSource

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.dataTuple.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let simpleData = data.dataTuple.values[indexPath.row]
        let cellConf = TableCellConfigurator<TileCollectionViewCell, SimpleDataSourceExposable>.init(item: simpleData)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: cellConf).reuseId, for: indexPath)
        cellConf.configure(cell: cell)
        return cell
    }
    
}
