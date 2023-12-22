//
//  HapticsManager.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/22/23.
//

import Foundation
import CoreHaptics

final class HapticsManager: ObservableObject {
    enum Action {
        case prepare
        case complex(Context)
    }
    
    enum Context {
        case correct
        case wrong
    }
    
    @Published var engine: CHHapticEngine?
    
    
    func send(_ action: Action) {
        switch action {
        case .prepare:
            Task {
                await prepare()
            }
        case .complex(let context):
            complexEvent(when: context)
        }
    }
    
    @MainActor
    private func prepare() async {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try await engine?.start()
        } catch {
            //TODO: Error Handling
            print(error.localizedDescription)
        }
    }
    
    
    private func complexEvent(when context: Context) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        switch context {
        case .correct:
            complexAnswerWasCorrect(&events)
        case .wrong:
            complexAnswerWasWrong(&events)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    private func complexAnswerWasCorrect(_ events: inout [CHHapticEvent]) {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let eventOne: CHHapticEvent = .init(eventType: .hapticTransient,
                                            parameters: [intensity],
                                            relativeTime: 0)
        let eventTwo: CHHapticEvent = .init(eventType: .hapticTransient,
                                            parameters: [intensity, sharpness],
                                            relativeTime: 0.5)
        events.append(contentsOf: [eventOne, eventTwo])
    }
    
    private func complexAnswerWasWrong(_ events: inout [CHHapticEvent]) {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 3)
        let event = CHHapticEvent(eventType: .hapticTransient,
                                  parameters: [intensity],
                                  relativeTime: 0)
        events.append(event)
    }
    
}
