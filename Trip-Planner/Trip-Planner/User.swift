//
//  User.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/16/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit

struct User
{
    var username : String
    var email : String
}

extension User : Decodable
{
    enum UserKeys : String, CodingKey
    {
        case username
        case email
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: UserKeys.self)
        let username = try container.decode(String.self, forKey: .username)
        let email = try container.decode(String.self, forKey: .email)
        self.init(username: username, email: email)
    }
}
