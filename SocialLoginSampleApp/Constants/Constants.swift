//
//  Constants.swift
//  SocialLoginSampleApp
//
//  Created by Beniamin Medan on 06/03/2018.
//  Copyright © 2018 Beniamin Medan. All rights reserved.
//

import Foundation

struct API
{
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "282b169d317b4d60819f61d2a54734e2"
    static let INSTAGRAM_CLIENTSERCRET = "9e30044380a04c47b665c0a881b31df1"
    static let INSTAGRAM_REDIRECT_URI = "https://localhost:3000/auth/instagram/callback"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "basic+follower_list+public_content+comments+likes+relationships" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}
