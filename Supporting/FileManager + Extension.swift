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
    static func getDocumentsDirectory() -> URL {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
    }
    
    static func getfilePathFromDocumentsDirectory(filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
