//
//  DetailedMapView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu on 5.06.2022.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseStorage


struct DetailedMapView: View {
    
    
    @State var selected: String
    
    @State var selectedLat : String
    @State var selectedLon : String
    
    
    @State var region : MKCoordinateRegion
    
    init(selected: String, selectedLat : String, selectedLon : String) {
        
        self.selected = selected
        self.selectedLat = selectedLat
        self.selectedLon = selectedLon
        
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: Double(selectedLat)!,
                                           longitude: Double(selectedLon)!),
            span: MKCoordinateSpan(latitudeDelta: 0.01,
                                   longitudeDelta: 0.01))
    }
    
    
    var body: some View {
        

            
            
            VStack{

//                Divider()
//                Text("Yapı seçiniz").font(.largeTitle)
                
                let a = AntikKent.tümKentoBölge
                    
                
                
                MapKit.Map(coordinateRegion: $region,annotationItems: a){
                    place in
                    MapAnnotation(coordinate: place.coordinate) {
                        
                        NavigationLink(
                            destination: CityDetailView(kentChoice: place, cityLong: place.longitude, cityLat: place.latitude, cityName: place.name, cityFrom: place.from, cityAbout: place.about, citySound: place.soundURL )){
                            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                                Image(uiImage: place.ImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 25)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 25/10))
                                .shadow(radius: 10)
                            Text(place.name)
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(Color.black)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                        }
                        
                    }
                        
                    
                }
                
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

            .background(Image("arkaPlan")
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            )
        }
            .navigationTitle(Text("Yapı seçiniz"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                selectedKent.name = selected
                getCities()
                DispatchQueue.main.asyncAfter(deadline: .now()
                                              + 1, execute: {
                    print("------------")
                    print(AntikKent.tümKentoBölge)
                })
            }
            
    }
}

extension DetailedMapView{
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let fileUrl = URL(string: url)!
        URLSession.shared.dataTask(with: fileUrl, completionHandler: completion).resume()
    }
        
    
    func getCities() {
        
        var idArr = [String: Any]()
       
        let db = Firestore.firestore()
        let docRef = db.collection("cities").document("\(selected)").collection("cityPlaces")
        
        docRef.getDocuments { documentSnapshot, error in
                if let error = error {
                    print("Error")
                    return
                }
                documentSnapshot?.documents.forEach({ snapshot in
                    var place = kentBölgeleri()
                    
                    let id = try? snapshot.data()
                    print("-----")
                    idArr.append(anotherDict: id!)
                    print(idArr)
                    
                    let results = idArr as? [String:Any]
                    
                    let placeLong = results!["placeLong"]
                    let placeLat = results!["placeLat"]
                    let placeSound = results!["placeSound"]
                    let placeId = results!["placeId"]
                    let placeName = results!["placeName"]
                    let placeImage = results!["placeImage"]
                    let placeImageNameUrl = results!["placeImageNameUrl"]
                    let placeAbout = results!["placeAbout"]
                    
                    print("***")
                    print(placeLong!)
                    print(placeLat!)
                    print(placeSound!)
                    print(placeId!)
                    print(placeName!)
                    
                    
                    
                    place.longitude = placeLong as! String
                    place.latitude = placeLat as! String
                    place.soundURL = placeSound as! String
                    place.id = placeId as! String
                    place.name = placeName as! String
                    place.about = placeAbout as! String
                    
                    
                    print("Download Started")
                    getData(from: placeImageNameUrl as! String) { data, response, error in
                        guard let data = data, error == nil else { return }
                        print("Download Finished")
                        // always update the UI from the main thread
                        DispatchQueue.main.async() { [ self] in
                            place.ImageName = (UIImage(data: data))!
                            print("of")
                        
                        }
                    }
                    
                   print("****")
                    
                    if !AntikKent.tümKentoBölge.contains(where: {$0.name == place.name && $0.latitude == place.latitude && $0.longitude == place.longitude && $0.about == place.about}){
                        AntikKent.tümKentoBölge.append(place)
                    } else{
                        print("already exists")
                    }
                    
                })
               
            }

    }
}

extension Dictionary where Key == String, Value == Any {
    
    mutating func append(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}

