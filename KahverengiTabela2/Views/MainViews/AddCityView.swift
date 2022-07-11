//
//  AddCityView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import Firebase
import AlertToast

struct AddCityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var cityImg = String()
    @State var cityName = String()
    @State var cityLong = String()
    @State var cityLat = String()
    @State var cityPlaces = [kentBölgeleri]()
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State var isCityDetail = false
    
    @State var isCityCreated = false
    
    @State var cityNotCreated = false
    
    var body: some View {
        ScrollView(.vertical) {
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
                        Text("Şehir adı")
                            .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                            .padding(.leading, 10)
                        
                        TextField("", text: $cityName)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                            .foregroundColor(.gray)
                            .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    VStack{
                        Text("Şehir Enlemi")
                            .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                            .padding(.leading, 10)
                        
                        TextField("", text: $cityLat)
                            .keyboardType(.decimalPad)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                            .foregroundColor(.gray)
                            .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            
                    }
                    .toast(isPresenting: $isCityCreated){
                        
                       
                        AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Şehir başarıyla yaratıldı!")
                        
                      
                    }
                    
                    .toast(isPresenting: $cityNotCreated){
                        
                       
                        AlertToast(displayMode: .hud, type: .error(Color.red), title: "Hata!")
                        
                      
                    }
                    
                    
                    VStack{
                        Text("Şehir Boylamı")
                            .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                            .padding(.leading, 10)
                        
                        TextField("", text: $cityLong)
                            .keyboardType(.decimalPad)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                            .foregroundColor(.gray)
                            .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                        .frame(width: screenWidth, height: 0.05 * screenHeight, alignment: .center)
                    
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            
                            Text("Geri dön")
                                .foregroundColor(.black)
                        })
                        .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                        .background(.white)
                        .cornerRadius(10)
                   
                        Button(action: {
                            cityLat = converter(text: cityLat)
                            cityLong = converter(text: cityLong)
                            
                            if  cityName.isEmpty || cityLat.isEmpty || cityLong.isEmpty{
                                cityNotCreated.toggle()
                            } else{
                                isCityCreated.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    createCity(cityImage: image, cityName: cityName, cityLong: cityLong, cityLat: cityLat, cityPlaces: cityPlaces)
                                    isCityDetail.toggle()
                                })
                                
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
        .fullScreenCover(isPresented: $isCityDetail, content: AddCityDetailView.init)
        }
    }
}

struct AddCityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityView()
    }
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
extension AddCityView{
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
    }
    
    func converter(text: String) -> String {
            let textDouble = Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0
            return String(format: "%.2f", textDouble)
        }
    
    
    func createCity(cityImage: UIImage, cityName: String, cityLong: String, cityLat: String, cityPlaces : [kentBölgeleri]){
        
        
        
        
        let antikKent = AntikKent()
        antikKent.name = cityName
        antikKent.longitude = cityLong
        antikKent.latitude = cityLat
        antikKent.kentPlaces = cityPlaces
        selectedKent = antikKent
        
        let ref = Storage.storage().reference(withPath: antikKent.id.uuidString)
        
        guard let imageData = cityImage.jpegData(compressionQuality: 0.5) else {
            return
        }
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
                
                print("za")
//                print(url?.absoluteURL.absoluteString)
//                print((url?.absoluteURL.absoluteString)!.toImage()!)
                
               
                antikKent.imageUrl = (url?.absoluteURL.absoluteString)!
                
                
                
                let cityInfoDictionary = ["cityName" : antikKent.name,
                                           "cityLong" :  antikKent.longitude,
                                           "cityLat" : antikKent.latitude,
                                          "cityImageUrl" : antikKent.imageUrl
                ] as [String : Any]
                
                let db = Firestore.firestore()
                
                let docRef = db.collection("cities").document("\(antikKent.name)")

                docRef.setData(cityInfoDictionary) { (error) in

                    if let error = error {
                        print("\(error)")
                    } else {
                        
                        print("City saved")
                    }

                }
            })
        })
        
            

       
        
        
    }
    
    
}
