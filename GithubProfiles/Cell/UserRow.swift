//
//  UserRow.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import SwiftUI

struct UserRow: View {
    let user: User
    
    var body: some View {
        Text(user.username)
    }
}
