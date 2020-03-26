//
//  ApiCommon.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

protocol ApiCommonDelegate: AnyObject { // : weak対応のためAnyObjectを追加
    func didFinishJsonSuccess(_ apiCommon: ApiCommon, apiName: String, receivedData: Data) -> Void // _ apiCommon: ApiCommon,を追加
    func didFinishJsonWithError(_ apiCommon: ApiCommon, apiName: String, errorMessage: String) -> Void // _ apiCommon: ApiCommon,を追加
}

class ApiCommon: NSObject {
    
    //let classname = "ApiCommon" // type(of: self)に置き換え
    weak var delegate: ApiCommonDelegate? // weakを追加
    
    
    // MARK: - Access to API
    
    // ApiでJSON取得
    func accessToApi(apiName: String, urlStr: String, method: HTTPMethod, params: Parameters) {
        print("\(type(of: self)) 開始", apiName)
        print("param:", params)
        
        // Api通信
        let url = URL(string: urlStr)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        var encoding: ParameterEncoding!
        if method == .get {
            encoding = URLEncoding.default
        } else {
            encoding = JSONEncoding.default
        }
        
        Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { response in
            print("通信要求 : ", response.request as Any)  // original URL request
            //print("通信応答 : ", response.response as Any) // HTTP URL response
            //print("通信データ : ", response.data as Any)     // server data
            //print("通信結果:", response.result as Any)   // result of response serialization
            
            switch response.result {
            // 通信失敗時
            case .failure(let error):
                print("\(type(of: self)) 通信エラー:", error)
                
                let message: String = "Error Code = \(error._code)\n\(error.localizedDescription)"
                self.delegate?.didFinishJsonWithError(self, apiName: apiName, errorMessage: message)
            // 通信成功時
            case .success(let responseObject):
                let statusCode = response.response?.statusCode
                print("statusCode:", statusCode as Any)
                print(responseObject)
                
                if statusCode != 200 {
                    let message: String = "Status Code = \(String(describing: statusCode)) エラー\n\(responseObject)"
                    self.delegate?.didFinishJsonWithError(self, apiName: apiName, errorMessage: message)
                    return
                }
                
                // Codable使用時はこれ
                self.delegate?.didFinishJsonSuccess(self, apiName: apiName, receivedData: response.data!)
                
                /* SwiftyJSON使用時はこちら
                do {
                    let json = try JSON(data: response.data!)
                    //print("JSON=",json)
                    self.delegate?.didFinishJsonSuccess(self, apiName: apiName, receivedData: json)
                    print("\(apiName) 正常終了")
                } catch let error as NSError {
                    // error
                    let message: String = "Error Code = \(error._code)\n\(error.localizedDescription)"
                    self.delegate?.didFinishJsonWithError(self, apiName: apiName, errorMessage: message)
                    print("\(type(of: self)) エラー終了:", error)
                }*/
            }
        }
    }
}
