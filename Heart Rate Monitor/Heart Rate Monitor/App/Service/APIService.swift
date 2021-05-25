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
    
    private var baseUrl: String = {
        return Environment.configuration(key: .baseUrl)
    }()
    
    private var disposeBag = DisposeBag()
    
    func login(username: String, password: String) -> Single<User> {
        Single.create { (single) -> Disposable in
            let params = [
                "userName": username,
                "password": password,
            ]
            AF.request("\(self.baseUrl)login/user_login", method: .post, parameters: params as Parameters)
                .validate()
                .responseDecodable(of: APIResponse<User>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard let user = data.data else {
                            single(.error(HError.unknown))
                            return
                        }
                        single(.success(user))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
            }
            return Disposables.create()
        }
    }
    
    func register(email: String, phoneNumber: String, password: String) -> Single<User> {
        Single.create { (single) -> Disposable in
            let params = [
                "email": email,
                "phoneNumber": phoneNumber,
                "password": password
            ]
            AF.request("\(self.baseUrl)login/user_register", method: .post, parameters: params as Parameters)
                .validate()
                .responseDecodable(of: APIResponse<User>.self) { res in
                    HLog.log(tag: APIService.tag, res.result)
                    switch res.result {
                    case .success(let data):
                        guard let user = data.data else {
                            single(.error(HError.unknown))
                            return
                        }
                        single(.success(user))
                    case .failure(let error):
                        single(.error(HError.init(code: error.responseCode, message: error.localizedDescription)))
                    }
            }
            return Disposables.create()
        }
    }
    
    func login1(username: String, password: String,completion : @escaping (_ result : APIResponsed)->()){
        
        let parameter: [String: String] = [
            "email": username,
            "password": password
        ]
        var result = APIResponsed()
        AF.request("\(self.baseUrl)/api/users/login", method: .post, parameters: parameter,encoder: JSONParameterEncoder.default).responseJSON { response in
                //debugPrint(response)
                guard let data = response.data else { return }
                            do {
                                let apiResponse = try JSONDecoder().decode(APIResponsed.self, from: data)
                                result = apiResponse
                                completion(result)
                            } catch let error {
                                print(error)
                            }
        }
    }
    
    func register1(username: String, password: String, phoneNumber: String,completion : @escaping (_ result : APIResponsed)->()){
        let parameter: [String: String] = [
            "email": username,
            "password": password,
            "phoneNumber": phoneNumber
        ]
        var result = APIResponsed()
        AF.request("\(self.baseUrl)/api/users/signup", method: .post, parameters: parameter,encoder: JSONParameterEncoder.default).responseJSON { response in
                //debugPrint(response)
                guard let data = response.data else { return }
                        do {
                            let apiResponse = try JSONDecoder().decode(APIResponsed.self, from: data)
                            result = apiResponse
                            completion(result)
                        } catch let error {
                            print(error)
                        }
        }
    }
    
    func authOtpCode(username: String, password: String,otpCode : String,caseOTP: String,completion : @escaping (_ result : APIResponsed)->()){
        let parameter: [String: String] = [
            "email": username,
            "password": password,
            "otpCode": otpCode,
            "case": caseOTP // 1 : resetpassword
        ]
        var result = APIResponsed()
        AF.request("\(self.baseUrl)/api/users/otp", method: .post, parameters: parameter,encoder: JSONParameterEncoder.default).responseJSON { response in
                //debugPrint(response)
                guard let data = response.data else { return }
                        do {
                            let apiResponse = try JSONDecoder().decode(APIResponsed.self, from: data)
                            result = apiResponse
                            completion(result)
                        } catch let error {
                            print(error)
                        }
        }
    }
    
    func resendOtpCode(username: String,completion : @escaping (_ result : APIResponsed)->()){
        let parameter: [String: String] = [
            "email": username
        ]
        var result = APIResponsed()
        AF.request("\(self.baseUrl)/api/users/resendOTP", method: .post, parameters: parameter,encoder: JSONParameterEncoder.default).responseJSON { response in
                //debugPrint(response)
                guard let data = response.data else { return }
                        do {
                            let apiResponse = try JSONDecoder().decode(APIResponsed.self, from: data)
                            result = apiResponse
                            completion(result)
                        } catch let error {
                            print(error)
                        }
        }
    }
    
    func forgotPassword(username: String,completion : @escaping (_ result : APIResponsed)->()){
        let parameter: [String: String] = [
            "email": username
        ]
        var result = APIResponsed()
        AF.request("\(self.baseUrl)/api/users/forgotpw", method: .post, parameters: parameter,encoder: JSONParameterEncoder.default).responseJSON { response in
                //debugPrint(response)
                guard let data = response.data else { return }
                        do {
                            let apiResponse = try JSONDecoder().decode(APIResponsed.self, from: data)
                            result = apiResponse
                            completion(result)
                        } catch let error {
                            print(error)
                        }
        }
    }
    
    
    func changePassword(username: String,password: String,completion : @escaping (_ result : APIResponsed)->()){
        let parameter: [String: String] = [
            "email": username,
            "password": password
        ]
        var result = APIResponsed()
        AF.request("\(self.baseUrl)/api/users/changepassword", method: .post, parameters: parameter,encoder: JSONParameterEncoder.default).responseJSON { response in
                //debugPrint(response)
                guard let data = response.data else { return }
                        do {
                            let apiResponse = try JSONDecoder().decode(APIResponsed.self, from: data)
                            result = apiResponse
                            completion(result)
                        } catch let error {
                            print(error)
                        }
        }
    }
}
