//
//  Global.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import Foundation
import SwiftUI
import Lottie

var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

var userLong = Double()
var userLat = Double()

var placeLong = Double()
var placelat = Double()

let uDefaults = UserDefaults.standard
var isUserPremium = false


var selectedKent = AntikKent()

var userLikedArr = [kentBölgeleri]()

func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle) {

    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()

}

func create_loading_view(view: UIView) -> UIView {

    let view_loading = UIView()
    view_loading.frame = view.bounds

    let view_background = UIView()
    view_background.frame = view_loading.bounds
    view_background.backgroundColor = .black
    view_background.alpha = 0.6
    view_loading.addSubview(view_background)

    let anim_loading = AnimationView(name: "animation1")
    anim_loading.frame = CGRect(x: 0.25 * screenWidth, y: 0.25 * screenHeight, width: 0.5 * screenWidth, height: 0.5 * screenHeight)
    anim_loading.backgroundColor = .clear
    anim_loading.loopMode = .loop
    anim_loading.animationSpeed = 1
    anim_loading.backgroundBehavior = .pauseAndRestore
    view_loading.addSubview(anim_loading)
    anim_loading.play()


    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        NotificationCenter.default.post(name: Notification.Name("Failed"), object: nil, userInfo: nil)
    }

    return view_loading

}
