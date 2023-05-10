//
//  TaskView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/28.
//

import UIKit
import SnapKit
import RxSwift
//달성한 목표만 보여주기
//진행 예정인 업무 보여주기
//다시 도전 가능한 목표 보여주기
//--> 클릭 시 재설정 후 다시 시도


//TODO
///COllectionView로 생성
///header 부분에 title 생성
///첫 번째 셀에 등록한 날짜/ 제목/ 상태 구현 및 클릭되지 않도록 설정
///
final class TaskView: UIViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel : TaskViewModel
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then{
//        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//    }
    
    private let tableView = UITableView().then{
        $0.register(TaskListCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(viewModel)
        layout()
    }
}

//MARK: - Layout
extension TaskView{
    
    func bind(_ VM: TaskViewModel){
        let input = TaskViewModel.Input()
        let output = VM.inOut(input: input)
        
        output.cellData
            .subscribe(onNext: {task in
                if task.isEmpty{
                    let emptyView = self.createEmptyView()
                    self.tableView.backgroundView = emptyView
                }else{
                    self.tableView.backgroundView = nil
                }
            })
            .disposed(by: bag)
        
        output.cellData.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "cell",cellType: TaskListCell.self)){row,data,cell in

                cell.setView(data)

            }
            .disposed(by: bag)
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func createEmptyView() -> UIView {
        let emptyView = UIView(frame: tableView.bounds)
        
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
