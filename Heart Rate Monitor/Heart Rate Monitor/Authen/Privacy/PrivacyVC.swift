//
//  PrivacyVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Vo on 6/2/21.
//

import UIKit
import WebKit

final class PrivacyVC: UIViewController {
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.allowsLinkPreview = true
        view.load(URLRequest(url: URL(string: "https://hcmus2021.github.io/Heart-Rate-Monitor-iOS-privacy/")!))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var closeButton: CustomRippleButton = {
        let view = CustomRippleButton()
        view.setImage(UIImage(named: "ic-arrow-down"), for: .normal)
        view.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        view.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.title = "Privacy Policy"
        view.backgroundColor = UIColor(named: "black-background")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor(named: "black-background")
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
