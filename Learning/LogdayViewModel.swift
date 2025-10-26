//
//  LogdayViewModel..swift
//  Learning
//
//  Created by Reem alghamdi on 01/05/1447 AH.
//

import Foundation
import Combine
import SwiftUI

class LogdayViewModel: ObservableObject {
    final class LogdayViewModel: ObservableObject {
        @Published var months: [Date] = []
        private let calendar = Calendar.current
        private let monthsBefore = 1
        private let monthsAfter = 1
        
        init() {
            buildMonths()
        }
        
        // MARK: - Calendar Helpers
        private func buildMonths() {
            let center = startOfMonth(for: Date())
            var list: [Date] = []
            for delta in (-monthsBefore)...monthsAfter {
                if let m = calendar.date(byAdding: .month, value: delta, to: center) {
                    list.append(startOfMonth(for: m))
                }
            }
            months = list
        }

        private func startOfMonth(for date: Date) -> Date {
            let comps = calendar.dateComponents([.year, .month], from: date)
            return calendar.date(from: comps) ?? date
        }

        func weekdaySymbolsShort() -> [String] {
            let symbols = calendar.shortWeekdaySymbols
            let first = calendar.firstWeekday - 1
            return Array(symbols[first...] + symbols[..<first])
        }

        func monthGrid(for monthStart: Date) -> [[Date]] {
            let start = startOfMonth(for: monthStart)
            guard let range = calendar.range(of: .day, in: .month, for: start),
                  let firstOfMonthWeekday = calendar.dateComponents([.weekday], from: start).weekday
            else { return [] }
            
            let firstWeekdayIndex = (firstOfMonthWeekday - calendar.firstWeekday + 7) % 7
            var days: [Date] = []
            
            if firstWeekdayIndex > 0 {
                if let previousMonth = calendar.date(byAdding: .month, value: -1, to: start),
                   let prevRange = calendar.range(of: .day, in: .month, for: previousMonth),
                   let prevStart = calendar.date(from: calendar.dateComponents([.year, .month], from: previousMonth)) {
                    let prevDaysCount = prevRange.count
                    for i in (prevDaysCount - firstWeekdayIndex + 1)...prevDaysCount {
                        if let d = calendar.date(byAdding: .day, value: i - 1, to: prevStart) {
                            days.append(d)
                        }
                    }
                }
            }
            
            for day in range {
                if let d = calendar.date(byAdding: .day, value: day - 1, to: start) {
                    days.append(d)
                }
            }
            
            while days.count % 7 != 0 {
                if let last = days.last,
                   let next = calendar.date(byAdding: .day, value: 1, to: last) {
                    days.append(next)
                }
            }
            
            var weeks: [[Date]] = []
            var idx = 0
            while idx < days.count {
                weeks.append(Array(days[idx..<min(idx+7, days.count)]))
                idx += 7
            }
            return weeks
        }
    }

    
    
    // MARK: - View-Specific State
    @Published var selectedDate: Date = Date()
    @Published var weekReferenceDate: Date = Date()
    @Published private var midnightTick: Date = Date() // Triggers view refresh
    
    // MARK: - Private Properties
    var appState: AppState
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    // MARK: - Passthrough Computed Properties
    // These just pass data from the AppState to the View
    
    var goal: String { appState.goal }
    var learnedStreak: Int { appState.learnedStreak }
    var frozenDaysCount: Int { appState.frozenDaysCount }
    var totalFreezes: Int { appState.totalFreezes }
    var isGoalComplete: Bool { appState.isGoalComplete }
    var todayStatus: DayStatus? { appState.todayStatus }
    var freezesLeft: Int { appState.freezesLeft }
    
    // MARK: - View-Specific Logic
    
    // This computed property builds a string for the view
    var freezeStatusText: String {
        "\(frozenDaysCount) out of \(totalFreezes) Freezes used"
    }
    
    // This logic determines if the freeze button should be disabled
    var isFreezeDisabled: Bool {
        todayStatus != nil || freezesLeft <= 0
    }
    
    var isTodayLogged: Bool {
        todayStatus != nil
    }
    
    // MARK: - Init
    
    init(appState: AppState) {
        self.appState = appState
        
        // This is optional, but good practice.
        // If anything changes in appState, this viewmodel will
        // broadcast an update, ensuring the view re-renders.
        appState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - View Intents (Actions)
    
    func logDay(as status: DayStatus) {
        appState.logDay(as: status)
    }
    
    func setNewGoal() {
        appState.setNewGoal()
    }
    
    // MARK: - Timer Logic
    
    func onAppear() {
        scheduleMidnightTick()
    }
    
    func onDisappear() {
        timer?.invalidate()
        timer = nil
    }
    
    private func scheduleMidnightTick() {
        let calendar = Calendar.current
        let now = Date()
        guard let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) else { return }
        
        let interval = nextMidnight.timeIntervalSince(now)
        
        timer?.invalidate() // Invalidate old timer just in case
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                // Trigger a view update
                self?.midnightTick = Date()
                // Reschedule for the *next* midnight.
                self?.scheduleMidnightTick()
            }
        }
    }
}
extension LogdayViewModel {
    
    func statusTextAndColor(for status: DayStatus?) -> (text: String, color: Color) {
        switch status {
        case .learned:
            return ("Learned\nToday", .orangeBASIC)
        case .frozen:
            return ("Day\nFreezed", .blueButton)
        case .none:
            return ("Log as Learned", .white)
        }
    }
    
    func buttonBackground(for status: DayStatus?) -> AnyView {
        switch status {
        case .learned:
            return AnyView(StyleGuide.learndeButtonCircle)
        case .frozen:
            return AnyView(StyleGuide.frozenDayCircle)
        case .none:
            return AnyView(StyleGuide.logButtonCircle)
        }
    }
}
extension View {
    func glassEffect() -> some View { self }
}

extension Date {
    var weekDates: [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return [] }
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }
}

