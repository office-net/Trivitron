//
//  NetworkManager.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 31/08/22.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class Networkmanager
{
    class func postRequest(vv:UIView,remainingUrl:String, parameters: [String:Any], completion: @escaping ((_ data: JSON, _ responseData:Foundation.Data) -> Void)) {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: vv)
        
        
        print("parameters posted : ",parameters)
        let completeUrl = base.url + remainingUrl
        print ("complete url : ", completeUrl)
        
        AF.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                
                guard let data = response.data else { return }
                
                switch response.result
                {
                case .success(let value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: vv)
                    
                    let swiftyJsonVar = JSON(value)
                    //print(swiftyJsonVar)
                    completion(swiftyJsonVar, data)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
                
            }
    }
    
    
    
    
    
    
    
    class func postImageData(vv:UIView,parameters: [String:Any], img :UIImage, imgKey:String, imgName:String, completion: @escaping ((_ data: JSON,_ responseData:Foundation.Data) -> Void)){
        
        print("image Posted")
        print("Parameters Posted in image : ",parameters)
        let completeUrl = "https://trivitron.officenet.in/MobileAPI/SaveLeadDetail.ashx"
        print("imgKey :",imgKey," imgName :",imgName)
        
        let imgData = img.jpegData(compressionQuality: 0.5)!
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: vv)
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData, withName: imgKey, fileName: imgName, mimeType: "image/jpeg")
            
            
            
            for (key, value) in parameters {
                if key == "AddDetail" {

                   let arrData =  try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    multipartFormData.append(arrData, withName: key as String)
                }
                else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
        },
        to:completeUrl).responseDecodable(of: JSON.self) { response in
            debugPrint(response)
            guard let data = response.data else { return }
            switch response.result
            {
                
            case .success(let value):
                let swiftyJsonVar = JSON(value)
              //  print(swiftyJsonVar)
                completion(swiftyJsonVar, data)
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: vv)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    
    
    
    
    
    
    class func postAndGetData(vv:UIView,parameters: [String:Any], img :[UIImage], imgKey:String, imgName:String, completion: @escaping ((_ data: JSON,_ responseData:Foundation.Data) -> Void)){
        
        print("image Posted")
        print("Parameters Posted in image : ",parameters)
        let completeUrl = "https://trivitron.officenet.in/MobileAPI/LeadUploadDocument.ashx"
        print("imgKey :",imgKey," imgName :",imgName)
        
      //  let imgData = img.jpegData(compressionQuality: 0.5)
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: vv)
        
        AF.upload(multipartFormData: { multipartFormData in
          for data in img
            {
             
              let imageData =  data.jpegData(compressionQuality: 0.5)
             
              multipartFormData.append(imageData!, withName: "Attachments", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
              
              
          }
            
            for (key, value) in parameters {
                if key == "AddDetail" {

                   let arrData =  try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    multipartFormData.append(arrData, withName: key as String)
                }
                else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
        },
        to:completeUrl).responseDecodable(of: JSON.self) { response in
           // debugPrint(response)
            guard let data = response.data else { return }
            switch response.result
            {
            
            case .success(let value):
                let swiftyJsonVar = JSON(value)
             
                
                completion(swiftyJsonVar, data)
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: vv)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
}
    
    






class Networkmanager2
{
    class func postRequest(remainingUrl:String, parameters: [String:Any], completion: @escaping ((_ data: JSON, _ responseData:Foundation.Data) -> Void)) {
       
  
        
        print("parameters posted : ",parameters)
        let completeUrl = base.url + remainingUrl
        print ("complete url : ", completeUrl)
     
        AF.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                
                guard let data = response.data else { return }
                switch response.result
                {
                case .success(let value):
                   
                  
                    let swiftyJsonVar = JSON(value)
                    //print(swiftyJsonVar)
                    completion(swiftyJsonVar, data)
                 
                case.failure(let error):
                    print(error.localizedDescription)
                }
           
        }
    }
      
}
