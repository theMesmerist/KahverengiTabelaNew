//
//  FavView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import Firebase

struct FavView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
  
    
    var body: some View {
        
        NavigationView {
          
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("btn_cross")
                            .padding(10)
                    }
                    Spacer()
                    
                    Text("Favoriler")
                        .font(.custom("Poppins-Regular", size: 30))
                    
                    Spacer()
                        .frame(width: screenWidth * 0.3, height: screenHeight * 0.05, alignment: .center)
                }
                
                VStack{
                    
                    
                    List(userLikedArr) { kentt in
                            NavigationLink(destination: CityDetailView(kentChoice: kentt, cityLong: kentt.longitude, cityLat: kentt.latitude, cityName: kentt.name, cityFrom: kentt.from, cityAbout: kentt.about, citySound: kentt.soundURL)){
                            
                                SearchCellView(cityImg: kentt.ImageName, cityName: kentt.name, cityFrom: kentt.kenti)
                                    


                        } .frame(width: 0.8 * screenWidth, height: 0.15 * screenHeight, alignment: .center)
                            
                       
                       

                        }
                    
                    

                       
                }
            }.navigationBarHidden(true)
                .onAppear{
                   getFromDb()
                }
        }
    }
}

struct FavView_Previews: PreviewProvider {
    static var previews: some View {
        FavView()
    }
}

extension FavView{
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let fileUrl = URL(string: url)!
        URLSession.shared.dataTask(with: fileUrl, completionHandler: completion).resume()
    }
    
    func getFromDb(){
        
       
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document("\(userID)").collection("favCities").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    var kent = kentBölgeleri()
                    
                    kent.about = document.get("placeAbout") as! String
                    kent.ImageNameUrl = document.get("placeImageNameUrl") as! String
                    kent.latitude = document.get("placeLat") as! String
                    kent.longitude = document.get("placeLong") as! String
                    kent.name = document.get("placeName") as! String
                    
                    print("Download Started")
//                    print(profileImgUrl)
                    getData(from: kent.ImageNameUrl) { data, response, error in
                        guard let data = data, error == nil else { return }
                        print("Download Finished")
                        // always update the UI from the main thread
                        DispatchQueue.main.async() { [ self] in
                            kent.ImageName = (UIImage(data: data))!
                            print("of")
                        
                        }
                    }
                    if userLikedArr.contains(where: { $0.name == kent.name && $0.about == kent.about && $0.ImageNameUrl == kent.ImageNameUrl && $0.latitude == kent.latitude &&        $0.longitude == kent.longitude}){
                        print("already exists")
                    } else{
                        userLikedArr.append(kent)
                    }
                   
                }
            }
            
        }
        
        
    }
}
