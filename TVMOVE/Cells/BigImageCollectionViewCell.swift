//
//  BigImageCollectionViewCell.swift
//  TVMOVE
//
//  Created by 김시종 on 8/1/24.
//

import UIKit


final class BigImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BigImageCollectionViewCell"
    
    private let posterImage = UIImageView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImage)
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(reviewLabel)
        stackView.addArrangedSubview(descLabel)
        
        posterImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(posterImage.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(14)
        }
    }
    
    public func configure(title: String, overview: String, review: String, url: String) {
        titleLabel.text = title
        reviewLabel.text = review
        descLabel.text = overview
        posterImage.kf.setImage(with: URL(string: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
