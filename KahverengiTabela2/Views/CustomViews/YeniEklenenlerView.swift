//
//  YeniEklenenlerView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI

struct YeniEklenenlerView: View {
    
    let layout = [
        GridItem(.fixed(80))
    ]
    
    @State var isSelectedPlace = false
   
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: layout) {
                Spacer()
                
                ForEach(AntikKent.antikKentler) { kent in
                    NavigationLink(destination: DetailedMapView(selected: kent.name, selectedLat: kent.latitude, selectedLon: kent.longitude), isActive: $isSelectedPlace){
                    }
                       
                        Button(action: {
                           
                            isSelectedPlace.toggle()
                            
                                
                        }, label: {
                            VStack{
                                
                                Image(uiImage: kent.ImageName)
                                .resizable()
                                .frame(width: 0.45 * screenWidth, height: 0.15 * screenHeight, alignment: .center)
                            Text(kent.name)
                                    .font(.custom("Poppins-Regular", size: 15))
                                    .foregroundColor(Color.black)
                            Spacer()
                            }
                        })
                        .buttonStyle(.plain)
                        .frame(width: 0.4 * screenWidth, height: 0.2 * screenHeight, alignment: .center)
                        
                   
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal , 20)
                        
                    
                
                }
            }
        }
        .frame(width: screenWidth, height: 0.22 * screenHeight, alignment: .center)
        
        
    }
}

struct YeniEklenenlerView_Previews: PreviewProvider {
    static var previews: some View {
        YeniEklenenlerView()
    }
}
