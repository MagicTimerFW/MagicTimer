//
//  ViewController.swift
//  MagicTimer
//
//  Created by sadeghgoo on 06/02/2020.
//  Copyright (c) 2020 sadeghgoo. All rights reserved.
//

import UIKit
import MagicTimer

class ViewController: UIViewController {

    @IBOutlet weak var timer: MagicTimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer.isActiveInBackground = false
        timer.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        timer.mode = .stopWatch
        timer.delegate = self
    }
    
    @IBAction func start(_ sender: Any) {
        timer.startCounting()
    }
    
    @IBAction func stop(_ sender: Any) {
        timer.stopCounting()
    }
    
    @IBAction func reset(_ sender: Any) {
        timer.reset()
    }
    
    @IBAction func resetDefault(_ sender: Any) {
        timer.resetToDefault()
    }
    
}

extension ViewController: MagicTimerViewDelegate {
    
    func timerElapsedTimeDidChange(timer: MagicTimerView, elapsedTime: TimeInterval) {
        //print(elapsedTime)
    }
}

