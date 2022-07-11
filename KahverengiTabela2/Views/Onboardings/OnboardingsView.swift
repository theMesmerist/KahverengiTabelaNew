//
//  Onboardings.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI

struct OnboardingsView: View {
    var body: some View {
        TabView{
            Onboarding1()
            Onboarding2()
            Onboarding3()
            inApp()
        }
        .tabViewStyle(.page)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct Onboarding1: View {
    var body: some View {
        VStack{
            Spacer()
                .frame(width: screenWidth, height: 0.25 * screenHeight, alignment: .center)
                VStack{
                Text("Kahverengi Tabela")
                        .font(.custom("Poppins-Medium", size: 30))
                    .foregroundColor(Color.black)
                    .frame(width: screenWidth, height: screenHeight * 0.1, alignment: .center)
                
                Text("Antik kentleri keşfet!")
                        .font(.custom("Poppins-Light", size: 20))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.1, alignment: .center)
                }
            Spacer()
            Image("img_onb1")
                .frame(width: screenWidth, height: screenHeight * 0.55, alignment: .bottom)
        }.edgesIgnoringSafeArea(.vertical)
           
    }
}

struct Onboarding2: View {
    var body: some View {
        VStack{
            Spacer()
                .frame(width: screenWidth, height: 0.25 * screenHeight, alignment: .center)
                VStack{
                Text("Antik Kentler")
                        .font(.custom("Poppins-Medium", size: 30))
                    .foregroundColor(Color.black)
                    .frame(width: screenWidth, height: screenHeight * 0.1, alignment: .center)
                
                Text("Tüm antik kentler elinin altında!")
                        .font(.custom("Poppins-Light", size: 20))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.1, alignment: .center)
                }
            Spacer()
            Image("img_onb2")
                .frame(width: screenWidth, height: screenHeight * 0.55, alignment: .bottom)
        }.edgesIgnoringSafeArea(.vertical)

    }
}

struct Onboarding3: View {
    @State var isInApp = false
    var body: some View {
       
        VStack{
          
            Spacer()
                .frame(width: screenWidth, height: 0.25 * screenHeight, alignment: .center)
                VStack{
                Text("Bilgiler edin")
                        .font(.custom("Poppins-Medium", size: 30))
                    .foregroundColor(Color.black)
                    .frame(width: screenWidth, height: screenHeight * 0.1, alignment: .center)
                
                Text("Antik kentler hakkında bilgiler edin")
                        .font(.custom("Poppins-Light", size: 20))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.1, alignment: .center)
                   
                }
            Spacer()
            Image("img_onb3")
                .frame(width: screenWidth, height: screenHeight * 0.55, alignment: .bottom)
        }
        .fullScreenCover(isPresented: $isInApp, content: inApp.init)
        .onAppear{
            uDefaults.setValue(true, forKey: "isUserFirst")
        }
        
    }
}




struct OnboardingsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingsView()
    }
}
