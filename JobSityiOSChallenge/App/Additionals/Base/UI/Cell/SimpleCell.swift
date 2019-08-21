//
//  SimpleInfoTableViewCell.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit
import Kingfisher

/// Represents a basic cell, using `SimpleDataSourceExposable` configuration
class SimpleCell: UITableViewCell, Configurable {
    
    @IBOutlet weak var imageImageView: UIImageView! {
        didSet {
            imageImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet weak var textInfoLabel: UILabel!
    
    func configure(data: SimpleDataSourceExposable) {    
        let placeholderImage = UIImage(imageLiteralResourceName: "loading")
        imageImageView.kf.setImage(with: data.url, placeholder: placeholderImage)
        textInfoLabel.text = data.text
    }
    
}
