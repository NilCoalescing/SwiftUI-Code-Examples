//
//  CountdownTimerBundle.swift
//  CountdownTimer
//
//  Created by Natalia Panferova on 03/07/2025.
//

import WidgetKit
import SwiftUI
import AlarmKit

@main
struct CountdownTimerBundle: WidgetBundle {
    var body: some Widget {
        CountdownTimerLiveActivity()
    }
}

struct CountdownTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<TimerData>.self) { context in
            CountdownTextView(state: context.state)
                .font(.largeTitle)
                .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        CountdownTextView(state: context.state)
                            .font(.headline)
                        CountdownProgressView(state: context.state)
                            .frame(maxHeight: 30)
                    }
                }
            } compactLeading: {
                CountdownTextView(state: context.state)
            } compactTrailing: {
                CountdownProgressView(state: context.state)
            } minimal: {
                CountdownProgressView(state: context.state)
            }
        }
    }
}

struct CountdownTextView: View {
    let state: AlarmPresentationState
    
    var body: some View {
        if case let .countdown(countdown) = state.mode {
            Text(timerInterval: Date.now ... countdown.fireDate)
                .monospacedDigit()
                .lineLimit(1)
        }
    }
}

struct CountdownProgressView: View {
    let state: AlarmPresentationState
    
    var body: some View {
        if case let .countdown(countdown) = state.mode {
            ProgressView(
                timerInterval: Date.now ... countdown.fireDate,
                label: { EmptyView() },
                currentValueLabel: { Text("") }
            )
            .progressViewStyle(.circular)
        }
    }
}
