//
//  ImageTableViewCell.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 19/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit
import Kingfisher

/// Represents a basic cell with only an image (`URL`) to load in whole content
class ImageTableViewCell: UITableViewCell, Configurable {

    typealias DataType = URL?
    @IBOutlet weak var imageImageView: UIImageView! {
        didSet {
            imageImageView.kf.indicatorType = .activity
        }
    }
    
    func configure(data: URL?) {
        imageImageView.kf.setImage(with: data)
    }

}
