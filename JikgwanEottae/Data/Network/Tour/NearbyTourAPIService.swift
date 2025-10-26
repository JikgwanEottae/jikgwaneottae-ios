//
//  NearbyTourAPIService.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Moya

enum NearbyTourAPIService {
    case fetchNearbyTourPlace(team: String)
}

extension NearbyTourAPIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.jikgwaneottae.xyz")!
    }
    
    var path: String {
        switch self {
        case .fetchNearbyTourPlace(let team):
            return "/api/attractions/\(team)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
