//
//  WelcomeView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            ZStack{
                
                HStack{
                    
                    Image("logo")
                        .resizable()
                        .frame(width: screenWidth * 0.325, height: screenHeight * 0.14, alignment: .center)
                        .cornerRadius(10)
                    
                    Text("Bizleri sosyal medya hesaplarımız üzerinden takip etmeyi unutmayın!")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .frame(width: screenWidth * 0.5, height: screenHeight * 0.14, alignment: .top)
                        .padding(.trailing,10)
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.17, alignment: .center)
                
               
                
                .padding(.horizontal,5)
                
            }
        }
        .frame(width: screenWidth * 0.9 , height: screenHeight * 0.18, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
