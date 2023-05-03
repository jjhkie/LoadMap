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
/// horizontal scroll이 가능하도록 설정
/// 
final class GoalView: UIViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel: GoalViewModel
    
    //글 추가 작성 버튼 
    private let addButton = UIButton().then{
        var config = UIButton().fillCustomButtony
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 10
        $0.configuration = config
    }
    
    private let tableView = UITableView().then{ tableView in
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        //tableView.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 100, right: 30)
        tableView.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
    }
    init(viewModel: GoalViewModel) {
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
extension GoalView{
    func bind(_ VM: GoalViewModel){
        let input = GoalViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        //추가 버튼 클릭 이벤트
        //클릭 시 AddPage로 이동
        addButton.rx.tap
            .subscribe(onNext: {
                if let navigation = self.navigationController{
                    navigation.tabBarController?.tabBar.isHidden = true
                    let view = GoalAddView(viewModel: GoalAddViewModel())
                    self.navigationController?.pushViewController(view, animated: true)
                }
               
            })
            .disposed(by: bag)
        
        output.cellData
            .drive(tableView.rx.items(dataSource: VM.tableDataSource()))
            .disposed(by: bag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
        
        tableView.rx.modelSelected(Goal.self)
            .bind(onNext: {_ in
                
                print(#function)
                //self.present(view, animated: true)
            })
            .disposed(by: bag)
    }
}

//MARK: - Layout
extension GoalView{
    
    private func attribute(){
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .lightGray
        
    }
    private func layout(){
        [tableView,addButton].forEach{
            view.addSubview($0)
        }
        
        
        //글작성 버튼 오토레이아웃
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        //테이블뷰 오토레이아웃
        tableView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            
        }
        

    }
}

extension GoalView: UITableViewDelegate{
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
