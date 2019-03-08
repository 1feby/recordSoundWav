//
//  ViewController.swift
//  recordSoundWav
//
//  Created by phoebe on 3/8/19.
//  Copyright © 2019 phoebe. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController ,AVAudioPlayerDelegate,AVAudioRecorderDelegate{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var soundrecorder : AVAudioRecorder!
    var soundplayer : AVAudioPlayer!
    var audioFile :String = "audioFile.m4a"
    var wavAudioFile : String = "wavAudioFile.wav"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRecorder()
        playButton.isEnabled = false
    }
    func getDocumentDirector() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return path[0]
    }
    func setupRecorder(){
        let recordedFileName = getDocumentDirector().appendingPathComponent(audioFile)
        let   recordedWavFile = getDocumentDirector().appendingPathComponent(wavAudioFile)
        try! FileManager.default.removeItem(at: recordedFileName)
        let recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless,AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,AVSampleRateKey:16000,
        AVEncoderBitRateKey:16000,AVNumberOfChannelsKey:1] as [String : Any]
        do{
            let recordedFileName = getDocumentDirector().appendingPathComponent(audioFile)
                        soundrecorder = try AVAudioRecorder(url: recordedFileName, settings: recordSetting)
            soundrecorder.delegate=self
            soundrecorder.prepareToRecord()
        }catch{
            print(error)
        }
    }
    func setupPlayer(){
        let recordedFileName = getDocumentDirector().appendingPathComponent(audioFile)
        do{
            soundplayer = try AVAudioPlayer(contentsOf: recordedFileName)
            soundplayer.delegate = self
            soundplayer.prepareToPlay()
            soundplayer.volume = 1.0
        }catch{
            print(error)
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let recordedFileName = getDocumentDirector().appendingPathComponent(audioFile)
        let   recordedWavFile = getDocumentDirector().appendingPathComponent(wavAudioFile)
        try! FileManager.default.removeItem(at: recordedWavFile)
       try! FileManager.default.copyItem(at: recordedFileName, to: recordedWavFile);
        print(recordedWavFile)
        playButton.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("play", for: .normal)
    }
    @IBAction func recordAct(_ sender: Any) {
        if recordButton.titleLabel?.text == "Record" {
                soundrecorder.record()
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
            
                  }else{
            soundrecorder.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = false
        }
    }
    
    @IBAction func playAct(_ sender: Any) {
        if playButton.titleLabel?.text == "play" {
            playButton.setTitle("Stop", for: .normal)
            recordButton.isEnabled = false
            setupPlayer()
            soundplayer.play()
        }else{
            soundplayer.stop()
            playButton.setTitle("play", for: .normal)
            recordButton.isEnabled = false
        }
    }
}

