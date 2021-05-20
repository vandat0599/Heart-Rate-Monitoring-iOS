//
//  ContainerVC.swift
//  FlashCloud
//
//  Created by Đạt on 4/24/20.
//  Copyright © 2020 Dat. All rights reserved.
//

import UIKit

class ContainerVC: BaseVC, MenuVCDelegate {
    //MARK: - Properties
    var isSHowingMenu = false
    private var showingVC: UINavigationController!
    private var vcArray: [UINavigationController] = []
    
    private lazy var measureVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HeartRateVC(viewModel: HeartRateVCVMImp()))
        return vc
    }()
    
    private lazy var statVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HistoryVC())
        return vc
    }()
    
    private lazy var historyVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HistoryVC1(viewModel: HistoryVM()))
        return vc
    }()
    
    private lazy var menuVC: MenuVC = {
        let menuVC = MenuVC()
        menuVC.delegate = self
        return menuVC
    }()
    
    public lazy var menuButton: CustomRippleButton = {
        let button = CustomRippleButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setImage(UIImage(named: "ic-menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        button.imageView?.tintColor = .white
        return button
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tapView: UIControl = {
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        view.center = self.view.center
        view.addTarget(self, action: #selector(holderViewTapped), for: .touchUpInside)
        return view
    }()
    
    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        vcArray = [
            measureVC,
            statVC,
            historyVC,
        ]
        showingVC = vcArray[0]
        display(showingVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        view.insertSubview(menuVC.view, at: 0)
        menuVC.view.fitIn(parentView: view, padding: 0)
        addChild(menuVC)
        menuVC.didMove(toParent: self)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - setup
    
    private func display(_ child: UIViewController) {
        addChild(child)
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    private func hide(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    private func cycleVC(from oldVC: UIViewController, to newVC: UIViewController) {
        oldVC.willMove(toParent: nil)
        addChild(newVC)
        newVC.view.frame = containerView.bounds
        transition(from: oldVC, to: newVC, duration: 0.2, options: .transitionCrossDissolve, animations: {
        }, completion: { finished in
            oldVC.removeFromParent()
            newVC.didMove(toParent: self)
        })
    }
    
    private func showMenuVC(show: Bool, completion: (() -> Void)?) {
        if show {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.containerView.frame.origin.x = self.containerView.frame.width*0.6
                self.menuVC.view.transform = .identity
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.containerView.transform = .identity
                self.containerView.frame.origin.x = 0
            }, completion: {(_) in
                completion?()
            })
        }
    }
    
    @objc private func menuTapped() {
        toggleMenu()
    }
    
    @objc private func holderViewTapped() {
        toggleMenu()
    }
    
    func toggleMenu() {
        isSHowingMenu.toggle()
        if isSHowingMenu {
            menuButton.setImage(UIImage(named: "ic-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
            containerView.addSubview(tapView)
        } else {
            menuButton.setImage(UIImage(named: "ic-menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
            tapView.removeFromSuperview()
        }
        showMenuVC(show: isSHowingMenu, completion: nil)
    }
    
    func onButtonCloseTapped() {
        toggleMenu()
    }
    
    func onItemTapped(index: Int) {
        guard index <= vcArray.count, showingVC != vcArray[index - 1] else {
            toggleMenu()
            return
        }
        toggleMenu()
        cycleVC(from: showingVC, to: vcArray[index - 1])
        showingVC = vcArray[index - 1]
    }
}
