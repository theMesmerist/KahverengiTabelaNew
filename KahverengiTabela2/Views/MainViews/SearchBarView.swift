//
//  SearchBarView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import SwiftAudioPlayer


struct SearchBarView: View {
    
    @State var searchText = ""
    @State var searching = false
    
    var body: some View {
        
        VStack {
            VStack{
//                    TextView(text: "Antik Kenler", textFieldText: "Antik kent adı giriniz")
//                    .padding(.bottom, 50)
                        
                    
                
                
                
                SearchBar(searchText: $searchText, searching: $searching)
                    .background(Color.clear)
                List(AntikKent.tümKentoBölge.filter({ (kentt: kentBölgeleri) -> Bool in
                    return kentt.name.hasPrefix(searchText) || searchText == ""
                    })) { kentt in
                        NavigationLink(destination: CityDetailView(kentChoice: kentt, cityLong: kentt.longitude, cityLat: kentt.latitude, cityName: kentt.name, cityFrom: kentt.from, cityAbout: kentt.about, citySound: kentt.soundURL)){
                        
                            SearchCellView(cityImg: kentt.ImageName, cityName: kentt.name, cityFrom: kentt.kenti)
                          
                        
//                        Image(kentt.ImageName)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height:100)
//                            .clipShape(Circle())
//                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                            .padding()
//
//                        VStack{
//                            Text(kentt.name)
//                                .font(.title)
//                                .fontWeight(.black)
//                                .padding()
//
//                            Text(kentt.kenti)
//                                .foregroundColor(.secondary)
//                                .fontWeight(.black)
//                                .padding()
//                        }
                        
                        


                    } .frame(width: 0.8 * screenWidth, height: 0.15 * screenHeight, alignment: .center)
                        
                   
                   

                    }
                
                   
                    .navigationBarHidden(true)
//                    .navigationBarTitleDisplayMode(.inline)
                    
                   
//                            .navigationTitle(searching ? "Aranıyor..." : "Antik kentler")
                    .toolbar {
                        if true {
                            Button("Vazgeç") {
                                searchText = ""
                                withAnimation {
                                   searching = false
                                   UIApplication.shared.dismissKeyboard()
                                }
                            }
                        }
                    }
                    .gesture(DragGesture().onChanged({ _ in
                            UIApplication.shared.dismissKeyboard()
                                })
                    )
            }
            .background(Color.clear)
            
            Spacer()
        }
        .onAppear{
            SAPlayer.shared.pause()
        }
        
        }
    }



struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}


struct SearchBar: View {

    @Binding var searchText: String
    @Binding var searching: Bool

    var body: some View {
        VStack {
            
            Text("Antik kentler")
                .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                .font(.custom("Poppins-Regular", size: 25))
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(width: 0.9 * screenWidth, height: 0.07 * screenHeight, alignment: .center)

                   
                HStack {
                    
                    TextField("Antik kent adı giriniz...", text: $searchText){ startedEditing in
                             if startedEditing {
                                 withAnimation {
                                     searching = true
                                 }
                             }
                    }onCommit: {
                        withAnimation {
                            searching = false
                        }
                    }
                }.foregroundColor(.gray)
                .padding(.leading, 13)
                
                HStack {
                    Image("icon_search")
                        .resizable()
                    .frame(width: screenWidth * 0.12, height: screenHeight * 0.05, alignment: .center)
                }
                .frame(width: 0.85 * screenWidth, height: 0.07 * screenHeight, alignment: .trailing)
                
            }
            
            .frame(width: 0.9 * screenWidth, height: 0.07 * screenHeight, alignment: .center)
            .cornerRadius(10)
        .shadow(radius: 5)
        }
        .background(Color.clear)
    }
}
extension UIApplication {
     func dismissKeyboard() {
         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for:nil)
     }
 }
