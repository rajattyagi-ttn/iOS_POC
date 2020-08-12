//
//  ViewController.swift
//  GraphsDemo
//
//  Created by Rajat Tyagi on 06/08/20.
//  Copyright © 2020 Rajat Tyagi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func drawShape(_ sender: Any) {
        drawView.drawShape(selectedShape: .rectangle, color: UIColor.red)
    }
    
    @IBAction func drawCircle(_ sender: Any) {
        drawView.drawShape(selectedShape: .circle, color: UIColor.blue)
    }
}

