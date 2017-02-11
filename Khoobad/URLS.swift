//
//  URLS.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/8/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class URLS: NSObject {

    internal static var nearestBizes:String = "http://185.105.186.2/api/close5?lat=%@&long=%@"
    internal static var suggestText:String = "http://185.105.186.2/api/suggest?q=%@&lat=%.4f&long=%.4f"
    internal static var HomeBiz:String = "http://185.105.186.2/api/mainpage?lat=%@&long=%@"
    internal static var BizImagess:String = "http://185.105.186.2/api/bizimages?bizid=%@"
    internal static var Imagess:String = "http://185.105.186.2/images/%@"
    internal static var UserImage:String = "http://185.105.186.2/users/%@"
    internal static var BizMainPageComments:String = "http://185.105.186.2/api/comment/get?bizid=%@"
    internal static var BizOtherPageComments:String = "http://185.105.186.2/api/comment/get?bizid=%@&page=%@"
    internal static var login:String = "http://185.105.186.2/api/authenticate"
    internal static var like:String = "http://185.105.186.2/api/comment/like"
    internal static var isLike:String = "http://185.105.186.2/api/comment/isliked"
    internal static var comment:String = "http://185.105.186.2/api/comment/add"
    internal static var category:String = "http://185.105.186.2/api/category"
    internal static var biz_category:String = "http://185.105.186.2/api/biz_category?category_id=%@&page=%@&lat=%@&long=%@"
    //internal static var map_image = "http://maps.googleapis.com/maps/api/staticmap?center=%@,%@8&zoom=13&size=144x144&scale=false&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0x3F51B5%7Clabel:%7C%@,%@"
    internal static var report:String = "http://185.105.186.2/api/comment/report"
    internal static var fix_report:String = "http://185.105.186.2/api/fix_report"
    internal static var register:String = "http://185.105.186.2/api/register"
    internal static var active_me:String = "http://185.105.186.2/api/activate_me"
    internal static var claim:String = "http://185.105.186.2/claim"
    internal static var forgot_password:String = "http://185.105.186.2/forgot_password"
    internal static var change_password:String = "http://185.105.186.2/change_password"
    internal static var what_where:String = "http://185.105.186.2/api/what_where?"
    internal static var add_biz:String = "http://185.105.186.2/api/add_biz"
    internal static var get_local:String = "http://185.105.186.2/local_biz?place_id=%@&timestamp=%@"
    internal static var get_local_rating:String = "http://185.105.186.2/local_rate?place_id=%@"
    internal static var similar_biz:String = "http://185.105.186.2/api/similar_biz?bizid=%@"
    
    internal static var upload_user_image:String = "http://185.105.186.2/api/upload_user_image"
    internal static var bizdetail:String = "http://185.105.186.2/api/bizdetail?bizid=%@"
    internal static var start_filter:String = "http://185.105.186.2/api/start_filter"
}
