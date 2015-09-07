//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filtered: [NSDictionary] = []
    var data: [NSDictionary]?
    var searchValue: String! = ""

    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 250, 20))
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.redColor()
        // Added search bar
        searchBar.placeholder = "Enter your search"
        searchBar.tintColor = UIColor.redColor()
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        loadData()

        

//        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                println(business.name!)
//                println(business.address!)
//            }
//        })
        
        
//        Business.searchWithTerm("Thai", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        
   

        
    }
    
    private func loadData() {
        let progressView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressView.labelText = "Please wait..."
        Business.searchWithTerm(searchValue!, sort: .Distance, categories: nil, radius: nil, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
                print(business.reviewCount)
                self.tableView.reloadData()
            }
            progressView.hide(true)

        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
       
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
//        
        
        //Deals
        var deals = filters["deals"] as? Bool
        
        //Distance
        var distance = filters["distance"] as? Float
        
        //Sort
        var sortRawValue = filters["sortRawValue"] as? Int
        var sort = (sortRawValue != nil) ? YelpSortMode(rawValue: sortRawValue!) : nil
        
        //Categories
        var categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("Restaurant", sort: sort, categories: categories, radius: distance, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
        
            
            self.businesses = businesses
            self.tableView.reloadData()
            
        }
        
//        let categories = filters["categories"] as? [String]
//        let distances = filters["radius"] as? [String]
//
//       
//            
//        Business.searchWithTerm(searchValue!, sort: nil, categories: categories, radius: nil, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            self.tableView.reloadData()
//        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses
        {
            return businesses.count
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessesCell", forIndexPath: indexPath) as! BusinessesCell
        cell.business = businesses![indexPath.row]
        
        return cell
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchValue = ""
        loadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchValue = searchBar.text
        loadData()
            
       
        
    
    }

}
