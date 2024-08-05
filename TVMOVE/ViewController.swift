//
//  ViewController.swift
//  TVMOVE
//
//  Created by 김시종 on 7/27/24.
//

import UIKit
import SnapKit
import RxSwift

enum Section: Hashable {
    case double
    case banner
    case horizontal(String)
    case vertical(String)
}

enum Item: Hashable {
    case normal(Content)
    case bigImage(Movie)
    case list(Movie)
}

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let buttonView = ButtonView()
    let viewModel = ViewModel()
    
    
    let tvTrigger = PublishSubject<Void>()
    let movieTrigger = PublishSubject<Void>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section,Item>?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.identifier)
        collectionView.register(BigImageCollectionViewCell.self, forCellWithReuseIdentifier: BigImageCollectionViewCell.identifier)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        bindVIew()
        setDatasource()
        
        tvTrigger.onNext(())
    }
    
    private func setUI() {
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)
        
        buttonView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(buttonView.snp.bottom)
        }
    }
    
    // MARK: - 뷰 바인드
    private func bindViewModel() {
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObservable(), movieTrigger: movieTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.tvList.bind { [weak self] tvList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            let items = tvList.map { return Item.normal(Content(tv: $0)) }
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.movieResult.bind { [weak self] movieResult in
            print("Movie Result \(movieResult)")
            switch movieResult {
            case .success(let movieResult):
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                let bigImageList = movieResult.nowPlaying.results.map { movie in
                    return Item.bigImage(movie)
                }
                let bannerSection = Section.banner
                snapshot.appendSections([bannerSection])
                snapshot.appendItems(bigImageList, toSection: bannerSection)
                
                let horizontalSection = Section.horizontal("Popular Movies")
                let normalList = movieResult.popular.results.map { movie in
                    return Item.normal(Content(movie: movie))
                }
                snapshot.appendSections([horizontalSection])
                snapshot.appendItems(normalList, toSection: horizontalSection)
                
                let upcomingSection = Section.vertical("UpComing Moives")
                let upcomingList = movieResult.upcomming.results.map { movie in
                    return Item.list(movie)
                }
                
                snapshot.appendSections([upcomingSection])
                snapshot.appendItems(upcomingList, toSection: upcomingSection)
                
                self?.dataSource?.apply(snapshot)
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindVIew() {
        buttonView.tvButton.rx.tap.bind { [weak self] in
            self?.tvTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        buttonView.movieButton.rx.tap.bind { [weak self] in
            self?.movieTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self]sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)

            switch section {
            case .banner:
                return self?.createBannerSeciton()
            case .horizontal:
                return self?.createHorizontalSection()
            case .vertical:
                return self?.createVerticalSection()
            default:
                return self?.createDoubleSection()
            }

        }, configuration: config)
    }
    
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createBannerSeciton() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(640))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .normal(let contentData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.identifier, for: indexPath) as? NormalCollectionViewCell
                cell?.configure(title: contentData.title, review: contentData.vote, desc: contentData.overview, imageURL: contentData.posterURL)
                return cell
            case .bigImage(let movieData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCollectionViewCell.identifier, for: indexPath) as? BigImageCollectionViewCell
                cell?.configure(title: movieData.title, overview: movieData.overview, review: movieData.vote, url: movieData.posterURL)
                return cell
            case .list(let movieData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell
                cell?.configure(title: movieData.title, release: movieData.releaseDate, url: movieData.posterURL)
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .horizontal(let title):
                (header as? HeaderView)?.configure(title: title)
            case .vertical(let title):
                (header as? HeaderView)?.configure(title: title)
            default:
                print("Default")
            }
            return header
        }
    }
}

