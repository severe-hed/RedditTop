//
//  RedditApiManager.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import Foundation

enum RedditEndpoint: String {
    case top = "top.json"
}

final class RedditApiManager {
    static let shared = RedditApiManager()
    private let apiURL = "https://www.reddit.com/"
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func fetchTop(limit: Int = 25, after: String? = nil, completion: @escaping (Result<[RedditPost], NSError>) -> Void) {
        var urlString = apiURL + RedditEndpoint.top.rawValue
        urlString += "?limit=" + String(limit)
        
        if let after = after {
            urlString += "&after=" + after
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Bad url"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error as NSError))
            }
            else if let data = data {
                do {
                    let posts = try JSONDecoder().decode(RedditListing.self, from: data).posts
                    completion(.success(posts))
                }
                catch let error as NSError {
                    completion(.failure(error))
                }
            }
            else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unknown error"])))
            }
        }.resume()
        
    }
}
