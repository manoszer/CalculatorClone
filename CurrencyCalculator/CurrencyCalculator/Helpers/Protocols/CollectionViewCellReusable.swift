//
//  CollectionViewCellReusable.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import UIKit

protocol CollectionViewCellReusable {
    static var cellIdentifier: String { get }
    static var nibIdentifier: String { get }
    
    static func dequeueInCollectionView(_ collectionView: UICollectionView, forIndexPath: IndexPath) -> Self
}

extension UICollectionViewCell {
    fileprivate class func dequeueInCollectionView<T: UICollectionViewCell>(_ collectionView: UICollectionView, forIndexPath: IndexPath, type: T.Type) -> T {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: forIndexPath) as? T
        
        if let cell = cell {
            return cell
        } else {
            collectionView.register(UINib(nibName: String(describing: self), bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: forIndexPath) as! T
        }
    }
}

extension UICollectionViewCell: CollectionViewCellReusable {
    static var cellIdentifier: String { return String("\(self)Identifier") }
    static var nibIdentifier: String { return String(describing: self) }
    
    class func dequeueInCollectionView(_ collectionView: UICollectionView, forIndexPath: IndexPath) -> Self {
        return dequeueInCollectionView(collectionView, forIndexPath: forIndexPath, type: self)
    }
}
