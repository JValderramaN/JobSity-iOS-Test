//
//  LoginViewController.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBAction func enterButtonTapped() {
        checkAuthentication()
    }
    
}

extension LoginViewController {
    
    func checkAuthentication() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "Provide identity in order to continue"
        
        guard localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) else {
            guard let error = authError else { return }
            UIAlertController.showAlert(in: self, withError: error)
            return
        }
        
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
            if success {
                DispatchQueue.main.async { self.performSegue(withIdentifier: "toLobby", sender: nil) }
            } else {
                guard let error = evaluateError else { return }
                UIAlertController.showAlert(in: self, withError: error)
            }
        }
    }
    
}
