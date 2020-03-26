//
//  KanjiNyuryokuViewController.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit

class KanjiNyuryokuViewController: UIViewController, UITextViewDelegate, ApiPostConvertToHiraganaDelegate {
    
    let apiPostConvertToHiragana: ApiPostConvertToHiragana = ApiPostConvertToHiragana() // var -> let に変更

    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var tapHereLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var memoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTextView.delegate = self
        originalTextView.font = FONT_SYSTEM_24
        convertButton.titleLabel?.font = FONT_SYSTEM_24
        
        //convertButton.layer.borderColor = UIColor.lightGray.cgColor
        convertButton.layer.borderWidth = 2.0
        convertButton.layer.cornerRadius = 10.0
    }
    
    override func viewDidLayoutSubviews() {
        // ダークモード対応（ダイナミックカラーを直接利用できないケースがあるためここで設定する）
        if traitCollection.userInterfaceStyle == .dark {
            convertButton.layer.borderColor = UIColor.white.cgColor
            self.view.backgroundColor = .black
            bgImageView.isHidden = true
            memoImageView.alpha = 0.5
        } else {
            convertButton.layer.borderColor = UIColor.red.cgColor
            self.view.backgroundColor = .white
            bgImageView.isHidden = false
            memoImageView.alpha = 1.0
        }
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func didTapConvertButton(_ sender: Any) { // 名称変更
        if originalTextView.text.isEmpty { // count == 0 -> isEmpty に変更
            showErrorAlert(title: "入力エラー", message: "文字入力がありません。")
            return
        }
        apiPostConvertToHiragana.delegate = self
        apiPostConvertToHiragana.sentence = originalTextView.text
        apiPostConvertToHiragana.sendApi()
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tapHereLabel.isHidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    // MARK: - ApiPostConvertToHiraganaDelegate
    
    func didGetConvertedText(_ apiPostConvertToHiragana: ApiPostConvertToHiragana, text: String) {
        performSegue(withIdentifier: "ToNextVC", sender: text)
    }
    
    func didFailToGetConvertedText(_ apiPostConvertToHiragana: ApiPostConvertToHiragana, errorMessage: String) {
        showErrorAlert(title: "通信エラー", message: errorMessage)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToNextVC") {
            let vc: HiraganaHenkanViewController = (segue.destination as? HiraganaHenkanViewController)!
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

