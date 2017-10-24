//
//  Borderable.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import UIKit

protocol Borderable {
    
    /// A UIView with border line around it
    ///
    /// - Parameters:
    ///   - color: The color of border line
    ///   - borderWidth: The size of border line
    func bordered(color: UIColor, borderWidth: CGFloat)
    
    func rounded(cornerRadius: CGFloat)
}

extension Borderable where Self: UIView {
    
    /// A UIView with border line around it
    ///
    /// - Parameters:
    ///   - color: The color of border line, the default is white
    ///   - borderWidth: The size of border line, the default is 2.0
    func bordered(color: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func rounded(cornerRadius: CGFloat = 15.0) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}

extension UIView: Borderable {}
