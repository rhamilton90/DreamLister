//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Reggie on 6/26/17.
//  Copyright © 2017 Reggie. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toitem: Item?

}
