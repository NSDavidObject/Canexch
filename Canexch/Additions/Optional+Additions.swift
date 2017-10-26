//
//  Optional+Additions.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import Foundation

extension Optional {
    
    func apply(_ closure: (Wrapped) -> Void) {
        if let wrapped = self {
            closure(wrapped)
        }
    }
}
