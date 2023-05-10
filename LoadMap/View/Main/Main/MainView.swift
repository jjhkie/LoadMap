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
final class MainView: UIViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel: MainViewModel
    
    
    private let taskCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then{
        
        $0.register(TaskCell.self, forCellWithReuseIdentifier: "taskCell")
        $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false//vertical 스크롤만 막기
    }
    
    private let noteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: noteViewLayout() ).then{
        $0.register(TodayNoteCell.self, forCellWithReuseIdentifier: "noteCell")
        $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false//vertical 스크롤만 막기
        $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
        
        
        output.taskCellData.asDriver(onErrorJustReturn: [])
            .drive(taskCollectionView.rx.items(dataSource: taskViewDataSource()))
            .disposed(by: bag)
        
        output.noteCellData.asDriver(onErrorJustReturn: [])
            .drive(noteCollectionView.rx.items(dataSource: noteViewDataSource()))
            .disposed(by: bag)
        
        //데이터가 있는 지 확인하여 없는 경우 backgroundView를 추가하여 특정 뷰를 보여준다.
        output.taskCellData
            .subscribe(onNext: {task in
                if let dataEmpty = task.first?.items.isEmpty{
                    if dataEmpty{
                        let emptyView = self.createEmptyView()
                        self.taskCollectionView.backgroundView = emptyView
                    }else{
                        self.taskCollectionView.backgroundView = nil
                    }
                }
            })
            .disposed(by: bag)
        
        //데이터가 있는 지 확인하여 없는 경우 backgroundView를 추가하여 특정 뷰를 보여준다.
        output.noteCellData
            .subscribe(onNext: {note in
                if let dataEmpty = note.first?.items.isEmpty{
                    if dataEmpty{
                        let emptyView = self.createEmptyView()
                        self.noteCollectionView.backgroundView = emptyView
                    }else{
                        self.noteCollectionView.backgroundView = nil
                    }
                }
            })
            .disposed(by: bag)
        
        //스크롤 이벤트를 적용하여 pagecontrol값 변경
        taskCollectionView.rx.contentOffset
            .bind(onNext: {
                print($0)
            })
            .disposed(by: bag)
        
        taskCollectionView.rx.didScroll
            .bind(onNext: {
                print($0)
            })
            .disposed(by: bag)

        
        
        output.taskSignal
            .emit(onNext: {
                if let navigation = self.navigationController{
                    navigation.tabBarController?.tabBar.isHidden = true
                    let view = TaskAddView(viewModel: TaskAddViewModel())
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
        [taskCollectionView,noteCollectionView].forEach{
            view.addSubview($0)
        }
        
        //컬렉션뷰 오토레이아웃
        taskCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).dividedBy(2.0)
        }
        
        noteCollectionView.snp.makeConstraints{
            $0.top.equalTo(taskCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
    private func createEmptyView() -> UIView {
        let emptyView = UIView(frame: taskCollectionView.bounds)
        
        let label = UILabel()
        label.text = "데이터 없음"
        
        label.textAlignment = .center
        label.textColor = .gray
        
        emptyView.addSubview(label)
        
        label.snp.makeConstraints{
            //$0.width.height.equalTo(500)
            $0.center.equalToSuperview()
        }
        
        return emptyView
    }
}

//MARK: - DataSource Func
extension MainView{
    
    func taskViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, Task>>{
        return RxCollectionViewSectionedReloadDataSource <SectionModel<String, Task>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as? TaskCell else { return UICollectionViewCell()}
                cell.setView(item)
                cell.bind(self.viewModel)
                return cell
                
            },configureSupplementaryView: {dataSource,collectionView,kind,indexPath -> UICollectionReusableView in
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HomeHeaderView else { return UICollectionReusableView()}
                    
                    let text = dataSource.sectionModels[indexPath.section].model
                                     header.setDate(text,0)
                                       header.bind(self.viewModel)
                    
                    return header
                default:
                    fatalError()
                }
            }
        )
    }
    
    func noteViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, Note>>{
        return RxCollectionViewSectionedReloadDataSource <SectionModel<String, Note>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as? TodayNoteCell else { return UICollectionViewCell()}
                
                cell.setView(item)
                
                return cell
                
            },configureSupplementaryView: {dataSource,collectionView,kind,indexPath -> UICollectionReusableView in
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HomeHeaderView else { return UICollectionReusableView()}
                    
                    let text = dataSource.sectionModels[indexPath.section].model
                                     header.setDate(text,1)
                                       header.bind(self.viewModel)
                    
                    return header
                default:
                    fatalError()
                }
            }
        )
    }
}
