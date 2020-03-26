//
//  HiraganaHenkanTest.swift
//  HiraganaHenkanTest
//
//  Created by Shigetomi Tetsu on 2020/03/23.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import XCTest

@testable import ひらがな変換 //HiraganaHenkan -> アプリ名称を指定しないとエラーになる

class HiraganaHenkanTest: XCTestCase, ApiPostConvertToHiraganaDelegate {
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    var callApiExpectation: XCTestExpectation? = nil
    
    func test正しくひらがな変換が行われているかの検証() {
        // 非同期処理の完了を監視するオブジェクトを作成
        // 別メソッドになるためメンバ変数を用意
        self.callApiExpectation = self.expectation(description: "正しくひらがな変換が行われているかの検証")
        
        let api: ApiPostConvertToHiragana = ApiPostConvertToHiragana()
        api.sentence = "今日は良いお天気です"
        api.delegate = self
        api.sendApi()
        
        // 指定秒数待つ
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func didGetConvertedText(_ apiPostConvertToHiragana: ApiPostConvertToHiragana, text: String) {
        // 非同期処理の監視を終了
        self.callApiExpectation?.fulfill()
        // 結果を確認
        XCTAssertEqual("きょうは よい おてんきです", text)
    }
    
    func didFailToGetConvertedText(_ apiPostConvertToHiragana: ApiPostConvertToHiragana, errorMessage: String) {
        
    }
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
