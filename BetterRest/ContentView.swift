//
//  ContentView.swift
//  BetterRest
//
//  Created by Marcus Stilwell on 7/21/21.
//

import SwiftUI



struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    

    
    func calculateBedtime() -> String{
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
            
        } catch {
            return  "Sorry, there was a problem calculating your bedtime."
        }
        
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
            }
                Section(header: Text("Desired amount of sleep")){
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")){
                    Picker("Number of cups", selection: $coffeeAmount){
                        ForEach(1 ..< 21){
                            if $0 == 0 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }
                    
                        if coffeeAmount == 0 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount + 1) cups")
                        }
                
                }

                Section(header: Text("Your ideal bedtime is").font(.title2)){
                    Text(calculateBedtime())
                        .font(.title)
                }
            }
            .navigationBarTitle("BetterRest")
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
