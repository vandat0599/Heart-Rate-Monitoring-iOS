//
//  HomeContainerVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit

class HomeContainerVC: BaseVC, BottomBarViewDelegate {

    // MARK: - ui components
    lazy var bottomBar: BottomBarView = {
        let view = BottomBarView()
        view.backgroundColor = UIColor(named: "white-black")
        view.delegate = self
        view.selectedIndex = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - data & state
    private var showingVC: UINavigationController!
    private var vcArray: [UINavigationController] = []
    static let bottomInsetHeight: CGFloat = 24
    
    // MARK: - init
    init() {
        let homeVC = UINavigationController(rootViewController: HistoryVC())
        let notificationListVC = UINavigationController(rootViewController: HeartRateVC(viewModel: HeartRateVCVMImp()))
        let settingVC = UINavigationController(rootViewController: ProfileVC())
        vcArray = [
          homeVC,
          notificationListVC,
          settingVC,
        ]
        showingVC = vcArray[1]
        super.init(nibName: nil, bundle: nil)
        display(showingVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - setup
    private func setupViews() {
        view.backgroundColor = .clear
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(containerView)
        view.addSubview(bottomBar)
        let bottomBarBottomAnchor = bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomBarBottomAnchor.priority = UILayoutPriority(1000)
        let containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: HomeContainerVC.bottomInsetHeight)
        containerViewBottomAnchor.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarBottomAnchor,
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerViewBottomAnchor,
        ])
    }
    
    // MARK: - others
    
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
    
    // MARK: - actions
    func bottomBarViewDelegate(view: BottomBarView, selectedIndex index: Int) {
        guard index < vcArray.count, showingVC != vcArray[index] else {return}
        cycleVC(from: showingVC, to: vcArray[index])
        showingVC = vcArray[index]
    }
}
