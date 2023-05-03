//
//  GoalDetailView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/24.
//

import UIKit
import SnapKit
import Then

///TODO
///items 나열하기 --> tableView 말고 view 추가로 구현하기
///progressBar 세로로 구현 하나로 구현 해보기
///

class GoalDetailView: UIViewController{
    
    var screenData: Goal
    
    private lazy var titleTopView = ContainerItemView(content: screenData,type: .title)
    
    private lazy var creationTopView = ContainerItemView(content: screenData,type: .creation)
    
    private lazy var dueTopView = ContainerItemView(content: screenData, type: .due)
    
    private lazy var tasksTopView = ContainerItemView(content: screenData, type: .tasks)
    
    deinit{
        
        print("GoalDetailView\(#function)")
    }
    
    init(screenData: Goal) {
        self.screenData = screenData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        attribute()
        layout()
    }
}
extension GoalDetailView{
    
 

    private func attribute(){
        self.navigationController?.navigationBar.isHidden = false
       
    }
    
    private func layout(){

        
        [titleTopView,creationTopView,dueTopView,tasksTopView].forEach{
            view.addSubview($0)
        }
        titleTopView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            $0.bottom.equalTo(titleTopView.itemContentView.snp.bottom).offset(20)
            
        }
        
        creationTopView.snp.makeConstraints{
            $0.leading.equalTo(titleTopView.snp.leading)
            $0.top.equalTo(titleTopView.snp.bottom)
            $0.trailing.equalTo(titleTopView.snp.trailing)
            $0.bottom.equalTo(creationTopView.itemContentView.snp.bottom).offset(20)
        }
        
        dueTopView.snp.makeConstraints{
            $0.leading.equalTo(creationTopView.snp.leading)
            $0.top.equalTo(creationTopView.snp.bottom)
            $0.trailing.equalTo(creationTopView.snp.trailing)
            $0.bottom.equalTo(dueTopView.itemContentView.snp.bottom).offset(20)
        }
        
        tasksTopView.snp.makeConstraints{
            $0.leading.equalTo(dueTopView.snp.leading)
            $0.top.equalTo(dueTopView.snp.bottom)
            $0.trailing.equalTo(dueTopView.snp.trailing)
            $0.bottom.equalTo(tasksTopView.itemContentView.snp.bottom).offset(20)
        }
        
    }
}
