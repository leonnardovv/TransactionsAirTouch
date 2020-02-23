//
//  Transaction.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import Foundation

struct Transaction: Codable{
    
    let product_name: String
    let amount: String
    let default_currency: String
    
    enum CodingKeys: String, CodingKey{
        case product_name = "sku"
        case amount
        case default_currency = "currency"
    }

}

protocol Displayable{
    func displayTransaction()
}

extension Transaction: Displayable{
    func displayTransaction() {
        print("Product name: \(self.product_name)")
    }
}



