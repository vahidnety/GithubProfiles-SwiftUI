//
//  UserDetails.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-06.
//

import Foundation

struct UserDetails: Decodable {
    let username: String
    let avatarUrl: String
    let url: String
    let fullname: String
    let followersUrl: String
    let followingUrl: String
    let company: String?
    let location: String?
    let time: String?
    let bio: String?
    let blog: String?
    let following: Int
    let followers: Int
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case avatarUrl = "avatar_url"
        case url, company , location, time, bio, blog
        case fullname = "name"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case following
        case followers

    }
}


