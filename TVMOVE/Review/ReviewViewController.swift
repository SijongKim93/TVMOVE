//
//  ReviewViewController.swift
//  TVMOVE
//
//  Created by 김시종 on 8/23/24.
//

import Foundation
import UIKit

final class ReviewViewController: UIViewController {
    init(id: Int, contentType: ContentType) {
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
