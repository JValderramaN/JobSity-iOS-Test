//
//  UIAlertController+JobSityiOSChallenge.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    @discardableResult
    class func showAlert(in controller: UIViewController, withError error: Error) -> UIAlertController {
        return UIAlertController.showAlert(in: controller, message: error.localizedDescription)
    }
    
    @discardableResult
    class func showAlert(in controller: UIViewController,
                         title: String = "",
                         message: String,
                         okButton: String = "Ok",
                         cancelButton: String? = nil,
                         okAction: (() -> Void)? = nil,
                         cancelAction: (() -> Void)? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: okButton, style: .default, handler: { (alertAction) in
            okAction?()
        }))
        
        if let cancelButton = cancelButton {
            alertController.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: { (alertAction) in
                cancelAction?()
            }))
        }
        
        DispatchQueue.main.async { [weak controller] in
            controller?.present(alertController, animated: true, completion: nil)
        }
        
        return alertController
    }
}
