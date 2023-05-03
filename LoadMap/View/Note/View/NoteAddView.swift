//
//  NoteAddView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
import RealmSwift
//TODO
///중요도 설정할 수 있도록 설정
///중요도 이미지를 메인 image로 사용

final class NoteAddView: UIViewController{
    private let bag = DisposeBag()
    
    var selectedDate :Date? = nil
    
    private lazy var viewModel = NoteAddViewModel(noteDate: selectedDate!.dayStringText)
    
    private lazy var dateLabel = UILabel().then{
        if let date = selectedDate{
            $0.text = date.dayStringText
        }
    }
    
    private lazy var textView = UITextView()
    
    private lazy var addButton = UIButton().then{
        $0.backgroundColor = .red //xxx
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                view.addGestureRecognizer(tapGesture)
        
        bind(viewModel)
        layout()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            view.endEditing(true)
        }
}

extension NoteAddView{
    
    func bind(_ VM: NoteAddViewModel){
        
        let input = NoteAddViewModel.Input(
            addButtonTapped: addButton.rx.tap.asObservable()
        )
        let output = VM.inOut(input: input)
        
        
        textView.rx.text.orEmpty
            .bind(to: VM.noteText)
            .disposed(by: bag)
        
        
        output.noteSaved
            .emit(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
    }
    
    
    private func layout(){
        [dateLabel,textView,addButton].forEach{
            view.addSubview($0)
        }
        dateLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        textView.snp.makeConstraints{
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        addButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
