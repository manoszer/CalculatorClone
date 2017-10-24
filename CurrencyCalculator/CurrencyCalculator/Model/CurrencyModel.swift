//
//  CurrencyModel.swift
//  CurrencyCalculator
//
//  Created by Emmanouil Zervos on 24/10/2017.
//  Copyright © 2017 manos. All rights reserved.
//

import Foundation

class CurrencyModel: NSObject {
    var rates: RatesResponse?
    
    func getCurrencyRates(base : String?, completion: @escaping(_ isSuccesfull: Bool) -> ())  {
        var urlString = "https://api.fixer.io/latest"
        if base != nil {
            urlString = "\(urlString)?base=\(base!)"
        }
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(false)
            }
            
            guard let data = data else {return}
            do {
                self.rates = try JSONDecoder().decode(RatesResponse.self, from: data)
                completion(true)
            } catch _ {
                completion(false)
            }
            }.resume()
    }
    
    
}
