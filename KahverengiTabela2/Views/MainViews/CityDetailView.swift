//
//  CityDetailView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import SwiftUI
import MapKit
import Firebase
import AlertToast
import SwiftAudioPlayer

struct CityDetailView: View {
   
    
    public var kentChoice : kentBölgeleri
    
    @State var isDirection = false
    
    @State var cityLat : String
    
    @State var cityLong : String
    
    @State var cityName : String
    
    @State var cityFrom : String
    
    @State var cityAbout : String
    
    @State var citySound : String
    
    @State var cityImage = UIImage()
    
    @State var region : MKCoordinateRegion
    
    @State var isLiked = false
    
    @State var isNotLiked = false
    
    @State var a = 0
    
    @State var isBack = false
    
    @State var isDeleted = false
    
    
  
    
    
    init(kentChoice: kentBölgeleri,cityLong : String,cityLat : String, cityName : String, cityFrom : String,
         cityAbout : String, citySound : String) {
        
        self.kentChoice = kentChoice
        self.cityLong = cityLong
        self.cityLat = cityLat
        self.cityName = cityName
        self.cityFrom = cityFrom
        self.cityAbout = cityAbout
        self.citySound = citySound
        
        
        
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: Double(cityLat)!,
                                           longitude: Double(cityLong)!),
            span: MKCoordinateSpan(latitudeDelta: 0.1,
                                   longitudeDelta: 0.1))
    }
    
   
    
    
    var body: some View {
        
        ScrollView {
            VStack{
                HStack{
                    Button(action: {
                        a = a+1
                        
                        if a % 2 == 1{
                            isLiked = true
                        } else{
                            isLiked = false
                        }
                      
                        
                        if isLiked{
                            setPlaces(placeName: kentChoice.name, placeAbout: kentChoice.about, placeImage: kentChoice.ImageName, placeSound: kentChoice.soundURL, placeLat: kentChoice.latitude, placeLong: kentChoice.longitude, placeId: kentChoice.id)
                            userLikedArr.append(kentChoice)
                        } else{
                            isNotLiked.toggle()
                            deletePlace(placeName: cityFrom)
                            userLikedArr = userLikedArr.filter { $0.name != kentChoice.name }
                        }
                       
                        
                        
                       
                    }, label: {
                        Image("img_hearth_unselected")
                            .resizable()
                            .frame(width: 0.1 * screenWidth, height: 0.04 * screenHeight, alignment: .center)
                            .padding(.leading,10)
                    })
                    
                    Spacer()
                        
                    Button(action: {
                        placelat = Double(kentChoice.latitude)!
                        placeLong = Double(kentChoice.longitude)!
                        
                        isDirection.toggle()
                    }, label: {
                        Image("map")
                    })
                }
                ZStack {
                    
                
                
              
                    
                    VStack {
                        MapKit.Map(coordinateRegion: $region)
                            .frame(alignment: .top)
                            .disabled(true)
                        
                        Spacer()
                            .frame(width: screenWidth, height: 0.15 * screenHeight, alignment: .top)
                            .cornerRadius(10)
                    }
                    .frame(width: screenWidth, height: 0.3 * screenHeight, alignment: .top)
                    
                    
                    
                    HStack{
                        VStack{
                            
                           
                            Image(uiImage: kentChoice.ImageName)
                                .resizable()
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 5))
                                .frame(width: 0.43 * screenWidth, height: 0.18 * screenHeight, alignment: .center)
                                .shadow(radius: 10)
                                
                                
                                
                            Text(cityName)
                                .padding()
                            
                            Text(cityFrom)
                                .foregroundColor(.secondary)
                            
                            
                            
                            
                        }
                    }
                    .frame(width: 0.6 * screenWidth, height: 0.25 * screenHeight, alignment: .center)
                .padding()
                }
                
                
                MusicView(kent: kentChoice, soundStringUrl:citySound, cityImage: cityImage)
                    .padding()
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 10, style: .circular)
                        .frame(width: 0.9 * screenWidth, height: 0.25 * screenHeight, alignment: .center)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    ScrollView{
                        Text(cityAbout)
                    }.frame(width: 0.8 * screenWidth, height: 0.2 * screenHeight, alignment: .center)
                }
                
                Spacer()
            }
        }
        .toolbar{
            Button(action: {
                deleteCityWithButton(placeId: kentChoice.id, placeName: selectedKent.name)
            }, label: {
                Image("btn_cross")
            })
        }.opacity(uDefaults.bool(forKey: "isAdmin") ? 1 : 0 )
        
       
        .fullScreenCover(isPresented: $isDirection, content: DirectionMapView.init)
        .fullScreenCover(isPresented: $isBack, content: ContentView.init)
        .toast(isPresenting: $isLiked){
            
           
            AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Favorilere Eklendi!")
            
          
        }
        .toast(isPresenting: $isNotLiked){
            
           
            AlertToast(displayMode: .hud, type: .error(Color.red), title: "Favorilerden silindi!")
            
          
        }
        
        .toast(isPresenting: $isDeleted){
            
           
            AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Silindi!")
            
          
        }
      
        
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailView(kentChoice: kentBölgeleri.init(),cityLong: kentBölgeleri.init().longitude,cityLat:kentBölgeleri.init().latitude, cityName: kentBölgeleri.init().name, cityFrom: kentBölgeleri.init().from, cityAbout: kentBölgeleri.init().about, citySound: kentBölgeleri.init().soundURL)
    }
}

extension CityDetailView{
    
    func deleteCityWithButton(placeId : String, placeName: String){
        let db = Firestore.firestore()
        db.collection("cities").document("\(placeName)").collection("cityPlaces").document("\(placeId)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                print(placeId)
                print(placeName)
                AntikKent.tümKentoBölge = AntikKent.tümKentoBölge.filter { $0.name != kentChoice.name }
                isDeleted.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    isBack.toggle()
                })
               
            }
        }
    }
    
    
    
    func deletePlace(placeName : String){
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document("\(userID)").collection("favCities").document("\(placeName)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    func setPlaces(placeName : String, placeAbout : String, placeImage : UIImage, placeSound : String, placeLat : String, placeLong : String, placeId : String){
        
        let place = kentBölgeleri()
        place.name = placeName
        place.about = placeAbout
        place.soundURL = placeSound
        place.latitude = placeLat
        place.longitude = placeLong
        place.from = selectedKent.name
        place.id = placeId
        
        let ref = Storage.storage().reference(withPath: place.id)
        
        let refAudio = Storage.storage().reference(withPath: String(Int(bitPattern: place.id)+1))
        
        guard let imageData = placeImage.jpegData(compressionQuality: 0.5) else {
            return
        }
        print(placeName)
        print(placeAbout)
        print(placeSound)
        print(placeLat)
        print(placeLong)
        print(placeImage)
       
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let data = Data(placeSound.utf8)

        let metadata = StorageMetadata()
            metadata.contentType = "audio/m4a"

        refAudio.putData(data, metadata: metadata, completion: { metadata, err in
            if let err = err{
                print(err)
                return
            }

            refAudio.downloadURL(completion: { url, err in
                if let err = err{
                    print(err)
                    return
                }

                place.soundURL = (url?.absoluteURL.absoluteString)!
        })

        })
                    
        ref.putData(imageData, metadata: nil, completion: { metadata, err in
            if let err = err{
                
                print(err)
                
                return
            }
            
            ref.downloadURL(completion: { url, err in
                if let err = err{
                    
                    print(err)
                    
                    return
                }
                
                place.ImageNameUrl = (url?.absoluteURL.absoluteString)!
                
                
                let db = Firestore.firestore()
                db.collection("users").document("\(userID)").collection("favCities").document("\(place.name)").setData([
                    "placeName" : place.name,
                    "placeAbout" : place.about,
                    "placeSound" : place.soundURL,
                    "placeLat" : place.latitude,
                    "placeLong" : place.longitude,
                    "placeImageNameUrl" : place.ImageNameUrl
                ])
            })
        })
        
    }
}
