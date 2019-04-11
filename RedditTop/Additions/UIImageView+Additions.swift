//
//  UIImageView+Additions.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFromURL(_ url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let response = cache.cachedResponse(for: request), let image = UIImage(data: response.data) {
            self.image = image
        }
        else {
            self.image = nil
            let indicator = UIActivityIndicatorView(style: .gray)
            self.addSubview(indicator)
            indicator.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            indicator.startAnimating()
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                var resultImage: UIImage? = nil
                
                if let data = data, let response = response, let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedResponse, for: request)
                    resultImage = image
                }
                
                DispatchQueue.main.async {
                    self.image = resultImage
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
                
            }.resume()
        }
    }
}
