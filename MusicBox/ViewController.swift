//
//  ViewController.swift
//  MusicBox
//
//  Created by amoblin on 16/5/8.
//  Copyright © 2016年 amoblin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let sfPlayer = SFPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sfPlayer.noteOn(83, velocity: 170)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

