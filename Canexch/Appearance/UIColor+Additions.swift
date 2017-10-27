//
//  UIColor+Additions.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/26/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let appColorsBlueColor: UIColor = UIColor(red: 43.0/255.0, green: 202.0/255.0, blue: 236.0/255.0, alpha: 255.0/255.0)
    static let appColorsGreyColor: UIColor = UIColor(red: 140.0/255.0, green: 150.0/255.0, blue: 156.0/255.0, alpha: 255.0/255.0)
    static let appColorsWhiteColor: UIColor = .white
    
    static let mainViewControllerBackgroundColor: UIColor = appColorsBlueColor
    static let mainViewControllerExchangeRateBarIconsColor: UIColor = appColorsGreyColor
    static let mainViewControllerConversionTitleLabelTextColor: UIColor = appColorsWhiteColor.withAlphaComponent(0.6)
    static let mainViewControllerConversionValuesTextColor: UIColor = appColorsWhiteColor
}
