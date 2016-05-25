//
//  View1.swift
//  SnapchatCamera
//
//  Created by Jared Davidson on 8/26/15.
//  Copyright (c) 2015 Archetapp. All rights reserved.
//

import UIKit
import CameraEngine

enum ModeCapture {
    case Photo
    case Video
    case GIF
}

class View1: UIViewController{
    
    let cameraEngine = CameraEngine()
    
    @IBOutlet weak var labelDuration: UILabel!
    
    
//     private var currentModeCapture: ModeCapture = .Photo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //starting the camera session
        self.labelDuration.hidden = true
//        self.view.backgroundColor = UIColor.blackColor()
        self.cameraEngine.startSession()
        
        self.cameraEngine.blockCompletionProgress = { progress in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.labelDuration.hidden = false
                self.labelDuration.text = "\(progress)"
            })
//            print("progress duration : \(progress)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        //brings the camera layer on the view, makes it the same size of the view
        let layer = self.cameraEngine.previewLayer
        layer.frame = self.view.bounds
        self.view.layer.insertSublayer(layer, atIndex: 0)
        self.view.layer.masksToBounds = true
        
    }

    @IBAction func flash(sender: AnyObject) {
        let alertController = UIAlertController(title: "Flash mode", message: "Change the flash mode", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "On", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            print("hello falshing")
            self.cameraEngine.flashMode = .On
        }))
        alertController.addAction(UIAlertAction(title: "Off", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.cameraEngine.flashMode = .Off
        }))
        alertController.addAction(UIAlertAction(title: "Auto", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.cameraEngine.flashMode = .Auto
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func switchCamera(sender: UIButton) {
        self.cameraEngine.switchCurrentDevice()
    }
    
    @IBAction func shootMe(sender: UIButton) {
        print("ouch I am hurt")
        self.cameraEngine.capturePhoto { (image, error) -> (Void) in
            if let image = image{
                
                let previewController = PreviewViewController(nibName: "PreviewViewController", bundle: nil)
     
                CameraEngineFileManager.savePhoto(image, blockCompletion: { (success, error) -> (Void) in
                    if let error = error {
                        print("error saving image \(error)")
                    }
                })
            
                previewController.media = Media.Photo(image: image)
                self.presentViewController(previewController, animated: true, completion: nil)
            }
            else{
                print("error")
            }
        }
        
    }

    @IBAction func recordMe(sender: UIButton) {
        self.labelDuration.hidden = false
        startRecording(sender)
    }
    
    private func startRecording(sender: UIButton) {

        if self.cameraEngine.isRecording == false {
            print("starting")
            sender.highlighted = true
            guard let url = CameraEngineFileManager.documentPath("video.mp4") else {
                print("what the fuck where is the url")
                return
            }
            
            self.cameraEngine.startRecordingVideo(url, blockCompletion: { (url, error) -> (Void) in
            
                let previewController = PreviewViewController(nibName: "PreviewViewController", bundle: nil)
      
                CameraEngineFileManager.saveVideo(url!, blockCompletion: { (success, error) -> (Void) in
                    if let error = error {
                        print("error saving video \(error)")
                    }
                    else {
                        print("Video saved properly")
                        previewController.media = Media.Video(url: url!)
                        self.presentViewController(previewController, animated: true, completion: nil)
                        //previewing camera
                    }
                })
            })
        }
        else {
            print("stopping recording")
            sender.highlighted = false
            self.cameraEngine.stopRecordingVideo()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Focusing on touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = event!.allTouches()!.first {
            let position = touch.locationInView(self.view)
            self.cameraEngine.focus(position)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
