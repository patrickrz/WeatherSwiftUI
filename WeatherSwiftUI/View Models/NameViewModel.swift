//
//  NameViewModel.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/12/20.
//

//import Foundation
//
//class NameViewModel: ObservableObject {
//    
//    @Published private var sysModel: SysModel?
// 
//    
//    var cityName: String {
//        guard let name = sysModel?.name else {
//            return "error wtf"
//        }
//        return name
//    }
//    
//    
//    func fetchName(city: String) {
//        
//        guard let city = city.spaceCheck() else {
//            return
//        }
//                
//        NameService().getName(city: city) { result1 in
//            switch result1 {
//            case .success(let receivedModel):
//                DispatchQueue.main.async {
//                    self.sysModel = receivedModel
//                }
//                
//            case .failure(_ ):
//                DispatchQueue.main.async {
//                    return
//                }
//                
//            }
//        }
//    }
//
//    
//}
