//
//  Cell+CoreDataProperties.swift
//  Must To Do
//
//  Created by Rian Anjasmara on 12/04/20.
//  Copyright © 2020 Rian Anjasmara. All rights reserved.
//
//

import Foundation
import CoreData


extension Cell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cell> {
        return NSFetchRequest<Cell>(entityName: "Cell")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var body: String?

}
