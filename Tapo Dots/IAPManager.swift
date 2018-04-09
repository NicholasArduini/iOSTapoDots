//
//  IAPManager.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-02-28.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    var product: SKProduct?
    var productID = Common.removeAdsPID
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
    }
    
    deinit{
       removePaymentObserver()
    }
    
    func removePaymentObserver(){
        SKPaymentQueue.default().remove(self)
    }
    
    func getPurchaseInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            postAlert(withMessage: Common.EnableIAP, title: Common.Error)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                savePurchase()
                hideAds()
                
            case SKPaymentTransactionState.restored:
                savePurchase()
                hideAds()
                postAlert(withMessage: Common.RestoreComplete, title: Common.Success)
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        if(products.count != 0){
            product = products[0]
        }
        
        let invalids = response.invalidProductIdentifiers
        for p in invalids {
            postAlert(withMessage: "\(Common.ProductNotFound) \(p)", title: Common.Error)
        }
    }
    
    func pay(){
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func savePurchase(){
        let save = UserDefaults.standard
        save.setValue(true, forKey: Common.PurchasedKey)
        save.synchronize()
    }
    
    func hideAds() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.PurchasedGame), object: nil)
    }
    
    func postAlert(withMessage: String, title: String){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.PresentAlert), object: nil, userInfo: [Common.MessageInfo:withMessage, Common.TitleInfo:title])
    }
}
