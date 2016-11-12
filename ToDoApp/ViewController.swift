//
//  ViewController.swift
//  ToDoApp
//
//  Created by Nikita Vlasenko on 11/11/16.
//  Copyright © 2016 Nikita Vlasenko. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, Dimmable  {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedTodoItem: ToDoItem?
    let realm = try! Realm()
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
        
        let backgroundImage = UIImage(named: "NorwayPhoto")
        //let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundColor = UIColor(patternImage: backgroundImage!)
        //imageView.contentMode = .ScaleAspectFit
        //tableView.backgroundColor = .lightGrayColor()
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(ToDoItem.self).count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat {
        return tableView.rowHeight;
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = realm.objects(ToDoItem.self).count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 0.7)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                                                               forIndexPath: indexPath) as! TableViewCell
        cell.selectionStyle = .None
        let item = realm.objects(ToDoItem.self).sorted("priority")[indexPath.row]
        // cell.textLabel?.text = item.text
        // cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    @IBAction func ToDoItemAdded(sender: AnyObject) {
        selectedTodoItem = ToDoItem()
        performSegueWithIdentifier("showDetailedSegue", sender: nil)
        
    }
    func toDoItemDeleted(toDoItem: ToDoItem) {
        
        let sortedList = realm.objects(ToDoItem).sorted("priority")
        
        //this will return optional Int?
        let indexOfItem = sortedList.indexOf(toDoItem)
        
        try! realm.write {
            realm.delete(toDoItem)
        }

        // loop over the visible cells to animate delete
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TableViewCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animateWithDuration(0.3, delay: delay, options: .CurveEaseInOut,
                                           animations: {() in
                                            cell.frame = CGRectOffset(cell.frame, 0.0,
                                                -cell.frame.size.height)},
                                           completion: {(finished: Bool) in
                                            if (cell == lastView) {
                                                self.tableView.reloadData()
                                            }
                    }
                )
                delay += 0.03
            }
            if cell.toDoItem === toDoItem {
                startAnimating = true
                cell.hidden = true
            }
        }
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: indexOfItem!, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
    }
    
    func showDetailed(toDoItem: ToDoItem) {
        selectedTodoItem = toDoItem
        performSegueWithIdentifier("showDetailedSegue", sender: nil)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailedViewController = segue.destinationViewController as! ViewControllerDetailed
        detailedViewController.toDoItem = selectedTodoItem!
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromDetailed(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
        self.tableView.reloadData()
    }

}

