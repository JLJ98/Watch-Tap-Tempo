import SwiftUI

struct ContentViewHelper: View {
    @Binding var contentOffset: CGFloat
    
    var body: some View {
        // Read and use the contentOffset binding here
        // Perform any necessary operations
        
        // Pass data or state to ContentView as needed
        Text("Helper View")
    }
}

struct ContentView: View {
    @State private var bpm: Double?
    @State private var tapButtonColorIndex = 0
    @State private var isTapButtonPressed = false
    @State private var isPlayButtonPressed = false
    @State private var selectedTempoIndex = 120 // Default tempo index
    
    let tapTempoCalculator = TapTempoCalculator()
    
    // Array of tempo values
    private let tempos = Array(0..<251)
    
    // Array of colors to cycle through for tap button
    private let tapButtonColors: [Color] = [.blue, .green, .orange, .red]
    
    // Computed property to get the selected tempo value
    private var selectedTempo: Int {
        tempos[selectedTempoIndex]
    }
    
    var body: some View {
        VStack {
            Text(bpm.map { String(format: "%.0f BPM", $0) } ?? "Tap Tempo")
                .padding()
            
            HStack {
                Button(action: {
                    withAnimation {
                        isTapButtonPressed.toggle()
                        if isTapButtonPressed {
                            tapButtonColorIndex = (tapButtonColorIndex + 1) % tapButtonColors.count
                        }
                    }
                    if let calculatedBPM = tapTempoCalculator.addTap() {
                        bpm = calculatedBPM
                    }
                }) {
                    Image(systemName: "hand.tap.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .frame(width: 50, height: 50)
                        .background(isTapButtonPressed ? Color.purple : tapButtonColors[tapButtonColorIndex])
                        .clipShape(Circle())
                }
                .scaleEffect(isTapButtonPressed ? 0.9 : 1.0)
                .padding()
                
                Spacer()
                
                Picker("Tempo", selection: $selectedTempoIndex) {
                    ForEach(Array(0..<tempos.count), id: \.self) { tempoIndex in
                        Text("\(tempos[tempoIndex])")
                    }
                }
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                .frame(width: 50, height: 30)
                .padding()
                
                Button(action: {
                    isPlayButtonPressed.toggle()
                    if isPlayButtonPressed {
                        tapTempoCalculator.stopMetronome()
                        let interval = 60.0 / Double(selectedTempo)
                        tapTempoCalculator.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                            WKInterfaceDevice.current().play(.start)
                        }
                    } else {
                        tapTempoCalculator.stopMetronome()
                    }
                }) {
                    Image(systemName: isPlayButtonPressed ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .frame(width: 50, height: 50)
                        .background(isPlayButtonPressed ? Color.orange : Color.green) // Change color here
                        .clipShape(Circle())
                }
                .scaleEffect(isPlayButtonPressed ? 0.9 : 1.0)
                .padding()
            }
            
            Button("Clear Tempo") {
                tapTempoCalculator.clearTapTimes()
                bpm = nil
            }
            .padding()
            .background(Color.red) // Set the button color
            .foregroundColor(.white) // Set the text color
            .clipShape(Capsule()) // Change the shape to an oval (capsule)
        }
        .padding()
    }
}

