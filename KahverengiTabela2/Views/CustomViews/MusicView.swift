//
//  MusicView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import SwiftUI
import AVKit
import Firebase
import SwiftAudioPlayer

struct MusicView: View {
    
    @State var kent : kentBölgeleri
    
    @State var soundStringUrl = String()
    @State var player = AVAudioPlayer()
    @State var isPlaying = false
    @State var cityImage = UIImage()
    @State var currentDuration = "0:00:00"
    @State var totalDuration = "0:00:00"
    
    var body: some View {
        HStack{
            
            VStack{
                ZStack{
                    
               
                    RoundedRectangle(cornerRadius: 10, style: .circular)
                        
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    HStack{
                        Image(uiImage: kent.ImageName)
                            .resizable()
                            .frame(width: 0.13 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                        
                        Text(kent.name)
                            .frame(width: screenWidth * 0.2, height: screenHeight * 0.08, alignment: .center)
                           
                        
                        Button(action: {
                            print(soundStringUrl)
                            isPlaying.toggle()
                            
                            if isPlaying{
                                subscribeToChanges()
                                let url = URL(string: soundStringUrl)!
                                SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
                                SAPlayer.shared.play()
                                let info = SALockScreenInfo(title: kent.name, artist: "KahverengiTabela", albumTitle: kent.from, artwork: cityImage, releaseDate:0)
                                SAPlayer.shared.mediaInfo = info
                            } else{
                                SAPlayer.shared.pause()
                                
                            }
                            
                        }, label: {
                            Image(isPlaying ? "btn_stop" : "btn_play")
                        })
                        
                        
                        Text(currentDuration)
                          
                        Text(totalDuration)
                        
                    }.frame(width: 0.8 * screenWidth, height: 0.06 * screenHeight, alignment: .leading)
                   
                }
            }.frame(width: 0.9 * screenWidth, height: 0.08 * screenHeight, alignment: .center)
        }
        
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(kent: kentBölgeleri.init())
    }
}

extension MusicView{
    func loadRadio(radioURL: String) {

            let url = URL.init(string: radioURL)
        downloadSound(url: url!)
        }
    func playMusic(urlString : String){
        let url = URL(string: urlString)!
        SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
        SAPlayer.shared.play()
    }
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    func downloadSound(url:URL){
        let docUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let desURL = docUrl.appendingPathComponent("tmpsong.m4a")
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [self](URLData, response, error) -> Void in
            do{
                let isFileFound:Bool? = FileManager.default.fileExists(atPath: desURL.path)
                if isFileFound == true{
                      print(desURL)

                    try FileManager.default.removeItem(atPath: desURL.path)
                    try FileManager.default.copyItem(at: URLData!, to: desURL)

                } else {
                    try FileManager.default.copyItem(at: URLData!, to: desURL)
                }
                let sPlayer = try AVAudioPlayer(contentsOf: desURL)
                player = sPlayer
                player.prepareToPlay()
                player.play()

            }catch let err {
                print(url)
                
                
                
                print(err.localizedDescription)
                print(err)
            }
                
            })
        downloadTask.resume()
    }
    
    func subscribeToChanges() {
        

        let _ = SAPlayer.Updates.ElapsedTime.subscribe { [self] (url, position) in
            guard url == URL(string: soundStringUrl) else { return }
            
            currentDuration = SAPlayer.prettifyTimestamp(position)
            
            let _ = SAPlayer.Updates.Duration.subscribe { [self] (url, duration) in
               
                guard url == URL(string: soundStringUrl) else { return }
                totalDuration = SAPlayer.prettifyTimestamp(duration)
               
            }
         
        }
      
        
        
    }


    
}
