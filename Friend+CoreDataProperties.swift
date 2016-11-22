//
//  Friend+CoreDataProperties.swift
//  fbMessangerAppDemo
//
//  Created by harsh patel on 20/11/16.
//  Copyright © 2016 harsh patel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Friend {

    @NSManaged var name: String?
    @NSManaged var profileImageName: String?
    @NSManaged var messages: NSSet?

}
