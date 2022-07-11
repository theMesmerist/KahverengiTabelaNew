//
//  ContentView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import SwiftAudioPlayer

struct Home: View {
    
   
    @State var selectedTab = "home"
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                Spacer()
                    .frame(height: screenHeight * 0.02, alignment: .center)
                
              HeaderView()
                    .frame(height: screenHeight * 0.06, alignment: .center)
                
                WelcomeView()
                   
          
                HStack{
                    
               
                    Text("Yeni Eklenenler")
                        .font(.custom("Poppins-Regular", size: 20))
                   
                }
                .frame(width: screenWidth * 0.95 , height: screenHeight * 0.05, alignment: .leading)
                
                
            YeniEklenenlerView()
                    .padding(.leading,20)
                    .padding(.trailing,20)
                
                
                VStack{
                    
                    HStack{
                        
                        Text("Editörün Seçtikleri")
                            .font(.custom("Poppins-Regular", size: 20))
                    }
                    .frame(width: screenWidth * 0.95 , height: screenHeight * 0.05, alignment: .leading)
                    
                }
                
                EnBegenilenlerView()
                    .padding(.leading,20)
                    .padding(.trailing,20)
                
                Spacer()
                    .frame(width: 1 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
            }
            .frame(width: screenWidth, height: screenHeight, alignment: .center)

//            CustomTabBar(selectedTab: $selectedTab)
            
            
        }
        .onAppear{
            SAPlayer.shared.pause()
        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
       Home()
    }
}
