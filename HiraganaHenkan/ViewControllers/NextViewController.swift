//
//  NextViewController.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    @IBOutlet weak var convertedTV: UITextView!
    
    var sentText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        convertedTV.text = sentText
        convertedTV.font = FONT_SYSTEM_24
    }

}
