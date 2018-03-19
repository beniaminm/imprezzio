//
//  UIViewController+Alerts.swift
//  SocialLoginSampleApp
//
//  Created by Beniamin Medan on 16/03/2018.
//  Copyright © 2018 Beniamin Medan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertControllerWithTitle(_ title: String) {
        let successAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(successAlert, animated: true, completion: nil)
    }
}
