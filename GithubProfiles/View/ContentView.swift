//
//  ContentView.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import Combine
import SwiftUI

struct ContentView: View {
    
    @StateObject private var usersListVM = UserViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            if usersListVM.isLoading {
                LoadingView()
            }else{
                ZStack{
                    List {
                        ForEach(usersListVM.users, id: \.self) { item in
                            NavigationLink {
                                DetailsView(user: item)
                            }
                        label:{
                            UserRow(user: item)
                                .onAppear{
                                    //it loads results indifinetly
                                    if usersListVM.errorMessage.isEmpty && !searchText.isEmpty && !usersListVM.users.isEmpty && item.id == usersListVM.users.last?.id && usersListVM.users.contains(item){
                                        DispatchQueue.main.async {
                                            usersListVM.page += 1
                                            usersListVM.find(query: searchText, page:usersListVM.page)
                                        }
                                    }
                                }
                        }
                        }
                    }
                    .refreshable {
                        if !searchText.isEmpty {
                            DispatchQueue.main.async{
                                usersListVM.page = 1
                                usersListVM.find(query: searchText, page: 1)
                            }
                        }
                    }
                    .searchable(text: $searchText)
                    .onChange(of: searchText) { newValue in
                        // print(newValue)
                        if !searchText.isEmpty && newValue == searchText{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                usersListVM.page = 1
                                //search result users
                                usersListVM.find(query: searchText, page: 1)
                            }
                        }
                        else{
                            //empty search result
                            usersListVM.users.removeAll()
                        }
                    }
                    Text("Not Found")
                        .font(.title)
                        .opacity(usersListVM.users.isEmpty && !searchText.isEmpty && !usersListVM.isLoading ? 1 : 0)
                }
                .navigationTitle("Github Users")
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
