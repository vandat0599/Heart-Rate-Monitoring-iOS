//
//  ProfileVC.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 21/03/2021.
//

import UIKit

class ProfileVC: BaseVC {
    
    //Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailProfileCell: ProfileCell!
    @IBOutlet weak var phoneProfileCell: ProfileCell!
    @IBOutlet weak var genderProfileCell: ProfileCell!
    @IBOutlet weak var heightProfileCell: ProfileCell!
    @IBOutlet weak var weightProfileCell: ProfileCell!
    @IBOutlet weak var ageProfileCell: ProfileCell!
    @IBOutlet weak var frequencyProfileCell: ProfileCell!
    @IBOutlet weak var timeProfileCell: ProfileCell!
    @IBOutlet weak var relationshipsStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Personal"
        
        setupView()
    }
    
    private func setupView() {
        emailProfileCell.keyLabel.text = "Email:"
        phoneProfileCell.keyLabel.text = "Phone:"
        
        genderProfileCell.keyLabel.text = "Gender:"
        heightProfileCell.keyLabel.text = "Height:"
        weightProfileCell.keyLabel.text = "Weight:"
        ageProfileCell.keyLabel.text = "Age:"
        
        frequencyProfileCell.keyLabel.text = "Frequency:"
        frequencyProfileCell.valueLabel.text = "Daily"
        
        timeProfileCell.keyLabel.text = "Time:"
        timeProfileCell.valueLabel.text = "09:00"
        
        fillUserInfo(user: User(email: "nvan.1199@gmail.com", name: "Nguyễn Văn An", phoneNumber: "0987123456", gender: Gender.Male, height: 172, weight: 73, age: 22, relationships: ["Nguyễn QUốc Bảo", "Lê Ngọc Châu"]))
    }

    func fillUserInfo(user: User) {
        nameLabel.text = user.name
        emailProfileCell.valueLabel.text = user.email
        phoneProfileCell.valueLabel.text = user.phoneNumber
        genderProfileCell.valueLabel.text = "\(user.gender)"
        heightProfileCell.valueLabel.text = "\(user.height)"
        weightProfileCell.valueLabel.text = "\(user.weight)"
        ageProfileCell.valueLabel.text = "\(user.age)"
        
        //add relationships into Relationships Stack View
    }
}
