//
//  BaseVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import UIKit

class BaseVC: UIViewController {
    
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    
    lazy var centerXView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var centerYView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(centerXView)
        view.addSubview(centerYView)
        NSLayoutConstraint.activate([
            centerXView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerXView.heightAnchor.constraint(equalToConstant: 1),
            centerXView.widthAnchor.constraint(equalToConstant: 0),
            
            centerYView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerYView.heightAnchor.constraint(equalToConstant: 0),
            centerYView.widthAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setupNavigationBar() {
        
    }
}
