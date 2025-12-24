//
//  TimerSession.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import Foundation

struct TimerSession: Codable, Identifiable {
    let id: UUID
    let duration: TimeInterval
    let completedAt: Date
    let wasCompleted: Bool // false if cancelled/reset
    
    init(duration: TimeInterval, completedAt: Date = Date(), wasCompleted: Bool = true) {
        self.id = UUID()
        self.duration = duration
        self.completedAt = completedAt
        self.wasCompleted = wasCompleted
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: completedAt, relativeTo: Date())
    }
}

class SessionHistoryManager: ObservableObject {
    @Published var sessions: [TimerSession] = []
    
    private let sessionsKey = "OKTimerSessions"
    private let maxSessions = 100 // Keep last 100 sessions
    
    init() {
        loadSessions()
    }
    
    func addSession(_ session: TimerSession) {
        sessions.insert(session, at: 0)
        
        // Keep only the most recent sessions
        if sessions.count > maxSessions {
            sessions = Array(sessions.prefix(maxSessions))
        }
        
        saveSessions()
    }
    
    func clearHistory() {
        sessions.removeAll()
        saveSessions()
    }
    
    // MARK: - Statistics
    
    var totalCompletedSessions: Int {
        sessions.filter { $0.wasCompleted }.count
    }
    
    var totalTimeSpent: TimeInterval {
        sessions.filter { $0.wasCompleted }.reduce(0) { $0 + $1.duration }
    }
    
    var averageSessionDuration: TimeInterval {
        let completed = sessions.filter { $0.wasCompleted }
        guard !completed.isEmpty else { return 0 }
        return totalTimeSpent / Double(completed.count)
    }
    
    func sessionsToday() -> [TimerSession] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return sessions.filter { calendar.startOfDay(for: $0.completedAt) == today }
    }
    
    func sessionsThisWeek() -> [TimerSession] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return sessions.filter { $0.completedAt >= weekAgo }
    }
    
    // MARK: - Persistence
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([TimerSession].self, from: data) {
            sessions = decoded
        }
    }
}
