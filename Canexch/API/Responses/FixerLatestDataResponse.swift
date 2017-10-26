//
//  FixerLatestDataResponse.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import Benetwork

struct FixerLatestDataResponse: JSONConstructible {
    
    let baseCurrency: Currency
    let exchangeRates: [Currency: Double]
    init(json: JSONDictionary) throws {
        let baseCurrencyAbbreviation: String = try json.value("base").required()
        let baseCurrency = Currency(abbreviation: baseCurrencyAbbreviation)
        let rates: [String: Double] = try json.value("rates").required()
        
        var exchangeRates: [Currency: Double] = [:]
        for exchangeRate in rates {
            let currency = Currency(abbreviation: exchangeRate.key)
            exchangeRates[currency] = exchangeRate.value
        }
        
        self.baseCurrency = baseCurrency
        self.exchangeRates = exchangeRates
    }
}
