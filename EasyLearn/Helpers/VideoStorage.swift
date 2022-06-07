//
//  VideoStorage.swift
//  EasyLearn
//
//  Created by Arm on 26.05.22.
//

import Foundation
import Firebase
import FirebaseStorage
import AVFoundation

var userVideos = [String]()
var players = [AVPlayer]()

class VideoStorage {

    private let storage = Storage.storage().reference()

    static let shared = VideoStorage()

    func getVideos() {
        if let uid = Auth.auth().currentUser?.uid {
            let videosRef = storage.child("Taken Videos")
            let fileName = "\(uid)"
            let userVideosRef = videosRef.child(fileName)
            userVideosRef.listAll { result, error in
                if error == nil {
                    userVideos.forEach {
                        if let url = URL(string: $0) {
                            result.items.forEach {
                                $0.write(toFile: url) { url, error in
                                    if let url = url, error == nil {
                                        players += [AVPlayer(url: url)]
                                    }
                                }.resume()
                            }
                        }
                    }
                }
            }
        }
    }
}
