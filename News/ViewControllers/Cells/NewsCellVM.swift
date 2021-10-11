//
//  NewsCellVM.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import Foundation
import RxSwift
import RxCocoa

protocol CellViewModelProtocol {
    var cellIdentifier: String { get }
    func updateContent(with model: Article)
}

class NewsCellVM: BaseViewModel, CellViewModelProtocol {
    
    var cellIdentifier: String = "NewsCell"
    
    let title: BehaviorRelay<String> = BehaviorRelay(value: "")
    let imageURL: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private(set) var article: Article?

    init(with model: Article) {
        super.init()
        self.article = model
        self.updateContent(with: model)
    }
    
    func updateContent(with model: Article) {
        self.title.accept(model.title)
        self.imageURL.accept(model.urlToImage)
    }
}
