//
//  APIService.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Alamofire

class APIService {
    static let shared = APIService()
    private init() {}
    static let tag: String = "APIService"

    private var requestManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
    
    private lazy var baseUrl: String = {
        return Environment.configuration(key: .baseUrl)
    }()
}
