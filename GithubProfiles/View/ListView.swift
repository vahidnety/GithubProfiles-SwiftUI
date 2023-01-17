//
//  ListView.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-06.
//

import SwiftUI

struct ListView: View {
    @StateObject private var usersListVM = UserViewModel()
    @State private var title: String = ""
    
    var type: String = ""
    var user : User
    
    var body: some View {
        VStack{
            if usersListVM.isLoading {
                LoadingView()
            }else{
                List {
                    ForEach(usersListVM.users, id: \.id) { item in
                        NavigationLink {
                            DetailsView(user: item)
                        }
                    label:{
                        UserRow(user: item)
                    }
                    }
                }
                .navigationBarTitle(Text(title), displayMode: .inline)
                .refreshable {
                    if(self.type.contains("followers")){
                        usersListVM.getItems(type: [User].self ,query: "\(user.username)/followers")
                    }
                    else {
                        usersListVM.getItems(type: [User].self ,query: "\(user.username)/following")
                    }
                }
            }
        }.onAppear{
            if(self.type.contains("followers")){
                title = "Followers of \(user.username)"
                usersListVM.getItems(type: [User].self ,query: "\(user.username)/followers")
            }
            else {
                title = "\(user.username) Followings"
                usersListVM.getItems(type: [User].self ,query: "\(user.username)/following")
            }
        }
    }
}

