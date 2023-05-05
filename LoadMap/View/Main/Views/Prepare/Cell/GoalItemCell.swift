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
    
    let bag = DisposeBag()
    
    private lazy var baseView = BaseView(editEnable: false).then{
        $0.emojiImage.image = UIImage(systemName: "list.bullet.clipboard")
        $0.emojiImage.tintColor = .cyan
        
        $0.infoStackView.spacing = 0
        $0.titleTextView.text = "업무"
    }
    
 
    private let workTextPlaceHolder :String
    
    var workTextView = UITextView().then{
        $0.isEditable = true
        $0.textColor = .lightGray
        $0.commonBackgroundColor()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        workTextPlaceHolder = "업무를 추가해주세요"
        workTextView.text = workTextPlaceHolder
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        bind()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalItemCell{
    func scrollBottom() {
        guard let tableView = superview as? UITableView else { return }
        
        let lastIndex = tableView.numberOfRows(inSection: 0) - 1
        
        let lastIndexPat = IndexPath(row: lastIndex, section: 0)
        
        tableView.scrollToRow(at: lastIndexPat, at: .bottom, animated: true)
    }
    func bind(){
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
 
    }
   
    func bind(viewmodel VM: GoalAddViewModel){
        
        workTextView.rx.didChange
            .subscribe(onNext: {[weak workTextView] in
                guard let textView = workTextView else {return}
                
                if textView.text.last == "\n" && !textView.text.isEmpty {
   
                    textView.text = self.workTextPlaceHolder
                    textView.textColor = .lightGray
                    //textView.resignFirstResponder()
                }
            })
            .disposed(by: bag)

    }
    
    
    private func layout(){
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()

        }
        
        
        baseView.infoStackView.addArrangedSubview(workTextView)

        baseView.infoStackView.snp.makeConstraints{
            $0.height.equalTo(50)
        }
    }
}
