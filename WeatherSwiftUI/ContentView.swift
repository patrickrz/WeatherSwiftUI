//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import SwiftUI

struct ContentView: View {
    
    
    @ObservedObject private var weatherVM = WeatherViewModel()
    @State private var city: String = ""
    
    init(weather: WeatherViewModel = WeatherViewModel()) {
            self.weatherVM = weatherVM
        }
    
    var body: some View {
        VStack {
            TextField("Search", text: self.$city, onEditingChanged: { _ in }, onCommit: {
                self.weatherVM.fetchWeather(city: self.city)
            }).textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            if self.weatherVM.loadingState == .loading {
                Text("Loading...")
            } else if self.weatherVM.loadingState == .success {
                WeatherView(weather: self.weatherVM)
            } else if self.weatherVM.loadingState == .failed {
                Text(weatherVM.errorMessage).foregroundColor(.red)

            }
            Spacer()
          
//            .onAppear() {
//                Probably need onAppear to be current weather!
//                self.weatherVM.fetchWeather()
//            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherView: View {
    @ObservedObject var weather: WeatherViewModel
    var body: some View {
        VStack(spacing: 10) {
            Text("\(weather.temperature)")
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Text("\(weather.humidityVal)")
                .foregroundColor(Color.white)
                .opacity(0.7)
            Picker(selection: self.$weather.temperatureUnit, label: Text("Select a Unit")) {
                ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                    Text(unit.title)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .frame(width: 300, height: 600)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
        
    }

}


