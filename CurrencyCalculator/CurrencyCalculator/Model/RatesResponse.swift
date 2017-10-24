//
//  RatesResponse.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import Foundation

struct RatesResponse: Decodable {
    let base: String
    let date: String
    let rates: Dictionary<String, Double>
}
