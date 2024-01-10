//
//  File.swift
//  Tap Tempo Watch App
//
//  Created by Jon-Luke Jenkins on 12/13/23.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var bpmLabel: WKInterfaceLabel!
    @IBOutlet weak var tapButton: WKInterfaceButton!

    private var startTime: Date?
    private var tapCount: Int = 0

    @IBAction func tapButtonPressed() {
        if startTime == nil {
            startTime = Date()
        } else {
            tapCount += 1
            updateBPM()
        }
    }

    private func updateBPM() {
        guard let startTime = startTime else { return }

        let endTime = Date()
        let elapsedTime = endTime.timeIntervalSince(startTime)

        // Calculate BPM
        let bpm = Double(tapCount) / (elapsedTime / 60.0)

        // Update the BPM label
        bpmLabel.setText(String(format: "%.0f BPM", bpm))
    }
}

import SwiftUI

struct Watch_Tap_Tempo_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

