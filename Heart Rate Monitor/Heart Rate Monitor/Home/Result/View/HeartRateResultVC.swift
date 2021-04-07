//
//  HeartRateResultVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 31/03/2021.
//

import UIKit

class HeartRateResultVC: BasePresentVC {
    
    @IBOutlet weak var heartRateNumberLabel: UILabel!
    @IBOutlet weak var normalControl: HeartRateStateView!
    @IBOutlet weak var runningControl: HeartRateStateView!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    private var viewModel: HeartRateResultVM
    
    init(viewModel: HeartRateResultVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "white-black")
        navigationItem.title = "Result"
        normalControl.titlelabel.text = "Normal"
        normalControl.isSelected = true
        normalControl.iconImageView.image = UIImage(named: "ic-person-normal")?.withRenderingMode(.alwaysTemplate)
        normalControl.isUserInteractionEnabled = true
        let normalControlTapped = UITapGestureRecognizer(target: self, action: #selector(normalControlTapped(_:)))
        normalControl.addGestureRecognizer(normalControlTapped)
        
        runningControl.titlelabel.text = "Active"
        runningControl.isSelected = false
        runningControl.iconImageView.image = UIImage(named: "ic-person-running")?.withRenderingMode(.alwaysTemplate)
        runningControl.isUserInteractionEnabled = true
        let runningControlTapped = UITapGestureRecognizer(target: self, action: #selector(runningControlTapped(_:)))
        runningControl.addGestureRecognizer(runningControlTapped)
    }
    
    private func bindView() {
        viewModel.heartRateRecord
            .bind { (value) in
                self.heartRateNumberLabel.text = "\(value.value ?? 0)"
                self.noteTextField.text = value.note ?? ""
            }
            .disposed(by: disposeBag)
    }
    @objc private func normalControlTapped(_ sender: Any) {
        normalControl.isSelected = true
        runningControl.isSelected = false
    }
    
    @objc private func runningControlTapped(_ sender: Any) {
        runningControl.isSelected = true
        normalControl.isSelected = false
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
}
