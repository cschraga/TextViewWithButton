//
//  ViewController.swift
//  TextViewMitButton
//
//  Created by Christian Schraga on 11/3/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TextViewWithButtonDelegate {

    @IBOutlet weak var textViewWithButton: TextViewWithButton!
    @IBOutlet weak var idealHeightLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var changingSizeFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewWithButton.lineWidth = 2.0
        textViewWithButton.lineColor = UIColor.green
        textViewWithButton.bgColor   = UIColor(white: 0.75, alpha: 0.25)
        textViewWithButton.delegate  = self
        heightConstraint.constant = textViewWithButton.idealHeight
        
    }

    func textViewButtonClicked(_ view: TextViewWithButton) {
        statusLabel.text = "Status: Clicked"
    }
    
    func textViewWithButtonNewHeight(_ view: TextViewWithButton, preferredHeight height: CGFloat) {
        idealHeightLabel.text = "Ideal Height: \(textViewWithButton.idealHeight)"
        let h = textViewWithButton.idealHeight
        if heightConstraint.constant != h {
            heightConstraint.constant = h
            changingSizeFlag = true
        }
    }
    
    func textViewWithButtonEditing(_ view: TextViewWithButton, editing: Bool) {
        statusLabel.text = editing ? "Status: Editing" : "Status: Not Editing"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

