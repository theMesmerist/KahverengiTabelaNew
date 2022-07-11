//
//  File.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import Foundation
import SwiftUI
import MapKit

class AntikKent : Identifiable{
    
    public var id = UUID();
    @Published var name : String = ""
    @Published var ImageName = UIImage()
    var latitude: String = ""
    var longitude: String = ""
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
      }
    var kentPlaces = [kentBölgeleri]()
    var imageUrl = String()
    
    
    
    init(name : String, ImageName : UIImage,latitude: String, longitude : String, kentPlaces : [kentBölgeleri], imageUrl : String) {
        self.name = name
        self.ImageName = ImageName
        self.latitude = latitude
        self.longitude = longitude
        self.kentPlaces = kentPlaces
        self.imageUrl = imageUrl
    }
    
    init() {
        
    }
    
    
    static var antikKentler : [AntikKent] = [
    
//        AntikKent(name: "Miletos",ImageName: UIImage(named: "AGORA")!, latitude: "37.53", longitude: "27.274", kentPlaces: [
//
//            kentBölgeleri(name: "Agora", about: "adasjknfkjasnfajksg ", ImageName: "AGORA", from: "Miletos", soundURL: "AGORA_FULL", latitude: 37.5286, longitude: 27.278, kenti: "Miletos", numOfImages: 1),
//
//            kentBölgeleri(name: "Miletos", about: "adasjknfkjasnfajksg", ImageName: "AGORA", from: "Miletos", soundURL: "MİLETOS_FULL", latitude: 37.53, longitude: 27.274, kenti: "Miletos", numOfImages: 2),
//
//            kentBölgeleri(name: "Tiyatro", about: "adasjknfkjasnfajksg", ImageName:"AGORA", from: "Miletos", soundURL: "TİYATRO_FULL",
//                latitude: 37.53, longitude: 27.2758, kenti: "Miletos", numOfImages: 1),
//
//            kentBölgeleri(name: "Avlulu Ev", about: "adasjknfkjasnfajksg ", ImageName: "AGORA", from: "Miletos", soundURL: "AVLULU EV_FULL", latitude: 37.5297, longitude: 27.2783, kenti: "Miletos", numOfImages: 1),
//
//            kentBölgeleri(name: "Helenistik Heron", about: "adasjknfkjasnfajksg ", ImageName: "AGORA", from: "Miletos", soundURL: "HEROON_FULL", latitude: 37.53, longitude: 27.2760, kenti: "Miletos", numOfImages: 1),
//
//            kentBölgeleri(name: "Liman", about: "adasjknfkjasnfajksg ", ImageName: "AGORA", from: "Miletos", soundURL: "LİMAN_FULL", latitude: 37.53, longitude: 27.2786, kenti: "Miletos", numOfImages: 1),
//
//            kentBölgeleri(name: "Müze", about: "adasjknfkjasnfajksg ", ImageName: "AGORA", from: "Miletos", soundURL: "MÜZE_FULL", latitude: 37.525, longitude: 27.274, kenti: "Miletos", numOfImages: 1),
//
//            kentBölgeleri(name: "Tören Yolu", about: "adasjknfkjasnfajksg ", ImageName: UIImage("AGORA"), from: "Miletos", soundURL: "TÖREN YOLU_FULL", latitude: 37.52916, longitude: 27.28, kenti: "Miletos", numOfImages: 1)
//        ]),
//
//        AntikKent(name: "Apollonia",ImageName: UIImage(named: "AGORA")!,latitude: "40.17", longitude: "28.683", kentPlaces: [
//            kentBölgeleri(name: "Apollonia", about: "adasjknfkjasnfajksg ", ImageName: UIImage("APOLLONİA"), from: "Apollonia", soundURL: "APOLLONİA_FULL", latitude: 40.17, longitude: 28.683, kenti: "Apollonia", numOfImages: 5),
//        ]),
//
////        AntikKent(name: "Priene",ImageName: UIImage(named: "AGORA")!,latitude: "37.6594", longitude: "27.3", kentPlaces: [
////            kentBölgeleri(name: "Priene", about: "adasjknfkjasnfajksg ", ImageName: "PRİENE", from: "Priene", soundURL: "PRİENE_FULL", latitude: 37.6594, longitude: 27.3, kenti: "Priene", numOfImages: 3),
////        ]),
//
//        AntikKent(name: "Tralleis",ImageName: UIImage(named: "AGORA")!,latitude: "37.859", longitude: "27.8355", kentPlaces: [
//
//            kentBölgeleri(name: "Latrina", about: "adasjknfkjasnfajksg ", ImageName: UIImage("LATRİNA"), from: "Tralleis", soundURL: "LATRİNA_FULL", latitude: 37.86, longitude: 27.8358, kenti: "Tralleis", numOfImages: 1),
//
//            kentBölgeleri(name: "Tralleis", about: "adasjknfkjasnfajksg ", ImageName: UIImage("TRALLEİS"), from: "Tralleis", soundURL: "TRALLEİS_FULL", latitude: 37.859, longitude: 27.8355, kenti: "Tralleis", numOfImages: 1),
//
//            kentBölgeleri(name: "Üç Gözler", about: "adasjknfkjasnfajksg ", ImageName: UIImage("ÜÇ GÖZLER"), from: "Tralleis", soundURL: "ÜÇ GÖZLER_FULL", latitude: 37.8597, longitude: 27.8347, kenti: "Tralleis", numOfImages: 1),
//
//
//        ]),
//
//        AntikKent(name: "Didim",ImageName: UIImage(named: "AGORA")!,latitude: "37.385", longitude: "27.2563", kentPlaces: [
//
//            kentBölgeleri(name: "Apollon", about: "adasjknfkjasnfajksg ", ImageName: UIImage("APOLLON"), from: "Didim", soundURL: "DİDİM_FULL", latitude: 37.385, longitude: 27.2563, kenti: "Didim", numOfImages: 1),
//        ]),
//
//        AntikKent(name: "Myus", ImageName: UIImage(named: "AGORA")!, latitude: "37.5958", longitude: "27.4288", kentPlaces: [
//
//            kentBölgeleri(name: "Myus", about: "adasjknfkjasnfajksg ", ImageName: UIImage("MYUS"), from: "Myus", soundURL: "MYUS_FULL", latitude: 37.5958, longitude: 27.4288, kenti: "Myus", numOfImages: 1),
//
//        ]),
//
//        AntikKent(name: "Herakleia", ImageName: UIImage(named: "AGORA")!, latitude: "37.5016", longitude: "27.5247", kentPlaces: [
//
//            kentBölgeleri(name: "Herakleia", about: "adasjknfkjasnfajksg ", ImageName: UIImage("HERAKLEİA"), from: "Herakleia", soundURL: "HERAKLEİA_FULL", latitude: 37.5016, longitude: 27.5247, kenti: "Herakleia", numOfImages: 1),
//
//            kentBölgeleri(name: "Kaya Mezarları", about: "adasjknfkjasnfajksg ", ImageName: UIImage("KAYA MEZARLARI"), from: "Herakleia", soundURL: "KAYA MEZARLARI_FULL", latitude: 37.4966, longitude: 27.52638, kenti: "Herakleia", numOfImages: 1),
//
//
//        ]),
//
//        AntikKent(name: "Nikaia", ImageName: UIImage(named: "AGORA")!, latitude: "40.4314", longitude: "29.7291", kentPlaces: [
//            kentBölgeleri(name: "Nikaia", about: "adasjknfkjasnfajksg ", ImageName: UIImage("NİKAİA"), from: "Nikaia", soundURL: "NİKAİA_FULL", latitude: 40.4313, longitude: 29.7291, kenti: "Nikaia", numOfImages: 3),
//        ]),
    ]
    
    static var tümKentoBölge : [kentBölgeleri] = [
        
        //MİLETOS
        
       
        
        
        
//        MİLETOS
        
//        PRİENE
        
      
//
//        kentBölgeleri(name: "Agora Priene", about: "adasjknfkjasnfajksg ", ImageName: UIImage("AGORA PRİENE"), from: "Priene", soundURL: "AGORA PRİENE_FULL", latitude: 37.6583, longitude: 27.2975, kenti: "Priene", numOfImages: 1),
//
//        kentBölgeleri(name: "Alexander", about: "adasjknfkjasnfajksg ", ImageName: UIImage("ALEXANDER"), from: "Priene", soundURL: "ALEXANDER_FULL", latitude: 37.6586, longitude: 27.2947, kenti: "Priene", numOfImages: 1),
//
//        kentBölgeleri(name: "Athena", about: "adasjknfkjasnfajksg ", ImageName: UIImage("ATHENA"), from: "Priene", soundURL: "ATHENA_FULL", latitude: 37.6591, longitude: 27.29638, kenti: "Priene", numOfImages: 1),
//
//        kentBölgeleri(name: "Bauleration Priene", about: "adasjknfkjasnfajksg ", ImageName: UIImage("BAULERATİON PRİENE"), from: "Priene", soundURL: "BAULERATİON_FULL", latitude: 37.6588, longitude: 27.298, kenti: "Priene", numOfImages: 1),
//
//        kentBölgeleri(name: "Tiyatro Priene", about: "adasjknfkjasnfajksg ", ImageName: UIImage("TİYATRO PRİENE"), from: "Priene", soundURL: "TİYATRO PRİENE_FULL", latitude: 37.6597, longitude: 27.2977, kenti: "Priene", numOfImages: 1),
//
//        
        
//        PRİENE
        
//    TRALLEİS
        
       
        
        
//        TRALLEİS
        
//        DİDYMA - APOLLON
        
       
        
//        DİDYMA - APOLLON
        
//        MYUS
        
        
//        MYUS
      
//        APOLLONİA
       
        
        
//        APOLLONİA
        
//        HERAKLEİA
      
        
//        HERAKLEİA
        
//        NİKAİA
       
        
//        NİKAİA
        
    ]
    
}

class kentBölgeleri : Identifiable {
    var id = String();
    @Published var name : String = ""
    @Published var about : String = ""
    @Published var ImageName = UIImage()
    @Published var ImageNameUrl = String()
    @Published public var from : String = ""
    var soundURL : String = ""
    var latitude = String()
    var longitude = String()
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
      }
    var kenti : String = ""
    var numOfImages : Int = 0
    
   
    
    
    init(name : String, about : String, ImageName : UIImage, from : String, soundURL : String, latitude : String,
         longitude : String, kenti : String, numOfImages : Int, ImageNameUrl : String) {
        self.name = name
        self.about = about
        self.ImageName = ImageName
        self.from = from
        self.soundURL = soundURL
        self.latitude = latitude
        self.longitude = longitude
        self.kenti = kenti
        self.numOfImages = numOfImages
        self.ImageNameUrl = ImageNameUrl
    }
    
    init() {
        
    }
}
