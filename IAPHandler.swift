//
//  IAPHandler.swift
//  Learn the World
//
//  Created by Gabriel Rocco on 07/06/2018.
//  Copyright © 2018 Graeff. All rights reserved.
//


import UIKit
import Foundation
import StoreKit
import SpriteKit



class IAPService: NSObject {
    

    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set = [IAPProduct.removeAdsProduct.rawValue, IAPProduct.colorBallsProduct.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
      func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
   
    
    
    func purchase(product: IAPProduct) {
        
  if self.canMakePurchases() {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
        }
    }
    
    func restorePurchases() {
        if self.canMakePurchases() {
           paymentQueue.restoreCompletedTransactions()
        }
       
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
    
            if transaction.transactionState == .purchased {
                queue.finishTransaction(transaction)
                //Pra remover anuncio
                if productBuy == "removeAdsProductStr"{
                    GameScene().removeAd()
                }
                
                if productBuy == "colorBallsBuy"{
                    GameScene().receiveColorBalls()
                }
           
            }
            
            if transaction.transactionState == .restored {
                   queue.finishTransaction(transaction)
                  //Pra remover anuncio
                if productBuy == "removeAdsProductStr"{
                    GameScene().removeAd()
                }
       
 
           
            
            if transaction.transactionState == .failed {
             
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
                
                
            }
            
           
                }}}}}
            
        
    

    
extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}

