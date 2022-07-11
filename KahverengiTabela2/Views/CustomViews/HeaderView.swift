//
//  HeaderView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI

struct HeaderView: View {
    
    @State var isSettings = false
    var body: some View {
        
        ZStack{
            
            VStack{
            VStack{
                HStack{
                    
                    Text("Merhaba!")
                        .font(.system(size: 32))
                    
                    Spacer()
                        
                    
                    Button {
                        isSettings.toggle()
                    } label: {
                        Image("btn_settings")
                    }
                    
                  

                }
                .padding(.horizontal)
            
            }
            
            Spacer()
            
            }
          
            
        }.fullScreenCover(isPresented: $isSettings, content: SettingsView.init)
        
       
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
