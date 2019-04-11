//
//  UITableView+Additions.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCells(_ classes: AnyClass...) {
        for cellClass in classes {
            let className = String(describing: cellClass)
            let nib = UINib(nibName: className, bundle: nil)
            self.register(nib, forCellReuseIdentifier: className)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(ofClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: ofClass)
        return self.dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
}
