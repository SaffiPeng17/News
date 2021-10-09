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
    func updateContent(with model: NewsCellModel)
}

struct NewsCellModel {
    var image: UIImage?
    var title: String
}

class NewsCellVM: BaseViewModel, CellViewModelProtocol {
    
    var cellIdentifier: String = "NewsCell"
    
    let image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let title: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private(set) var newsModel: NewsCellModel?

    init(with model: NewsCellModel) {
        super.init()
        self.newsModel = model
        self.updateContent(with: model)
    }
    
    func updateContent(with model: NewsCellModel) {
        self.image.accept(model.image)
        self.title.accept(model.title)
    }
}
