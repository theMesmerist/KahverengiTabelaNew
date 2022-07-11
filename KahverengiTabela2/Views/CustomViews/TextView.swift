//
//  TextView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import SwiftUI

struct TextView: View {
    
    @State var text : String = "AAA"
    @State var textFieldText : String = "CCC"
    
    var body: some View {
       
        
        VStack{
            Text(text)
                .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                .padding(.leading, 10)
            
            TextField("abc", text: $textFieldText)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                .foregroundColor(.gray)
                .frame(width: 0.9 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
