//
//  MainViewController.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import UIKit

private struct Constants {
    
    // I'd normally create a UIColor category which includes the color palette of the app but don't wanna spend more time on these small details/optimizations for this take home. Also the same for UIFonts
    static let backgroundColor: UIColor = UIColor(red:43.0/255.0, green:202.0/255.0, blue:236.0/255.0, alpha:255.0/255.0)
    static let exchangeRateBarIconsColor: UIColor = UIColor(red:140.0/255.0, green:150.0/255.0, blue:156.0/255.0, alpha:255.0/255.0)
    static let conversionTitleLabelTextColor: UIColor = UIColor.white.withAlphaComponent(0.6)
    static let conversionValuesTextColor: UIColor = UIColor.white
    
    static let defaultBaseCurrency: Currency = Currency(abbreviation: "USD")
    static let defaultConversionCurrency: Currency = Currency(abbreviation: "CAD")
}

class MainViewController: UIViewController {

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    @IBOutlet weak var exchangeIconImageView: UIImageView!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var conversionCurrencyButton: UIButton!
    
    @IBOutlet weak var conversionBaseTitleLabel: UILabel!
    @IBOutlet weak var conversionToTitleLabel: UILabel!
    
    @IBOutlet weak var convertedValueTitleLabel: UILabel!
    @IBOutlet weak var conversionBaseValueTextField: UITextField!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let textFieldDelegate: NumberInputTextfieldDelegate = NumberInputTextfieldDelegate()
    var baseCurrency: Currency = Constants.defaultBaseCurrency
    var conversionCurrency: Currency? = Constants.defaultConversionCurrency
    var exchangeRateManager: ExchangeRateManager? {
        didSet {
            exchangeRateManager.apply({ setup(withExchangeRateManager: $0) })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Canexch"
        
        textFieldDelegate.delegate = self
        conversionBaseValueTextField.delegate = textFieldDelegate
        
        // Disable textfield until loading completes
        conversionBaseValueTextField.isEnabled = false
        
        setupAppearance()
        fetchExchangeRates()
    }

    func setupAppearance() {
        
        view.backgroundColor = Constants.backgroundColor
        exchangeIconImageView.tintColor = Constants.exchangeRateBarIconsColor
        exchangeIconImageView.image = #imageLiteral(resourceName: "exchange-icon").withRenderingMode(.alwaysTemplate)
        
        baseCurrencyButton.setTitleColor(Constants.exchangeRateBarIconsColor, for: .normal)
        conversionCurrencyButton.setTitleColor(Constants.exchangeRateBarIconsColor, for: .normal)
        
        conversionBaseTitleLabel.textColor = Constants.conversionTitleLabelTextColor
        conversionToTitleLabel.textColor = Constants.conversionTitleLabelTextColor
    
        convertedValueTitleLabel.textColor = Constants.conversionValuesTextColor
        conversionBaseValueTextField.textColor = Constants.conversionValuesTextColor
    }
    
    func fetchExchangeRates() {
        
        let latestDataRequest = FixerLatestDataRequest()
        latestDataRequest.requestAndConstructOnBackgroundQueue { [weak self] response in
            guard let strongSelf = self else { return }
            guard let constructedResponse = response.result.value else { return }

            let baseCurrency = constructedResponse.baseCurrency
            var exchangeRates = constructedResponse.exchangeRates
            exchangeRates[baseCurrency] = 1.0
            
            let exchangeRateManager = ExchangeRateManager(baseCurrency: baseCurrency, exchangeRates: exchangeRates)
            if let conversionCurrency = strongSelf.conversionCurrency, !exchangeRateManager.availableCurrencies.contains(conversionCurrency) {
                if let conversionCurrency = exchangeRateManager.availableCurrencies.first(where: { $0 != baseCurrency }) {
                    strongSelf.conversionCurrency = conversionCurrency
                } else {
                    strongSelf.conversionCurrency = nil
                }
            }
            
            if !exchangeRateManager.availableCurrencies.contains(strongSelf.baseCurrency) {
                strongSelf.baseCurrency = baseCurrency
            }
            
            strongSelf.exchangeRateManager = exchangeRateManager
            
            let conversionCurrencyTitle: String = strongSelf.conversionCurrency?.abbreviation ?? "NAN"
            strongSelf.baseCurrencyButton.setTitle(strongSelf.baseCurrency.abbreviation, for: .normal)
            strongSelf.conversionCurrencyButton.setTitle(conversionCurrencyTitle, for: .normal)
            
            strongSelf.loadingLabel.isHidden = true
            strongSelf.conversionBaseValueTextField.isEnabled = true
        }
    }
    
    func setup(withExchangeRateManager exchangeRateManager: ExchangeRateManager) {
        computeAndDisplayExchangeRate(forBaseConversionValue: 0)
    }
    
    func computeAndDisplayExchangeRate(forBaseConversionValue baseValue: Double) {
        var convertedValueTitleText: String = "NAN"
        defer {
            conversionBaseValueTextField.text = MainViewController.formattedValueAmount(baseValue)
            convertedValueTitleLabel.text = convertedValueTitleText
        }
        
        guard let conversionCurrency = conversionCurrency else { return }
        guard let exchangeRateManager = exchangeRateManager else { return }
        
        let conversionRate = exchangeRateManager.exchangeRate(from: baseCurrency, to: conversionCurrency)
        let convertedValue = baseValue * conversionRate
        convertedValueTitleText = MainViewController.formattedValueAmount(convertedValue)
    }
    
    static func formattedValueAmount(_ amount: Double) -> String {
        let currentValueAmountNumber = NSNumber(value: amount)
        return MainViewController.numberFormatter.string(from: currentValueAmountNumber) ?? "NAN"
    }
    
    @IBAction func didTapBaseCurrencySelection(_ sender: Any) {
        
    }
    
    @IBAction func didTapConversionCurrencySelection(_ sender: Any) {
        
    }
}

extension MainViewController: NumberInputTextfieldDelegateDelegate {
    
    func numberInputTextfieldDelegate(_ delegate: NumberInputTextfieldDelegate, didUpdateToValue updatedValue: Double) {
        computeAndDisplayExchangeRate(forBaseConversionValue: updatedValue)
    }
}