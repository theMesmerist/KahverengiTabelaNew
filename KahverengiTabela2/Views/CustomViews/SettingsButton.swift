//
//  SettingsButton.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI

struct SettingsButton: View {
    
    @State var btnText = ""
    
    
    var body: some View {
        Button(action: {
            
            switch btnText {
                case "Photo Access":
                print("hehehe")
                
                case "Share with your friends":
                guard let data = URL(string: "https://www.google.co") else { return }
                let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                
                case "Help & Support":
                print("hehehe")
                
                case "Terms of Use":
                if let url = URL(string: "https://www.google.co") {
                  if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                  }
                }
                
                case "Privacy Policy":
                if let url = URL(string: "https://www.google.co") {
                  if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                  }
                }
                
                default:
                        
                        print("aaa")
                }
                    
                
            
        }, label: {
            
            HStack{
                Text(btnText)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image("btn_arrow")
                    .resizable()
                    .frame(width: 0.1 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
            }
            .padding(.horizontal)
          
        })
        .frame(width: 0.9 * screenWidth, height: 0.065 * screenHeight, alignment: .center)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.bottom,10)
        
        
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}

