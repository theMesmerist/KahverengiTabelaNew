//
//  SettingsView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import SwiftAudioPlayer

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            Spacer()
                .frame(width: screenWidth * 0.38, height: 0.07 * screenHeight, alignment: .center)
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("btn_cross")
                })
                
                Spacer()
                   
                
                Text("Ayarlar")
                    .font(.custom("Poppins-Semibold", size: 24))
                   
                
                
                Spacer()
                    .frame(width: screenWidth * 0.33, height: 0.05 * screenHeight, alignment: .center)
            }
            .padding(.horizontal)
            
           
            VStack{
             
                
                    
            SettingsButton(btnText: "Kullanım Koşulları")
                    
            SettingsButton(btnText: "Gizlilik")
                    
                
               
                
                
            }
           
            Spacer()
        }
        .navigationBarHidden(true)
        .frame(width: screenWidth, height: screenHeight, alignment: .center)
        .background(Color.white)
        .onAppear{
            SAPlayer.shared.pause()
        }
    }
       
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


