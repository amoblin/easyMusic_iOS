//
//  ViewController.swift
//  MusicBox
//
//  Created by amoblin on 16/5/8.
//  Copyright © 2016年 amoblin. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    var aUGraph:AUGraph = nil
    var samplerUnit:AudioUnit = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func prepareAUGraph() {
        let err:OSStatus
        
        let samplerNode:AUNode
        let remoteOutputNode:AUNode
        
        NewAUGraph(&aUGraph)
        AUGraphOpen(aUGraph)
        
        var cd:AudioComponentDescription
        cd.componentType = kAudioUnitType_Output;
        cd.componentSubType =  kAudioUnitSubType_RemoteIO;
        cd.componentManufacturer = kAudioUnitManufacturer_Apple;
        cd.componentFlags = 0
        cd.componentFlagsMask = 0;
        
        err = AUGraphAddNode(aUGraph, &cd, &remoteOutputNode);
        self.checkError(err)
        cd.componentType = kAudioUnitType_MusicDevice;
        cd.componentSubType = kAudioUnitSubType_Sampler;
        err = AUGraphAddNode(aUGraph, &cd, &samplerNode);
        self.checkError(err)
        err = AUGraphConnectNodeInput(aUGraph, samplerNode, 0, remoteOutputNode, 0);
        self.checkError(err)
        
        err = AUGraphInitialize(aUGraph);
        self.checkError(err)
        err = AUGraphStart(aUGraph);
        self.checkError(err)
        
        err = AUGraphNodeInfo(aUGraph,
                              samplerNode,
                              nil,
                              &samplerUnit);
        self.checkError(err)
    }
    
    func checkError(err:OSStatus) {
        if err == OSStatus(noErr) {
            print("err = %ld", err)
        }
    }

    func noteOn(noteNumber:NSNumber, _ velocityNumber:NSNumber) {
    let note = noteNumber.integerValue
    let velocity = velocityNumber.integerValue
    MusicDeviceMIDIEvent(samplerUnit,
                         0x90,
                         UInt32(note),
                         UInt32(velocity),
                         0);
}


    func loadSamplerPath(pathId:Int) {
    let resourceArray = ["GeneralUser GS SoftSynth v1.44",
                               "TimGM6mb",
                               "Drama Piano",
                               "Electric Grand HQ",
                               "Electric Piano 1",
                               "Electric Piano 2",
                               "Electric Piano 4",
                               "Electric Piano 5",
                               "Electric Piano 6",
                               "Electro Piano 3",
                               "FLStudioMania.txt",
                               "FM Piano",
                               "Fantasy Piano",
                               "Fazioli Grand Piano",
                               "Full Grand Piano",
                               "Giga Piano",
                               "Grand Piano",
                               "Kawai Grand Piano",
                               "Korg Triniton Piano",
                               "Motif ES6 Concert Piano",
                               "Piano Bass",
                               "Reverb Bell Piano",
                               "SC55 Piano V2",
                               "Stereo Piano",
                               "Tight Piano",
                               "U20 Electric Grand Piano",
                               "West Coast Piano"];

        let presetURL = NSBundle.mainBundle().URLForResource(resourceArray[4], withExtension:"sf2") as CFURL
    self.loadFromDLSOrSoundFont(presetURL, 0)
}


    func loadFromDLSOrSoundFont(soundBankURL:Unmanaged<CFURL>, _ presetNumber:Int) -> OSStatus {
        var result = noErr
        // fill out a bank preset data structure
        var bpdata = AUSamplerBankPresetData(bankURL: soundBankURL,
                                             bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                             bankLSB: UInt8(kAUSampler_DefaultBankLSB),
                                             presetID: UInt8(presetNumber),
                                             reserved: 0)
        //    guard bpdata.bankURL  = bankURL else {
        //        fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        //        }

        // set the kAUSamplerProperty_LoadPresetFromBank property
        result = AudioUnitSetProperty(samplerUnit,
                                      kAUSamplerProperty_LoadPresetFromBank,
                                      kAudioUnitScope_Global,
                                      0,
                                      &bpdata,
                                      UInt32(sizeof(bpdata)))
        // check for errors
        /*
        NSCAssert(result == noErr,
                  @"Unable to set the preset property on the Sampler. Error code:%d '%.4s'",
                   (int)result,
                   (const char *)&result);
 */
        return result
    }
}

