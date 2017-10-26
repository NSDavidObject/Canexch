//
//  Currency.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

struct Currency {
    let abbreviation: String
}

extension Currency: Equatable {
    
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.abbreviation == rhs.abbreviation
    }
}

extension Currency: Hashable {
    
    public var hashValue: Int {
        return abbreviation.hashValue
    }
}
