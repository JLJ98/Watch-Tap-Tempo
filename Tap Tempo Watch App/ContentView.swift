import SwiftUI
import WatchKit

class TapTempoCalculator {
    private var tapTimes: [Date] = []
    private let maxTaps = 4 // Limit the number of taps to consider
    var timer: Timer?

    func addTap() -> Double? {
        let currentTime = Date()
        tapTimes.append(currentTime)

        // Limit the number of taps stored
        if tapTimes.count > maxTaps {
            tapTimes.removeFirst()
        }

        if tapTimes.count > 1 {
            let intervals = zip(tapTimes, tapTimes.dropFirst()).map { $1.timeIntervalSince($0) }
            let averageInterval = intervals.reduce(0, +) / Double(intervals.count)
            let tapsPerMinute = 60.0 / averageInterval

            WKInterfaceDevice.current().play(.start)

            return tapsPerMinute
        } else {
            tapTimes.append(currentTime)
            return nil // Not enough taps for BPM calculation yet
        }
    }

    func clearTapTimes() {
        tapTimes.removeAll()
    }

    func stopMetronome() {
        timer?.invalidate()
    }
}




