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
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 20.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: url) { (data, response, error) in
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
