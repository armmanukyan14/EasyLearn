//
//  ProfileCollectionViewCell.swift
//  EasyLearn
//
//  Created by MacBook on 20.01.22.
//

import AVKit
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet var profileVideoView: UIView! { didSet {
        profileVideoView.layer.cornerRadius = 10
//        profileVideoView.backgroundColor = UIColor.random()

//        if let urlString = UserDefaults.standard.value(forKey: "videoUrl") as? String,
//           let url = URL(string: urlString) {
//            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//                guard let data = data, error == nil
//                else { return }
//
//                DispatchQueue.main.async {
//                    let player = AVPlayer(url: url)
//
//                    let videoLayer = AVPlayerLayer(player: player)
//                    videoLayer.frame = self.profileVideoView.bounds
//                    videoLayer.masksToBounds = true
//                    videoLayer.cornerRadius = 10.0
//                    videoLayer.videoGravity = .resizeAspectFill
//                    self.profileVideoView.layer.addSublayer(videoLayer)
//
////                    player.play()
//                }
//            })
//            task.resume()
//        }

//        let videoLayer = AVPlayerLayer(player: player1)
//        videoLayer.frame = profileVideoView.bounds
//        videoLayer.masksToBounds = true
//        videoLayer.cornerRadius = 10.0
//      videoLayer.videoGravity = .resizeAspectFill
//        profileVideoView.layer.addSublayer(videoLayer)
//        player1.play()
    }}
}
