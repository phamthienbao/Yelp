//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Bao Pham on 9/6/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    var categories: [[String:String]]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        self.tableView.tableHeaderView?.autoresizesSubviews = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    {
        return categories.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("CustomHeaderCell") as! CustomHeaderCell
        headerCell.backgroundColor = UIColor.cyanColor()
        
        headerCell.headerLabel.text = "Categories"
        
        return headerCell
    }
    
    
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code" : "afghani"],
            ["name" : "African", "code" : "african"],
            ["name" : "American, New", "code" :"newamerican"],
            ["name" : "Agentine", "code" : "argentine"],
            ["name" : "Thai", "code": "thai"]]
        
    }
    

}
