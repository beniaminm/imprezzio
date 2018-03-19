//
//  FacebookVC.swift
//  SocialLoginSampleApp
//
//  Created by Beniamin Medan on 08/03/2018.
//  Copyright © 2018 Beniamin Medan. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
import FacebookShare

class FacebookVC: UIViewController {
    
    @IBOutlet weak var getFriendsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var image: UIImage?
    var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton( publishPermissions: [.publishActions])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        getFriendsButton.isHidden = true
        shareButton.isHidden = true
    }
    
    // MARK: Facebook user data
    //Fetching the user data
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    print(dict)
                }
            })
        }
    }
    
    // MARK:  Facebook user's friends list
    @IBAction func getFriendsList(_ sender: Any) {
        let params = ["fields": "id, first_name, last_name, name, email, picture"]
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)

        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in

            if error == nil {
                if let userData = result as? [String:Any] {
                    print(userData)
                }
            } else {
                print("Error Getting Friends \(String(describing: error))");
            }
        })

        connection.start()
    }
    
    // MARK: Share media content on Facebook
    @IBAction func shareOnFacebookAction(_ sender: Any) {
        if let imageToShare = image {
            let photo = Photo(image: imageToShare , userGenerated: true)
            let content = PhotoShareContent(photos: [photo])
            let sharer = GraphSharer(content: content)
            
            do {
                try sharer.share()

            } catch {
                print(error)
            }

            sharer.completion = { result in
                // Handle share result
                switch result {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success( _):
                    self.showAlertControllerWithTitle("Photo uploaded successfully")
                    break
                case .cancelled:
                    break
                }
            }
        }
        else if let videoUrl = videoURL {
            let video = Video(url: videoUrl)
            let content = VideoShareContent(video:video)
            let sharer = GraphSharer(content: content)
            
            do {
                try sharer.share()
                
            } catch {
                print(error)
            }
            
            sharer.completion = { result in
                switch result {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success( _):
                    self.showAlertControllerWithTitle("Video uploaded successfully")
                    break
                case .cancelled:
                    break
                }
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FacebookVC: LoginButtonDelegate
{
    // MARK: Facebook Login Button Delegate
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        getFriendsButton.isHidden = false
        
        if image != nil || videoURL != nil {
            shareButton.isHidden = false
        }
        
        getFBUserData()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        getFriendsButton.isHidden = true
        shareButton.isHidden = true
        image = nil
        videoURL = nil
    }
}
