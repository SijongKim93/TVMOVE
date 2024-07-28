//
//  ButtonView.swift
//  TVMOVE
//
//  Created by 김시종 on 7/27/24.
//

import UIKit


class ButtonView: UIView {
    let tvButton: UIButton = {
        let button = UIButton()
        button.setTitle("TV", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.configuration = UIButton.Configuration.bordered()
        return button
    }()
    
    
    let movieButton: UIButton = {
        let button = UIButton()
        button.setTitle("Movie", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.configuration = UIButton.Configuration.bordered()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    
    private func setUI() {
        self.addSubview(tvButton)
        self.addSubview(movieButton)
        
        tvButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(40)
        }
        
        movieButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tvButton.snp.trailing).offset(10)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
