//
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import Alamofire

@objc public protocol webseviceDelegate {
    func webserviceResponseMethod(jsonData:NSDictionary)
}

class ApiCall: NSObject {
    var delegate : webseviceDelegate?
    class func getServercall(onView:UIViewController,isBody:Bool, urlString:String,completionBlock:@escaping (_ response:NSDictionary)->Void){
        if Connectivity.isConnectedToInternet {
            let headers = [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "sitename":"IOS",
                "AccessPassword":""
            ]
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500).responseJSON { response in
                MBProgressHUD.hide(for: onView.view, animated: true)
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
                        completionBlock(JSON)
                    }
                case .failure(let error):
                    print("RESPONSE ERROR: \(error)")
                }
            }
        }else {
            MBProgressHUD.hide(for: onView.view, animated: true)
            let alert = UIAlertController(title: "Network Connection", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            onView.present(alert, animated: true, completion: nil)
        }
    }
    class func getServerCallUserExist(onView:UIViewController,isBody:Bool, urlString:String,completionBlock:@escaping (_ response:String)->Void){
        if Connectivity.isConnectedToInternet {
            let headers = [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "sitename":"IOS",
                "AccessPassword":""
            ]
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500).responseJSON { response in
                MBProgressHUD.hide(for: onView.view, animated: true)
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        completionBlock(result as! String)
                    }
                case .failure(let error):
                    print("RESPONSE ERROR: \(error)")
                }
            }
        }else {
            MBProgressHUD.hide(for: onView.view, animated: true)
            let alert = UIAlertController(title: "Network Connection", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            onView.present(alert, animated: true, completion: nil)
        }
    }
    static func sendRequest(onView:UIViewController,isBody:Bool, urlString:String,urlParams:[String : AnyObject],completionBlock:@escaping (_ response:ResponseModel)->Void){
        if Connectivity.isConnectedToInternet {
            let headers = [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "sitename":"IOS",
                "AccessPassword":""
            ]
            Alamofire.request(urlString, method: .post,parameters: urlParams, encoding: JSONEncoding.default,headers: headers).validate(statusCode: 200..<500).responseJSON { response in
                MBProgressHUD.hide(for: onView.view, animated: true)
                //Code here.
                print("req ",response.response?.statusCode as Any)
                
                if (response.result.error == nil){
                    let responseModel = ResponseModel()
                    responseModel.responseCode = response.response?.statusCode
                    switch response.result {
                    case .success(let data):
                        if ((data as AnyObject) is NSDictionary){
                            responseModel.responseDictionary = data as! NSDictionary
                        }else if ((data as AnyObject) is NSArray){
                            responseModel.customModel = data as! NSArray
                        }else if ((data as AnyObject) is NSString){
                            responseModel.customModel = data as! NSString as String
                        }else if ((data as AnyObject) is NSInteger){
                            responseModel.customModel = data as! NSInteger
                        }
                        print("Url String with Response : \(urlString) \n Response : \(data)")
                        responseModel.isSuccess = true
                        break
                    case .failure(let error):
                        responseModel.isSuccess = false
                        print("Request failed with error: \(error)")
                        break
                    }
                    completionBlock(responseModel)
                }else{
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    let responseModel = ResponseModel()
                    responseModel.responseCode = response.response?.statusCode
                    responseModel.isSuccess = false
                    completionBlock(responseModel)
                }
            }
        }else {
            MBProgressHUD.hide(for: onView.view, animated: true)
            let alert = UIAlertController(title: "Network Connection", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            onView.present(alert, animated: true, completion: nil)
        }
    }
    class func postServercall(onView:UIViewController, url : String, httpMethod : HTTPMethod, loading: Any, completion:@escaping (_ response:ResponseModel)->Void) {
        
        if Connectivity.isConnectedToInternet {
            let headers = [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "sitename":"IOS",
                "AccessPassword":""
            ]
            Alamofire.request(url, method: httpMethod, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500).responseJSON { response in
                MBProgressHUD.hide(for: onView.view, animated: true)
                if (response.result.error == nil){
                    let responseModel = ResponseModel()
                    responseModel.responseCode = response.response?.statusCode
                    switch response.result {
                    case .success(let data):
                        if ((data as AnyObject) is NSDictionary){
                            responseModel.responseDictionary = data as! NSDictionary
                        }else if ((data as AnyObject) is NSArray){
                            responseModel.customModel = data as! NSArray
                        }else if ((data as AnyObject) is NSString){
                            responseModel.customModel = data as! NSString as String
                        }else if ((data as AnyObject) is Int){
                            responseModel.customModel = data as! Int as Int
                        }
                        print("Url String with Response : \(url) \n Response : \(data)")
                        responseModel.isSuccess = true
                        break
                    case .failure(let error):
                        responseModel.isSuccess = false
                        print("Request failed with error: \(error)")
                        break
                    }
                    completion(responseModel)
                }else{
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    let responseModel = ResponseModel()
                    responseModel.responseCode = response.response?.statusCode
                    responseModel.isSuccess = false
                    completion(responseModel)
                }
            }
        }else {
            MBProgressHUD.hide(for: onView.view, animated: true)
            let alert = UIAlertController(title: "Network Connection", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            onView.present(alert, animated: true, completion: nil)
        }
    }
    class func postCall(url : String, httpMethod : HTTPMethod, loading: Any, completion:@escaping (_ success: String?,_ failure : String?)->()) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "sitename":"IOS",
            "AccessPassword":""
        ]
        
        Alamofire.upload(multipartFormData: { MultipartFormData  in
            
        }, usingThreshold: UInt64.init(), to: url, method: httpMethod, headers: headers) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseString { response in
                    
                    guard let resStr = response.result.value else {
                        completion(nil, "Something went wrong")
                        return
                    }
                    
                    
                    let userDetails = BaseModel(JSONString: resStr)
                  let  resultStr = response.result
                    
                    if let error = userDetails?.Error {
                        completion(nil,error)
                    }else {
                        completion(resStr,nil)
                    }
                }
                
            case .failure(let encodingError):
                completion(nil,encodingError.localizedDescription)
            }
        }
    }
    
    static func uploadImageRequest(onView:UIViewController,image:UIImage,filenameStr:String,urlString:String,parameters:[String : AnyObject],completionBlock:@escaping (_ response:ResponseModel)->Void){
        if Connectivity.isConnectedToInternet {
            //print(urlString)
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "file", fileName: filenameStr, mimeType: "image/jpeg")
                }
                // print(multipartFormData)
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }}, to: urlString, method: .post, headers: ["Content-Type": "multipart/form-data",                "AccessPassword":""
                ],
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                if (response.result.error == nil) {
                                    let responseModel = ResponseModel()
                                    responseModel.responseCode = response.response?.statusCode
                                    // print(response.response?.statusCode)
                                    switch response.result {
                                    case .success(let data):
                                        if ((data as AnyObject) is NSDictionary){
                                            responseModel.responseDictionary = data as! NSDictionary
                                        }
                                        responseModel.isSuccess = true
                                        break
                                    case .failure(let error):
                                        responseModel.isSuccess = false
                                        print("Request failed with error: \(error)")
                                        break
                                    }
                                    completionBlock(responseModel)
                                }else {
                                    //debugPrint("HTTP Request failed: \(response.result.error)")
                                    let responseModel = ResponseModel()
                                    responseModel.responseCode = response.response?.statusCode
                                    responseModel.isSuccess = false
                                    completionBlock(responseModel)
                                }
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                            
                        }
            })
            
        }else{
            MBProgressHUD.hide(for: onView.view, animated: true)
            let alert = UIAlertController(title: "Network Connection", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            onView.present(alert, animated: true, completion: nil)
        }
    }
    
}
