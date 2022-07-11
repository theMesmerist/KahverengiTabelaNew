//
//  ProfileView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import FirebaseAuth
import Firebase
import AlertToast
import SwiftAudioPlayer

struct ProfileView: View {
    
    @State var isSettings = false
    @State var user = Auth.auth().currentUser
    @State var userName = String()
    
    @State var isLogout = false
    
    @State var isAntikKentEkle = false
    
    @State var profileImg = UIImage()
    @State var profileImgUrl = String()
    
    @State var isFavView = false
    
    @State var isLinkSent = false
    @State var isLinkNotSent = false
    
    var body: some View {
        VStack{
            VStack{
                
           
            HStack{
                Spacer()
                    .frame(width: screenWidth * 0.8, alignment: .center)
                Button(action: {
                    isSettings.toggle()
                }, label: {
                    Image("btn_settings")
                })
                
                
            }
                
                Spacer()
                    .frame(height: screenHeight * 0.07, alignment: .center)
               
            }
           
            VStack{
                Image(uiImage: profileImg)
                    .resizable()
                    .clipShape(Circle())
                
                Text(userName)
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.05, alignment: .center)
            }
            .frame(width: screenWidth * 0.5, height: screenHeight * 0.2, alignment: .center)
            .padding(.bottom)
            
            
            VStack{
                Button(action: {
                    isFavView.toggle()
                }, label: {
                    HStack{
                        Image("btn_hearth")
                            .padding(.trailing)
                        
                        Text("Favori antik kentlerim")
                            .foregroundColor(.black)
                    }
                    .frame(width: screenWidth * 0.7, height: 0.06 * screenHeight, alignment: .leading)
                    
                })
                .frame(width: screenWidth * 0.8, height: 0.06 * screenHeight, alignment: .center)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            .padding()
            
            
            VStack{
                Button(action: {
                    changePass()
                }, label: {
                    HStack{
                        Image("btn_key")
                            .padding(.trailing)
                        
                        Text("Şifremi değiştir")
                            .foregroundColor(.black)
                    }
                    .frame(width: screenWidth * 0.7, height: 0.06 * screenHeight, alignment: .leading)
                    
                })
                .frame(width: screenWidth * 0.8, height: 0.06 * screenHeight, alignment: .center)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            .padding()
            
            
            VStack{
                Button(action: {
                    signOutUser()
                }, label: {
                    HStack{
                        Image("btn_exit")
                            .padding(.trailing)
                        
                        Text("Çıkış yap")
                            .foregroundColor(.black)
                    }
                    .frame(width: screenWidth * 0.7, height: 0.06 * screenHeight, alignment: .leading)
                    
                })
                .frame(width: screenWidth * 0.8, height: 0.06 * screenHeight, alignment: .center)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            .padding()
            
            VStack{
                Button(action: {
                    isAntikKentEkle.toggle()
                }, label: {
                    HStack{
                        Image("btn_hearth")
                            .padding(.trailing)
                        
                        Text("Antik Kent Ekle")
                            .foregroundColor(.black)
                    }
                    .frame(width: screenWidth * 0.7, height: 0.06 * screenHeight, alignment: .leading)
                    
                })
                .frame(width: screenWidth * 0.8, height: 0.06 * screenHeight, alignment: .center)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .opacity(uDefaults.bool(forKey: "isAdmin") ? 1 : 0 )
//                .disabled(uDefaults.bool(forKey: "isAdmin") ? true : false)
            }
            .padding()
//            .opacity(uDefaults.bool(forKey: "isAdmin") ? 0 : 1)
//            .disabled(uDefaults.bool(forKey: "isAdmin") ? true : false)
            
            Spacer()
            
           
        }
        
        .fullScreenCover(isPresented: $isSettings, content: SettingsView.init)
        .fullScreenCover(isPresented: $isLogout, content: LoginView.init)
        .fullScreenCover(isPresented: $isAntikKentEkle, content: AddCityView.init)
        .fullScreenCover(isPresented: $isFavView, content: FavView.init)
        
            .onAppear{
                    SAPlayer.shared.pause()

                getFromDb()
//                getFromDbFav()
            }
        
            .toast(isPresenting: $isLinkSent){
                
               
                AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Email'e link gönderildi!")
                
              
            }
        
            .toast(isPresenting: $isLinkNotSent){
                
               
                AlertToast(displayMode: .hud, type: .error(Color.red), title: "Email'e link gönderilemedi!")
                
              
            }
      
    }
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

extension ProfileView{
    
    func changePass(){
        guard let userEmail = Auth.auth().currentUser?.email else {return}
        
        
            Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
                if error != nil{
                    isLinkNotSent.toggle()
                } else{
                    isLinkSent.toggle()
                }
               
            }
    }
    
    
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let fileUrl = URL(string: url)!
        URLSession.shared.dataTask(with: fileUrl, completionHandler: completion).resume()
    }
    
    func getFromDb(){
        
       
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document("\(userID)").collection("userInfo").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    
                    
                    userName = document.get("name") as! String
                    profileImgUrl = document.get("userImg") as! String
                    
                    print("Download Started")
                    print(profileImgUrl)
                    getData(from: profileImgUrl) { data, response, error in
                        guard let data = data, error == nil else { return }
                        print("Download Finished")
                        // always update the UI from the main thread
                        DispatchQueue.main.async() { [ self] in
                            profileImg = (UIImage(data: data))!
                            print("of")
                        
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    func getFromDbFav(){
        
       
        
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
                    if userLikedArr.contains(where: { $0.name == kent.name && $0.about == kent.about && $0.ImageNameUrl == kent.ImageNameUrl && $0.latitude == kent.latitude && $0.longitude == kent.longitude}){
                        print("already exists")
                    } else{
                        userLikedArr.append(kent)
                    }
                   
                }
            }
            
        }
        
        
    }
    
    func signOutUser() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            uDefaults.setValue(false, forKey: "isLogged")
            isLogout.toggle()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
       
    }
}

