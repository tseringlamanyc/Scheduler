//
//  Persistence Helper .swift
//  Scheduler
//
//  Created by Tsering Lama on 1/17/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error {
    case savingError(Error) // associated value
    case decodingError(Error)
    case fileDoesntExist(String)
    case noData
}

class PersistenceHelper {
    // CURD (create update remove delete)
    
    // array of events
    private static var events = [Event]()
    
    // create filename
    private static let fileName = "schedules.plist"
    
    // create - save item to document directory
    static func save(item: Event) throws {
        
        // get url path inorder to save the item
        let url = FileManager.pathFromDocumentsDirectory(filename: fileName)
        
        // append
        events.append(item)
        
        // events array wil be the object that is being covereted to data object
        // we will use the data object and write / save it to documents
        
        do {
            let data = try PropertyListEncoder().encode(events) // encodes events to data, serializes
            try data.write(to: url, options: .atomic) // write to the url , atomic(all at once)
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    // read - load item from document directory
    static func loadEvents() throws -> [Event] {
        
        // need access to the filename url
        let url = FileManager.pathFromDocumentsDirectory(filename: fileName)
        if FileManager.default.fileExists(atPath: url.path) {
                if let data = FileManager.default.contents(atPath: url.path) {
                    do {
                        events = try PropertyListDecoder().decode([Event].self, from: data)
                    } catch {
                        throw DataPersistenceError.decodingError(error)
                    }
                } else {
                    throw DataPersistenceError.noData
                }
        } else {
            throw DataPersistenceError.fileDoesntExist(fileName)
        }
        return events
    }
    
    // update
    
    // delete - remove from documents directory
}
