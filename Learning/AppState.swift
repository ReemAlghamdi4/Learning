//
//  AppState.swift
//  Learning
//
//  Created by Reem alghamdi on 01/05/1447 AH.
//

import Foundation
import Combine
import SwiftUI

// This class will manage the state of your entire application.
class AppState: ObservableObject {
    
    // --- Published Properties ---
    @Published var goal: String = ""
    @Published var duration: Duration = .week
    @Published var startDate: Date?
    @Published var endDate: Date?

    @Published var learnedStreak: Int = 0
    @Published var freezesLeft: Int = 0
    @Published var totalFreezes: Int = 0

    // A dictionary to store the status for each day
    @Published var loggedDays: [String: DayStatus] = [:]

    // This boolean will control whether to show the goal setup or the calendar view.
    @Published var isGoalActive: Bool = false

    // Activity timestamps for enforcement
    @Published var lastLearnedDate: Date?
    @Published var lastFrozenDate: Date?

    private let userDefaultsKey = "learningAppState"

    init() {
        loadState()
        // Enforce the 32-hour rule on startup
        enforceStreakRuleNow()
    }
    
    // MARK: - Computed Properties
    
    var frozenDaysCount: Int {
        loggedDays.values.filter { $0 == .frozen }.count
    }
    
    var isTodayLogged: Bool {
        loggedDays[dateToString(Date())] != nil
    }
    
    var todayStatus: DayStatus? {
        loggedDays[dateToString(Date())]
    }
    
    var isGoalComplete: Bool {
        guard let endDate = endDate else { return false }
        return Date() > endDate
    }

    // MARK: - Core Functions
    
    func startGoal(goal: String, duration: Duration) {
        self.goal = goal.isEmpty ? "Swift" : goal
        self.duration = duration
        self.startDate = Date()
        self.learnedStreak = 0
        self.loggedDays = [:]
        self.lastLearnedDate = nil
        self.lastFrozenDate = nil
        
        let now = Date()
        switch duration {
        case .week:
            totalFreezes = 2
            endDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
        case .month:
            totalFreezes = 8
            endDate = Calendar.current.date(byAdding: .month, value: 1, to: now)
        case .year:
            totalFreezes = 96
            endDate = Calendar.current.date(byAdding: .year, value: 1, to: now)
        }
        self.freezesLeft = totalFreezes
        self.isGoalActive = true
        saveState()
    }

    func logDay(as status: DayStatus) {
        let todayString = dateToString(Date())
        
        guard !isTodayLogged, !isGoalComplete else { return }

        if status == .learned {
            learnedStreak += 1
            lastLearnedDate = Date()
        } else if status == .frozen {
            guard freezesLeft > 0 else { return }
            freezesLeft -= 1
            lastFrozenDate = Date()
        }

        loggedDays[todayString] = status
        saveState()
    }
    
    func setNewGoal() {
        goal = ""
        duration = .week
        startDate = nil
        endDate = nil
        learnedStreak = 0
        freezesLeft = 0
        totalFreezes = 0
        loggedDays = [:]
        isGoalActive = false
        lastLearnedDate = nil
        lastFrozenDate = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    // MARK: - 32-hour Enforcement

    // Resets the streak if there has been no learned or freeze in the last 32 hours.
    func enforceStreakRuleNow(reference now: Date = Date()) {
        // If no active goal, nothing to enforce
        guard isGoalActive else { return }
        
        // If streak already zero, nothing to do
        guard learnedStreak > 0 else { return }

        // Find most recent activity (learned or frozen)
        let lastActivity = maxDate(lastLearnedDate, lastFrozenDate)
        
        // If user never learned or froze yet, and streak > 0 (shouldn't happen normally), reset defensively
        guard let lastActivityDate = lastActivity else {
            learnedStreak = 0
            saveState()
            return
        }
        
        let elapsed = now.timeIntervalSince(lastActivityDate)
        let threshold: TimeInterval = 32 * 60 * 60 // 32 hours in seconds
        
        if elapsed > threshold {
            // More than 32 hours with no learned/freeze -> reset
            learnedStreak = 0
            saveState()
        }
    }
    
    private func maxDate(_ a: Date?, _ b: Date?) -> Date? {
        switch (a, b) {
        case (nil, nil): return nil
        case (let d?, nil): return d
        case (nil, let d?): return d
        case (let d1?, let d2?): return max(d1, d2)
        }
    }

    // MARK: - Data Persistence
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func saveState() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(loggedDays) {
            var data: [String: Any] = [
                "goal": goal,
                "duration": duration.rawValue,
                "startDate": startDate ?? Date(),
                "endDate": endDate ?? Date(),
                "learnedStreak": learnedStreak,
                "freezesLeft": freezesLeft,
                "totalFreezes": totalFreezes,
                "loggedDays": encodedData,
                "isGoalActive": isGoalActive
            ]
            // Only include dates if they exist; store as TimeInterval (Double)
            if let lastLearnedDate {
                data["lastLearnedDate"] = lastLearnedDate.timeIntervalSince1970
            }
            if let lastFrozenDate {
                data["lastFrozenDate"] = lastFrozenDate.timeIntervalSince1970
            }
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func loadState() {
        guard let data = UserDefaults.standard.dictionary(forKey: userDefaultsKey) else { return }
        
        self.goal = data["goal"] as? String ?? ""
        if let durationRaw = data["duration"] as? String {
            self.duration = Duration(rawValue: durationRaw) ?? .week
        }
        self.startDate = data["startDate"] as? Date
        self.endDate = data["endDate"] as? Date
        self.learnedStreak = data["learnedStreak"] as? Int ?? 0
        self.freezesLeft = data["freezesLeft"] as? Int ?? 0
        self.totalFreezes = data["totalFreezes"] as? Int ?? 0
        
        if let savedLoggedDays = data["loggedDays"] as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([String: DayStatus].self, from: savedLoggedDays) {
                self.loggedDays = decoded
            }
        }
        
        self.isGoalActive = data["isGoalActive"] as? Bool ?? false
        
        // Read timestamps as Double and convert back to Date
        if let lastLearnedTS = data["lastLearnedDate"] as? Double {
            self.lastLearnedDate = Date(timeIntervalSince1970: lastLearnedTS)
        } else {
            self.lastLearnedDate = nil
        }
        if let lastFrozenTS = data["lastFrozenDate"] as? Double {
            self.lastFrozenDate = Date(timeIntervalSince1970: lastFrozenTS)
        } else {
            self.lastFrozenDate = nil
        }
    }
}

