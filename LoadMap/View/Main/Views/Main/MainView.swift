//
//  GoalView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import Then
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources


//TODO :
/// progressBar animation 적용
/// today 정보 다 가져오기[ Task , Note 로 구분 ].
/// 
final class MainView: UIViewController, UIScrollViewDelegate{
    
    private let bag = DisposeBag()
    
    private let viewModel: MainViewModel
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then{
        $0.register(TaskCell.self, forCellWithReuseIdentifier: "taskCell")
        $0.register(MemoCell.self, forCellWithReuseIdentifier: "memoCell")
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")// remove
        $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false//vertical 스크롤만 막기 
}
    


    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        bind(viewModel)
        layout()
    }
}

//MARK: - Bind
extension MainView{
    func bind(_ VM: MainViewModel){
        let input = MainViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        output.cellData
            .drive(collectionView.rx.items(dataSource: collectionViewDataSource()))
            .disposed(by: bag)
        
        output.taskSignal
            .emit(onNext: {
                if let navigation = self.navigationController{
                    navigation.tabBarController?.tabBar.isHidden = true
                    let view = GoalAddView(viewModel: GoalAddViewModel())
                    self.navigationController?.pushViewController(view, animated: true)
                }
            })
            .disposed(by: bag)
        
        ///메모 작성 페이지로 이동
        ///오늘 날짜로만 작성
        output.noteSignal
            .emit(onNext: {
                
                if let navigation = self.navigationController{
                    navigation.tabBarController?.tabBar.isHidden = true
                    let view = NoteAddView(selectedDate: Date())
                    self.navigationController?.pushViewController(view, animated: true)
                }

            })
            .disposed(by: bag)
        
        output.detailSignal
            .emit(onNext: {id in
                if let navigation = self.navigationController{
                    navigation.tabBarController?.tabBar.isHidden = true
                    let viewModel = TaskDetailViewModel(id: id)
                    let view = TaskDetailView(viewModel: viewModel)
                    
                    self.navigationController?.pushViewController(view, animated: true)
                }
            })
            .disposed(by: bag)
        
        

    }
}

//MARK: - Layout
extension MainView{
    
    private func attribute(){
        
       
        view.backgroundColor = .white
        
    }
    private func layout(){
        [collectionView].forEach{
            view.addSubview($0)
        }
        
        //컬렉션뷰 오토레이아웃
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}

//MARK: - DataSource Func
extension MainView{
    
    func collectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<MainModel>{
        return RxCollectionViewSectionedReloadDataSource <MainModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath]{
                case .tasksItem(value: let value):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as? TaskCell else { return UICollectionViewCell()}
                    cell.setView(value)
                    cell.bind(self.viewModel)
                    return cell
                case .notesItem(value: let value):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCell", for: indexPath) as? MemoCell else {return UICollectionViewCell()}
                    
                    cell.setView(value)
                    
                    return cell
                }
            },configureSupplementaryView: {dataSource,collectionView,kind,indexPath -> UICollectionReusableView in
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HomeHeaderView else { return UICollectionReusableView()}
                    
                    let text = dataSource.sectionModels[indexPath.section].title
                    header.setDate(text,indexPath.section)
                    header.bind(self.viewModel)
                   
                    return header
                default:
                    fatalError()
                }
            }
        )
    }
}
