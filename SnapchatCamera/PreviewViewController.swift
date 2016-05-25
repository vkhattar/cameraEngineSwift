//
//  PreviewViewController.swift
//  SnapchatCamera
//
//  Created by Vedant Khattar on 2016-05-24.
//  Copyright © 2016 Archetapp. All rights reserved.
//

import UIKit
import PBJVideoPlayer
//import FLAnimatedImage

enum Media {
    case Photo(image: UIImage)
    case Video(url: NSURL)
//    case GIF(url: NSURL)
}



class PreviewViewController: UIViewController, PBJVideoPlayerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonClose: UIButton!
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var aspectRatio: CGFloat = 1.0
    
    var viewFinderHeight: CGFloat = 0.0
    var viewFinderWidth: CGFloat = 0.0
    var viewFinderMarginLeft: CGFloat = 0.0
    var viewFinderMarginTop: CGFloat = 0.0
    
    var media: Media!
    var playerController: PBJVideoPlayerController!
    
    @IBAction func closePreview(sender: UIButton) {
        print("some one is trying to close me baby")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func playVideo(url: NSURL) {
        print("display video for url : \(url.absoluteString)")
//        UISaveVideoAtPathToSavedPhotosAlbum(url.absoluteString, nil, nil, nil)
        self.playerController = PBJVideoPlayerController()
        self.playerController.delegate = self
        
        if screenWidth > screenHeight {
            aspectRatio = screenHeight / screenWidth * aspectRatio
            viewFinderWidth = self.view.bounds.width
            viewFinderHeight = self.view.bounds.height * aspectRatio
            viewFinderMarginTop *= aspectRatio
        } else {
            aspectRatio = screenWidth / screenHeight
            viewFinderWidth = self.view.bounds.width * aspectRatio
            viewFinderHeight = self.view.bounds.height
            viewFinderMarginLeft *= aspectRatio
        }

        self.playerController.view.frame = CGRectMake(viewFinderMarginLeft, viewFinderMarginTop, viewFinderWidth, viewFinderHeight)
        
        
//        self.playerController.view.frame = self.view.bounds
        self.playerController.videoPath = url.absoluteString
        
        
    
        self.addChildViewController(self.playerController)
        self.view.insertSubview(self.playerController.view, atIndex: 0)
      
        self.playerController.videoFillMode = "AVLayerVideoGravityResizeAspectFill"
        self.playerController.didMoveToParentViewController(self)
    }

    
    override func viewWillAppear(animated: Bool) {
        switch self.media! {
        case .Photo(let image): self.imageView.image = image
        case .Video(let url): self.playVideo(url)
        }
    }
    
    
   func videoPlayerReady(videoPlayer: PBJVideoPlayerController!) {
        print("Video player is ready!")
        videoPlayer.playFromBeginning()
        videoPlayer.playbackFreezesAtEnd = true
    }
    
    func videoPlayerPlaybackDidEnd(videoPlayer: PBJVideoPlayerController!) {
        print("oh it ended")
        videoPlayer.playFromBeginning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
