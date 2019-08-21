//
//  UIViewController+JobSityiOSChallenge.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    func toggleActivity(state: Bool = true) {
        state ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        view.isUserInteractionEnabled = !state
    }
    
}
