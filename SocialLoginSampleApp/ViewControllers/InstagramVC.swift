//
//  InstagramVC.swift
//  SocialLoginSampleApp
//
//  Created by Beniamin Medan on 05/03/2018.
//  Copyright © 2018 Beniamin Medan. All rights reserved.
//

import UIKit
import SwiftInstagram

class InstagramVC: UIViewController, UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var postButton: UIButton!
    
    var image: UIImage?
    var videoURL: URL?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        postButton.addTarget(self, action:#selector(shareOnInstagram), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if image == nil && videoURL == nil {
            postButton.isHidden = true
        }
    }
    
    // Mark - Instagram login
    @IBAction func loginWithInstagramAction(_ sender: Any) {
        
        let api = Instagram.shared
        
        // Login
        api.login(from: navigationController!, withScopes: [.all], success: {
            self.getInstagramUserData()
            
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    // Mark - Instagram user data
    func getInstagramUserData() {
        let api = Instagram.shared
        
        if api.isAuthenticated {
            api.user("self", success: { user in
                
                print(user)
                self.getUserFollowers()
            }, failure: { error in
                
                print(error.localizedDescription)
            })
        }
    }
    
    func getUserFollowers() {
        let api = Instagram.shared
        
        if api.isAuthenticated {
            api.userFollowers(success: { users in
                print(users)
            }) { error in
            }
        }
    }
    
    // Mark - Share on Instagram
    @objc func shareOnInstagram() {
        var objectsToShare: [AnyObject]?
        if let imageToShare = image {
            objectsToShare = [imageToShare]
        } else if let videoUrl = videoURL {
            objectsToShare = [videoUrl as AnyObject]
        }
        
        if objectsToShare != nil {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare!, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    // Mark - Close the Instagram view
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
