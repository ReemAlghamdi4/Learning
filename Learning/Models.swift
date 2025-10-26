//
//  Models.swift
//  Learning
//
//  Created by Reem alghamdi on 01/05/1447 AH.
//

import Foundation

// Enum to represent the status of a logged day
enum DayStatus: String, Codable {
    case learned
    case frozen
}

// Enum for goal duration
enum Duration: String, CaseIterable, Identifiable, Codable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var id: String { rawValue }
}
