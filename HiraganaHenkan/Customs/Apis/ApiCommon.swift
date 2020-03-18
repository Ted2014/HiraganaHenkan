//
//  ApiCommon.swift
//  HiraganaHenkan
//
//  Created by Shigetomi Tetsu on 2020/03/16.
//  Copyright © 2020 Shigetomi Tetsu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ApiCommonDelegate {
    func didFinishJsonSuccess(apiName: String, receivedData: JSON) -> Void
    func didFinishJsonWithError(apiName: String, errorMessage: String) -> Void
}

class ApiCommon: NSObject {
    
    let classname = "ApiCommon"
    var delegate: ApiCommonDelegate?
    
    
    // MARK: - Access to API
    
    // ApiでJSON取得
    func accessToApi(apiName: String, urlStr: String, method: HTTPMethod, params: Parameters) {
        print("\(classname) 開始", apiName)
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
                print("\(self.classname) 通信エラー:", error)
                
                let message: String = "Error Code = \(error._code)\n\(error.localizedDescription)"
                self.delegate?.didFinishJsonWithError(apiName: apiName, errorMessage: message)
                
            // 通信成功時
            case .success(let responseObject):
                let statusCode = response.response?.statusCode
                print("statusCode:", statusCode as Any)
                print(responseObject)
                
                if statusCode != 200 {
                    let message: String = "Status Code = \(String(describing: statusCode)) エラー\n\(responseObject)"
                    self.delegate?.didFinishJsonWithError(apiName: apiName, errorMessage: message)
                    return
                }
                
                do {
                    let json = try JSON(data: response.data!)
                    //print("JSON=",json)
                    self.delegate?.didFinishJsonSuccess(apiName: apiName, receivedData: json)
                    print("\(apiName) 正常終了")
                } catch let error as NSError {
                    // error
                    let message: String = "Error Code = \(error._code)\n\(error.localizedDescription)"
                    self.delegate?.didFinishJsonWithError(apiName: apiName, errorMessage: message)
                    print("\(self.classname) エラー終了:", error)
                }
            }
        }
    }
}
