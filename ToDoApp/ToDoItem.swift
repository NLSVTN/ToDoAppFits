//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Nikita Vlasenko on 11/11/16.
//  Copyright © 2016 Nikita Vlasenko. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoItem: Object {
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var priority: Int = 0
    dynamic var completed: Bool = false
    
    
    
    convenience required init(title: String, desc: String, priority: Int) {
        self.init()
        
        self.title = title
        self.desc = desc
        self.priority = priority
    }
}
