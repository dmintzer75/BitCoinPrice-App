//
//  CoinManager.swift
//  BitCoinPrice-App
//
//  Created by Dario Mintzer on 22/01/2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(coin: CoinData, currency: String) //Must be able to update coin
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0AF654CF-8EFA-43CE-80B8-C5F8273D27B2"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString, currency: currency)
        
    }
   
    
    func performRequest(_ urlString: String, currency: String) {
        
        //1. Create a URL
        if let url = URL(string: urlString) {
        //2. Create a url session
            let session = URLSession(configuration: .default)
        //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(coin: coin, currency: currency)
                    }
                }
            }
        //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            
            let coin = CoinData(rate: rate)
            return coin 
            
        } catch  {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
