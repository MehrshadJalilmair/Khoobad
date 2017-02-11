//
//  dataDownloaderServiceTask.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/17/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class dataDownloaderServiceTask: NSObject {

    lazy var configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session : NSURLSession = NSURLSession(configuration: self.configuration)
    
    var url : NSURL
    
    init(url: NSURL)
    {
        self.url = url
    }
    
    func Download(completion:(NSData->Void))
    {
        let request = NSURLRequest(URL: url)
        let dataTask = session.dataTaskWithRequest(request){(data , response , error) in
            
            if error == nil
            {
                if let httpResponse = response as? NSHTTPURLResponse{
                    
                    switch(httpResponse.statusCode)
                    {
                        
                    case 200:
                        
                        if let data = data{
                            
                            completion(data)
                        }
                        
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func isLiked(comment_id:Int , completion:(NSData->Void))
    {
        let request = NSMutableURLRequest(URL: url)
        let bodyData = String.localizedStringWithFormat("comment_id=%d&user_id=%d&token=%@", comment_id , user.id , user.userToken)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let dataTask = session.dataTaskWithRequest(request){(data , response , error) in
            
            if error == nil
            {
                if let httpResponse = response as? NSHTTPURLResponse{
                    
                    switch(httpResponse.statusCode)
                    {
                        
                    case 200:
                        
                        if let data = data{
                            
                            completion(data)
                        }
                        
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            }
        }
        dataTask.resume()
    }

}
