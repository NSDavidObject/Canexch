//
//  NumberInputTextfieldDelegate.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/26/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import UIKit

// MARK: - NumberInputTextfieldDelegateDelegate

protocol NumberInputTextfieldDelegateDelegate: class {
    func numberInputTextfieldDelegate(_ delegate: NumberInputTextfieldDelegate, didUpdateToValue updatedValue: Double)
}

// MARK: - NumberInputTextfieldDelegate

class NumberInputTextfieldDelegate: NSObject {
    
    private static let invalidCharacters = NSCharacterSet(charactersIn: "1234567890.").inverted
    private var value: Int = 0 {
        didSet {
            updateDelegateWithChange()
        }
    }
    
    weak var delegate: NumberInputTextfieldDelegateDelegate?
    
    let maxValueAmount: Double
    init(maxValueAmount: Double = 9999.99, initalValue: Double = 0.0) {
        self.maxValueAmount = maxValueAmount
        self.value = Int(initalValue * 10)
    }
    
    func resetValueAmount(to newValue: Double = 0.0) {
        self.value = Int(newValue * 10)
    }
    
    func updateDelegateWithChange() {
        let updatedValueAmount = valueAmount(forValue: value)
        delegate?.numberInputTextfieldDelegate(self, didUpdateToValue: updatedValueAmount)
    }
}

// MARK: - UITextFieldDelegate

extension NumberInputTextfieldDelegate: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString: String) -> Bool {
        guard isStringOfValidEntry(replacementString) else { return false }

        var updatedValue = value
        if let digit = Int(replacementString) {
            updatedValue = (updatedValue * 10) + digit
        } else if replacementString == "" {
            updatedValue = updatedValue/10
        }
        
        let updatedValueAmount = valueAmount(forValue: updatedValue)
        let shouldUpdateCurrentValue = (updatedValueAmount <= maxValueAmount)
        if shouldUpdateCurrentValue {
            value = updatedValue
        }
        
        return false
    }
}

// MARK: - Private Helpers

fileprivate extension NumberInputTextfieldDelegate {
    
    func isStringOfValidEntry(_ string: String) -> Bool {
        let invalidCharacterSet = NumberInputTextfieldDelegate.invalidCharacters
        let range = string.rangeOfCharacter(from: invalidCharacterSet)
        return (range == nil)
    }
    
    func valueAmount(forValue value: Int) -> Double {
        return Double(value / 100) + Double(value % 100) / 100
    }
}
