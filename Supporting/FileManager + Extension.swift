//
//  FileManager + Extension.swift
//  Scheduler
//
//  Created by Tsering Lama on 1/17/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

extension FileManager {
    // function gets URL path to documents directory
    // type method
    // documents/
    static func getDocumentsDirectory() -> URL {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
    }
    
    // getting url ,, in and out
    // documents/schedules.plist "schedules.plist"
    static func pathFromDocumentsDirectory(filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
