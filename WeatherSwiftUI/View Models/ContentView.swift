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
//    @State private var locationManager = LocationManager()
    @State private var city: String = ""
    
    
    
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                
//                if self.weatherVM.loadingState == .firstTime {
//                    self.weatherVM.fetchWeather(city: self.weatherVM.fetchInitial())
//                }
                if weatherVM.loadingState != .firstTime {
                    TextField("Search", text: self.$city, onEditingChanged: { _ in }, onCommit: {
                        self.weatherVM.fetchWeather(city: self.city)
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
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
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            Text("\(weather.temperature)")
                .font(.largeTitle)
                .foregroundColor(Color.white)
            
            HStack(spacing: 10) {
                Text("H:\(weather.maxTemp)")
                    .foregroundColor(Color.white)
                Text("L:\(weather.minTemp)")
                    .foregroundColor(Color.white)
            }
            Text("Humidity: \(weather.humidityVal)")
                .foregroundColor(Color.white)
                .opacity(0.7)
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 600)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))

    }
}



