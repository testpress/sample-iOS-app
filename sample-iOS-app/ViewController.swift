//
//  ViewController.swift
//  sample-iOS-app
//
//  Created by Testpress on 09/06/23.
//

import UIKit
import SwiftUI
import TPStreamsSDK

class ViewController: UIViewController {
    @IBOutlet weak var playerContainer: UIView!
    let player = TPAVPlayer(assetID: "8eaHZjXt6km", accessToken: "16b608ba-9979-45a0-94fb-b27c1a86b3c1")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerContainer.removeFromSuperview()
        
        let playerView = UIHostingController(rootView: TPStreamPlayerView(player: player))
        playerView.view.frame = playerContainer.frame
        view.addSubview(playerView.view)
    }
    
    @IBAction func togglePlay(_ sender: UIButton) {
        if (player.timeControlStatus == .playing){
            player.pause()
            sender.setTitle("Play", for: .normal)
        } else {
            player.play()
            sender.setTitle("Pause", for: .normal)
        }
    }
}

