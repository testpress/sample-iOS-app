//
//  PlayerViewController.swift
//  sample-iOS-app
//
//  Created by Prithuvi on 27/11/24.
//

import UIKit
import TPStreamsSDK
import AVKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    var assistId: String?
    var accessToken: String?
    
    var player: TPAVPlayer?
    var playerViewController: TPStreamPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPlayerView()
        player?.play()
    }
    
    func setupPlayerView(){
        if (TPStreamsDownloadManager.shared.isAssetDownloaded(assetID: assistId!)){
            player = TPAVPlayer(offlineAssetId:assistId!){ error in
                guard error == nil else {
                    print("Setup error: \(error!.localizedDescription)")
                    return
                }

                print("TPAVPlayer setup successfully")
            }
        } else {
            player = TPAVPlayer(assetID: assistId!, accessToken: accessToken!){ error in
                guard error == nil else {
                    print("Setup error: \(error!.localizedDescription)")
                    return
                }

                print("TPAVPlayer setup successfully")
            }
        }
        playerViewController = TPStreamPlayerViewController()
        playerViewController?.player = player
        playerViewController?.delegate = self

        
        let config = TPStreamPlayerConfigurationBuilder()
            .setPreferredForwardDuration(15)
            .setPreferredRewindDuration(5)
            .setprogressBarThumbColor(.systemBlue)
            .setwatchedProgressTrackColor(.systemBlue)
            .showDownloadOption()
            .build()
        
        playerViewController?.config = config

        addChild(playerViewController!)
        playerContainer.addSubview(playerViewController!.view)
        playerViewController!.view.frame = playerContainer.bounds
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        player?.pause()
        dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: TPStreamPlayerViewControllerDelegate {
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

