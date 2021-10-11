//
//  MainViewController.swift
//  News
//
//  Created by Saffi on 2021/10/6.
//

import UIKit
import RxSwift

class MainViewController: UITableViewController {
    
    var disposeBag = DisposeBag()
    
    var viewModel = MainViewControllerVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Exam"
        self.setupTableView()
        self.registerCells()
        self.initBinding()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hex: 0x3C3391)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupTableView() {
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func registerCells() {
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
    }
    
    private func initBinding() {
        self.viewModel.reloadTable.subscribe(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.viewModel.numberOfRows(), let vm = self.viewModel.getNewsCellVM(indexPath: indexPath) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellIdentifier, for: indexPath)
        if let myCell = cell as? ImplementViewModelProtocol {
            myCell.setupViewModel(viewModel: vm)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
