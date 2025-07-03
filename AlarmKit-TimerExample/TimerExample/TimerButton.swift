//
//  TimerButton.swift
//  TimerExample
//
//  Created by Natalia Panferova on 02/07/2025.
//

import SwiftUI
import AlarmKit

struct TimerButton: View {
    private let manager = AlarmManager.shared
    
    var body: some View {
        Button("Start a timer", systemImage: "timer") {
            Task {
                if await checkForAuthorization() {
                    await scheduleTimer()
                } else {
                    // Handle unauthorized status
                }
            }
        }
    }
    
    private func scheduleTimer() async {
        let alert = AlarmPresentation.Alert(
            title: "Ready!",
            stopButton: AlarmButton(
                text: "Done",
                textColor: .pink,
                systemImageName: "checkmark"
            )
        )
        
        let attributes = AlarmAttributes<TimerData>(
            presentation: AlarmPresentation(alert: alert),
            tintColor: .pink
        )
        
        do {
            let _ = try await manager.schedule(
                id: UUID(),
                configuration: .timer(
                    duration: 10,
                    attributes: attributes
                )
            )
        } catch {
            print("Scheduling error: \(error)")
        }
    }
    
    private func checkForAuthorization() async -> Bool {
        switch manager.authorizationState {
        case .notDetermined:
            do {
                let state = try await manager.requestAuthorization()
                return state == .authorized
            } catch {
                print("Authorization error: \(error)")
                return false
            }
        case .authorized: return true
        case .denied: return false
        @unknown default: return false
        }
    }
}
