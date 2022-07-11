//
//  StoreKitOperations.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import Foundation
import SwiftyStoreKit
import UIKit
import StoreKit

var priceMonthly = String()
var priceWeekly = String()


let monthlyProductID = "unlock.tiksaver.monthly"
let weeklyProductID = "unlock.tiksaver.weekly"

var arrAllProducts = [monthlyProductID, weeklyProductID]


class StoreKitOperations{
    
    let sharedSecret = "8bff400a74044f2ca88105a700bd5c7b"
    
    func configureStoreKit(){
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
    
    func retriveProductInfo(productID : String){
        SwiftyStoreKit.retrieveProductsInfo([productID]) { result in
            if let product = result.retrievedProducts.first {
                let price = product.localizedPrice
                
                switch productID {
                case monthlyProductID:
                    priceMonthly = price!
                    uDefaults.setValue(priceMonthly, forKey: "priceMonthly")
                case weeklyProductID:
                    priceWeekly = price!
                    uDefaults.setValue(priceWeekly, forKey: "priceWeekly")
                default: break
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    
    
    func setPrices(){
        retriveProductInfo(productID: monthlyProductID)
        retriveProductInfo(productID: weeklyProductID)
    }
    
    func purchaseProduct(productID : String) {
        
        vibrate(style: .medium)
       
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: false) { result in
            
            
            switch result {
            case .success(let purchase):
                
                print("Purchase Success: \(purchase.productId)")
        
                DispatchQueue.main.async {
                    uDefaults.setValue(true, forKey: purchase.productId)
                    uDefaults.synchronize()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.verifySubscription(isComeFromRestore: false,completion: {
                    })
                    NotificationCenter.default.post(name: Notification.Name("PurchaseSucces"), object: nil)

                }
                
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    func restorePurchase(viewController : UIViewController){
        
        vibrate(style: .medium)
        let view_loading = create_loading_view(view: viewController.view)
        viewController.view.addSubview(view_loading)
        
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            
           
            
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                
                
                NotificationCenter.default.post(name: Notification.Name("PurchaseError"), object: nil)
                
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
          
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                        print("qqqqq")
                    }
                }
                
             
                    self.verifySubscription(isComeFromRestore: true, completion: {
                        view_loading.removeFromSuperview()
                    })
                
                
            }
            else {
                print("Nothing to Restore")
                
                view_loading.removeFromSuperview()
                NotificationCenter.default.post(name: Notification.Name("PurchaseError"), object: nil)
                
            }
        }
        
        
        
    }
    



    
    func verifySubscription(isComeFromRestore: Bool = false, completion: @escaping ()->()){
        
        for productID in arrAllProducts{
            
            if productID != ""{
                
                let appleValidator = AppleReceiptValidator(service:  .production, sharedSecret: sharedSecret)
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    switch result {
                    case .success(let receipt):
                        
                        // Verify the purchase of a Subscription
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable, // or .nonRenewing (see below)
                            productId: productID,
                            inReceipt: receipt)
                        
                        switch purchaseResult {
                        case .purchased(let expiryDate, let items):
                            print("\(productID) is valid until \(expiryDate)\n\(items)\n")
                            //StoreKitOperations().isSubscribed() = true
                            uDefaults.setValue(true, forKey: productID)
                            uDefaults.synchronize()
                            
                            if isComeFromRestore {

                                completion()
                            }
                            
                        case .expired(let expiryDate, let items):
                            print("\(productID) is expired since \(expiryDate)\n\(items)\n")
                            
                            //StoreKitOperations().isSubscribed() = false
                            uDefaults.setValue(false, forKey: productID)
                            uDefaults.synchronize()
                           
                        case .notPurchased:
                            print("The user has never purchased \(productID)")
                          
                            //StoreKitOperations().isSubscribed() = false
                            uDefaults.setValue(false, forKey: productID)
                            uDefaults.synchronize()
                          
                        }
                        
                    case .error(let error):
                        print("Receipt verification failed: \(error)")
                    }
                }
                
            }
            
        }
        
        
        if isComeFromRestore && !isSubscribed(){
            
            completion()
            
            NotificationCenter.default.post(name: Notification.Name("PurchaseError"), object: nil)

            
            
         
        }
        
        
    }
    
    
    func isPlanActive(_ plan:String) -> Bool {
        return uDefaults.bool(forKey: plan)
    }
    
    func isSubscribed() -> Bool {
    
      //  return true
        for productID in arrAllProducts {
            if self.isPlanActive(productID) {
                return true
            }
        }
        return false
    }
}


