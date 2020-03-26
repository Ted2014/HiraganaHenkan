//
//  CustomNavigationController.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*//　ナビゲーションバーの共通の設定
        navigationBar.barTintColor = UIColor(red: 236.0/255.0, green: 6.0/255.0, blue: 6.0/255.0, alpha: 1.0) // バーの色
        navigationBar.tintColor = UIColor.white // バー上のアイテムの色
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white, // 文字の色
            .font: UIFont.boldSystemFont(ofSize: 24.0 * SCREEN_SCALE) // フォントサイズ
        ]*/
    }
    
    override func viewDidLayoutSubviews() {
        // ダークモード対応（ダイナミックカラーを直接利用できないケースがあるためここで設定する）
        if traitCollection.userInterfaceStyle == .dark {
            //　ナビゲーションバーの共通の設定
            navigationBar.barTintColor = .lightGray // バーの色
            navigationBar.tintColor = UIColor.white // バー上のアイテムの色
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white, // 文字の色
                .font: UIFont.boldSystemFont(ofSize: 24.0 * SCREEN_SCALE) // フォントサイズ
            ]
        } else {
            //　ナビゲーションバーの共通の設定
            navigationBar.barTintColor = UIColor(red: 236.0/255.0, green: 6.0/255.0, blue: 6.0/255.0, alpha: 1.0) // バーの色
            navigationBar.tintColor = UIColor.white // バー上のアイテムの色
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white, // 文字の色
                .font: UIFont.boldSystemFont(ofSize: 24.0 * SCREEN_SCALE) // フォントサイズ
            ]
        }
    }
}


