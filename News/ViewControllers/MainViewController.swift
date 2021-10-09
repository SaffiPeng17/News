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
        // Do any additional setup after loading the view.
        self.title = "News"
        self.setupTableView()
        self.registerCells()
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
        if let mCell = cell as? ImplementViewModelProtocol {
            mCell.setupViewModel(viewModel: vm)
        }
        return cell
    }
}

private extension MainViewController {

    func setupTableView() {
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func registerCells() {
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hex: 0x3C3391)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
