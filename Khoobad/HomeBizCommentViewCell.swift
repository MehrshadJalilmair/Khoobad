//
//  HomeBizCommentViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/11/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

protocol liking
{
    func like(cell : HomeBizCommentViewCell)
    func dislike(cell : HomeBizCommentViewCell)
}
protocol report
{
    func report(cell : HomeBizCommentViewCell)
}

class HomeBizCommentViewCell: UITableViewCell {

    @IBOutlet weak var commentBackground: UIView!
    //@IBOutlet weak var commentBackground: UIView!
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_comment: UILabel!
    @IBOutlet weak var user_rate: UILabel!
    @IBOutlet weak var like_counts: UILabel!
    @IBOutlet weak var dislikes_counts: UILabel!
    var delegate:liking!
    var delegate1:report!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var dislike_btn: UIButton!
    
    var comment:HomeBizComment! {
        
        didSet{
        
            updateUI()
        }
    }
    
    private func updateUI()
    {
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadComment", name: "reloadComment", object: nil)
        
        self.user_rate.layer.cornerRadius = self.user_rate.bounds.width / 2
        
        user_rate.text = "\(Int(comment.Rate))"
        
        self.user_rate.textColor = UIColor.whiteColor()
        
        if Int(comment.Rate) == -1
        {
            user_rate.text = "-/-"
            user_rate.textColor = UIColor.grayColor()
        }
        
        
        self.user_rate.textColor = UIColor.whiteColor()
        if Int(comment.Rate) >= 7 {
            
            
            self.user_rate.layer.backgroundColor = UIColor(red: 113/255 , green: 218/255 , blue: 62/255, alpha: 1).CGColor
            //self.BizRateView.layer.borderColor = UIColor.greenColor().CGColor
        }
        else if Int(comment.Rate) >= 5 && Int(comment.Rate) < 7
        {
            
            self.user_rate.layer.backgroundColor = UIColor(red: 242/255, green: 231/255, blue: 0/255, alpha: 1).colorWithAlphaComponent(1).CGColor
            //self.BizRateView.layer.borderColor = UIColor.yellowColor().CGColor
        }
        else if Int(comment.Rate) >= 0 && Int(comment.Rate) < 5
        {
            
            self.user_rate.layer.backgroundColor = UIColor(red: 239/255, green: 52/255, blue: 62/255, alpha: 1).colorWithAlphaComponent(1).CGColor
            //self.BizRateView.layer.borderColor = UIColor.redColor().CGColor
        }

        /*self.user_rate.layer.cornerRadius = self.user_rate.bounds.width / 2
        self.user_rate.layer.borderWidth = 1.5
        self.user_rate.layer.backgroundColor = UIColor.blackColor().CGColor
        user_rate.alpha = 0.45
        self.user_rate.layer.borderColor = UIColor.whiteColor().CGColor
        
        if Int(comment.Rate) >= 7 {
            
            self.user_rate.textColor = UIColor.greenColor()
            self.user_rate.layer.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5).CGColor
            //self.BizRateView.layer.borderColor = UIColor.greenColor().CGColor
        }
        else if Int(comment.Rate) >= 5 && Int(comment.Rate) < 7
        {
            self.user_rate.textColor = UIColor.yellowColor()
            self.user_rate.layer.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5).CGColor
            //self.BizRateView.layer.borderColor = UIColor.yellowColor().CGColor
        }
        else if Int(comment.Rate) >= 0 && Int(comment.Rate) < 5
        {
            self.user_rate.textColor = UIColor.redColor()
            self.user_rate.layer.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5).CGColor
            //self.BizRateView.layer.borderColor = UIColor.redColor().CGColor
        }*/

        
        //commentBackground.backgroundColor = UIColor.whiteColor()
        commentBackground.layer.cornerRadius = 5
        commentBackground.layer.masksToBounds = false
        commentBackground.layer.borderWidth = 0.5
        commentBackground.layer.borderColor = UIColor(red: 0, green: 162, blue: 232, alpha: 0.5).CGColor
        //commentBackground.layer.shadowColor = UIColor(red: 73, green: 141, blue: 154, alpha: 1).colorWithAlphaComponent(0.5).CGColor
        commentBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        commentBackground.layer.shadowOpacity = 0.8
        
        //download user image
        let _url =  NSURL(string : String.localizedStringWithFormat(URLS.UserImage , comment.user_image_url))
        if let url = _url {
            
            let imageDownloader = dataDownloaderServiceTask(url: url)
            imageDownloader.Download({ (data) in
                
                let image = UIImage(data : data)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.user_image.image = image
                })
            })
        }
    
        //i'm like or dislike or not this comment
        if user.isLogin {
            
            if reachabilityStatus == KNOTREACHABLE {
                
                /*if comment.iLikeThis == true
                {
                    
                    self.like_btn.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
                    self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
                }
                else if comment.iDislikeThis == true
                {
                    self.dislike_btn.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)
                    self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
                }
                else
                {
                    self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
                    self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
                }*/
            }
            else
            {
                let _url1 =  NSURL(string : URLS.isLike)
                if let url = _url1 {
                    
                    let likeRecognizer = dataDownloaderServiceTask(url: url)
                    likeRecognizer.isLiked(self.comment.comment_id , completion: { (data) in
                        
                        let like = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions())
                        
                        //print("like_or_dislike \(self.comment.comment_id)")
                        
                        let like_or_dislike = (like["like_or_dislike"] as? String)!
                        print("like_or_dislike \(like)")
                        
                        switch like_or_dislike
                        {
                        case "0":
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
                                self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
                            })

                            break
                        case "1":
                            if pagingType == 0
                            {
                                (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iLikeThis = true
                                
                            }
                            else if(pagingType == 1)
                            {
                                nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
                            }
                            else if(pagingType == 2)
                            {
                                categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
                            }
                            else if(pagingType == 3)
                            {
                                KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
                            }
                            else if(pagingType == 4)
                            {
                                simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.like_btn.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
                                self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
                            })
                            
                            break
                        case "-1":
                            if pagingType == 0
                            {
                                (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iDislikeThis = true
                            }
                            else if(pagingType == 1)
                            {
                                nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
                            }
                            else if(pagingType == 2)
                            {
                                categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
                            }
                            else if(pagingType == 3)
                            {
                                KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
                            }
                            else if(pagingType == 4)
                            {
                                simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.dislike_btn.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)
                                self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
                            })
                            
                            break
                            
                        default:
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
                                self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
                            })
                            break
                        }
                    })
                }
            }
        }
        else
        {
            //self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
            //self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
            /*if comment.iLikeThis == true{
                
                self.like_btn.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
            }
            else
            {
                self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
            }
            
            if comment.iDislikeThis == true
            {
                self.dislike_btn.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)
            }
            else
            {
                self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
            }*/
        }
        
        user_image.layer.borderColor = UIColor.whiteColor().CGColor
        user_image.layer.cornerRadius = user_image.bounds.width / 2.0
        user_image.layer.masksToBounds = true
        user_image.layer.borderWidth = 1.5
        
        self.user_name.text = "\(comment.user_firstname) \(comment.user_lastname)"
        self.user_comment.text = comment.commentText
        self.user_rate.text = "\(comment.Rate)"
        self.like_counts.text = "\(comment.liksNumber)"
        self.dislikes_counts.text = "\(comment.disliksNumber)"
        
        if comment.user_id == String(user.id)
        {
            self.user_name.text = "من"
            //self.user_name.textColor = UIColor.greenColor()
        }
        print("\(comment.comment_id) \(comment.iLikeThis) \(comment.iDislikeThis)")
    }
    
    @IBAction func like(sender: AnyObject) {
        
        
        if comment.iLikeThis {
            
            return
        }
        var temp:Bool = true
        
        if pagingType == 0
        {
            temp = ((HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iDislikeThis)!
        }
        else if(pagingType == 1)
        {
            temp = nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iDislikeThis
        }
        else if(pagingType == 2)
        {
            temp = categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iDislikeThis
        }
        else if(pagingType == 3)
        {
            temp = KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iDislikeThis
        }
        else if(pagingType == 4)
        {
            temp = simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iDislikeThis
        }
        
        if temp
        {
            if pagingType == 0
            {
                (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.disliksNumber -= 1
                (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iDislikeThis = false
            }
            else if(pagingType == 1)
            {
                nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber -= 1
                nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = false
            }
            else if(pagingType == 2)
            {
                categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber -= 1
                categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = false
            }
            else if(pagingType == 3)
            {
                KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber -= 1
                KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = false
            }
            else if(pagingType == 4)
            {
                simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber -= 1
                simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = false
            }
        }
        if pagingType == 0
        {
            (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iLikeThis = true
            (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.liksNumber += 1
        }
        else if(pagingType == 1)
        {
            nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
            nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber += 1
        }
        else if(pagingType == 2)
        {
            categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
            categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber += 1
        }
        else if(pagingType == 3)
        {
            KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
            KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber += 1
        }
        else if(pagingType == 4)
        {
            simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = true
            simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber += 1
        }
        dispatch_async(dispatch_get_main_queue(), {
            
            self.comment.iLikeThis = true
            //self.comment.liksNumber += 1
            
            //if self.comment.iDislikeThis { self.comment.disliksNumber -= 1}
            self.comment.iDislikeThis = false
            
            self.like_counts.text = "\(self.comment.liksNumber)"
            self.dislikes_counts.text = "\(self.comment.disliksNumber)"
            self.dislike_btn.setImage(UIImage(named: "dislikeblack.png"), forState: UIControlState.Normal)
            self.like_btn.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
        })
        
        delegate.like(self)
        //NSNotificationCenter.defaultCenter().postNotificationName("reloadCommentsTableViewRow", object: nil)
    }
    
    @IBAction func dislike(sender: AnyObject) {
        
        if comment.iDislikeThis {
            
            return
        }
        var temp:Bool = true
        if pagingType == 0
        {
            temp = ((HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iLikeThis)!
        }
        else if(pagingType == 1)
        {
            temp = nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iLikeThis
        }
        else if(pagingType == 2)
        {
            temp = categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iLikeThis
        }
        else if(pagingType == 3)
        {
            temp = KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iLikeThis
        }
        else if(pagingType == 4)
        {
            temp = simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]!.iLikeThis
        }
        
        if temp
        {
            if pagingType == 0
            {
                (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.liksNumber -= 1
                (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iLikeThis = false
            }
            else if(pagingType == 1)
            {
                nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber -= 1
                nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = false
            }
            else if(pagingType == 2)
            {
                categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber -= 1
                categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = false
            }
            else if(pagingType == 3)
            {
                KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber -= 1
                KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = false
            }
            else if(pagingType == 4)
            {
                simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.liksNumber -= 1
                simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iLikeThis = false
            }
        }
        if pagingType == 0
        {
            (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.disliksNumber += 1
            (HomeBizes.HomeBizesArr[Int(self.comment.biz_id)!])?.Comments[self.comment.comment_id]?.iDislikeThis = true
        }
        else if(pagingType == 1)
        {
            nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber += 1
            nearestBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
        }
        else if(pagingType == 2)
        {
            categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber += 1
            categorySearchResultBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
        }
        else if(pagingType == 3)
        {
            KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber += 1
            KojaList[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
        }
        else if(pagingType == 4)
        {
            simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.disliksNumber += 1
            simpleBizes[currentSelectedBizIndex].Comments[self.comment.comment_id]?.iDislikeThis = true
        }
        dispatch_async(dispatch_get_main_queue(), {
            
            //if self.comment.iLikeThis { self.comment.liksNumber -= 1 }
            self.comment.iLikeThis = false
            self.comment.iDislikeThis = true
            //self.comment.disliksNumber += 1
            self.like_counts.text = "\(self.comment.liksNumber)"
            self.dislikes_counts.text = "\(self.comment.disliksNumber)"
            self.dislike_btn.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)
            self.like_btn.setImage(UIImage(named: "likeblack.png"), forState: UIControlState.Normal)
        })

        delegate.dislike(self)
        //NSNotificationCenter.defaultCenter().postNotificationName("reloadCommentsTableViewRow", object: nil)
    }
    
    @IBAction func reportComment(sender: AnyObject) {
        
        delegate1.report(self)
    }
    
    func reloadComment() {
        
        print("here")
        //selectedBiz = HomeBizes.HomeBizesArr[Biz.id]
        if pagingType == 0{
            
            //selectedBiz = HomeBizes.HomeBizesArr[Biz.id]
        }
        else if pagingType == 1{
            
            selectedBiz = nearestBizes[currentSelectedBizIndex]
        }
        else if pagingType == 2{
            
            selectedBiz = categorySearchResultBizes[currentSelectedBizIndex]
        }
        else if pagingType == 3{
            
            selectedBiz = KojaList[currentSelectedBizIndex]
        }
        else if pagingType == 4{
            
            selectedBiz = simpleBizes[currentSelectedBizIndex]
        }
        self.comment = selectedBiz.Comments[self.comment.comment_id]
        //commentsTableView.reloadData()
    }
}
