//
//  ViewController.swift
//  MusicBox
//
//  Created by amoblin on 16/5/8.
//  Copyright © 2016年 amoblin. All rights reserved.
//

import UIKit
import DDTile

class ViewController: DDBaseCollectionViewController {
    let sfPlayer = SFPlayer()
    let timer = NSTimer(

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var dataArray = [DDTitleData]()
        for (index,fontName) in sfPlayer.soundFontArray.enumerate() {
            let data = DDTitleData(title: fontName as! String, { (data) in
                self.sfPlayer.loadSamplerAtIndex(data.sequence)
                self.sfPlayer.noteOn(83, velocity: 170)
            })
            data.sequence = index
            dataArray.append(data)
        }
        self.dataArray = dataArray
        sfPlayer.noteOn(83, velocity: 170)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

