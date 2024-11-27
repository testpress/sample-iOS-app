//
//  AppDownloadManager.swift
//  sample-iOS-app
//
//  Created by Prithuvi on 27/11/24.
//

import Foundation
import TPStreamsSDK

class AppDownloadManager: TPStreamsDownloadDelegate, ObservableObject {

    @Published var offlineAssets: [OfflineAsset] = []

    init() {
        TPStreamsDownloadManager.shared.setTPStreamsDownloadDelegate(tpStreamsDownloadDelegate: self)
        getOfflineAssets()

        NotificationCenter.default.addObserver(self, selector: #selector(handleOfflineAssetsUpdated), name: Notification.Name("OfflineAssetsUpdated"), object: nil)
    }

    func getOfflineAssets() {
        offlineAssets = TPStreamsDownloadManager.shared.getAllOfflineAssets()
    }

    func onComplete(offlineAsset: OfflineAsset) {
        getOfflineAssets()
        print("Download Complete", offlineAsset)
    }

    func onStart(offlineAsset: OfflineAsset) {
        offlineAssets.append(offlineAsset)
        print("Download Start", offlineAsset.assetId)
    }

    func onPause(offlineAsset: OfflineAsset) {
        print("Download Pause", offlineAsset.assetId)
    }

    func onResume(offlineAsset: OfflineAsset) {
        print("Download Resume", offlineAsset.assetId)
    }
    
    func onCanceled(assetId: String) {
        getOfflineAssets()
        print("Download Canceled", assetId)
    }
    
    func onDelete(assetId: String) {
        getOfflineAssets()
        print("on Delete", assetId)
    }

    @objc func handleOfflineAssetsUpdated() {
        getOfflineAssets()
        print("Offline Assets Updated")
    }

    func onStateChange(status: Status, offlineAsset: OfflineAsset) {
        updateOfflineAsset(offlineAsset)
    }

    func onProgressChange(assetId: String, percentage: Double) {
        print("Downloads Progress Change")
    }

    func updateOfflineAsset(_ offlineAsset: OfflineAsset) {
        if let index = offlineAssets.firstIndex(where: { $0.assetId == offlineAsset.assetId }) {
            offlineAssets[index] = offlineAsset
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("OfflineAssetsUpdated"), object: nil)
    }

}
