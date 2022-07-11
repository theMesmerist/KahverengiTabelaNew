//
//  MapView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu on 29.05.2022.
//

import SwiftUI
import MapKit
import Firebase

struct MapView: View {
    
    
@State var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 38.96,
                                   longitude: 28.24),
    span: MKCoordinateSpan(latitudeDelta: 5.5,
                           longitudeDelta: 5.5))
    
    @State var locationManager = LocationManager()
    @State var mapView = MKMapView()
    
    @State var userLat : CLLocationDegrees!
    @State var userLong : CLLocationDegrees!
    
    var body: some View {
        
        
        ZStack{
            VStack{
                
                HStack{
                    Text("Antik kent seçiniz")
                        .font(.custom("Poppins-Regular", size: 20))
                        .frame(width: 0.9 * screenWidth, height: 0.05 * screenHeight, alignment: .leading)
                }
                .frame(width:  screenWidth, height: 0.05 * screenHeight, alignment: .center)
               
                
                
                MapKit.Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: AntikKent.antikKentler){
                    place in
                    MapAnnotation(coordinate: place.coordinate) {
                        NavigationLink(
                            destination: DetailedMapView(selected: place.name, selectedLat: place.latitude, selectedLon: place.longitude)){
                            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                                Image(uiImage: place.ImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 25)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 25/10))
                                .shadow(radius: 10)
                            Text(place.name)
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(Color.black)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                                
                            }
                            
                        }
                        
                    
                    }

                }  .cornerRadius(10)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
              
            }
          
            
        }
        .onAppear{
            
                LocationManager.shared.requestLocationAuthorization()
              
          
            
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
extension UIImage {
    func toString() -> String? {

        let pngData = self.pngData()

        //let jpegData = self.jpegData(compressionQuality: 0.75)

        return pngData?.base64EncodedString(options: .lineLength64Characters)
    }
}
extension MapView{
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let fileUrl = URL(string: url)!
        URLSession.shared.dataTask(with: fileUrl, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
       
    }
    
   
}
