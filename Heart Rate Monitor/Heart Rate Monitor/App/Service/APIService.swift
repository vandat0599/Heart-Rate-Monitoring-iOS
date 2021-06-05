//
//  APIService.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Alamofire
import RxSwift

class APIService {
    static let shared = APIService()
    private init() {}
    static let tag = "APIService"

    private var requestManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
    
    var headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "*/*"
    ]
    
    func getAccessToken() -> String {
        UserDefaultHelper.getLogedUser()?.accessToken ?? ""
    }
    
    func getHeader() -> HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "token": getAccessToken()
        ]
    }
    
    private var baseUrl: String = {
        return Environment.configuration(key: .baseUrl)
    }()
    
    private var disposeBag = DisposeBag()
    
    func login(username: String, password: String) -> Single<User> {
        Single.create { (single) -> Disposable in
            let params: [String: Any] = [
                "email": username,
                "password": password,
            ]
            AF.request("\(self.baseUrl)users/login",
                       method: .post,
                       parameters: params as Parameters,
                       encoding: JSONEncoding.default,
                       headers: self.headers)
                .responseDecodable(of: APIResponse<UserResponse>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard var user = data.data?.user, let token = data.data?.token else {
                            single(.error(HError.unknown))
                            return
                        }
                        user.accessToken = token
                        single(.success(user))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
            }
            return Disposables.create()
        }
    }
    
    func register(name: String, email: String, password: String) -> Single<User?> {
        Single.create { (single) -> Disposable in
            let params: [String: Any] = [
                "email": email,
                "name": name,
                "password": password
            ]
            AF.request("\(self.baseUrl)users/signup",
                       method: .post,
                       parameters: params as Parameters,
                       encoding: JSONEncoding.default,
                       headers: self.headers)
                .responseDecodable(of: APIResponse<User?>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard data.errorCode != 0 else {
                            single(.error(HError.unknown))
                            return
                        }
                        single(.success(nil))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func verifyRegister(email: String, password: String, otp: String) -> Single<User> {
        Single.create { (single) -> Disposable in
            let params: [String: Any] = [
                "email": email,
                "password": password,
                "otpCode": otp
            ]
            AF.request("\(self.baseUrl)users/otp",
                       method: .post,
                       parameters: params as Parameters,
                       encoding: JSONEncoding.default,
                       headers: self.headers)
                .responseDecodable(of: APIResponse<UserResponse>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard var user = data.data?.user, let token = data.data?.token else {
                            single(.error(HError.unknown))
                            return
                        }
                        user.accessToken = token
                        single(.success(user))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
            }
            return Disposables.create()
        }
    }
    
    func sendOtpResetPassword(email: String) -> Single<User?> {
        Single.create { (single) -> Disposable in
            let params: [String: Any] = [
                "email": email
            ]
            AF.request("\(self.baseUrl)users/forgotpw",
                       method: .post,
                       parameters: params as Parameters,
                       encoding: JSONEncoding.default,
                       headers: self.headers)
                .responseDecodable(of: APIResponse<User?>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard data.errorCode != 0 else {
                            single(.error(HError.unknown))
                            return
                        }
                        single(.success(nil))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func changePasswordWithOTP(email: String, password: String, otp: String) -> Single<User> {
        Single.create { (single) -> Disposable in
            let params: [String: Any] = [
                "email": email,
                "password": password,
                "otpCode": otp,
                "case": 1
            ]
            print(params)
            AF.request("\(self.baseUrl)users/otp",
                       method: .post,
                       parameters: params as Parameters,
                       encoding: JSONEncoding.default,
                       headers: self.headers)
                .responseDecodable(of: APIResponse<UserResponse>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard var user = data.data?.user, let token = data.data?.token else {
                            single(.error(HError.unknown))
                            return
                        }
                        user.accessToken = token
                        single(.success(user))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func postHeartRate(heartRates: [HeartRateHistory]) -> Single<[HeartRateHistory]> {
        return Single.create { (single) -> Disposable in
            let params: [String: Any] = [
                "rates": Array(heartRates).map {[
                            "local_id": $0.id ?? 0,
                            "grapValues": $0.grapValues,
                            "heartRateNumber": $0.heartRateNumber ?? 0,
                            "label": $0.label ?? "",
                            "createDate": $0.createDate ?? "",
                            "isSubmitted": $0.isSubmitted ?? false
                        ]}
            ]
            print("params: \(params)")
            AF.request("\(self.baseUrl)rates/arr",
                       method: .post,
                       parameters: params as Parameters,
                       encoding: JSONEncoding.default,
                       headers: self.getHeader())
                .responseDecodable(of: APIResponse<[HeartRateHistory]>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard let rates = data.data else {
                            single(.error(HError.unknown))
                            return
                        }
                        single(.success(rates))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func getHeartRates(limitDay: Int = 999999999999) -> Single<[HeartRateHistory]> {
        return Single.create { (single) -> Disposable in
            AF.request("\(self.baseUrl)rates?limitDay=\(limitDay)",
                       method: .get,
                       headers: self.getHeader())
                .responseDecodable(of: APIResponse<[HeartRateHistory]>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard let rates = data.data else {
                            single(.error(HError.unknown))
                            return
                        }
                        single(.success(rates))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
                }
            return Disposables.create()
        }
    }
}
