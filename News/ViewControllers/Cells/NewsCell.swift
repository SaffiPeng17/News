//
//  NewsCell.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import UIKit
import RxSwift
import Kingfisher

class NewsCell: BaseTableViewCell<NewsCellVM> {

    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var lblNewsTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
        self.lblNewsTitle.text = ""
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.selectionStyle = .none

        self.addSubview(self.newsImage)
        self.addSubview(self.lblNewsTitle)
        
        self.newsImage.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        self.lblNewsTitle.snp.makeConstraints { make in
            make.leading.equalTo(newsImage.snp.trailing).offset(12)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(14)
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.title.bind(to: self.lblNewsTitle.rx.text).disposed(by: disposeBag)
        self.viewModel.imageURL.subscribe(onNext: { [weak self] imageURL in
            guard !imageURL.isEmpty, let url = URL(string: imageURL) else {
                return
            }
            let resource = ImageResource(downloadURL: url, cacheKey: imageURL)
            self?.newsImage.kf.setImage(with: resource, placeholder: UIImage(named: "news"))
        }).disposed(by: disposeBag)
    }
}
