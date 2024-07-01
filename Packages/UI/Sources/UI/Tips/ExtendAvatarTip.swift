//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 01.07.2024.
//

import TipKit

@available(iOS 17, *)
struct ExtendAvatarTip: Tip {
    var title: Text {
        Text("Tap to extend!")
    }

    var message: Text? {
        Text("The avatar can be extended to full screen width.")
    }

    var image: Image? {
        Image(systemName: "arrow.down.backward.and.arrow.up.forward")
    }
}
