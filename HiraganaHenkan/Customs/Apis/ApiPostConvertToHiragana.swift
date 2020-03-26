//
//  ApiPostConvertToHiragana.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

protocol ApiPostConvertToHiraganaDelegate: AnyObject { // : AnyObjectを追加
    func didGetConvertedText(_ apiPostConvertToHiragana: ApiPostConvertToHiragana, text: String) -> Void
    func didFailToGetConvertedText(_ apiPostConvertToHiragana: ApiPostConvertToHiragana, errorMessage: String) -> Void
}

class ApiPostConvertToHiragana: NSObject, ApiCommonDelegate {
    
    //let classname = "ApiPostConvertToHiragana" // String(describing: type(of: self))に置き換え
    weak var delegate: ApiPostConvertToHiraganaDelegate? // weakを追加
    
    
    /* --- 送信 --- */
    
    var sentence: String = ""
    
    func sendApi() {
        // urlとパラメーター設定
        let params: Parameters = ["app_id":APP_ID,
                                  "sentence":sentence,
                                  "output_type":"hiragana"]
        // API送信
        let apiCommon = ApiCommon()
        apiCommon.delegate = self
        apiCommon.accessToApi(apiName: String(describing: type(of: self)),
                              urlStr: REQUEST_URL_STR,
                              method: .post,
                              params: params)
    }
    
    
    /* --- 受信 --- */
    
    
    struct Result: Codable {
        let request_id: String
        let output_type: String
        let converted: String
    }
    
    func didFinishJsonSuccess(_ apiCommon: ApiCommon, apiName: String, receivedData: Data) {
        print("apiName:", apiName, receivedData)
        if apiName != String(describing: type(of: self)) { return }
        
        var requestId: String = ""
        var outputType: String = ""
        var convertedText: String = ""
        
        do {
            let json: Result = try JSONDecoder().decode(Result.self, from: receivedData)
            requestId = json.request_id
            outputType = json.output_type
            convertedText = json.converted
            print(requestId, outputType, convertedText)
        } catch let error as NSError {
            // error
            let errorMessage: String = "Error Code = \(error._code)\n\(error.localizedDescription)"
            self.delegate?.didFailToGetConvertedText(self, errorMessage: errorMessage)
        }
        
        /* SwiftyJSON使用時はこちら
        let requestId: String = receivedData["request_id"].stringValue
        let outputType: String = receivedData["output_type"].stringValue
        let convertedText: String = receivedData["converted"].stringValue
        print(requestId)
        print(outputType)
        print(convertedText)*/
        
        self.delegate?.didGetConvertedText(self, text: convertedText)
        print("\(type(of: self)) 正常終了")
    }
    
    func didFinishJsonWithError(_ apiCommon: ApiCommon, apiName: String, errorMessage: String) {
        print("apiName:", apiName, errorMessage)
        self.delegate?.didFailToGetConvertedText(self, errorMessage: errorMessage)
    }
}
