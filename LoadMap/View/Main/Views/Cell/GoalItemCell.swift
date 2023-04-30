//
//  GoalItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GoalItemCell: UITableViewCell{
    
    private let bag = DisposeBag()
    
    private lazy var baseView = BaseView(editEnable: false).then{
        $0.emojiImage.image = UIImage(systemName: "list.bullet.clipboard")
        $0.emojiImage.tintColor = .cyan
        
        $0.infoStackView.spacing = 0
        $0.titleTextView.text = "업무"
    }
    
    var workArr: [String] = []
    
    private let workTextPlaceHolder = "업무를 추가해주세요"
    
    private lazy var workTextView = UITextView().then{
        $0.isEditable = true
        $0.textColor = .lightGray
        $0.text = workTextPlaceHolder
    }
    
    private lazy var tableView = UITableView().then{
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalItemCell{
    
    func bind(_ VM: GoalAddViewModel){
        
        workTextView.rx.didEndEditing
            .subscribe(onNext: {[weak workTextView] in
                guard let textView = workTextView else {return}
                
                if textView.text.isEmpty{
                    textView.text = self.workTextPlaceHolder
                    textView.textColor = .lightGray
                }
            })
            .disposed(by: bag)
        
        workTextView.rx.didBeginEditing
            .subscribe(onNext: {[weak workTextView] in
                guard let textView = workTextView else {return}
                
                if textView.text == self.workTextPlaceHolder{
                    textView.text = ""
                    textView.textColor = .black
                }
            })
            .disposed(by: bag)
        
        //textField enter 이벤트
        workTextView.rx.didChange
            .subscribe(onNext: {[weak workTextView] in
                guard let textView = workTextView else {return}
                
                if textView.text.last == "\n" && !textView.text.isEmpty {
                    self.workArr.append(textView.text)
                    VM.worksData.accept(self.workArr)
                    textView.text = self.workTextPlaceHolder
                    textView.textColor = .lightGray
                    textView.resignFirstResponder()
                    
                    
                }
            })
            .disposed(by: bag)
        
        VM.worksData.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cell",cellType: UITableViewCell.self)){view,data,cell in
                
                cell.textLabel?.text = data
            }
            .disposed(by: bag)
        
        

    }
    
    
    private func layout(){
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
        baseView.infoStackView.addArrangedSubview(workTextView)
        baseView.infoStackView.addArrangedSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.height.equalTo(100)
        }

        workTextView.snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
    }
}
