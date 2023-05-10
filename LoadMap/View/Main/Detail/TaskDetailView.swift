//
//  TaskDetailView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/05.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import RxSwift


///TODO
///CollectionView를 사용하여 startDay ~ 오늘 까지 cell 생성
///items 중에 complete == false .first 인 데이터는 tag 추가 가능하도록 설정 
final class TaskDetailView: UIViewController{
    
   private  let bag = DisposeBag()
    let viewModel: TaskDetailViewModel
    
    
    private let detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: taskDetailViewLayout()).then{
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "detailCell")
        $0.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    //제목 라벨
    private let titleLabel = UITextView().then{
        $0.font = UIFont.dovemayoFont(ofSize: 20)
    }
    
    // 내용 라벨
    private let contentLabel = UITextView()
    
    //작업 시작 날짜
    private let createDateLabel = UILabel()
    
    //작업 종료 날짜
    private let dueDateLabel = UILabel()
    
    //진행도
    private let processLabel = UILabel()

    
    init(viewModel: TaskDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind(viewModel)
        layout()
    }
    
}

extension TaskDetailView{
    
    func bind(_ VM : TaskDetailViewModel){
        
        let input = TaskDetailViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        guard let data = VM.selectedTask.first else {return }
        
        
        output.viewData
            .drive(detailCollectionView.rx.items(dataSource: taskDetailDataSource()))
            .disposed(by: bag)
        titleLabel.text = data.title
        
        contentLabel.text = data.content
        
        createDateLabel.text = "작업 시작 날짜 : \(data.startDay.dayStringText)"
        
        dueDateLabel.text = "작업 종료 날짜 : \(data.endDay.dayStringText)"
        
        let process = data.items.filter{$0.itemComplete == true}.count / data.items.count
        
        processLabel.text = "진행도 : \(process) %"
        
       
    }
    
    private func layout(){
        view.addSubview(detailCollectionView)
        
        detailCollectionView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
//        [titleLabel,contentLabel,createDateLabel,dueDateLabel,processLabel].forEach{
//            view.addSubview($0)
//        }
//
//        titleLabel.snp.makeConstraints{
//            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
//            $0.height.equalTo(30)
//        }
//
//        contentLabel.snp.makeConstraints{
//            $0.top.equalTo(titleLabel.snp.bottom)
//            $0.leading.equalTo(titleLabel.snp.leading)
//            $0.height.equalTo(30)
//        }
//
//        createDateLabel.snp.makeConstraints{
//            $0.top.equalTo(contentLabel.snp.bottom)
//            $0.leading.equalTo(contentLabel.snp.leading)
//        }
//
//        dueDateLabel.snp.makeConstraints{
//            $0.top.equalTo(createDateLabel.snp.bottom)
//            $0.leading.equalTo(createDateLabel.snp.leading)
//        }
//
//        processLabel.snp.makeConstraints{
//            $0.top.equalTo(dueDateLabel.snp.bottom)
//            $0.leading.equalTo(dueDateLabel.snp.leading)
//        }
    }
}


extension TaskDetailView{
    func taskDetailDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Task, TaskItem>>{
        return RxCollectionViewSectionedReloadDataSource <SectionModel<Task, TaskItem>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? UICollectionViewCell else { return UICollectionViewCell()}
                print(item)
                //cell.setView(item)
                //cell.bind(self.viewModel)
                return cell
                
            },configureSupplementaryView: {dataSource,collectionView,kind,indexPath -> UICollectionReusableView in
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? UICollectionReusableView else { return UICollectionReusableView()}
                    print("abc")
                    print(dataSource.sectionModels[indexPath.section].model)
                    //let text = dataSource.sectionModels[indexPath.section].model
                                    // header.setDate(text,0)
                                       //header.bind(self.viewModel)
                   
                    return header
                default:
                    fatalError()
                }
            }
        )
    }
    
}
