//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/10/20.
//

import SwiftUI

struct ContentView: View {
    
    
    @ObservedObject private var weatherVM = WeatherViewModel()
    @ObservedObject private var nameVM = NameViewModel()
    @State private var locationManager = LocationManager()
    @State private var city: String = ""
    
    init(weather: WeatherViewModel = WeatherViewModel()) {
            self.weatherVM = weatherVM
        }
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                if self.weatherVM.loadingState == .firstTime {
                    self.weatherVM.fetchWeather(city: self.weatherVM.fetchInitial())
                }
                else {
                    TextField("Search", text: self.$city, onEditingChanged: { _ in }, onCommit: {
                        self.weatherVM.fetchWeather(city: self.city)
                        self.nameVM.fetchName(city: self.city)
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                }
            
            
            MainView(weatherVM: weatherVM, nameVM: nameVM)
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
    @ObservedObject var nameVM: NameViewModel

    var body: some View {
        
            Spacer()

            if self.weatherVM.loadingState == .loading {
                Text("Loading...")
            } else if self.weatherVM.loadingState == .success {
                WeatherView(weather: self.weatherVM, name: nameVM)
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
    @ObservedObject var name: NameViewModel
    var body: some View {
        VStack(spacing: 5) {
            Picker(selection: self.$weather.temperatureUnit, label: Text("Select a Unit")) {
                ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                    Text(unit.title)
                }
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            Text("\(name.cityName)")
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
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))

    }
}



