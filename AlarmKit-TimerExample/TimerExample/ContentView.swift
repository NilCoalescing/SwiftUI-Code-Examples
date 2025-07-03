//
//  ContentView.swift
//  TimerExample
//
//  Created by Natalia Panferova on 02/07/2025.
//

import SwiftUI
import AlarmKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TimerList()
                .safeAreaInset(edge: .bottom) {
                    TimerButton()
                        .font(.headline)
                        .buttonStyle(.borderedProminent)
                }
                .navigationTitle("Timers")
        }
        .tint(.pink)
    }
}

struct TimerList: View {
    @State private var timerAlarms: [Alarm] = []
    
    var body: some View {
        List(timerAlarms) { alarm in
            TimerAlarmRow(alarm: alarm)
        }
        .task {
            for await alarms in AlarmManager.shared.alarmUpdates {
                timerAlarms.removeAll { local in
                    alarms.allSatisfy { $0.id != local.id }
                }
                
                for alarm in alarms {
                    if let index = timerAlarms.firstIndex(
                        where: { $0.id == alarm.id }
                    ) {
                        timerAlarms[index] = alarm
                    } else {
                        timerAlarms.insert(alarm, at: 0)
                    }
                }
            }
        }
    }
}

struct TimerAlarmRow: View {
    let alarm: Alarm
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("\(alarm.id)")
                    .font(.caption)
                
                if let countdown = alarm.countdownDuration?.preAlert {
                    let duration = Duration.seconds(countdown)
                    Text("\(duration, format: .units(width: .wide))")
                        .font(.title)
                }
                
                switch alarm.state {
                case .countdown: Text("running")
                case .alerting: Text("alerting")
                default: EmptyView()
                }
            }
            
            Spacer()
            
            Button(role: .cancel) {
                try? AlarmManager.shared.cancel(id: alarm.id)
            }
            .labelStyle(.iconOnly)
        }
    }
}
