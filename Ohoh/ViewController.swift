//
//  ViewController.swift
//  Ohoh
//
//  Created by Gnanavelu, Mohanavelu on 7/21/15.
//  Copyright (c) 2015 Gnanavelu, Mohanavelu. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate  {

    @IBOutlet weak var button: UIButton!
    
    var isPlaying: Bool!
    var timer: NSTimer!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!
    
    let fileName = "demo.caf"
    
    func setupRecorder() {
        var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioSession.setActive(true, error: nil)
        
        //set the settings for recorder
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        var error: NSError?
        soundRecorder = AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [NSObject : AnyObject], error: &error)
        
        if let err = error {
            NSLog("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }
    }
    
    // MARK:- Prepare AVPlayer
    
    func preparePlayer() {
        var error: NSError?
        soundPlayer = AVAudioPlayer(contentsOfURL: getFileURL(), error: &error)
        if let err = error {
            NSLog("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }
    
    // MARK:- File URL
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory,.UserDomainMask, true) as! [String]
        return paths[0]
    }
    
    func getFileURL() -> NSURL {
        let path =  getCacheDirectory().stringByAppendingPathComponent(fileName)
        let filePath = NSURL(fileURLWithPath: path)
        return filePath!
    }
    
    // MARK:- AVAudioPlayer delegate methods
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        NSLog("Error while playing audio \(error.localizedDescription)")
    }
    
    // MARK:- AVAudioRecorder delegate methods
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        NSLog("Error while recording audio \(error.localizedDescription)")
    }
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        isPlaying = false
        
        let stopImage = UIImage(named:  "record-button")
        let scaledImage = UIImage(CGImage: stopImage?.CGImage, scale: 2, orientation: (stopImage?.imageOrientation)! )
        button.setImage(scaledImage, forState: UIControlState.Normal)
        setupRecorder()
    }

    @IBAction func OnTouch(sender: UIButton) {
        if(isPlaying == false){
            button.sizeToFit();
            let stopImage = UIImage(named:  "stop-button")
            // grab the original image
            let scaledImage = UIImage(CGImage: stopImage?.CGImage, scale: 8, orientation: (stopImage?.imageOrientation)! )
            button.setImage(scaledImage, forState: UIControlState.Normal)
            startTimer();
            isPlaying = true
        }else {
            stopTimer()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func startTimer(){
        if(timer == nil){
            timer = NSTimer(timeInterval: 5.0, target: self, selector: "stopTimer", userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            soundRecorder.record()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        soundRecorder.stop()
        timer = nil
        let stopImage = UIImage(named:  "record-button")
        let scaledImage = UIImage(CGImage: stopImage?.CGImage, scale: 2, orientation: (stopImage?.imageOrientation)! )
        button.setImage(scaledImage, forState: UIControlState.Normal)
        isPlaying = false;
        preparePlayer()
        soundPlayer.play()
    }
}

