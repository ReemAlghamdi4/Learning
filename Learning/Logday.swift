import SwiftUI

// MARK: - 5. Main View (Logday)
struct Logday: View {
    let appState: AppState
        
        // Use @StateObject for the ViewModel
        @StateObject private var viewModel: LogdayViewModel


    init(appState: AppState) {
            self.appState = appState
            _viewModel = StateObject(wrappedValue: LogdayViewModel(appState: appState))
        }
    
    var body: some View {
            NavigationStack {
                ZStack {
                    Color.black.ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Activity")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            
                            NavigationLink {
                                // This view and its children still need the environment object
                                AllActivitiesCalendarView(selectedDate: $viewModel.selectedDate)
                                    .environmentObject(appState) // Provide it here
                            } label: {
                                ZStack {
                                    StyleGuide.graniteCircle
                                    Image(systemName: "calendar")
                                        .resizable().scaledToFit()
                                        .foregroundStyle(Color.white.opacity(0.90))
                                        .frame(width: 24, height: 24)
                                }
                            }

                            NavigationLink {
                                reselectgoal(appState: appState)
                            } label: {
                                ZStack {
                                    StyleGuide.graniteCircle
                                    Image(systemName: "pencil.and.outline")
                                        .resizable().scaledToFit()
                                        .foregroundStyle(Color.white.opacity(0.90))
                                        .frame(width: 24, height: 24)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer().frame(height: 27)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // WeekView might still use @EnvironmentObject,
                            // which it gets from the App struct ancestor.
                            WeekView(
                                currentDate: $viewModel.weekReferenceDate,
                                selectedDate: $viewModel.selectedDate
                            )
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color.gray.opacity(0.5))
                            
                            Text("Learning \(viewModel.goal)")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 16) {
                                DataPill(value: "\(viewModel.learnedStreak)",
                                         label: viewModel.learnedStreak == 1 ? "Day Learned" : "Days Learned",
                                         iconName: "flame.fill",
                                         color: Color.orangeBASIC)
                                DataPill(value: "\(viewModel.frozenDaysCount)",
                                         label: viewModel.frozenDaysCount == 1 ? "Day Freezed" : "Days Freezed",
                                         iconName: "cube.fill",
                                         color: Color.blueButton)
                            }
                        }
                        .padding(16)
                        .background(StyleGuide.mainCardBackground)
                        
                        Spacer().frame(height: 16)
                        
                        if viewModel.isGoalComplete {
                            goalCompletionView
                        } else {
                            dailyStatusView
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    viewModel.onAppear()
                }
                .onDisappear {
                    viewModel.onDisappear()
                }
                #if os(iOS)
                .navigationBarHidden(true)
                #endif
            }
        }
    
    // (goalCompletionView remains the same)
    private var goalCompletionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "hands.and.sparkles.fill")
                .font(.system(size: 40))
                .foregroundColor(Color.orangeBASIC)
                .padding(.top , 62)

            Text("Well done!")
                .font(.system(size: 22)).bold()
                .foregroundColor(.white)
            
            Text("Goal completed! Start learning again or set a new learning goal.")
                .font(.system(size: 18))
                .foregroundColor(.gray.opacity(0.80))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)

            Button {
                viewModel.setNewGoal()
            } label: {
                ZStack {
                    StyleGuide.selectedPill
                    Text("Set new learning goal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 240, height: 48)
            }
            
            Button {
                viewModel.setNewGoal()
            } label: {
                Text("Set same learning goal and duration")
                    .font(.system(size: 16))
                    .foregroundColor(Color.orangeBASIC)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
    }

    // (dailyStatusView remains the same)
    private var dailyStatusView: some View {
        VStack {
            interactiveActionButtons
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    // (interactiveActionButtons remains the same)
        private var interactiveActionButtons: some View {
            let status = viewModel.todayStatus
            let (text, color) = viewModel.statusTextAndColor(for: status)

            return VStack(spacing: 0) {
                Button {
                    if status == nil {
                        viewModel.logDay(as: .learned)
                    }
                } label: {
                    ZStack {
                        viewModel.buttonBackground(for: status)
                        Text(text)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(color)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
                .frame(width: 274, height: 274)
                .disabled(viewModel.isTodayLogged)
                
                Spacer().frame(height: 32)
                
                Button {
                    if status == nil {
                        viewModel.logDay(as: .frozen)
                    }
                } label: {
                    ZStack {
                        StyleGuide.freezeButtonRectangle
                        Text("Log as Freezed")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(viewModel.isFreezeDisabled)
                .opacity(viewModel.isFreezeDisabled ? 0.5 : 1.0)
                
                Spacer().frame(height: 8)
                
                Text(viewModel.freezeStatusText)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }

}


// MARK: - 3. Week View Component
// (WeekView remains the same)
struct WeekView: View {
    @EnvironmentObject var appState: AppState
    @Binding var currentDate: Date
    @Binding var selectedDate: Date

    var weekDates: [Date] { currentDate.weekDates }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(currentDate.formatted(.dateTime.month(.wide).year()))
                    .font(.title2).bold()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.orangeBASIC)
                    .bold()
                Spacer()

                HStack(spacing: 10) {
                    Button(action: goToPreviousWeek) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.orangeBASIC)
                            .font(.title2.bold())
                    }
                    Button(action: goToNextWeek) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.orangeBASIC)
                            .font(.title2.bold())
                    }
                }
                .font(.headline)
            }
            .foregroundColor(.white)

            HStack {
                ForEach(weekDates, id: \.self) { date in
                    let dateString = appState.dateToString(date)
                    let status = appState.loggedDays[dateString]
                    
                    VStack(spacing: 4) {
                        Text(date.formatted(.dateTime.weekday()).uppercased())
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        Text(date.formatted(.dateTime.day()))
                            .font(.title3).bold()
                            .frame(width: 44, height: 44)
                            .background(CalendarDayBackground( // <-- NEW
                                status: status,
                                isToday: Calendar.current.isDateInToday(date)
                            ))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedDate = date
                        currentDate = date
                    }
                }
            }
        }
    }
  
    func goToPreviousWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }

    func goToNextWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }
}

// MARK: - All Activities Calendar Screen
// (AllActivitiesCalendarView remains the same, including its macOS check)
struct AllActivitiesCalendarView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            StyleGuide.graniteCircle
                            Image(systemName: "chevron.left")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(Color.white.opacity(0.90))
                        }
                    }
                    Spacer()
                    Text("All activities")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                    Spacer()
                    ZStack {
                        StyleGuide.graniteCircle
                    }
                    .opacity(0)
                    .disabled(true)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 27)

                FullCalendarView(selectedDate: $selectedDate)
                    .environmentObject(appState)
            }
        }
    
        .navigationBarHidden(true)
    }
}

// MARK: - Reusable Calendar Day Background
struct CalendarDayBackground: View {
    let status: DayStatus?
    let isToday: Bool
    let isInDisplayedMonth: Bool // Default to true for WeekView
    
    init(status: DayStatus?, isToday: Bool, isInDisplayedMonth: Bool = true) {
        self.status = status
        self.isToday = isToday
        self.isInDisplayedMonth = isInDisplayedMonth
    }

    var body: some View {
        let base: Color = {
            guard isInDisplayedMonth else { return .clear }
            switch status {
            case .learned:
                // Using consistent colors
                return Color.orangeBASIC.opacity(0.4)
            case .frozen:
                // Using consistent colors
                return Color.blueButton.opacity(0.4)
            case .none:
                return .clear
            }
        }()
        
        let ringColor: Color = (isToday && status == nil && isInDisplayedMonth) ? Color.orangeBASIC : .clear
        
        Circle()
            .fill(base)
            .overlay(
                Circle().stroke(ringColor, lineWidth: 2)
            )
    }
}
// MARK: - Full Month Calendar View
// (FullCalendarView remains the same)
struct FullCalendarView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let monthsBefore = 36
    private let monthsAfter = 36
    
    @State private var months: [Date] = []
    
    var body: some View {
        
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20, pinnedViews: []) {
                    ForEach(months, id: \.self) { monthStart in
                        MonthSection(
                            selectedDate: $selectedDate, monthStart: monthStart
                        )
                        .environmentObject(appState)
                        .id(monthStart)
                        
                        Divider()
                            .background(Color.gray.opacity(0.5))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
            .background(Color.black)
            .onAppear {
                buildMonths()
                let target = startOfMonth(for: selectedDate)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        proxy.scrollTo(target, anchor: .top)
                    }
                }
            }
        }
    }

    
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
}

// (MonthSection remains the same)
private struct MonthSection: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedDate: Date
    
    let monthStart: Date
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(monthStart.formatted(.dateTime.month(.wide).year()))
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(weekdaySymbolsShort(), id: \.self) { symbol in
                    Text(symbol.uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(monthGrid(), id: \.self) { week in
                    HStack(spacing: 0) {
                        ForEach(week, id: \.self) { date in
                            dayCell(for: date)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(.horizontal, 0)
        }
    }
    
  
    @ViewBuilder
    private func dayCell(for date: Date) -> some View {
        let isInDisplayedMonth = calendar.isDate(date, equalTo: monthStart, toGranularity: .month)
        let dateKey = appState.dateToString(date)
        let status = appState.loggedDays[dateKey]
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        VStack(spacing: 6) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isInDisplayedMonth ? .white : .gray.opacity(0.5))
                .frame(width: 38, height: 38)
                .background(
                        CalendarDayBackground( // <-- NEW
                            status: status,
                            isToday: isToday,
                            isInDisplayedMonth: isInDisplayedMonth
                        ))
                .clipShape(Circle())

                
        }
        .frame(height: 44)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedDate = date
        }
        .padding(.vertical, 4)
    }
    
    
    @ViewBuilder
    private func dayBackground(for status: DayStatus?, isToday: Bool, inMonth: Bool) -> some View {
        let base: Color = {
            guard inMonth else { return .clear }
            switch status {
            case .learned:
                return Color.orangeBASIC.opacity(0.4)
            case .frozen:
                return Color.orangeBASIC.opacity(0.4)
            case .none:
                return .clear
            }
        }()
        let ringColor: Color = (isToday && status == nil && inMonth) ? Color.orangeBASIC : .clear
        Circle()
            .fill(base)
            .overlay(
                Circle().stroke(ringColor, lineWidth: 2)
            )
    }
}


// MARK: - 4. Data Pill Component
// --- ✅ Corrected DataPill Definition (removed bad cite tags) ---
struct DataPill: View {
    let value: String
    let label: String
    let iconName: String // Parameter name is correct
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 69)
                .fill(color.opacity(0.40))
                .frame(height: 69)

            HStack(spacing: 4) {
                Image(systemName: iconName) // Using the correct parameter
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 24)
                    .foregroundColor(color)
                    .padding(.leading, 24)
                    .padding(.trailing, 16)

                VStack(alignment: .leading) {
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                    Text(label)
                        .font(.system(size: 12))
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}


