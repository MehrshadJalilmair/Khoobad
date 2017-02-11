//
//  HomeBizComment.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/11/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class HomeBizComment: NSObject {
    
    var comment_id = 0
    var user_id = ""
    var commentText = ""
    var Rate = ""
    var iLikeThis = false
    var iDislikeThis = false
    var like_dislike_req = false//send/or not
    var liksNumber = 0
    var disliksNumber = 0
    var biz_id = ""
    var created_at = ""
    var updated_at = ""
    var user_firstname = ""
    var user_lastname = ""
    var user_image_url = ""
    
    init(comment_id:Int , user_id:String , commentText:String , Rate:String , iLikeThis:Bool , iDislikeThis:Bool , likesNumber:Int , dislikesNumber:Int , biz_id:String , created_at:String , updated_at:String , user_firstname:String , user_lastname:String , user_image_url:String) {
        
        self.user_id = user_id
        self.commentText = commentText
        self.Rate = Rate
        self.iLikeThis = iLikeThis
        self.iDislikeThis = iDislikeThis
        self.liksNumber = likesNumber
        self.disliksNumber = dislikesNumber
        self.comment_id = comment_id
        self.biz_id = biz_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.user_firstname = user_firstname
        self.user_lastname = user_lastname
        self.user_image_url = user_image_url
    }
    
    //with rest api---->getting comments and images
    class func getComments(biz_id:Int , page:Int)
    {
        /*var tot_pages = 0
        
        if pagingType == 0
        {
            tot_pages = ((HomeBizes.HomeBizesArr[biz_id])?.CommentsPageCount)!
        }
        else if(pagingType == 1)
        {
            tot_pages = nearestBizes[currentSelectedBizIndex].CommentsPageCount
        }
        else if(pagingType == 2)
        {
            tot_pages = categorySearchResultBizes[currentSelectedBizIndex].CommentsPageCount
        }
        else if(pagingType == 3)
        {
            tot_pages = KojaList[currentSelectedBizIndex].CommentsPageCount
        }
        else if(pagingType == 4)
        {
            tot_pages = simpleBizes[currentSelectedBizIndex].CommentsPageCount
        }*/
                
        if (!selectedBiz.isFullLoaded){//from net
            
            let URL:NSURL
            if (!selectedBiz.CommentsGOT) {
                
                URL = NSURL(string: String.localizedStringWithFormat(URLS.BizMainPageComments , String(biz_id)))!
            }
            else{
                
                URL = NSURL(string: String.localizedStringWithFormat(URLS.BizOtherPageComments , String(biz_id) , String(page + 1)))!
            }
            let HomeBizRequest : NSURLRequest = NSURLRequest(URL: URL)
            
            print(URL)
            
            NSURLConnection.sendAsynchronousRequest(HomeBizRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                
                if data == nil{
                    
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutCommentsReciveData", object: nil)
                    
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutReciveCommentsResponse", object: nil)
                    
                    return
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("GetCommentsServreConnectionProblem", object: nil)
                    
                    return
                }
                
                let _comments = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                print(_comments)
                /*print((Bizes["count"] as! Int))
                 print((Bizes["distance"] as! Int))
                 print((Bizes["status"] as! String))
                 print((Bizes["places"] as! [NSObject]))*/
                
                let pages_count = (_comments["total_pages"] as! Int)
                let current_page = (_comments["page_num"] as! Int)
    
                if pagingType == 0
                {
                    (HomeBizes.HomeBizesArr[biz_id])?.CommentsPageCount = pages_count
                    (HomeBizes.HomeBizesArr[biz_id])?.currentPage = Int(current_page)
                }
                else if(pagingType == 1)
                {
                    nearestBizes[currentSelectedBizIndex].CommentsPageCount = pages_count
                    nearestBizes[currentSelectedBizIndex].currentPage = Int(current_page)
                }
                else if(pagingType == 2)
                {
                    categorySearchResultBizes[currentSelectedBizIndex].CommentsPageCount = pages_count
                    categorySearchResultBizes[currentSelectedBizIndex].currentPage = Int(current_page)
                }
                else if(pagingType == 3)
                {
                    KojaList[currentSelectedBizIndex].CommentsPageCount = pages_count
                    KojaList[currentSelectedBizIndex].currentPage = Int(current_page)
                }
                else if(pagingType == 4)
                {
                    simpleBizes[currentSelectedBizIndex].CommentsPageCount = pages_count
                    simpleBizes[currentSelectedBizIndex].currentPage = Int(current_page)
                }
                
                let comments = (_comments["comments"] as! [NSObject])
                
                if comments.count > 0
                {
                    if pagingType == 0{(HomeBizes.HomeBizesArr[biz_id])?.CommentsGOT = true}
                    else if(pagingType == 1){nearestBizes[currentSelectedBizIndex].CommentsGOT = true}
                    else if(pagingType == 2){categorySearchResultBizes[currentSelectedBizIndex].CommentsGOT = true}
                    else if(pagingType == 3){KojaList[currentSelectedBizIndex].CommentsGOT = true}
                    else if(pagingType == 4){simpleBizes[currentSelectedBizIndex].CommentsGOT = true}
                }
                
                for object in comments{
                    
                    guard let ActualComment = object as? [String : AnyObject] else
                    {
                        continue
                    }
                    
                    let id:Int = ActualComment["id"] as! Int
                    let user_id:String = ActualComment["user_id"] as! String
                    let commentText:String = ActualComment["comment"] as! String
                    let Rate:String = ActualComment["rate"] as! String
                    let likesNumber:Int = ActualComment["likes"] as! Int
                    let dislikesNumber:Int = ActualComment["dislikes"] as! Int
                    let created_at:String = ActualComment["created_at"] as! String
                    let updated_at:String = ActualComment["updated_at"]as! String
                    let user_firstname:String = ActualComment["user_firstname"] as! String
                    let user_lastname:String = ActualComment["user_lastname"] as! String
                    let user_image_url:String = ActualComment["user_image"]as! String
                    let _biz_id:String = ActualComment["biz_id"]as! String
                    
                    let newComment = HomeBizComment(comment_id: id, user_id: user_id, commentText: commentText, Rate: Rate, iLikeThis: false, iDislikeThis: false, likesNumber: likesNumber , dislikesNumber: dislikesNumber , biz_id: _biz_id, created_at: created_at, updated_at: updated_at, user_firstname: user_firstname, user_lastname: user_lastname, user_image_url: user_image_url)
                    
                    if pagingType == 0
                    {
                        (HomeBizes.HomeBizesArr[biz_id])?.Comments[id] = (newComment)
                        (HomeBizes.HomeBizesArr[biz_id])?.CommentsIDS.append(id)
                    }
                    else if(pagingType == 1)
                    {
                        nearestBizes[currentSelectedBizIndex].Comments[id] = (newComment)
                        nearestBizes[currentSelectedBizIndex].CommentsIDS.append(id)
                    }
                    else if(pagingType == 2)
                    {
                        categorySearchResultBizes[currentSelectedBizIndex].Comments[id] = (newComment)
                        categorySearchResultBizes[currentSelectedBizIndex].CommentsIDS.append(id)
                    }
                    else if(pagingType == 3)
                    {
                        KojaList[currentSelectedBizIndex].Comments[id] = (newComment)
                        KojaList[currentSelectedBizIndex].CommentsIDS.append(id)
                    }
                    else if(pagingType == 4)
                    {
                        simpleBizes[currentSelectedBizIndex].Comments[id] = (newComment)
                        simpleBizes[currentSelectedBizIndex].CommentsIDS.append(id)
                    }
                
                    print("\(id) \(_biz_id) \(user_id)")
                }
                NSNotificationCenter.defaultCenter().postNotificationName("reloadCommentsTableView", object: nil)
            })
        }
    }
    
    class func like_dislike(like_dislike:Int , comment_id:Int , biz_id:Int)
    {
        /*if like_dislike == 1 {
            
            
            
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadCommentsTableView", object: nil)
        }
        else if like_dislike == -1
        {
                        
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadCommentsTableView", object: nil)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadComment", object: nil)*/
        
        let URL:NSURL = NSURL(string: URLS.like)!
        let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        
        let bodyData = String.localizedStringWithFormat("like=%d&user_id=%d&comment_id=%d&token=%@", like_dislike , user.id , comment_id , user.userToken)
        loginReq.HTTPMethod = "POST"
        loginReq.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(URL)
        
        NSURLConnection.sendAsynchronousRequest(loginReq, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
            
            if data == nil{
                
                //send later
                return
            }
            guard let httpResponse = response as? NSHTTPURLResponse
                else
            {
                //send later
                return
            }
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
            {
                //send later
                return
            }
            let like = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            
            print(like)
            
            let _status = (like["status"] as! Int)
            
            if _status == 1
            {
                let status = (like["like"] as! String)
                
                print(status)
                
                if status == "1"
                {
                    //ok
                }
                else if status == "-1"
                {
                    //ok
                }
            }
            else
            {
                //send later
            }
        })
    }
    
    class func postComment(comment: String , rate : Double , biz_id : Int , openion:String , user_id:Int , token:String)
    {
        var cmText = comment
        
        if cmText == "" {
            
            cmText = ""
        }
        
        if reachabilityStatus != KNOTREACHABLE && !_NOP
        {
            let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session : NSURLSession = NSURLSession(configuration: configuration)
            let request = NSMutableURLRequest(URL: NSURL(string: URLS.comment)!)
            
            var bodyData = String.localizedStringWithFormat("rate=%@&comment=%@&bizid=%@&user_id=%@&token=%@&opinion=%@", "\(Int(rate))" , cmText , "\(biz_id)" , "\(user_id)" , token , openion)
            bodyData = bodyData.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            request.HTTPMethod = "POST"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            print(bodyData)
            
            let dataTask = session.dataTaskWithRequest(request){(data , response , error) in
                
                if error == nil
                {
                    if let httpResponse = response as? NSHTTPURLResponse{
                        
                        switch(httpResponse.statusCode)
                        {
                            
                        case 200:
                            
                            if let data = data{
                                
                                
                                let _comment = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                                let status = (_comment["status"] as? Int)
                                
                                print(_comment)
                                if status == 1
                                {
                                    //ok
                                    //NSNotificationCenter.defaultCenter().postNotificationName("reloadComments", object: nil)
                                    let id = (_comment["id"] as? Int)
                                    print(id)
                                }
                                else
                                {
                                    //save to db and try again
                                    db.addFailedComment(cmText, rate: rate, biz_id: biz_id, openion: openion, user_id: user_id, token: token)
                                }
                            }
                            
                        default:
                            //save to db and try again
                            print(httpResponse.statusCode)
                            db.addFailedComment(cmText, rate: rate, biz_id: biz_id, openion: openion, user_id: user_id, token: token)
                        }
                    }
                }
            }
            dataTask.resume()
        }
        else if reachabilityStatus == KNOTREACHABLE && _NOP
        {
            //save to db and send later
            db.addFailedComment(cmText, rate: rate, biz_id: biz_id, openion: openion, user_id: user_id, token: token)
        }
    }
}
