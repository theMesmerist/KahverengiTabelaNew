//
//  ContentView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI

struct ContentView: View {
    
    
    
    @State var selectedIndex = 0
    
    let tabBarImageNames = ["home", "map", "search", "profile"]
    let tabBarImageNamesSelected = ["selectedHome", "selectedMap", "selectedSearch", "selectedProfile"]

    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                
                switch selectedIndex {
                case 0:
                    NavigationView {
                       Home()
                            .navigationBarHidden(true)
                        
                    }
                    
                case 1:
                    NavigationView {
                       MapView()
                            .navigationBarHidden(true)
                    }
                case 2:
                    NavigationView {
                       SearchBarView()
                            .navigationBarHidden(true)
                    }
                case 3:
                    NavigationView {
                        if uDefaults.bool(forKey: "isLogged"){
                            ProfileView()
                                 .navigationBarHidden(true)
                        } else{
                            LoginView()
                                .navigationBarHidden(true)
                        }
                      
                    }
                default:
                    NavigationView {
                        Home()
                            .navigationBarHidden(true)
                        
                    }
                }
                
            }
            
//            Spacer()
            
          
            
            VStack {
                HStack {
                    ForEach(0..<4) { num in
                        Button(action: {
                            
                           
                            
                            selectedIndex = num
                        }, label: {
                            Spacer()
                            
                                
                            ZStack {
                                Image(selectedIndex == num ? tabBarImageNamesSelected[num] : tabBarImageNames[num])
                                    .resizable()
                                    .frame(width: 0.14 * screenWidth, height: 0.06 * screenHeight, alignment: .center)
                                        .foregroundColor(selectedIndex == num ? Color.white : Color.black)
                                    .padding(.vertical)
                                
                            }
                            
                            
                            
                            Spacer()
                            
                        })
                        
                    }
                  
                }
                
            }
            .frame(width: 0.95 * screenWidth, height: 0.08 * screenHeight, alignment: .center)
               
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                
            
            Spacer()
                .frame(width: 1 * screenWidth, height: 0.04 * screenHeight, alignment: .center)
           
             
            
            
        }.frame(width: screenWidth, height: screenHeight, alignment: .center)
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
