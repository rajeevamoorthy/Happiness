//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Rajiv on 12/10/17.
//  Copyright © 2017 Pedscapades. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
        }
    }
    
    var happiness: Int = 75 { // 0 is sad, 100 is happy
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("Happiness = \(happiness)")
            updateUI()
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50) / 50
    }
    
    func updateUI() {
        faceView.setNeedsDisplay()
    }
    

}

