//
//  GoalDetailView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/24.
//

import UIKit
import SnapKit
import Then

class GoalDetailView: UIViewController{
    
    var screenData: Goal
    
    private lazy var titleTopView = ContainerItemView(content: screenData,type: .title)
    
    private lazy var statusTopView = ContainerItemView(content: screenData,type: .status)
    

    
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
       
    }
    
    private func layout(){

        
        [titleTopView,statusTopView].forEach{
            view.addSubview($0)
        }
        titleTopView.snp.makeConstraints{
            $0.leading.top.trailing.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
            //$0.height.equalTo(100)
        }
        
        statusTopView.snp.makeConstraints{
            $0.leading.equalTo(titleTopView.snp.leading)
            $0.top.equalTo(titleTopView.snp.bottom)
            $0.trailing.equalTo(titleTopView.snp.trailing)
        }
        
    }
}
