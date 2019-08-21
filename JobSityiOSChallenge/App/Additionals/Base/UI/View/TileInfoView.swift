//
//  TileInfoView.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

/// Represents a UIView with `SimpleDataSourceExposable` configurable. UI is organized in different way than `SimpleCell`
class TileInfoView: UIView, Configurable {

    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var imageImageView: UIImageView! {
        didSet {
            imageImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet weak var textInfoLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: TileInfoView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func configure(data: SimpleDataSourceExposable) {
        let placeholderImage = UIImage(imageLiteralResourceName: "loading")
        imageImageView.kf.setImage(with: data.url, placeholder: placeholderImage)
        textInfoLabel.text = data.text
    }
    
}
