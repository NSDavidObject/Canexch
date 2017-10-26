//
//  ExchangeRateManagerTest.swift
//  CanexchTests
//
//  Created by David Elsonbaty on 10/26/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import XCTest
@testable import Canexch

class ExchangeRateManagerTest: XCTestCase {

    let baseCurrency =  Currency(abbreviation: "EUR")
    let cadCurrency = Currency(abbreviation: "CAD")
    let audCurrency = Currency(abbreviation: "AUD")
    lazy var exchangeRates = [cadCurrency: 1.4963, audCurrency: 1.5282]
    lazy var exchangeRateManager = ExchangeRateManager(baseCurrency: baseCurrency, exchangeRates: exchangeRates)
    
    func testExchangeRateAgainstBase() {
        let exchangeRate = self.exchangeRateManager.exchangeRate(from: baseCurrency, to: baseCurrency)
        XCTAssertEqual(exchangeRate, 1.0)
    }
    
    func testExchangeRateWithBaseCurrency() {
        let exchangeRate = self.exchangeRateManager.exchangeRate(from: baseCurrency, to: cadCurrency)
        XCTAssertEqual(exchangeRate, 1.4963, accuracy: 0.00001)
    }
    
    func testExchangeRateWithDifferentCurrencies() {
        let exchangeRate = self.exchangeRateManager.exchangeRate(from: cadCurrency, to: audCurrency)
        XCTAssertEqual(exchangeRate, 1.02131925416026, accuracy: 0.00001)
    }
    
    func testExchangeRateWithDifferentReversedCurrencies() {
        let exchangeRate = self.exchangeRateManager.exchangeRate(from: audCurrency, to: cadCurrency)
        XCTAssertEqual(exchangeRate, 0.9791257689, accuracy: 0.00001)
    }
}
