//
//  NormalCollectionViewCell.swift
//  TVMOVE
//
//  Created by 김시종 on 7/30/24.
//

import UIKit
import Kingfisher


class NormalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NormalCollectionViewCell"
    let image: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let reviewLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let descLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(image)
        self.addSubview(titleLabel)
        self.addSubview(reviewLabel)
        self.addSubview(descLabel)
        
        image.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    public func configure(title: String, review: String, desc: String, imageURL: String) {
        image.kf.setImage(with: URL(string: imageURL))
        titleLabel.text = title
        reviewLabel.text = review
        descLabel.text = desc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
