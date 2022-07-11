//
//  DirectionMapView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import MapKit
import SwiftAudioPlayer

struct DirectionMapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.96,
                                       longitude: 28.24),
        span: MKCoordinateSpan(latitudeDelta: 5.5,
                               longitudeDelta: 5.5))
    
//    @State var mapView = MKMapView()
//    let mapView = MapManager(route: DirectionMapView.init().$route)
    
    
    @State var route: MKPolyline?
    
    var body: some View {
        VStack{
            Spacer()
                .frame(width: screenWidth * 0.4, height: screenHeight * 0.03, alignment: .center)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("btn_cross")
                        .padding(10)
                }
                Spacer()
                
                Text("Rota")
                    .font(.custom("Poppins-Regular", size: 30))
                
                Spacer()
                    .frame(width: screenWidth * 0.4, height: screenHeight * 0.05, alignment: .center)
            }
            
           
            MapManager(route: $route)
                .ignoresSafeArea(.all)
            .frame(width: screenWidth, height: screenHeight * 0.85, alignment: .center)
            .cornerRadius(10)
            .onAppear{
               findPlace()
                    SAPlayer.shared.pause()
            }
            
            
            
            
            
            
        }
    }
}

struct DirectionMapView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionMapView()
    }
}

private extension DirectionMapView {
    func findPlace() {
        let start = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
        let region = CLLocationCoordinate2D(latitude: placelat, longitude: placeLong)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: region, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        
        directions.calculate {  response, error in
            guard response != nil else { return }
       
        
                self.route = response?.routes.first?.polyline
        }
    }
}



