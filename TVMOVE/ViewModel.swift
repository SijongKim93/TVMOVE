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
    private let tvNetwork: TVNetwork
    private let movieNetwork: MovieNetwork
    
    init() {
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
        movieNetwork = provider.makeMovieNetwork()
    }
    
    struct Input {
        let tvTrigger: Observable<Void>
        let movieTrigger: Observable<Void>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
        let movieResult: Observable<MovieResult>
    }
    
    func transform(input: Input) -> Output {
        
        // trigger -> 네트워크 -> Observable<T> -> VC 전달 -> VC에서 구독
        
        let tvList = input.tvTrigger.flatMapLatest {[unowned self] _ -> Observable<[TV]> in
            return self.tvNetwork.getTopRatedList().map{ $0.results }
        }
        
        let movieResult = input.movieTrigger.flatMapLatest { [unowned self] _ -> Observable<MovieResult> in
            // combineLatest
            // 하나의 옵저버블로 리턴해줄 수 있다.
            return Observable.combineLatest(self.movieNetwork.getUpcomingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()) { upcoming, popular, nowPlaying -> MovieResult in
                return MovieResult(upcomming: upcoming, popular: popular, nowPlaying: nowPlaying)
            }
        }
        
        return Output(tvList: tvList, movieResult: movieResult)
    }
}
