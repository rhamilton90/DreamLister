//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Reggie on 6/26/17.
//  Copyright © 2017 Reggie. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }

}
