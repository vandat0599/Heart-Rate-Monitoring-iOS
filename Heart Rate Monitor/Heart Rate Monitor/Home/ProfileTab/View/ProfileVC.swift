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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var heightPicker = UIPickerView()
    var weightPicker = UIPickerView()
    var agePicker = UIPickerView()
    var genderPicker = UIPickerView()
    var frequencyPicker = UIPickerView()
    var timePicker = UIDatePicker()
    let frequencyState = ["Daily", "Weekly", "Never"]
    
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
        
        timeProfileCell.keyLabel.text = "Time:"
        
        fillUserInfo(user: User(email: "nvan.1199@gmail.com", name: "Nguyễn Văn An", phoneNumber: "0987123456", gender: Gender.Male, height: 172, weight: 73, age: 22, relationships: ["Nguyễn Quốc Bảo", "Lê Ngọc Châu"]))
        frequencyProfileCell.valueTextView.text = frequencyState[0]
        timeProfileCell.valueTextView.text = "05:00 AM"
        
        saveButton.isHidden = true
        
        genderProfileCell.valueTextView.delegate = self
        heightProfileCell.valueTextView.delegate = self
        weightProfileCell.valueTextView.delegate = self
        ageProfileCell.valueTextView.delegate = self
        frequencyProfileCell.valueTextView.delegate = self
        timeProfileCell.valueTextView.delegate = self
        
        heightPicker.delegate = self
        weightPicker.delegate = self
        agePicker.delegate = self
        genderPicker.delegate  = self
        frequencyPicker.delegate = self
        
        heightPicker.dataSource = self
        weightPicker.dataSource = self
        agePicker.dataSource = self
        genderPicker.dataSource = self
        frequencyPicker.dataSource = self
        timePicker.datePickerMode = .time
    }

    func fillUserInfo(user: User) {
        nameLabel.text = user.name
        emailProfileCell.valueTextView.text = user.email
        phoneProfileCell.valueTextView.text = user.phoneNumber
        genderProfileCell.valueTextView.text = "\(user.gender)"
        heightProfileCell.valueTextView.text =  "\(user.height)"
        weightProfileCell.valueTextView.text =  "\(user.weight)"
        ageProfileCell.valueTextView.text = "\(user.age)"
        
        //add relationships into Relationships Stack View
        relationshipsStackView.sizeToFit()
        relationshipsStackView.translatesAutoresizingMaskIntoConstraints = false
        for relationship in user.relationships {
            let textLabel = UILabel()
            textLabel.backgroundColor = .clear
            textLabel.text = relationship
            textLabel.textAlignment = .left
            textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
            textLabel.backgroundColor = UIColor(named: "backgroundGray")
            textLabel.widthAnchor.constraint(equalToConstant: relationshipsStackView.frame.width).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
            
            relationshipsStackView.addArrangedSubview(textLabel)
        }
    }
    
    @IBAction func editButtonTouched(_ sender: Any) {
        editButton.isHidden = true
        saveButton.isHidden = false
        
        emailProfileCell.turnToEditMode()
        phoneProfileCell.turnToEditMode()
        genderProfileCell.turnToEditMode()
        heightProfileCell.turnToEditMode()
        weightProfileCell.turnToEditMode()
        ageProfileCell.turnToEditMode()
        frequencyProfileCell.turnToEditMode()
        timeProfileCell.turnToEditMode()
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        saveButton.isHidden = true
        editButton.isHidden = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        timeProfileCell.valueTextView.text = "\(dateFormatter.string(from: timePicker.date))"
        if let removable = timeProfileCell.valueTextView.viewWithTag(3){
            removable.removeFromSuperview()
         }
        
        
        emailProfileCell.turnToViewMode()
        phoneProfileCell.turnToViewMode()
        genderProfileCell.turnToViewMode()
        heightProfileCell.turnToViewMode()
        weightProfileCell.turnToViewMode()
        ageProfileCell.turnToViewMode()
        frequencyProfileCell.turnToViewMode()
        timeProfileCell.turnToViewMode()
    }
    
}


extension ProfileVC: UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.layer {
        case self.genderProfileCell.valueTextView.layer:
            genderProfileCell.valueTextView.inputView = genderPicker
        case self.heightProfileCell.valueTextView.layer:
            heightProfileCell.valueTextView.inputView = heightPicker
        case self.weightProfileCell.valueTextView.layer:
            weightProfileCell.valueTextView.inputView = weightPicker
        case self.ageProfileCell.valueTextView.layer:
            ageProfileCell.valueTextView.inputView = agePicker
        case self.frequencyProfileCell.valueTextView.layer:
            frequencyProfileCell.valueTextView.inputView = frequencyPicker
        case self.timeProfileCell.valueTextView.layer:
            timeProfileCell.valueTextView.addSubview(timePicker)
            timePicker.tag = 3
        default:
            print("////////Unknown")
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

extension ProfileVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case agePicker:
            return 150
        case genderPicker, frequencyPicker:
            return 3
        default: // heightPicker & weightPicker
            return 200
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPicker:
            return Gender(rawValue: row)?.description
        case frequencyPicker:
            return frequencyState[row]
        default: // agePicker, heightPicker & weightPicker
            return "\(row)"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPicker:
            genderProfileCell.valueTextView.text = Gender(rawValue: row)?.description
        case heightPicker:
            heightProfileCell.valueTextView.text = "\(row)"
        case weightPicker:
            weightProfileCell.valueTextView.text = "\(row)"
        case agePicker:
            ageProfileCell.valueTextView.text = "\(row)"
        case frequencyPicker:
            frequencyProfileCell.valueTextView.text = frequencyState[row]
        default:
            print("Selecting row in Picker failed.")
        }
    }
    
}
