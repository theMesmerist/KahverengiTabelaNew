//
//  inApp.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import AlertToast
import SwiftAudioPlayer

struct inApp: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isWeeklySelected = true
    @State var isMonthlySelected = false
    @State var isContentView = false
    
    @State var isSuccess = false
    @State var isError = false
    
    var body: some View {
        
        
        
        VStack {
            HStack {
                Button {
                    isContentView.toggle()
                } label: {
                    Image("btn_cross")
                        .padding(10)
                }
                Spacer()
            }
            VStack{
                Image("img_premium")
                    .padding(.top, -50)
                Spacer()
                    .frame(width: screenWidth, height: screenHeight * 0.05, alignment: .center)
                Text("Sınırsız\niçeriğe ulaş!")
                    .font(.custom("Poppins-Regular", size: 24))
                    .frame(width: 0.9 * screenWidth, height: 0.18 * screenWidth, alignment: .top)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(width: screenWidth, height: screenHeight * 0.05, alignment: .center)
                HStack {
                    Text("Tüm içeriklere sınırsız eriş")
                        .font(.custom("Poppins-Regular", size: 16)).foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                    .frame(width: screenWidth, height: screenHeight * 0.05, alignment: .center)
            }
            
            VStack {
                Button {
                    print("weakly")
                    isWeeklySelected = true
                    isMonthlySelected = false
                    
                } label: {
                    VStack {
                        Text(priceWeekly)
                        Text("1 Haftalık")
                    }.foregroundColor(Color.black)
                        .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                        .contentShape(Rectangle())
                        .background(Color.white)
                }.border(isWeeklySelected ? Color(UIColor(red: 0.23, green: 0.32, blue: 0.60, alpha: 1.00)) : Color.gray)
                Button {
                    print("Monthly")
                    isMonthlySelected = true
                    isWeeklySelected = false
                } label: {
                    VStack {
                        Text(priceMonthly)
                        Text("1 Aylık")
                    }.foregroundColor(Color.black)
                        .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                        .contentShape(Rectangle())
                        .background(Color.white)
                }.border(isMonthlySelected ? Color(UIColor(red: 0.23, green: 0.32, blue: 0.60, alpha: 1.00)) : Color.gray)
            }
            Button {
                if isWeeklySelected{
                    StoreKitOperations().purchaseProduct(productID: weeklyProductID)
                } else if isMonthlySelected{
                    StoreKitOperations().purchaseProduct(productID: monthlyProductID)
                }
            } label: {
                Text("Başla!")
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Medium", size: 16))
                    .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                    .contentShape(Rectangle())
            }.background(Color(UIColor(red: 0.23, green: 0.32, blue: 0.60, alpha: 1.00)))
                .padding(.vertical)
            HStack{
                Button {
                    print("Kullanım Koşulları")
                } label: {
                    Text("Kullanım Koşulları")
                        .foregroundColor(Color.black)
                        .underline()
                }.padding(.leading, 0.1 * screenWidth)
                Spacer()
                Button {
                    print("Satın alımı yenile")
                } label: {
                    Text("Satın alımı yenile")
                        .foregroundColor(Color.black)
                        .underline()
                }.padding(.trailing, 0.1 * screenWidth)
            }
            
        }
        .onAppear{
            SAPlayer.shared.pause()
        }
        
            .navigationBarHidden(true)
            .transition(.move(edge: .leading))
            .fullScreenCover(isPresented: $isContentView, content: ContentView.init)
        
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PurchaseSucces"))){_ in
                isSuccess.toggle()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PurchaseError"))){_ in
                isError.toggle()
            }
        
            .toast(isPresenting: $isSuccess){
                
               
                AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Satın alma başarılı!")
                
              
            }
        
            .toast(isPresenting: $isError){
                
               
                AlertToast(displayMode: .hud, type: .complete(Color.red), title: "Satın alma başarısız!")
                
              
            }
        
        
    }
}

struct inApp_Previews: PreviewProvider {
    static var previews: some View {
        inApp()
    }
}
