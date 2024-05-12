//
//  Item.swift
//  Redefine
//
//  Created by Olaf Neumann on 12.05.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
