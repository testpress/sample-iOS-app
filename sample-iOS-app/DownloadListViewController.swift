//
//  DownloadListViewController.swift
//  sample-iOS-app
//
//  Created by Prithuvi on 27/11/24.
//

import UIKit
import Combine
import TPStreamsSDK

class DownloadListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    var downloadManager: AppDownloadManager?
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDownloadManager()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func initializeDownloadManager() {
        downloadManager = AppDownloadManager()
        downloadManager?.$offlineAssets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DownloadListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadManager?.offlineAssets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "downloadCell", for: indexPath) as? DownloadTableViewCell else {
            return UITableViewCell()
        }
        
        if let offlineAsset = downloadManager?.offlineAssets[indexPath.row] {
            cell.titleLabel.text = offlineAsset.title
            cell.infoLabel.text = "\(formatDate(date: offlineAsset.createdAt)) • \(formatDuration(seconds: offlineAsset.duration)) • \(String(format: "%.2f MB", offlineAsset.size / 8 / 1024 / 1024)) • \(offlineAsset.status)"
            
            let progress = (offlineAsset.percentageCompleted / 100)
            cell.progressView.progress = Float(progress)
            
            switch offlineAsset.status {
            case Status.inProgress.rawValue:
                cell.play.isHidden = true
                cell.delete.isHidden = true
            case Status.finished.rawValue:
                cell.cancel.isHidden = true
                cell.play.isHidden = false
                cell.delete.isHidden = false
            default:
                cell.cancel.isHidden = false
                cell.play.isHidden = false
                cell.delete.isHidden = false
            }
            
            cell.cancel.tag = indexPath.row
            cell.cancel.addTarget(self, action: #selector(cancelDownload(_:)), for: .touchUpInside)
            
            cell.delete.tag = indexPath.row
            cell.delete.addTarget(self, action: #selector(deleteDownload(_:)), for: .touchUpInside)
            
            cell.play.tag = indexPath.row
            cell.play.addTarget(self, action: #selector(playDownload(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func cancelDownload(_ sender: UIButton) {
        let index = sender.tag
        if let offlineAsset = downloadManager?.offlineAssets[index] {
            TPStreamsDownloadManager.shared.cancelDownload(offlineAsset.assetId)
        }
    }

    @objc func deleteDownload(_ sender: UIButton) {
        let index = sender.tag
        if let offlineAsset = downloadManager?.offlineAssets[index] {
            TPStreamsDownloadManager.shared.deleteDownload(offlineAsset.assetId)
        }
    }

    @objc func playDownload(_ sender: UIButton) {
        let index = sender.tag
        if let offlineAsset = downloadManager?.offlineAssets[index] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController {
                playerVC.assistId = offlineAsset.assetId
                playerVC.modalPresentationStyle = .fullScreen
                present(playerVC, animated: true, completion: nil)
            }
        }
    }
    
    func formatDuration(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2

        if let formattedString = formatter.string(from: seconds) {
            return formattedString
        } else {
            return "0s"
        }
    }

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let formattedString = dateFormatter.string(from: date)
        return formattedString
    }
}

class DownloadTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var play: UIButton!
}
