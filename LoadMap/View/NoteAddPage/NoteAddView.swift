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

class NoteAddView: UIViewController{
    let bag = DisposeBag()
    
    let viewModel = NoteAddViewModel()
    
    let textView = UITextView()
    let addButton = UIButton().then{
        $0.backgroundColor = .red //xxx
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(viewModel)
        layout()
    }
}

extension NoteAddView{
    
    func bind(_ VM: NoteAddViewModel){
        
        let input = NoteAddViewModel.Input(
            addButtonTapped: addButton.rx.tap.asObservable()
        )
        let output = VM.inOut(input: input)
        
        
        
//        addButton.rx.tap
//            .subscribe(onNext: {
//
//                if !self.textView.text.isEmpty{
//                    try! self.realm.write{
//                        let newNote = Note()
//                        newNote.noteDate = Date()
//                        newNote.noteContent = self.textView.text
//                        self.realm.add(newNote)
//                    }
//                    self.navigationController?.popViewController(animated: true)
//                }else{
//                    let alert =  UIAlertController(title: "내용을 작성해주세요.", message: "", preferredStyle: .alert)
//                    let action = UIAlertAction(title: "닫기", style: .default, handler: nil)
//                            alert.addAction(action)
//                    self.present(alert, animated: true)
//                }
//
//
//            })
//            .disposed(by: bag)
    }
    
    
    private func layout(){
        [textView,addButton].forEach{
            view.addSubview($0)
        }
        
        
        textView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        addButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}