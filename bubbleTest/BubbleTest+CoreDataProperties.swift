//
//  BubbleTest+CoreDataProperties.swift
//  bubbleTest
//
//  Created by ouniwang on 10/7/16.
//  Copyright © 2016 ham. All rights reserved.
//

import Foundation
import CoreData


extension BubbleTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BubbleTest> {
        return NSFetchRequest<BubbleTest>(entityName: "BubbleTest");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var message: String?
    @NSManaged public var isReceived: Bool
    @NSManaged public var room: Int16
    @NSManaged public var sender: Int16

}
