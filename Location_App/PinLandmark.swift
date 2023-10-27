//
//  PinLandmark.swift
//  Location_App
//
//  Created by KU Kim on 2023/10/26.
//

import Foundation
import MapKit


enum PinLandmark: Int, CaseIterable {
    case Deoksugung = 100
    case Gyeongbokgung = 200
    case SeoulCityHall = 300
}

extension PinLandmark {
    
    var title: String {
        return "\(self)"
    }
    
    var id: Int {
        self.rawValue
    }
    
    // 좌표계
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .Deoksugung:
            return .init(latitude: 37.5658049, longitude: 126.9751461)
        case .Gyeongbokgung:
            return .init(latitude: 37.5662952, longitude: 126.9779451)
        case .SeoulCityHall:
            return .init(latitude: 37.5785635, longitude: 126.9769535)
        }
    }
    
    // 공식 사이트 링크
    var url: URL? {
        switch self {
        case .Deoksugung:
            return URL(string: "https://www.deoksugung.go.kr")
        case .Gyeongbokgung:
            return URL(string: "https://www.royalpalace.go.kr")
        case .SeoulCityHall:
            return URL(string: "https://www.seoul.go.kr")
        }
    }
    
    
}
