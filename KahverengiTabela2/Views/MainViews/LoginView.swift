//
//  RegisterView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import FirebaseAuth
import AlertToast

struct LoginView: View {
    @State private var email = String()
    @State private var password = String()
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    @State var isError = false
    
    @State var isLogin = false
    @State var isRegister = false
    
    var body: some View {
        ZStack{
            
            VStack{
                
                Text("Devam etmek için giriş yapınız")
            
                Spacer()
                    .frame(width: screenWidth * 0.05, height: 0.25 * screenWidth, alignment: .center)
                
                
                VStack{
                        Text("Email")
                            .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                            .padding(.leading, 10)
                        
                        TextField("abc", text: $email)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                            .foregroundColor(.gray)
                            .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    
                       
                    
                }.frame(width: screenWidth * 0.9, height: screenHeight * 0.05, alignment: .center)
                    
                Spacer()
                    .frame(width: screenWidth, height: 0.2 * screenWidth, alignment: .center)
            
             
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
                    
                       
                    
                }.frame(width: screenWidth * 0.9, height: screenHeight * 0.05, alignment: .center)
                
                Spacer()
                    .frame(width: screenWidth, height: 0.2 * screenWidth, alignment: .center)
                
                HStack{
                    
                    Button(action: {
                        isRegister.toggle()
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
                        signInUser(userEmail: email, userPassword: password)
                    }, label: {
                        
                        Text("Devam et")
                            .foregroundColor(.white)
                    })
                    .frame(width: screenWidth * 0.4, height: 0.07 * screenHeight, alignment: .center)
                    .background(.blue)
                    .cornerRadius(10)
                    
                    
                }
                .shadow(radius: 5)
                
                Spacer()
                    .frame(width: screenWidth * 0.05, height: 0.2 * screenWidth, alignment: .center)
                
                VStack{
                    Text("Bir hesabın yok mu?")
                    
                    Button(action: {
                        isRegister.toggle()
                    }, label: {
                        
                        Text("Kayıt ol")
                            .foregroundColor(.black)
                    })
                    .frame(width: screenWidth * 0.8, height: 0.07 * screenHeight, alignment: .center)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                Spacer()
                    .frame(width: screenWidth * 0.05, height: 0.2 * screenWidth, alignment: .center)
            }
            .fullScreenCover(isPresented: $isLogin, content: ContentView.init)
            .fullScreenCover(isPresented: $isRegister, content: RegisterView.init)
           
            
            
        }.toast(isPresenting: $isError){
            
            
            AlertToast(displayMode: .hud, type: .error(Color.red), title: signInErrorMessage)
            
          
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView {
    func signInUser(userEmail: String, userPassword: String) {
        
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            
            guard error == nil else {
                signInProcessing = false
                isError.toggle()
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                signInProcessing = false
            case .some(_):
                if email == "kahverengitabelapod@gmail.com"{
                    uDefaults.setValue(true, forKey: "isAdmin")
                }
                uDefaults.setValue(true, forKey: "isLogged")
                print("User signed in")
                signInProcessing = false
                isLogin.toggle()
            }
            
        }
    }
}
