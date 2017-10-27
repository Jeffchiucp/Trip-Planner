//
//  User.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/16/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import KeychainSwift

struct User
{
    var username : String
    let password: String
    var keychain = KeychainSwift()
    
    init(username: String, password: String)
    {
        self.username = username
        self.password = password
        let credential = BasicAuth.generateBasicAuthHeader(username: self.username, password: self.password)
        self.keychain.set(credential, forKey: "credential")
    }
}

extension User : Decodable
{
    enum UserKeys : String, CodingKey
    {
        case username
        case password
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: UserKeys.self)
        let username = try container.decode(String.self, forKey: .username)
        let password = try container.decode(String.self, forKey: .password)
        self.init(username: username, password: password)
    }
}
