//
//  MenuVC.swift
//  FlashCloud
//
//  Created by Đạt on 4/24/20.
//  Copyright © 2020 Dat. All rights reserved.
//

import UIKit

protocol MenuVCDelegate: AnyObject {
    func onButtonCloseTapped()
    func onItemTapped(index: Int)
}

class MenuVC: BaseVC {
    //MARK: - Properties
    weak var delegate: MenuVCDelegate!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: -Actions
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.delegate.onButtonCloseTapped()
    }
    
    @IBAction func itemTapped(_ sender: UIButton) {
        self.delegate.onItemTapped(index: sender.tag)
    }
}
