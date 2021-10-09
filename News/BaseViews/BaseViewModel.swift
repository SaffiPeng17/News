//
//  BaseViewModel.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import Foundation

protocol ImplementViewModelProtocol: AnyObject {
    func setupViewModel(viewModel: BaseViewModel)
    func bindViewModel()
    func updateViews()
}

class BaseViewModel {
    init() {
        
    }
}
