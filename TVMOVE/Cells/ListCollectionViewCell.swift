//
//  ListCollectionViewCell.swift
//  TVMOVE
//
//  Created by 김시종 on 8/1/24.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "ListCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let releaseDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(releaseDate)
        
        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview()
        }
    }
    
    public func configure(title: String, release: String, url: String) {
        titleLabel.text = title
        releaseDate.text = release
        imageView.kf.setImage(with: URL(string: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
