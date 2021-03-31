//
//  HeartRateResultVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 31/03/2021.
//

import UIKit

class HeartRateResultVC: BasePresentVC {
    
    @IBOutlet weak var heartRateNumberLabel: UILabel!
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
        navigationItem.title = "Result"
        bindView()
    }
    
    private func bindView() {
        viewModel.heartRateResultNumber
            .bind { (value) in
                self.heartRateNumberLabel.text = "\(value)"
            }
            .disposed(by: disposeBag)
    }
}
