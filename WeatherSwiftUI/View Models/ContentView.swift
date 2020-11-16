//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    
    @ObservedObject private var weatherVM = WeatherViewModel()
    @State private var city: String = ""
    
    var body: some View {
        ZStack {
            Color.init(hex: "457B9D").ignoresSafeArea()
            VStack {
                if weatherVM.loadingState != .firstTime {
                    TextField("Search", text: self.$city, onEditingChanged: { _ in }, onCommit: {
                        self.weatherVM.fetchWeather(city: self.city)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                MainView(weatherVM: weatherVM)
            }.padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MainView: View {
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        
        Spacer()
        
        if self.weatherVM.loadingState == .loading {
            Text("Loading...")
                .foregroundColor(Color.white)
        } else if self.weatherVM.loadingState == .success {
            WeatherView(weather: self.weatherVM)
        } else if self.weatherVM.loadingState == .failed {
            Text(weatherVM.errorMessage).foregroundColor(.red)
            
        }
        Spacer()
        
    }
}

struct WeatherView: View {
    @ObservedObject var weather: WeatherViewModel
    var body: some View {
        VStack(spacing: 5) {
            Picker(selection: self.$weather.temperatureUnit, label: Text("Select a Unit")) {
                ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                    Text(unit.title)
                }
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            Text("\(weather.cityName)")
                .font(.system(size: 40))
                .foregroundColor(Color.white)
                .padding(.bottom)
            Text("\(weather.temperature)")
                .font(.system(size: 90))
                .foregroundColor(Color.white)
                .padding(.bottom)
            
            HStack(spacing: 10) {
                Text("H:\(weather.maxTemp)")
                    .foregroundColor(Color.white)
                    .opacity(0.8)
                    .font(.system(size: 28))
                Text("L:\(weather.minTemp)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 28))
                    .opacity(0.9)
            }
            Text("Humidity: \(weather.humidityVal)")
                .foregroundColor(Color.white)
                .font(.system(size: 28))
                .opacity(0.85)
            Spacer()
        }
        .padding()
        .frame(width: 350, height: 600)
        .background(Color.init(hex: "457B9D"))
        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



