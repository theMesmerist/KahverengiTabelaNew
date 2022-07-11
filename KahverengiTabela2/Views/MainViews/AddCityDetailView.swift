//
//  AddCityDetailView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import Firebase
import AlertToast

struct AddCityDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @State var placeName = String()
    @State var placeAbout = String()
    @State var placeImage = String()
    @State var placeSound = String()
    @State var placeLat = String()
    @State var placeLong = String()
    @State var placeId = UUID()
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State private var showDocument = false
    
    @State var isCityCreated = false
    
    @State var cityNotCreated = false
    
    @State var isMain = false
    
    @State var isSoundSelected = false
    
    @State var cityCount = 0
    
    var body: some View {
        
        ScrollView {
            VStack{
                    
                    HStack{
                        Image(uiImage: self.image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .onTapGesture {
                            showSheet = true
                        }
                    }
                    .frame(width: screenWidth * 0.4, height: screenHeight * 0.2, alignment: .center)
                    .onAppear{
                        image = UIImage(named: "img_user")!
                    }
                    
                    VStack{
                        VStack{
                            Text("Bölge adı")
                                .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                                .padding(.leading, 10)
                            
                            TextField("", text: $placeName)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                                .foregroundColor(.gray)
                                .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .toast(isPresenting: $isCityCreated){
                            
                            return AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Şehir başarıyla yaratıldı!")
                          
                          
                        }
                        
                        .toast(isPresenting: $cityNotCreated){
                            
                           
                            AlertToast(displayMode: .hud, type: .error(Color.red), title: "Hata!")
                            
                          
                        }
                        
                        VStack{
                            Text("Bölge Enlemi")
                                .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                                .padding(.leading, 10)
                            
                            TextField("", text: $placeLat)
                                .keyboardType(.decimalPad)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                                .foregroundColor(.gray)
                                .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        
                        
                        VStack{
                            Text("Bölge Boylamı")
                                .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                                .padding(.leading, 10)
                            
                            TextField("", text: $placeLong)
                                .keyboardType(.decimalPad)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                                .foregroundColor(.gray)
                                .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        
                        VStack{
                            Text("Bölge Hakkında")
                                .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                                .padding(.leading, 10)
                            
                            TextField("", text: $placeAbout)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                                .foregroundColor(.gray)
                                .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            showDocument.toggle()
                        }, label: {
                            Text(isSoundSelected ? placeSound : "Ses dosyası seçiniz")
                        })
                        .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                        .background(.white)
                        .cornerRadius(10)
                        
                        Spacer()
                            .frame(width: screenWidth, height: 0.05 * screenHeight, alignment: .center)
                        
                        HStack{
                            Button(action: {
                                if cityCount > 0 {
                                    isMain.toggle()
                                } else{
                                    cityNotCreated.toggle()
                                }
                               
                            }, label: {
                                
                                Text("Geri dön")
                                    .foregroundColor(.black)
                            })
                            .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                            .background(.white)
                            .cornerRadius(10)
                       
                            Button(action: {
                                placeLat = converter(text: placeLat)
                                placeLong = converter(text: placeLong)
                                
                                if placeName.isEmpty || placeAbout.isEmpty || placeSound.isEmpty || placeLat.isEmpty || placeLong.isEmpty {
                                    cityNotCreated.toggle()
                                } else{
                                    cityCount = cityCount + 1
                                    isCityCreated.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        setPlaces(placeName: placeName, placeAbout: placeAbout, placeImage: image, placeSound: placeSound, placeLat: placeLat, placeLong: placeLong, placeId: placeId.uuidString)
                                        
                                        image = UIImage(named: "img_user")!
                                        placeName = ""
                                        placeAbout = ""
                                        placeImage = ""
                                        placeSound = ""
                                        placeLat = ""
                                        placeLong = ""
                                        placeId = UUID()
                                        isSoundSelected = false
                                    })
                                    getCities()
                                    
                                }
                                
                                
                            }, label: {
                                
                                Text("Devam et")
                                    .foregroundColor(.white)
                            })
                            .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                            .background(.blue)
                            .cornerRadius(10)
                            
                            
                        }.shadow(radius: 5)
                        
                    }
                }
                .sheet(isPresented: $showSheet) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                .fileImporter(isPresented: $showDocument, allowedContentTypes: [.audio], onCompletion: { (res) in
                    
                    do{
                        let fileUrl = try res.get()
                        
                        print(fileUrl)
                        
                        placeSound = fileUrl.absoluteString
                        isSoundSelected = true
                        
                    }catch{
                        print(error.localizedDescription)
                    }
            })
        }
        .fullScreenCover(isPresented: $isMain, content: ContentView.init)
    }
}

struct AddCityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityDetailView()
    }
}

extension AddCityDetailView{
    
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
                            getData(from: cityImage as! String) { data, response, error in
                                guard let data = data, error == nil else { return }
                                print("Download Finished")
                                // always update the UI from the main thread
                                DispatchQueue.main.async() { [ self] in
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
    
    func setPlaces(placeName : String, placeAbout : String, placeImage : UIImage, placeSound : String, placeLat : String, placeLong : String, placeId : String){
        
        let place = kentBölgeleri()
        place.name = placeName
        place.about = placeAbout
        place.latitude = placeLat
        place.longitude = placeLong
        place.id = placeId
        place.from = selectedKent.name
        
        let ref = Storage.storage().reference(withPath: place.id)
        
        let refAudio = Storage.storage().reference(withPath: String(Int(bitPattern: place.id)+1))
        
        guard let imageData = placeImage.jpegData(compressionQuality: 0.5) else {
            return
        }
         
        let selectedFile =  URL(string: placeSound)!
        if selectedFile.startAccessingSecurityScopedResource() {

            
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
      
        
        let data2 = try! Data(contentsOf: selectedFile)
           
        
        let metadata = StorageMetadata()
            metadata.contentType = "audio/mpeg"
        
        refAudio.putData(data2, metadata: metadata, completion: { metadata, err in
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
                print(place.soundURL)
              
                let db = Firestore.firestore()
                db.collection("cities").document("\(selectedKent.name)").collection("cityPlaces").document("\(placeId)").updateData([
                    "placeSound" : place.soundURL
                ])
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
                db.collection("cities").document("\(selectedKent.name)").collection("cityPlaces").document("\(placeId)").setData([
                    "placeName" : place.name,
                    "placeAbout" : place.about,
                    "placeSound" : place.soundURL,
                    "placeLat" : place.latitude,
                    "placeLong" : place.longitude,
                    "placeId" : place.id,
                    "placeImageNameUrl" : place.ImageNameUrl,
                    "placeFrom" : place.from,
                    "addedUserName" : userID
                ])
            })
        })
        
    }
        
        selectedFile.stopAccessingSecurityScopedResource()
    }
    
    func converter(text: String) -> String {
            let textDouble = Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0
            return String(format: "%.2f", textDouble)
        }
   
}
