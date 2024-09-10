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
    
    //input
    struct Input {
        let tvTrigger: Observable<Void>
        let movieTrigger: Observable<Void>
    }
    
    //output
    struct Output {
        let tvList: Observable<[TV]>
        let movieResult: Observable<Result<MovieResult, Error>>
    }
    
    func transform(input: Input) -> Output {
        let tvList = input.tvTrigger.flatMapLatest {[unowned self] _ -> Observable<[TV]> in
            return self.tvNetwork.getTopRatedList().map{ $0.results }
        }
        
        let movieResult = input.movieTrigger.flatMapLatest { [unowned self] _ -> Observable<Result<MovieResult, Error>> in
            return Observable.combineLatest(self.movieNetwork.getUpcomingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()) { upcoming, popular, nowPlaying -> Result<MovieResult, Error> in
                    .success(MovieResult(upcomming: upcoming, popular: popular, nowPlaying: nowPlaying))
            }.catch { error in
                return Observable.just(.failure(error))
            }
        }
        return Output(tvList: tvList, movieResult: movieResult)
    }
}
