//
//  KahverengiTabela2App.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      StoreKitOperations().configureStoreKit()
      get_prices_from_uDefaults()
      StoreKitOperations().setPrices()
      getCities()
    return true
  }
    
    func get_prices_from_uDefaults(){
       if let price_monthly_uDefault = uDefaults.object(forKey: "priceMonthly") as? String{
         priceMonthly = price_monthly_uDefault
       }
       if let price_weekly_uDefault = uDefaults.object(forKey: "priceWeekly") as? String{
        priceWeekly = price_weekly_uDefault
       }
     
    }
}


@main
struct KahverengiTabela2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

    
    var body: some Scene {
        
        WindowGroup{
            
            if uDefaults.bool(forKey: "isLogged"){
              
                
                if !StoreKitOperations().isSubscribed(){
                    
                    inApp()
                } else{
                    
                    ContentView()
                }
               
                
            } else if !uDefaults.bool(forKey: "isUserFirst"){
                OnboardingsView()
            } else{
                LoginView()
            }
           
               
        }
    }
    
}
extension AppDelegate{
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let fileUrl = URL(string: url)!
        URLSession.shared.dataTask(with: fileUrl, completionHandler: completion).resume()
    }
    
    func getCities() {
        let db = Firestore.firestore()
        let docRef = db.collection("cities")
        docRef.getDocuments { (querySnapshot, error) in
            if let snapshotDocuments = querySnapshot?.documents {
                for document in snapshotDocuments {
                  
                    do {
                        var antikCity = AntikKent()
                        
                        if let cityImage = try document.get("cityImageUrl") {
                            print("Download Started")
                            self.getData(from: cityImage as! String) { data, response, error in
                                guard let data = data, error == nil else { return }
                                print("Download Finished")
                                // always update the UI from the main thread
                                DispatchQueue.main.async() { [] in
                                    antikCity.ImageName = (UIImage(data: data))!
                                    print("of")
                                    print(antikCity.ImageName)
                                }
                            }
  
                        }
                        if let cityLat = try document.get("cityLat") {
                            antikCity.latitude = cityLat as! String
                        }
                        if let cityLong = try document.get("cityLong") {
                            antikCity.longitude = cityLong as! String
                        }
                        if let cityName = try document.get("cityName") {
                            antikCity.name = cityName as! String
                        }
                        
                        if !AntikKent.antikKentler.contains(where: {$0.name == antikCity.name && $0.latitude == antikCity.latitude && $0.longitude == antikCity.longitude  }){
                            AntikKent.antikKentler.append(antikCity)
                        } else{
                            print("already exists")
                        }
                        
                       
                    } catch let error as NSError {
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}



