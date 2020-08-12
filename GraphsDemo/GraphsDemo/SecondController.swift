//
//  SecondController.swift
//  GraphsDemo
//
//  Created by Rajat Tyagi on 11/08/20.
//  Copyright © 2020 Rajat Tyagi. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
    
    var drawView = DrawView()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.backgroundColor = .white
        view.addSubview(drawView)
        drawView.translatesAutoresizingMaskIntoConstraints = false
        drawView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        drawView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        drawView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
//        drawView.drawShape(selectedShape: .rectangle, color: UIColor.red)
//        drawView.drawShape(selectedShape: .filledCircle, color: .red)
        
        drawView.drawGraph(selectedGraph: .bar, graphCoordinates: [2,4,60,30,14,45,25])
        
    }
    

   

}
