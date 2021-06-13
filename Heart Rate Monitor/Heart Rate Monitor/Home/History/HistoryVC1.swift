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
import Alamofire

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
    
    private lazy var exportPDFButton: UIButton = {
        let view = UIButton()
        view.setTitle("Export", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .clear
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        view.addTarget(self, action: #selector(exportPDFTapped), for: .touchUpInside)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: labelHeaderFilterView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exportPDFButton)
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
        
        tableView.rx.itemSelected
            .bind {[weak self] (indexPath) in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let model = self.viewModel.historyData.value[indexPath.row]
                var removedHistory = self.viewModel.historyData.value
                removedHistory.remove(at: indexPath.row)
                let vc = EditHistoryBottoSheetVC(heartRateHistory: model, leftAction: {[weak self] in
                    guard let self = self else { return }
                    self.viewModel.historyData.accept(removedHistory)
                    if UserDefaultHelper.getLogedUser() != nil && (NetworkReachabilityManager()?.isReachable ?? false) == true {
                        APIService.shared.deleteHistoryRates(by: [model.id ?? 0])
                            .subscribe(onSuccess: { (_) in
                                LocalDatabaseHandler.shared.deleteHistory(id: model.id ?? 0)
                            }, onError: { _ in })
                            .disposed(by: self.disposeBag)
                    }
                }) {[weak self] (label) in
                    guard let self = self else { return }
                    var model = self.viewModel.historyData.value[indexPath.row]
                    model.label = label
                    self.viewModel.data[indexPath.row] = model
                    self.viewModel.reloadLabels()
                    self.viewModel.filterData(with: self.labelHeaderFilterView.label.text ?? "ALL LABELS")
                    if UserDefaultHelper.getLogedUser() != nil && (NetworkReachabilityManager()?.isReachable ?? false) == true {
                        APIService.shared.updateHistoryLabel(remoteId: model.remoteId ?? "", label: label)
                            .subscribe { (_) in
                                model.isLabelUpdated = false
                                LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: model)
                                print("updated")
                            } onError: { (err) in
                                print("err: \(err)")
                            }
                            .disposed(by: self.disposeBag)
                    }
                }
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func filterButtonTapped() {
        tmpTextField.becomeFirstResponder()
    }
    
    override func didLogin() {
        super.didLogin()
        viewModel.reloadData(label: labelHeaderFilterView.label.text ?? "ALL LABELS")
    }
    
    override func didLogout() {
        super.didLogout()
        viewModel.reloadData(label: labelHeaderFilterView.label.text ?? "ALL LABELS")
    }
    
    // MARK: - Action
    @objc func exportPDFTapped() {
        guard tableView.visibleCells.count > 0 else { return }
        HHud.showHud()
        let currentContentOffset = tableView.contentOffset
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let iterationCount = Int(ceil(tableView.contentSize.height / tableView.bounds.size.height))
        for i in 0..<iterationCount {
            tableView.setContentOffset(CGPoint(x: 0, y: Int(tableView.bounds.size.height) * i), animated: false)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let pdfImageView = UIImageView(image: image)
        let pdfData: NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfImageView.bounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfImageView.bounds, nil)
        pdfImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()
        DispatchQueue.global().async {[unowned self] in
            let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let documentsFileName = documentDirectories! + "/" + "History.pdf"
            pdfData.write(toFile: documentsFileName, atomically: true)
            let fileURL = NSURL(fileURLWithPath: documentsFileName)
            var filesToShare = [Any]()
            filesToShare.append(fileURL)
            DispatchQueue.main.async {
                self.tableView.setContentOffset(currentContentOffset, animated: false)
                HHud.hideHud()
                let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
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
        viewModel.filterData(with: viewModel.allLabels[row])
    }
}




