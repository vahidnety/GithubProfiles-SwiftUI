//
//  User.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import Foundation

struct User: Decodable, Hashable {
    let id: Int
    let username: String
    let avatarUrl: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarUrl = "avatar_url"
        case url = "url"
    }
}

struct Results: Decodable{
    var items:[User]
}

