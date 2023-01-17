//
//  UserViewModel.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    //search result users
    @Published var users: [User] = []
    
    //current results of the page
    @Published var page = 1
    
    //isloading is to show/hide progress view/indicator
    @Published var isLoading: Bool = false
    
    //User details info
    @Published var userDetails: UserDetails?
    
    // error message
    @Published var errorMessage: String = ""
    
    func find(query: String,  page: Int) {
        if(isLoading){
            return
        }
        self.isLoading = true
        
        APIService.shared.getUsersService(searchQuery: query, pageNumber: page) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch result {
                
            case .success(let users):
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else { return }
                    //                    print(users.items)
                    //remove previous datas if new query request
                    if self.page == 1 {
                        self.users.removeAll()
                    }
                    
                    //check redundant loaded results and ignore it
                    self.users = Array(Set(self.users).union(Set(users.items)))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error.errorDescription ?? "Unkown Error"
                    self.errorMessage = err
                    print(err)
                }
            }
        }
    }
    
    func getItems<T: Decodable>(type: T.Type, query: String) {
        if(isLoading){
            return
        }
        self.isLoading = true
        //        print(query)
        APIService.shared.getItemsService(type: type, urlQuery: query) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch result {
                
            case .success(let items):
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else { return }
                    //print(items)
                    if let details = items as? UserDetails {
                        self.userDetails = details
                    }
                    else{
                        guard let users = items as? [User] else {  return  }
                        self.users = users
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error.errorDescription ?? "Unkown Error"
                    self.errorMessage = err
                    print(err)
                }
            }
        }
    }
    
}
