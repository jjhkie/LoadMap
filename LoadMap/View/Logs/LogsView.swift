//
//  LogsView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/09.
//

import UIKit
import SnapKit
import Then
import RxDataSources
import RxSwift
import RxCocoa


final class LogsView:UIViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel : LogsViewModel
    
    init(viewModel: LogsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: logCollectionViewLayout()).then{
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(viewModel)
        layout()
    }
}

extension LogsView{
    
    func bind(_ VM: LogsViewModel){
        
        let input = LogsViewModel.Input()
        let output = VM.inOut(input: input)
 
        
        output.cellData
            .drive(collectionView.rx.items(dataSource: logsDataSource()))
            .disposed(by: bag)
        
    }
    
    private func layout(){
        view.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

extension LogsView{
    func logsDataSource() ->
    RxCollectionViewSectionedReloadDataSource<LogCustomData>{
        return RxCollectionViewSectionedReloadDataSource <LogCustomData>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath]{
                    
                case .dateItems(date: let date):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell else { return UICollectionViewCell()}
                    
                    cell.backgroundColor = .red
                    
                    return cell
                case .LogItems(type: let type, title: let title, time: let time):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell else { return UICollectionViewCell()}
                    
                    cell.backgroundColor = .blue
                    
                    return cell
                }
            }
        )}
}


extension LogsView{
    static func logCollectionViewLayout() -> UICollectionViewCompositionalLayout{
        UICollectionViewCompositionalLayout{ section, env -> NSCollectionLayoutSection? in
            switch section{
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.25),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.25)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
            
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.3)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.3)
                )
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
               
                let section = NSCollectionLayoutSection(group: group)
               

                
                return section
            default:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            
        }
    }
}


//MARK: - Model


enum LogType{
    case goal
    case task
    case tag
}

enum LogItems{
    case dateItems(date: Date)
    case LogItems(type: LogType, title: String, time: Date)
}

enum LogCustomData{
    case sectionDates(title: String?,items: [Item])
    case sectionLogs(title: String?, items: [Item])
 
}

extension LogCustomData: SectionModelType{
    
    var title: String?{
        switch self{
            
        case .sectionDates(title: let title, items: _):
            return title
        case .sectionLogs(title: let title, items: _):
            return title
        }
    }
    var items: [LogItems] {
        switch self{
            
        case .sectionDates(title: _, items: let items):
            return items.map{$0}
        case .sectionLogs(title: _, items: let items):
            return items.map{$0}
        }
    }
    

    
    typealias Item = LogItems
    
    init(original: LogCustomData, items: [LogItems]) {
        switch original{
        case .sectionDates(title: let title, items: _):
            self = .sectionDates(title: title, items: items)
        case .sectionLogs(title: let title, items: _):
            self = .sectionLogs(title: title, items: items)
        }
    }
}
