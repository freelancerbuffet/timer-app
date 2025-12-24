//
//  OKTimerWidget.swift
//  OKTimerWidget
//
//  Created by Developer on 12/24/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TimerEntry {
        TimerEntry(date: Date(), timerState: .idle, timeRemaining: 300)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> ()) {
        let entry = TimerEntry(date: Date(), timerState: .idle, timeRemaining: 300)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // For now, simple static timeline
        let currentDate = Date()
        let entry = TimerEntry(date: currentDate, timerState: .idle, timeRemaining: 300)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct TimerEntry: TimelineEntry {
    let date: Date
    let timerState: TimerState
    let timeRemaining: TimeInterval
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct OKTimerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: TimerEntry
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.3), .cyan.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Text("OK TIMER")
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundColor(.primary.opacity(0.6))
                
                Text(entry.formattedTime)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.primary)
                
                Text(entry.timerState == .running ? "Running" : "Tap to start")
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct MediumWidgetView: View {
    let entry: TimerEntry
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.3), .cyan.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("OK TIMER")
                        .font(.system(size: 14, weight: .light, design: .rounded))
                        .foregroundColor(.primary.opacity(0.6))
                    
                    Text(entry.formattedTime)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.primary)
                    
                    Text(stateText)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Quick actions
                VStack(spacing: 12) {
                    QuickActionButton(title: "5m", action: "start-5")
                    QuickActionButton(title: "10m", action: "start-10")
                    QuickActionButton(title: "15m", action: "start-15")
                }
            }
            .padding()
        }
    }
    
    private var stateText: String {
        switch entry.timerState {
        case .idle:
            return "Ready"
        case .running:
            return "In Progress"
        case .paused:
            return "Paused"
        case .completed:
            return "Completed!"
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let action: String
    
    var body: some View {
        Link(destination: URL(string: "oktimer://\(action)")!) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 50, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.8))
                )
        }
    }
}

struct OKTimerWidget: Widget {
    let kind: String = "OKTimerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OKTimerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("OK Timer")
        .description("Quick access to your timer")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    OKTimerWidget()
} timeline: {
    TimerEntry(date: .now, timerState: .idle, timeRemaining: 300)
    TimerEntry(date: .now, timerState: .running, timeRemaining: 180)
}
