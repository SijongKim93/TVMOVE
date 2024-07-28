//
//  ViewModel.swift
//  TVMOVE
//
//  Created by 김시종 on 7/28/24.
//

import Foundation
import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
    
    
    struct Input {
        let tvTrigger: Observable<Void>
        let movieTrigger: Observable<Void>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
//        let movieList: Observable<MovieResult>
    }
    
    func transform(input: Input) -> Output {
        
        input.tvTrigger.bind {
            print("Trigger")
        }.disposed(by: disposeBag)
        
        return Output(tvList: Observable<[TV]>.just([]))
    }
}
