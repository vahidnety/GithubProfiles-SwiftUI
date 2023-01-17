//
//  APIService.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import Foundation

enum NetworkError: LocalizedError {
    case response
    case data
    case decoding
    case invalidURL
    case notFound
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .response:
            return "Something went wrong. Please try again"
        case .data:
            return "There was a problem with your request. Please try again"
        case .decoding:
            return "Something went wrong. Please try again"
        case .invalidURL:
            return "Sorry we couldn't find anything. Please try a different search phrase"
        case .notFound:
            return "Sorry we couldn't find what you're looking for"
        case .serverError:
            return "Something went wrong please try again"
        }
    }
}

enum UserSearchEndPoint {
    case getUsersService(searchQuery: String, pageNumber: Int, perPage: Int = 20)
    
    var path: String {
        switch self {
        case .getUsersService(searchQuery: let searchQuery, pageNumber: let pageNumber, perPage: let perPage):
            return "search/users?q=\(searchQuery)&page=\(pageNumber)&per_page=\(perPage)"
        }
    }
    
    var url: URL? {
        let scheme = "https://"
        let domain = "api.github.com/"
        
        switch self {
        case .getUsersService(searchQuery: _, pageNumber: _, perPage: _):
            return URL(string: "\(scheme)\(domain)\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
    }
}

enum ItemsEndPoint {
    case getItemsService(urlQuery: String)
    
    var path: String {
        switch self {
        case .getItemsService(urlQuery: let urlQuery):
            return "users/\(urlQuery)"
        }
    }
    
    var url: URL? {
        let scheme = "https://"
        let domain = "api.github.com/"
        
        switch self {
        case .getItemsService(urlQuery: _):
            return URL(string: "\(scheme)\(domain)\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
    }
}

class APIService {
    static let shared = APIService()
    
    func getUsersService(searchQuery: String, pageNumber: Int, completed: @escaping (Result<Results, NetworkError>) -> Void) {
        
        guard let url = UserSearchEndPoint.getUsersService(searchQuery: searchQuery, pageNumber: pageNumber).url else {
            completed(.failure(.invalidURL))
            return
        }
        
        //        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.response))
                return
            }
            
            guard let data = data else {
                completed(.failure(.data))
                return
            }
            
            do {
                let deconder = JSONDecoder()
                let results = try deconder.decode(Results.self, from: data)
                
                completed(.success(results))
                
            } catch {
                completed(.failure(.decoding))
                print(error)
            }
        }
        task.resume()
        
    }
    
    func getItemsService<T: Decodable>(type: T.Type,urlQuery: String,completed: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = ItemsEndPoint.getItemsService(urlQuery: urlQuery).url else {
            completed(.failure(.invalidURL))
            return
        }
//        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.response))
                return
            }
            
            guard let data = data else {
                completed(.failure(.data))
                return
            }
            
            do {
                let deconder = JSONDecoder()
                let results = try deconder.decode(type, from: data)
                
                completed(.success(results))
                
            } catch {
                completed(.failure(.decoding))
                print(error)
            }
        }
        task.resume()
        
    }
}
