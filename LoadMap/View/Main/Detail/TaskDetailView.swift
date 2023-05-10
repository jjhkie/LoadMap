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

///TODO
///CollectionView를 사용하여 startDay ~ 오늘 까지 cell 생성
///items 중에 complete == false .first 인 데이터는 tag 추가 가능하도록 설정 
final class TaskDetailView: UIViewController{
    
    let viewModel: TaskDetailViewModel
    
    private let titleLabel = UILabel()
    
    private let contentLabel = UILabel()
    
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
        titleLabel.text = data.title
        
        contentLabel.text = data.content
        
       
    }
    
    private func layout(){
        [titleLabel,contentLabel].forEach{
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}

