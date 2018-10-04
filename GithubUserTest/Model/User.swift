//
//  User.swift
//  GithubUserTest
//
//  Created by Chris Ferdian on 04/10/18.
//  Copyright © 2018 Chris Ferdian. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Mappable {

    var login: String?
    var avatar_url:String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        login <- map["login"]
        avatar_url <- map["avatar_url"]
    }
}
