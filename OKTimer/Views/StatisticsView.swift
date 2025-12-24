//
//  StatisticsView.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var historyManager: SessionHistoryManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Statistics")
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundColor(.primary.opacity(0.8))
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary.opacity(0.6))
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.primary.opacity(0.06))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Overview cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Today",
                            value: "\(historyManager.sessionsToday().count)",
                            subtitle: "sessions",
                            icon: "calendar",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "This Week",
                            value: "\(historyManager.sessionsThisWeek().count)",
                            subtitle: "sessions",
                            icon: "chart.bar",
                            color: .green
                        )
                    }
                    
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Total Time",
                            value: formatTotalTime(historyManager.totalTimeSpent),
                            subtitle: "completed",
                            icon: "clock",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Avg Duration",
                            value: formatAvgTime(historyManager.averageSessionDuration),
                            subtitle: "per session",
                            icon: "timer",
                            color: .purple
                        )
                    }
                    
                    // Recent sessions
                    if !historyManager.sessions.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.accentColor)
                                    .frame(width: 20)
                                
                                Text("Recent Sessions")
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary.opacity(0.8))
                                
                                Spacer()
                                
                                if historyManager.sessions.count > 0 {
                                    Button(action: {
                                        historyManager.clearHistory()
                                    }) {
                                        Text("Clear")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.red.opacity(0.8))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            VStack(spacing: 0) {
                                ForEach(Array(historyManager.sessions.prefix(10).enumerated()), id: \.element.id) { index, session in
                                    SessionRow(session: session)
                                    
                                    if index < min(9, historyManager.sessions.count - 1) {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.primary.opacity(0.03))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                    )
                            )
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "chart.bar.doc.horizontal")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(.secondary.opacity(0.5))
                            
                            Text("No sessions yet")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            Text("Complete your first timer to see statistics")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.secondary.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 40)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            #if os(iOS)
            Color.clear
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 0))
            #else
            Color.clear
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            #endif
        }
    }
    
    private func formatTotalTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatAvgTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.primary.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Session Row
struct SessionRow: View {
    let session: TimerSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.formattedDuration)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(session.formattedDate)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: session.wasCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(session.wasCompleted ? .green : .orange)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView(historyManager: SessionHistoryManager())
}
