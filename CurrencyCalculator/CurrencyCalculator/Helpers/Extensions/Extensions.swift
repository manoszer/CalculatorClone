//
//  Extensions.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import UIKit

struct Number {
    static let formatterWithCommas: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 20
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Double {
    var formattedWithCommas: String? {
        if !self.isFinite {
            return "Error"
        }
        return Number.formatterWithCommas.string(from: self as NSNumber)
    }
}
