//
//  Reloadble.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 19/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import UIKit

let retryButtonTag: Int = -10

@objc protocol Reloadable {
    func reload()
    @objc optional func prepareForRetryButton(to show: Bool)
}

extension Reloadable where Self: UIViewController {
    
    func showReloadAlert(title: String? = nil,
                         message: String? = nil,
                         leftButtonTitle: String? = nil,
                         rightButtonTitle: String? = nil,
                         leftButtonAction: (() -> Void)? = nil,
                         rightButtonAction: (() -> Void)? = nil) {
        
        UIAlertController.showAlert(in: self,
                          title: title ?? "",
                          message: message ?? "Check internet conection",
                          okButton: rightButtonTitle ?? "Retry",
                          cancelButton: leftButtonTitle ?? "Ok",
                          okAction: rightButtonAction ?? reload,
                          cancelAction: leftButtonAction)
    }
    
    @discardableResult
    func toggleRetryButton(_ show: Bool = true, mayPrepare: Bool = true) -> UIButton {
        var retryButton: UIButton
        
        if let currentRetryButton = view.viewWithTag(retryButtonTag) as? UIButton {
            retryButton = currentRetryButton
        } else {
            retryButton = UIButton(type: .custom)
            retryButton.setTitle("Retry", for: .normal)
            retryButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
            retryButton.tag = retryButtonTag
            retryButton.backgroundColor = .white
            retryButton.setTitleColor(.blue, for: .normal)
            retryButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            retryButton.border(withRadius: 10, borderWidth: 1, borderColor: .black)
            view.addSubview(retryButton)
            view.bringSubviewToFront(retryButton)
            retryButton.constraintsCenterXInSuperview()
            retryButton.constraintsCenterYInSuperview()
        }
        
        mayPrepare ? prepareForRetryButton?(to: show) : ()
        retryButton.isHidden = !show
        return retryButton
    }
    
    func createRefreshControl(callback: Selector? = nil) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: callback ?? #selector(reload), for: .valueChanged)
        return refreshControl
    }
    
}
