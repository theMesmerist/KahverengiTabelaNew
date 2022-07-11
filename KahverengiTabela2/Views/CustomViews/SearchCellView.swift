//
//  SearchCellView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import SwiftUI

struct SearchCellView: View {
    
    @State var cityImg = UIImage()
    @State var cityName = ""
    @State var cityFrom = ""
    
    var body: some View {
        HStack{
          
            Button(action: {
                
            }, label: {
                HStack{
                    
               
                    Image(uiImage: cityImg)
                    .resizable()
                    .frame(width: 0.28 * screenWidth, height: 0.125 * screenHeight, alignment: .center)
                    .cornerRadius(10)
                    .padding(.leading,20)
                    
                    
                    VStack{
                        
                   
                Text(cityName)
                        .foregroundColor(.black)
                        .bold()
                        .frame(width: 0.5 * screenWidth, height: 0.04 * screenHeight, alignment: .center)
                        
                Text(cityFrom)
                            .foregroundColor(.secondary)
                            .frame(width: 0.5 * screenWidth, height: 0.04 * screenHeight, alignment: .center)
                    }
                    
                }  .frame(width: 0.7 * screenWidth, height: 0.15 * screenHeight, alignment: .center)
            })
            
        }
        .frame(width: 0.8 * screenWidth, height: 0.15 * screenHeight, alignment: .center)
//        .background(.white)
        .cornerRadius(10)
//        .shadow(radius: 5)
       
    }
}

struct SearchCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCellView()
    }
}
