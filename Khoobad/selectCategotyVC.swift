//
//  selectCategotyVC.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/19/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

extension UIView {
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = duration
        rotateAnimation.removedOnCompletion = false
        rotateAnimation.fillMode = kCAFillModeForwards
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}

class selectCategotyVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    //
    // MARK: - Data
    //
    struct item {
        
        var name:String!
        var id: Int!
        
        init(name: String, id: Int) {
            self.name = name
            self.id = id
        }
    }
    struct Section {
        
        var name: String!
        var items: [item]!
        var collapsed: Bool!
        var id:Int!
        
        init(name: String, items: [item], collapsed: Bool = false , id:Int) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
            self.id = id
        }
    }
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        /*sections = [
            Section(name: "Mac", items: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini", "Accessories", "OS X El Capitan"]),
            Section(name: "iPad", items: ["iPad Pro", "iPad Air 2", "iPad mini 4", "Accessories"]),
            Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6", "iPhone SE", "Accessories"])
        ]*/
        tableView.allowsMultipleSelection = true
       //tableView.separatorStyle = .None
        
        for cat in categories {
            
            var items:[item] = [item]()
            for sub in subCategories {
                
                if ((Int((sub.parent_id as? String)!)) == (cat.id)) {
                    
                    let tmp = item(name: sub.name, id: sub.id)
                    items.append(tmp)
                }
            }
            sections.append(Section(name: cat.name, items: items, collapsed: true, id: cat.id))
        }
    }
    
    
    //
    // MARK: - UITableViewDelegate
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section].collapsed!) ? 0 : sections[section].items.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCellWithIdentifier("header") as! collapsibleHeader
        
        header.toggleButton.tag = section
        header.titleLabel.tag = section
        header.titleLabel.setTitle(sections[section].name, forState: UIControlState.Normal)
        header.toggleButton.rotate(sections[section].collapsed! ? 0.0 : CGFloat(M_PI_2))
        header.toggleButton.addTarget(self, action: #selector(selectCategotyVC.toggleCollapse(_:)), forControlEvents: .TouchUpInside)
        header.titleLabel.addTarget(self, action: #selector(selectCategotyVC.toggleCollapse(_:)), forControlEvents: .TouchUpInside)
        return header.contentView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 45.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].name
        cell.textLabel?.textAlignment = .Right
        cell.textLabel?.font = UIFont(name: "B Yekan", size: 13)
        
        if let tmp = registerbiz.categories.indexForKey(String(self.sections[indexPath.section].items[indexPath.row].id))
        {
            print(tmp)
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print(String(self.sections[indexPath.section].items[indexPath.row].id))
        
        let _category:cat = cat(id: String(self.sections[indexPath.section].items[indexPath.row].id) , name:self.sections[indexPath.section].items[indexPath.row].name)
        registerbiz.categories[String(self.sections[indexPath.section].items[indexPath.row].id)] = _category
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        print(String(self.sections[indexPath.section].items[indexPath.row].id))
        registerbiz.categories.removeValueForKey(String(self.sections[indexPath.section].items[indexPath.row].id))
        print(registerbiz.categories)
    }
    //
    // MARK: - Event Handlers
    //
    func toggleCollapse(sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed
        
        // Reload section
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    }
}
