//
//  ExchangeRateManager.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import Foundation

class ExchangeRateManager {
    typealias ExchangeRates = [Currency: Double]
    
    let availableCurrencies: [Currency]
    private let exchangeRates: ExchangeRates
    init(baseCurrency: Currency, exchangeRates: ExchangeRates) {
        var exchangeRatesWithBaseCurrency = exchangeRates
        exchangeRatesWithBaseCurrency[baseCurrency] = 1.0
        self.exchangeRates = exchangeRatesWithBaseCurrency
        self.availableCurrencies = self.exchangeRates.map({ $0.key })
    }
    
    func exchangeRate(from base: Currency, to currency: Currency) -> Double {
        guard let baseExchangeRate: Double = exchangeRates[base] else { fatalError() }
        guard let toCurrencyExchangeRate: Double = exchangeRates[currency] else { fatalError() }
        return ((1.0 / baseExchangeRate) * toCurrencyExchangeRate)
    }
}
