//
//  FixerGetNetworkRequest.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import Benetwork

protocol FixerNetworkGetRequest: FixerNetworkRequest {}
extension FixerNetworkGetRequest {
    
    var method: NetworkMethod {
        return .get
    }
}
