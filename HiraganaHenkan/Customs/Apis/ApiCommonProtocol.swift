//
//  ApiCommonProtocol.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/04/15.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import UIKit
import Alamofire

struct ApiCommonResult {
    let targetApiName: String
    let responseData: Data
    let errorMessage: String
}

protocol ApiCommonProtocol {
    
    //var apiName: String! { get }
    //var urlStr: String! { get }
    
    // ApiでJSON取得し、結果をApiCommonResultとしてcallbackする
    func accessToApi(_ apiName: String, urlStr: String, method: HTTPMethod, params: Parameters, callback: @escaping (ApiCommonResult) -> Void)
}

extension ApiCommonProtocol {
    
    func accessToApi(_ apiName: String, urlStr: String, method: HTTPMethod, params: Parameters, callback: @escaping (ApiCommonResult) -> Void) {
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
        
        Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: headers).responseJSON { response in
            print("通信要求 : ", response.request as Any)  // original URL request
            //print("通信応答 : ", response.response as Any) // HTTP URL response
            //print("通信データ : ", response.data as Any)     // server data
            //print("通信結果:", response.result as Any)   // result of response serialization
            
            var message: String = ""
            
            switch response.result {
            // 通信失敗時
            case .failure(let error):
                print("\(type(of: self)) 通信エラー:", error)
                message = "Error Code = \(error._code)\n\(error.localizedDescription)"
            // 通信成功時
            case .success(let responseObject):
                let statusCode = response.response?.statusCode
                print("statusCode:", statusCode as Any)
                print(responseObject)
                
                if statusCode != 200 {
                    message = "Status Code = \(String(describing: statusCode)) エラー\n\(responseObject)"
                }
            }
            callback(ApiCommonResult(targetApiName: apiName, responseData: response.data!, errorMessage: message))
        }
    }
}
