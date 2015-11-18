//
//  SecondViewController.swift
//  earthquakrgenie
//
//  Created by Ryan Schachte on 11/16/15.
//  Copyright (c) 2015 uberchanger. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var labe_passedAddress: UILabel!
    
    @IBOutlet weak var output_text: UITextView!
    var receivedAddress: String = ""
    var northString: String = ""
    var eastString: String = ""
    var southString: String = ""
    var westString: String = ""
    
    var receivedJsonInformation : String = ""
    
    @IBOutlet weak var northText: UITextField!
    @IBOutlet weak var eastText: UITextField!
    @IBOutlet weak var southText: UITextField!
    @IBOutlet weak var westText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(self.receivedJsonInformation)

        output_text.text = receivedJsonInformation

        
        labe_passedAddress.text = "Address: " + receivedAddress
        northText.text = northString
        eastText.text = eastString
        southText.text = southString
        westText.text = westString
    }




}
