//
//  CoreDataStack.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/17/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: CustomStringConvertible {
  var modelName : String
  var storeName : String
  var options: NSDictionary?

  init(modelName: String, storeName: String, options: NSDictionary? = nil) {
      self.modelName = modelName
      self.storeName = storeName
      self.options = options
  }

  var description : String
    {
    return "context: \(context)\n" +
      "modelName: \(modelName)" +
      //        "model: \(model.entityVersionHashesByName)\n" +
      //        "coordinator: \(coordinator)\n" +
      "storeURL: \(storeURL)\n"
      //        "store: \(store)"
  }

  var modelURL : NSURL {
    return Bundle.main.url(forResource: self.modelName, withExtension: "momd")! as NSURL
  }

  var storeURL : NSURL {
    var storePaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true) as [String]
    let storePath = String(storePaths[0]) as NSString
    let fileManager = FileManager.default
    
    do {
      try fileManager.createDirectory(atPath: storePath as String, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
      print("Error creating storePath \(storePath): \(error)")
    }
    let sqliteFilePath = storePath.appendingPathComponent(storeName + ".sqlite")
    return NSURL(fileURLWithPath: sqliteFilePath)
  }

  lazy var model : NSManagedObjectModel = NSManagedObjectModel(contentsOf: self.modelURL as URL)!

  var store : NSPersistentStore?

  lazy var coordinator : NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
    do {
        self.store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
                                                        at: self.storeURL as URL,
        options: self.options as! [AnyHashable : Any]?)
    } catch var error as NSError {
      print("Store Error: \(error)")
      self.store = nil
    } catch {
      fatalError()
    }
    return coordinator
  }()
  
  lazy var context : NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = self.coordinator
    return context
  }()
}
