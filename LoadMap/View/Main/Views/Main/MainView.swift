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


//TODO :
/// progressBar animation 적용
/// 진행중인 것과 예정인 것 나누기
/// today 정보 다 가져오기[ Task , Note 로 구분 ].
/// CollectionView horizontal scroll이 가능하도록 설정
/// 
final class MainView: UIViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel: MainViewModel
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then{
        $0.register(TaskCell.self, forCellWithReuseIdentifier: "taskCell")
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
            .drive(collectionView.rx.items(dataSource: VM.collectionViewDataSource()))
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
        
        output.noteSignal
            .emit(onNext: {
                
                if let navigation = self.navigationController{
                    navigation.tabBarController?.tabBar.isHidden = true
                    let viewModel = NoteAddView()
                    viewModel.selectedDate = Date()
                    self.navigationController?.pushViewController(viewModel, animated: true)
                }

            })
            .disposed(by: bag)
        
        collectionView.rx.setDelegate(self).disposed(by: bag)


    }
}

//MARK: - Layout
extension MainView{
    
    private func attribute(){
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
    }
    private func layout(){
        [collectionView].forEach{
            view.addSubview($0)
        }
        
        //컬렉션뷰 오토레이아웃
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
            
        }

    }
}

extension MainView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = GoalHeaderView()
        view.button.rx.tap.subscribe(onNext: {

            var value = self.viewModel.expandedSections.value
            value[section] = !value[section]
            self.viewModel.expandedSections.accept(value)
            tableView.beginUpdates()
            tableView.reloadData()

            
            tableView.endUpdates()

        })
        .disposed(by: bag)
        view.layoutIfNeeded()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = viewModel.expandedSections.value
        return  object[indexPath.section] ? UITableView.automaticDimension : 0.0
    }
}
