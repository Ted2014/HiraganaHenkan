//
//  NextViewController.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    @IBOutlet weak var convertedTextView: UITextView!
    
    var sentText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        convertedTextView.text = sentText
        convertedTextView.font = FONT_SYSTEM_24
    }

}
