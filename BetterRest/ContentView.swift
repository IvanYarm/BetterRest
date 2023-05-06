//
//  ContentView.swift
//  BetterRest
//
//  Created by Ivan Yarmoliuk on 5/4/23.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var cofeeAmount = 1
    
    @State private var alertTitle = "Your ideal time is..."
//    @State private var alertMessage = ""
    @State private var showingAlert = false
    
   static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var calculateBadtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            // some more code
            let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (component.hour ?? 0) * 60 * 60
            let minutes = (component.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minutes), estimatedSleep: sleepAmount, coffee: Double(cofeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            var newMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            return newMessage
        } catch {
            alertTitle = "Error"
    
        }
        return "Sorry, problem calculating your bedtime."
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                
               Section("When do you want to wake up?") {
                   DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                       
        
                        
               }
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desire anount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker("How many cups", selection: $cofeeAmount) {
                        ForEach(0..<11) {
                            Text("\($0)" + " Coffee")
                        }
                    }
//                    Stepper(cofeeAmount == 1 ? "Cup" : "\(cofeeAmount) cups", value: $cofeeAmount, in: 1...10)
                }
                
                Section {
                    Text(calculateBadtime)
                } header: {
                    Text(alertTitle)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("BetterRest")
            
        }
    
    }
    
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
