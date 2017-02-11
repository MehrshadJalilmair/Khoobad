//
//  CommentsTableViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/27/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell , liking , report{
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var Biz:HomeBiz!
    {
        didSet{
        
            UppdateUI()
        }
    }
    
    var CopyBiz:HomeBiz!
    
    func UppdateUI()
    {
        commentsTableView.separatorStyle = .None
        Biz.currentPage = 0//comments page
        Biz.CommentsGOT = false
        getComments(Biz.currentPage)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsTableViewCell.reloadCommentsTableData), name: "reloadCommentsTableView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsTableViewCell.reloadCommentsTableRowData), name: "reloadCommentsTableViewRow", object: nil)
        CopyBiz = Biz
    }
    
    func getComments(page:Int)
    {
        HomeBizComment.getComments(selectedBiz.id, page: selectedBiz.currentPage)//result will notify...
    }
    func LoadMoreComments()
    {
        getComments(selectedBiz.currentPage)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedBiz.Comments.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! HomeBizCommentViewCell
        
        let comment = selectedBiz.Comments[selectedBiz.CommentsIDS[indexPath.row]]
        
        cell.comment = comment
        
        print(cell.comment.iLikeThis)
        
        cell.delegate = self
        cell.delegate1 = self
        
        cell.selectionStyle = .None
        
        if indexPath.row == selectedBiz.Comments.count - 1 {
            
            if selectedBiz.CommentsPageCount > 1 {
                
                if selectedBiz.currentPage == selectedBiz.CommentsPageCount {
                    
                    
                }
                else
                {
                    print("LoadMoreComments")
                    LoadMoreComments()
                }
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //self.performSegueWithIdentifier("Show Biz", sender: indexPath.row)
        print(indexPath.row)
    }

    //Mark : like and dislike
    func like(cell: HomeBizCommentViewCell) {
        
        cellForLikeOrDislike = cell
        /*if !cell.comment.iLikeThis {
            
            if user.isLogin {
                
                cellForLikeOrDislike = cell
                HomeBizComment.like_dislike(1, comment_id: cell.comment.comment_id, biz_id: Int(cell.comment.biz_id)!)
                return
            }
            user.login()
        }*/
        if user.isLogin {
            
            cellForLikeOrDislike = cell
            HomeBizComment.like_dislike(1, comment_id: cell.comment.comment_id, biz_id: Int(cell.comment.biz_id)!)
            return
        }
        user.login()
    }
    func dislike(cell: HomeBizCommentViewCell) {
        
        cellForLikeOrDislike = cell
        /*if !cell.comment.iDislikeThis
        {
            if user.isLogin {
                
                cellForLikeOrDislike = cell
                HomeBizComment.like_dislike(-1, comment_id: cell.comment.comment_id, biz_id: Int(cell.comment.biz_id)!)
                return
            }
            user.login()
        }*/
        if user.isLogin {
            
            cellForLikeOrDislike = cell
            HomeBizComment.like_dislike(-1, comment_id: cell.comment.comment_id, biz_id: Int(cell.comment.biz_id)!)
            return
        }
        user.login()
    }
    
    func report(cell: HomeBizCommentViewCell) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let content = storyboard.instantiateViewControllerWithIdentifier("reportModal") as? reportModal
        content?.comment_id = cell.comment.comment_id
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content!, contentHeight: UIScreen.mainScreen().bounds.height - 200)

        self.window?.rootViewController!.presentViewController(partialModal, animated: true)
        {
            print("presenting view controller - done")
        }
    }
    
    func reloadCommentsTableData() {
        
        //selectedBiz = HomeBizes.HomeBizesArr[Biz.id]
        if pagingType == 0{
            
            selectedBiz = HomeBizes.HomeBizesArr[Biz.id]
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
        //self.Biz = selectedBiz
        
        commentsTableView.reloadData()
    }
    func reloadCommentsTableRowData()
    {
        if pagingType == 0{
            
            selectedBiz = HomeBizes.HomeBizesArr[Biz.id]
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
        
        //cellForLikeOrDislike.comment = selectedBiz.Comments[cellForLikeOrDislike.comment.comment_id]
        
        if  let row = self.commentsTableView.indexPathForCell(cellForLikeOrDislike)?.row {
            
            print(row)
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            self.commentsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        }
        else
        {
            commentsTableView.reloadData()
        }
        //self.Biz = selectedBiz

        //commentsTableView.reloadData()
    }
}
