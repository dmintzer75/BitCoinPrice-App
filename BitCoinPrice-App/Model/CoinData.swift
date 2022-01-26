//
//  CoinData.swift
//  BitCoinPrice-App
//
//  Created by Dario Mintzer on 24/01/2022.
//

import Foundation

struct CoinData: Codable {
    
    let rate: Double
    var rateString: String {
        return String(format: "%.3f", rate)
    }
    
}
