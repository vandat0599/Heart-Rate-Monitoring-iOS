//
//  InputRelationshipTableViewCell.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 01/04/2021.
//

import UIKit

class InputRelationshipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate : addNewRelationship?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor(named: "backgroundGray")
        
        emailTextField.borderColor = .clear
        emailTextField.backgroundColor = .clear
        emailTextField.placeholder = "Your relationship's email"
        emailTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        
        Gradient.diagonal(addButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func addButtonTouched(_ sender: Any) {
        delegate?.addNewRelationshipTouched(email: emailTextField.text ?? "")
        emailTextField.text = ""
    }
}
