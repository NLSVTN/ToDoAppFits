//
//  ViewControllerDetailed.swift
//  ToDoApp
//
//  Created by Nikita Vlasenko on 11/11/16.
//  Copyright © 2016 Nikita Vlasenko. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerDetailed: UIViewController {

    var toDoItem: ToDoItem!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var itemPriority: UILabel!
    @IBOutlet weak var prioritySlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor.blackColor().CGColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.blackColor().CGColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        // Do any additional setup after loading the view.
        
        itemTitle.text = toDoItem.title
        itemDesc.text = toDoItem.desc
        itemPriority.text = String(toDoItem.priority)
        prioritySlider.value = Float(toDoItem.priority)
    }
    
    @IBAction func priorityChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        itemPriority.text = "\(currentValue)"
        itemPriority.font = UIFont(name: itemPriority.font.fontName, size: 32)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("unwindFromDetailedSegue", sender: nil)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        // Get the default Realm
        let realm = try! Realm()
        
            if let title = itemTitle.text, desc = itemDesc.text, priority = itemPriority.text {
                if title.isEmpty {
                    let alert = UIAlertView()
                    alert.title = "Empty Title!"
                    alert.message = "Please, enter ToDo item title"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    let count = realm.objects(ToDoItem.self).filter("title = '\(toDoItem.title)'").count
                    
                    // updating if > 0
                    if count > 0 {
                        try! realm.write {
                            toDoItem.title = title
                            toDoItem.desc = desc
                            toDoItem.priority = Int(priority)!
                        }
                    } else {
                        toDoItem.title = title
                        toDoItem.desc = desc
                        toDoItem.priority = Int(priority)!
                        try! realm.write {
                            realm.add(toDoItem)
                        }
                    }
                    performSegueWithIdentifier("unwindFromDetailedSegue", sender: nil)
                }
            }
    }

}
