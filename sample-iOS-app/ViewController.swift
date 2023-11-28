//
//  ViewController.swift
//  sample-iOS-app
//
//  Created by Testpress on 09/06/23.
//

import UIKit
import SwiftUI
import TPStreamsSDK
import AVKit


class ViewController: UIViewController {
    @IBOutlet weak var playerContainer: UIView!
    var player: TPAVPlayer!
    var playerViewController: TPStreamPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        player?.play()
    }
    
    func setupPlayerView(){
        player = TPAVPlayer(assetID: "8eaHZjXt6km", accessToken: "16b608ba-9979-45a0-94fb-b27c1a86b3c1")
        playerViewController = TPStreamPlayerViewController()
        playerViewController?.player = player
        playerViewController!.delegate = self

        addChild(playerViewController!)
        playerContainer.addSubview(playerViewController!.view)
        playerViewController!.view.frame = playerContainer.bounds
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

extension ViewController: TPStreamPlayerViewControllerDelegate {
    func willEnterFullScreenMode() {
        print("willEnterFullScreenMode")
    }
    
    func didEnterFullScreenMode() {
        print("didEnterFullScreenMode")
    }
    
    func willExitFullScreenMode() {
        print("willExitFullScreenMode")
    }
    
    func didExitFullScreenMode() {
        print("didExitFullScreenMode")
    }
}

