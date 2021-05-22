//
//  Utils.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 22/05/2021.
//

import Foundation
import AVFoundation

class Utils {
    static func playLocalAudio(named: String, withExtension: String) {
        guard let startURL = Bundle.main.url(forResource: named, withExtension: withExtension) else { return }
        let player = try? AVAudioPlayer(contentsOf: startURL)
        player?.prepareToPlay()
        player?.play()
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    static func checkValidateField(email: String?, password: String?, passwordConf: String?,phoneNum: String?)->Int?{
        if email!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordConf!.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            return 1
        }
        if Utils.isValidEmail(email!.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
            return 2
        }
        
        if Utils.isPasswordValid(password!.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
            return 3
        }
        if (password!.trimmingCharacters(in: .whitespacesAndNewlines) != passwordConf!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return 4
        }
        return 0
    }
}
