//
//  HistoryVC1.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class HistoryVC1: BaseVC, UIPickerViewDelegate, UIPickerViewDataSource {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "black-background")
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.contentInsetAdjustmentBehavior = .never
        view.separatorStyle = .singleLine
        view.registerWithClassName(cellType: HistoryTableViewCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelHeaderFilterView: LabelPickerView = {
        let view = LabelPickerView()
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var labelPickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var tmpTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.inputView = labelPickerView
        return view
    }()
    
    private var viewModel: HistoryVM!
    
    init(viewModel: HistoryVM) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData(label: labelHeaderFilterView.label.text ?? "ALL LABELS")
    }
    
    func setupView() {
        navigationItem.titleView = labelHeaderFilterView
        view.backgroundColor = UIColor(named: "black-background")
        view.addSubview(tmpTextField)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    func bindView() {
        viewModel.historyData
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: tableView.rx.items(cellIdentifier: HistoryTableViewCell.className)) {
                (index: Int, model: HeartRateHistory, cell: HistoryTableViewCell) in
                cell.setData(model: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HeartRateHistory.self)
            .bind { (model) in
                let vc = EditHistoryBottoSheetVC(heartRateHistory: model)
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind {[weak self] (indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.of(LocalDatabaseHandler.shared.didInsertHistory, LocalDatabaseHandler.shared.didUpdateHistory, LocalDatabaseHandler.shared.didDeleteHistory).merge()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind { [weak self] (_) in
                guard let self = self else { return }
                self.viewModel.reloadData(label: self.labelHeaderFilterView.label.text ?? "ALL LABELS")
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func filterButtonTapped() {
        tmpTextField.becomeFirstResponder()
    }
    
    // MARK: - Action
    
    // UIPicker Delegate & Datasource
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.allLabels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.allLabels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelHeaderFilterView.label.text = viewModel.allLabels[row]
        viewModel.reloadData(label: viewModel.allLabels[row])
    }
}




