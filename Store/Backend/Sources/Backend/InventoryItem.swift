//
//  InventoryItem.swift
//  Backend
//
//  Created by Farzad Nazifi on 24.01.18.
//

import Foundation
import Meow
import PromiseKit

class InventoryItem: Model {
    var _id = ObjectId()
    var carrier: Reference<Carrier>
    var code: String
    var isActive: Bool
    var orderID: String?
    var userName: String?
    
    init(carrier: Reference<Carrier>, code: String, isActive: Bool, orderID: String? = nil, userName: String? = nil) {
        self.carrier = carrier
        self.code = code
        self.isActive = isActive
        self.orderID = orderID
        self.userName = userName
    }
    
    static func hasAvaliable(carrier: Carrier) -> Promise<(Bool, Carrier)> {
        return Promise<(Bool, Carrier)>(.pending) { seal in
            do {
                let count = try InventoryItem.count("carrier" == carrier._id && "isActive" == true, limitedTo: nil, skipping: nil)
                if count > 0 {
                    seal.fulfill((true, carrier))
                }else{
                    seal.reject(Store.Errors.inventoryEmpty)
                }
            } catch let err {
                seal.reject(err)
            }
        }
    }
    
    static func userItems(userName: String) -> Promise<[InventoryItem]> {
        return Promise<[InventoryItem]>(.pending) { seal in
            do {
                let items = try InventoryItem.find("isActive" == false && "userName" == userName)
                seal.fulfill(Array(items))
            } catch let err {
                seal.reject(err)
            }
        }
    }
}
