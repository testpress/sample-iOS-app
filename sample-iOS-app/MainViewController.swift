//
//  MainViewController.swift
//  sample-iOS-app
//
//  Created by Prithuvi on 27/11/24.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var sample1: UIButton!
    @IBOutlet weak var sample2: UIButton!
    @IBOutlet weak var sample3: UIButton!
    @IBOutlet weak var downloads: UIButton!
    
    @IBAction func sample1Tapped(_ sender: UIButton) {
        presentPlayerViewController(assistId: "42h2tZ5fmNf", accessToken: "5e053725-0497-48c9-9a7d-3491c809ce61")
    }
    
    @IBAction func sample2Tapped(_ sender: UIButton) {
        presentPlayerViewController(assistId: "ACGhHuD7DEa", accessToken: "fe0cca1a-affe-4215-ac53-b1f26cce6ce2")
    }
    
    @IBAction func downloadsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let downloadListVC = storyboard.instantiateViewController(withIdentifier: "DownloadListViewController") as? DownloadListViewController {
            downloadListVC.modalPresentationStyle = .fullScreen
            present(downloadListVC, animated: true, completion: nil)
        }
    }
    
    private func presentPlayerViewController(assistId: String, accessToken: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController {
            playerVC.assistId = assistId
            playerVC.accessToken = accessToken
            playerVC.modalPresentationStyle = .fullScreen
            present(playerVC, animated: true, completion: nil)
        }
    }
}
