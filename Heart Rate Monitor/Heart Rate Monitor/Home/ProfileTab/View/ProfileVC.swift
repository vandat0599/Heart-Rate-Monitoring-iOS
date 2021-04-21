//
//  ProfileVC.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 21/03/2021.
//

import UIKit

protocol addNewRelationship {
    func addNewRelationshipTouched(email: String)
}

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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var relationshipTableView: UITableView!
    @IBOutlet weak var relationshipTableHeightConstraint: NSLayoutConstraint!
    
    
    var heightPicker = UIPickerView()
    var weightPicker = UIPickerView()
    var agePicker = UIPickerView()
    var genderPicker = UIPickerView()
    var frequencyPicker = UIPickerView()
    var timePicker = UIDatePicker()
    let frequencyState = ["Daily", "Weekly", "Never"]
    
    var fakeUser = User(
        id: "asdfffd",
        name: "Lý Em",
        email: "emly@gmail.com",
        phoneNumber: "01235463738",
        address: "222 Cách Mạng Tháng 8, Quận 10, TPHCM")
    
    var relationships = [
        "Ngô Huy Biên 1",
        "Ngô Huy Biên 2",
        "Ngô Huy Biên 3",
        "Ngô Huy Biên 4",
        "Ngô Huy Biên 5",
        "Ngô Huy Biên 6",
    ]
    
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
        
        UNUserNotificationCenter.current().delegate = self
        
        relationshipTableView.register(RelationshipTableViewCell.nib, forCellReuseIdentifier: RelationshipTableViewCell.identifier)
        relationshipTableView.register(InputRelationshipTableViewCell.nib, forCellReuseIdentifier: InputRelationshipTableViewCell.identifier)
        relationshipTableView.delegate = self
        relationshipTableView.dataSource = self
        relationshipTableHeightConstraint.constant = 42 * CGFloat(relationships.count)
        relationshipTableView.layoutIfNeeded()
        relationshipTableView.separatorColor = view.backgroundColor
        relationshipTableView.separatorStyle = .singleLine
        relationshipTableView.allowsSelection = false
        
        fillUserInfo(user: fakeUser)
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
        genderProfileCell.valueTextView.text = "user gender"
        heightProfileCell.valueTextView.text =  "170"
        weightProfileCell.valueTextView.text =  "45kg"
        ageProfileCell.valueTextView.text = "25"
        relationshipTableView.sizeToFit()
        
    }
    
    @IBAction func editButtonTouched(_ sender: Any) {
        editButton.isHidden = true
        editButton.isEnabled = false
        saveButton.isHidden = false
        saveButton.isEnabled = true
        
        emailProfileCell.turnToEditMode()
        phoneProfileCell.turnToEditMode()
        genderProfileCell.turnToEditMode()
        heightProfileCell.turnToEditMode()
        weightProfileCell.turnToEditMode()
        ageProfileCell.turnToEditMode()
        frequencyProfileCell.turnToEditMode()
        timeProfileCell.turnToEditMode()
        
        relationshipTableHeightConstraint.constant += 42
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        saveButton.isHidden = true
        saveButton.isEnabled = false
        editButton.isHidden = false
        editButton.isEnabled = true
        
        if frequencyProfileCell.valueTextView.text == "Never" {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["frequencyReminder"])
        } else {
            registerReminder()
        }
        
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
        
        relationshipTableHeightConstraint.constant -= 42
    }
    
    func registerReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Time to measure your heart rate."
//        content.badge = 1
        content.categoryIdentifier = "frequencyReminder"
        
        let time = timePicker.date
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = time.hour
        dateComponents.minute = time.minute
        dateComponents.weekday = (frequencyProfileCell.valueTextView.text == "Weekly") ? Calendar.current.component(.weekday, from: time) : nil
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let requestIdentifier = "frequencyReminder"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let err = error {
                print(err.localizedDescription)
            }
        })
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
//            timePicker.trailingAnchor.constraint(equalTo: timeProfileCell.valueTextView.trailingAnchor).isActive = true
            timePicker.trailingAnchor.constraint(equalTo: timeProfileCell.valueTextView.trailingAnchor, constant: 0).isActive = true
            timePicker.centerYAnchor.constraint(equalTo: timeProfileCell.valueTextView.centerYAnchor).isActive = true
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

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return relationships.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RelationshipTableViewCell.identifier, for: indexPath) as! RelationshipTableViewCell
            cell.bindData(name: relationships[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InputRelationshipTableViewCell.identifier, for: indexPath) as! InputRelationshipTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editButton.isHidden
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete: \(relationships[indexPath.row])")
            relationships.remove(at: indexPath.row)
            tableView.reloadData()
            relationshipTableHeightConstraint.constant -= 42
            tableView.layoutIfNeeded()
        }
    }
}

extension ProfileVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .banner])
        } else {
            completionHandler([.sound, .alert])
        }
    }
}

extension ProfileVC: addNewRelationship {
    func addNewRelationshipTouched(email: String) {
        if email != "" {
            //Check email valid
            //Get Fullname of user
            relationships.append(email)
            relationshipTableView.reloadData()
            relationshipTableHeightConstraint.constant += 42
        }
    }
    
    
}

