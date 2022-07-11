//
//  RegisterView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import AlertToast

struct RegisterView: View {
    
    @State var username = String()
    @State var email = String()
    @State var password = String()
    @State var name = String()
    
    @State private var image = UIImage()
    @State var signUpProcessing = false
    @State var registerErrorMessage = ""
    @State var isError = false
    
    @State var isLogin = false
    @State var isBack = false
    
    @State private var showSheet = false
    
    @State var userImageUrl = String()
    
    var body: some View {
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
                    Text("Kullanıcı adı")
                        .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                        .padding(.leading, 10)
                    
                    TextField("abc", text: $username)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                        .foregroundColor(.gray)
                        .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                VStack{
                    Text("Şifre")
                        .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                        .padding(.leading, 10)
                    
                    TextField("abc", text: $password)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                        .foregroundColor(.gray)
                        .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                VStack{
                    Text("E-mail")
                        .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                        .padding(.leading, 10)
                    
                    TextField("abc", text: $email)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                        .foregroundColor(.gray)
                        .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                VStack{
                    Text("İsim")
                        .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                        .padding(.leading, 10)
                    
                    TextField("abc", text: $name)
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
                        isBack.toggle()
                    }, label: {
                        
                        Text("Geri dön")
                            .foregroundColor(.black)
                    })
                    .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                    .background(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                        .frame(width: screenWidth * 0.05, height: 0.1 * screenWidth, alignment: .center)
                    Button(action: {
                        print("bbb")
                        print(password)
                        signUpUser(userEmail: email, userPassword: password, userImage: image)
                    }, label: {
                        
                        Text("Devam et")
                            .foregroundColor(.white)
                    })
                    .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                    .background(.blue)
                    .cornerRadius(10)
                    
                    
                }
                .shadow(radius: 5)
                
                
            }
             
            
        }
        .fullScreenCover(isPresented: $isBack, content: LoginView.init)
        .fullScreenCover(isPresented: $isLogin, content: ContentView.init)
        .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .toast(isPresenting: $isError){
            
            
            AlertToast(displayMode: .hud, type: .error(Color.red), title: registerErrorMessage)
            
          
        }
    }
    
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

extension RegisterView{
    func signUpUser(userEmail: String, userPassword: String, userImage: UIImage) {
        
        signUpProcessing = true
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                
                signUpProcessing = false
                registerErrorMessage = error!.localizedDescription
                isError.toggle()
                print("aaa")
                print(error)
                
                return
            }
            
            
            
            switch authResult {
            case .none:
                print("Could not create account.")
                signUpProcessing = false
                
            case .some(_):
                print("User created")
                signUpProcessing = false
                uDefaults.setValue(true, forKey: "isLogged")
                
                guard let userID = Auth.auth().currentUser?.uid else { return }
                guard let imageData = userImage.jpegData(compressionQuality: 0.5) else {
                    return
                }
                
                let ref = Storage.storage().reference(withPath: userID)
                
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
                        
                        userImageUrl = (url?.absoluteURL.absoluteString)!
                        
                        let db = Firestore.firestore()
                        db.collection("users").document("\(userID)").collection("userInfo").document("\(userID)").setData([
                            "username" : username,
                            "name" : name,
                            "mail" : Auth.auth().currentUser?.email! as Any,
                            "userImg" : userImageUrl
                        ])

                        isLogin.toggle()
                    })
                })
                
                
                
//                viewRouter.currentPage = .homePage
            }
        }
    }
}

