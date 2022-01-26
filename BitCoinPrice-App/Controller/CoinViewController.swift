//
//  ViewController.swift
//  BitCoinPrice-App
//
//  Created by Dario Mintzer on 21/01/2022.
//

import UIKit

class CoinViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    var selectedCurrency: String = ""
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var coinView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinView.layer.cornerRadius = 20
        currencyPicker.delegate = self
        currencyPicker.dataSource = self //Sets ViewController as the data source
        coinManager.delegate = self
    }

}

//MARK: - CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate {

    
    //When a city is selected, get the weather information from the manager.
    //If the manager finds an error it prints it with didFailWithError
    func didUpdateCoin(coin: CoinData, currency: String) {
        DispatchQueue.main.async {
            let current_rate = coin.rateString
            self.bitcoinLabel.text =  current_rate
            self.currencyLabel.text = currency
            
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }

}

//MARK: - UIPickerDelegate
extension CoinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
