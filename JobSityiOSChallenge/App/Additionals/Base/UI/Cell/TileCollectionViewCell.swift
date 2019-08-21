//
//  TileCollectionViewCell.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell, Configurable {

    @IBOutlet weak var tileInfoView: TileInfoView!
    
    func configure(data: TileInfoView.DataType) {
        tileInfoView.configure(data: data)
    }

}
