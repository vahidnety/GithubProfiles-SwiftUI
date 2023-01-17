//
//  DetailsView.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailsView: View {
    
    @StateObject private var usersListVM = UserViewModel()
    
    var user : User
    
    var body: some View {
        
        VStack {
            if usersListVM.isLoading {
                LoadingView()
            }else{
                HStack(alignment: .center) {
                    AnimatedImage(url: URL(string: user.avatarUrl)!)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .cornerRadius(15)
                }
                VStack(alignment: .center) {
                    Text("***User Name :*** \(user.username)")
                    Text("***Name :*** \(usersListVM.userDetails?.fullname ?? "-")")
                    Text("***Description***")
                    Text("***Company :*** \(usersListVM.userDetails?.company ?? "-")")
                    Text("***Location :*** \(usersListVM.userDetails?.location ?? "-")")
                    Text("***TimeZone :*** \(usersListVM.userDetails?.time ?? "-")")
                    Text("***Bio :*** \(usersListVM.userDetails?.bio ?? "-")")
                    
                    NavigationLink(destination: ListView(type:"followings", user: user)) {
                        Text("\(usersListVM.userDetails?.following ?? 0) followings")
                    }.padding(5)
                    NavigationLink(destination: ListView(type:"followers", user: user)) {
                        Text("\(usersListVM.userDetails?.followers ?? 0) followers")
                    }.padding(5)

                }.padding(10)
            }
        }
        .onAppear{
            usersListVM.getItems(type: UserDetails.self, query: "\(user.username)")
        }
    }
}
