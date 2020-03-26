//
//  HiraganaHenkanViewController.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit

class HiraganaHenkanViewController: UIViewController {
    
    @IBOutlet weak var convertedTextView: UITextView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var memoImageView: UIImageView!
    
    var sentText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        convertedTextView.text = sentText
        convertedTextView.font = FONT_SYSTEM_24
    }
    
    override func viewDidLayoutSubviews() {
        // ダークモード対応（ダイナミックカラーを直接利用できないケースがあるためここで設定する）
        if traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .black
            bgImageView.isHidden = true
            memoImageView.alpha = 0.5
        } else {
            self.view.backgroundColor = .white
            bgImageView.isHidden = false
            memoImageView.alpha = 1.0
        }
    }
}
