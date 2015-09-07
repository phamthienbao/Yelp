//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Bao Pham on 9/6/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

let SECTION_HEADERS = [
    "Price",
    "Distance",
    "Sort By",
    "Categories"
]

let SORTBY_OPTIONS = [
    (id: "0", title: "Best Matched"),
    (id: "1", title: "Distance"),
    (id: "2", title: "Highest Rated"),
]


let DISTANCE_OPTIONS = [
    (id: "0", title: "Auto"),
    (id: "482", title: "0.3 miles"),
    (id: "1600", title: "1 miles"),
    (id: "80000", title: "5 miles"),
    (id: "160000", title: "10 miles"),

]


@objc protocol FiltersViewControllerDelegate{
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:[String:AnyObject])
    
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegated {

    @IBOutlet weak var tableView: UITableView!
    var deals: Bool!
    let distance: [Double] = [0, 0.3, 1, 5, 10]
    var distanceSection = RowSelectSingle()
    var sortbySection = RowSelectSingle()
    var categoriesAll = RowSelectMultiple()
    var switchStates = [Int:Bool]()
    var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]]!
    var distances: [[String:String]]!
    var distanceStates: [Bool] = [false, false, false, false, false]
    var sortByStates: [Bool] = [false, false, false]
    
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        var filters = [String:AnyObject]()

        var selectedCategory = [String]()
        
        //Deals
        filters["deals"] = deals
        
        //Distance
        for var index = 0; index < distance.count; index++ {
            if distanceStates[index] == true {
                filters["distance"] = distance[index]
            }
        }
        
        //Sort by
        for var index = 0; index < SORTBY_OPTIONS.count; index++ {
            if sortByStates[index] == true {
                filters["sortRawValue"] = index
            }
        }
        
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategory.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategory.count > 0 {
                filters["categories"] = selectedCategory
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
        
        dismissViewControllerAnimated(true, completion: nil)
       
    }
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        self.tableView.tableHeaderView?.autoresizesSubviews = true
        sortbySection.options = SORTBY_OPTIONS
        distanceSection.options = DISTANCE_OPTIONS


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    {
        
        switch section {
        case 0: return 1
        case 1: return distanceSection.numberOfRows()
        case 2: return sortbySection.numberOfRows()
        default: // case 4: categories
            return categories.count

        }
        
        //return categories.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

        switch indexPath.section {
        case 0:
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.on = deals ?? false

            
            //cell.onSwitch.on = filters["deal"] as? Bool ?? false
            
            return cell
        case 1:
            print("1")
            return distanceSection.createCell(self.tableView, row: indexPath.row)
            cell.onSwitch.on = distanceStates[indexPath.row] ?? false
        case 2:
            return sortbySection.createCell(self.tableView, row: indexPath.row)
            cell.onSwitch.on = sortByStates[indexPath.row] ?? false


        default: // case 4: categories
                cell.userInteractionEnabled = true
                cell.switchLabel.text = categories[indexPath.row]["name"]
                cell.delegate = self
                cell.onSwitch.on = switchStates[indexPath.row] ?? false
                
                //return cell
        }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0: return
        case 1:
            distanceSection.rowSelected(self.tableView, indexPath: indexPath)
        case 2:
            sortbySection.rowSelected(self.tableView, indexPath: indexPath)

    
        default: // case 4: categories
            return
            //categoriesSection.rowSelected(self.tableView, indexPath: indexPath)
        }
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
//        let indexPath = tableView.indexPathForCell(switchCell)!
//        switchStates[indexPath.row] = value
//        

        
        let indexPath = tableView.indexPathForCell(switchCell)!
        //Deals
        if indexPath.section == 0 {
            deals = value
        }
            //Distance section
        else if indexPath.section == 1 {
            for var i = 0; i < DISTANCE_OPTIONS.count; i++ {
                if i == indexPath.row {
                    distanceStates[i] = distanceStates[i] ? false : true
                } else {
                    distanceStates[i] = false
                }
                var indexPathTemp = NSIndexPath(forRow: i, inSection: 1)
                self.tableView.reloadRowsAtIndexPaths([indexPathTemp], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
            //Sort by section
        else if indexPath.section == 2 {
            for var i = 0; i < SORTBY_OPTIONS.count; i++ {
                if i == indexPath.row {
                    sortByStates[i] = sortByStates[i] ? false : true
                } else {
                    sortByStates[i] = false
                }
                var indexPathTemp = NSIndexPath(forRow: i, inSection: 2)
                self.tableView.reloadRowsAtIndexPaths([indexPathTemp], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
            //Categories section
        else {
            switchStates[indexPath.row] = value
        }

        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SECTION_HEADERS.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SECTION_HEADERS[section]
    }
    

    


    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let  headerCell = tableView.dequeueReusableCellWithIdentifier("CustomHeaderCell") as! CustomHeaderCell
//        headerCell.backgroundColor = UIColor.cyanColor()
//        
//        headerCell.headerLabel.text = "Categories"
//        
//        return headerCell
//    }
    
    
    class RowSelectSingle {
        var isExpanded = false
        var options: [(id: String, title: String)] = []
        var chosenRow: Int = 0
        var chosenID: String {
            get {
                return options[chosenRow].id
            }
            set {
                for (o, option) in options.enumerate() {
                    if option.id == newValue {
                        chosenRow = o
                        return
                    }
                }
                chosenRow = 0
            }
        }
        
        func numberOfRows() -> Int {
            return isExpanded ? options.count : 1
        }
        
        func createCell(tableView: UITableView, row: Int) -> UITableViewCell {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            if isExpanded {
                var option = options[row]
                cell.switchLabel.text = option.title
                cell.onSwitch.on = (row == chosenRow)
            }
            else {
                var option = options[chosenRow]
                cell.switchLabel.text = option.title
                cell.onSwitch.on = true
            }
            // for some reason some cells are being disabled
            cell.onSwitch.enabled = true
            cell.userInteractionEnabled = true
            return cell
        }
        
        func rowSelected(tableView: UITableView, indexPath: NSIndexPath) {
            if !isExpanded || chosenRow == indexPath.row {
                isExpanded = !isExpanded
            }
            else {
                chosenRow = indexPath.row
                for (o, option) in options.enumerate() {
                    var oIndex = NSIndexPath(forRow: o, inSection: indexPath.section)
                    var cell = tableView.cellForRowAtIndexPath(oIndex)
                    // cell might be offscreen and therefor not really exist
                    if let gotCell = cell as? SwitchCell {
                        gotCell.onSwitch.on = (o == chosenRow)
                    }
                }
                isExpanded = false
            }
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            // TODO -- scroll tableView so that section is more prominent
        }
    }
    
    
    class RowSelectMultiple {
        var isExpanded = false
        var options: [(id: String, title: String)] = []
        var chosenRows: [Int] = []
        var chosenIDs: [String] {
            get {
                return chosenRows.map {
                    self.options[$0].id
                }
            }
            set {
                var nsChosenIDs = NSArray(array: newValue)
                var chosen: [Int] = []
                for (o, option) in options.enumerate() {
                    if nsChosenIDs.containsObject(option.id) {
                        chosen.append(o)
                    }
                }
                chosenRows = chosen
            }
        }
        
        func numberOfRows() -> Int {
            return isExpanded ? options.count + 1 : chosenRows.count + 1
        }
        
        func createCell(tableView: UITableView, row: Int) -> UITableViewCell {
            if isExpanded {
                if row == options.count {
                    var cell = tableView.dequeueReusableCellWithIdentifier("SelectToggleCell") as! SelectToggleCell
                    cell.titleLabel.text = "Hide"
                    return cell
                }
                else {
                    var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
                    var option = options[row]
                    cell.switchLabel.text = option.title
                    var nsChosenRows = NSArray(array: chosenRows)
                    cell.onSwitch.on = nsChosenRows.containsObject(row)
                    // for some reason some cells are being disabled
                    cell.onSwitch.enabled = true
                    cell.userInteractionEnabled = true
                    return cell
                }
            }
            else {
                if row == chosenRows.count {
                    var cell = tableView.dequeueReusableCellWithIdentifier("SelectToggleCell") as! SelectToggleCell
                    cell.titleLabel.text = "Show All"
                    return cell
                }
                else {
                    var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
                    var option = options[chosenRows[row]]
                    cell.switchLabel.text = option.title
                    cell.onSwitch.on = true
                    // for some reason some cells are being disabled
                    cell.onSwitch.enabled = true
                    cell.userInteractionEnabled = true
                    return cell
                }
            }
        }
        
        func rowSelected(tableView: UITableView, indexPath: NSIndexPath) {
            var nsChosenRows = NSArray(array: chosenRows)
            var drop: Int?
            if isExpanded {
                if indexPath.row == options.count {
                    isExpanded = false
                    tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                }
                else {
                    // toggle tapped row
                    var cell = tableView.cellForRowAtIndexPath(indexPath) as! SwitchCell
                    if nsChosenRows.containsObject(indexPath.row) {
                        cell.onSwitch.on = false
                        drop = indexPath.row
                    }
                    else {
                        cell.onSwitch.on = true
                        chosenRows.append(indexPath.row)
                        // sort so that choice order doesn't determine display order while collapsed
                        chosenRows.sort { $0 < $1 }
                    }
                }
            }
            else {
                if indexPath.row == chosenRows.count {
                    isExpanded = true
                    tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                }
                else {
                    // drop tapped row from chosenRows
                    drop = chosenRows[indexPath.row]
                }
            }
            if drop != nil {
                chosenRows = chosenRows.filter() { $0 != drop! }
                if !isExpanded {
                    tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                }
            }
        }
    }

    
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code" : "afghani"],
            ["name" : "African", "code" : "african"],
            ["name" : "American, New", "code" :"newamerican"],
            ["name" : "Agentine", "code" : "argentine"],
            ["name" : "Thai", "code": "thai"]]
        
    }
    

}
