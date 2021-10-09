//
//  NewsCell.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import UIKit
import SnapKit
import RxSwift

class NewsCell: BaseTableViewCell<NewsCellVM> {

    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var lblNewsTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.selectionStyle = .none

        self.addSubview(self.newsImage)
        self.addSubview(self.lblNewsTitle)
        
        self.newsImage.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        self.lblNewsTitle.snp.makeConstraints { make in
            make.leading.equalTo(newsImage.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(14)
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.image.distinctUntilChanged().bind(to: self.newsImage.rx.image).disposed(by: disposeBag)
        self.viewModel.title.distinctUntilChanged().bind(to: self.lblNewsTitle.rx.text).disposed(by: disposeBag)
    }
}
