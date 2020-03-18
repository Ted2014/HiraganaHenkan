//
//  ViewController.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, ApiPostConvertToHiraganaDelegate {
    
    var apiPostConvertToHiragana: ApiPostConvertToHiragana = ApiPostConvertToHiragana()

    @IBOutlet weak var originalTV: UITextView!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var tapHereLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTV.delegate = self
        originalTV.font = FONT_SYSTEM_24
        convertBtn.titleLabel?.font = FONT_SYSTEM_24
    }
    
    override func viewDidLayoutSubviews() {
        convertBtn.layer.cornerRadius = 10.0
        convertBtn.layer.borderColor = UIColor.lightGray.cgColor
        convertBtn.layer.borderWidth = 2.0
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func didTapConvertBtn(_ sender: Any) {
        if originalTV.text.count == 0 {
            showErrorAlert(title: "入力エラー", message: "文字入力がありません。")
            return
        }
        apiPostConvertToHiragana.delegate = self
        apiPostConvertToHiragana.sentence = originalTV.text
        apiPostConvertToHiragana.sendApi()
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tapHereLbl.isHidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    // MARK: - ApiPostConvertToHiraganaDelegate
    
    func didGetConvertedText(text: String) {
        performSegue(withIdentifier: "ToNextVC", sender: text)
    }
    
    func didFailToGetConvertedText(errorMessage: String) {
        showErrorAlert(title: "通信エラー", message: errorMessage)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToNextVC") {
            let vc: NextViewController = (segue.destination as? NextViewController)!
            let convertedText: String = sender as! String
            vc.sentText = convertedText
        }
    }
    
    
    // MARK: - Alert
    
    func showErrorAlert(title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

