//
//  HeaderView.swift
//  TVMOVE
//
//  Created by 김시종 on 8/1/24.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }
    
    public func configure(title: String) {
        self.titleLabel.text = title
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
