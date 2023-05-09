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
    
    var selectedDate :Date
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var viewModel = NoteAddViewModel(noteDate: selectedDate.dayStringText)//noteDate remove
    
    private lazy var dateLabel = UILabel().then{
        $0.text = selectedDate.dayStringText
        $0.font = .dovemayoFont(ofSize: 30)
    }
    private lazy var textView = UITextView()
    
    private lazy var buttonView = UIView().then{
        $0.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30)
    }
    
    private lazy var importantView = UIStackView().then{
        $0.spacing = 10
        $0.axis = .horizontal
    }
    
    private lazy var lowButton = UIButton(type: .system).then{
        $0.frame.size = CGSize(width: 100, height: 100)
        $0.setTitle("low", for: .normal)
    }
    
    private lazy var middleButton = UIButton(type: .system).then{
        $0.setTitle("middle", for: .normal)
    }
    
    private lazy var highButton = UIButton(type: .system).then{
        $0.setTitle("high", for: .normal)
    }
    
    private lazy var addButton = UIButton(type: .system).then{
        $0.frame = CGRect(x: view.frame.width - 100, y: 0, width: 60, height: 30)
        $0.setTitle("완료", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //자동으로 textView에 커서가 가도록 설정
        textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
        
        // 커스텀 뷰를 textField의 inputAccessoryView로 설정합니다.
        textView.inputAccessoryView = buttonView
        
        bind(viewModel)
        layout()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension NoteAddView{
    
    func bind(_ VM: NoteAddViewModel){
        
        let input = NoteAddViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        addButton.rx.tap
            .bind(onNext: {[weak self] in
                guard let self = self else { return }
                VM.addNote(date: selectedDate)
            })
            .disposed(by: bag)
        
        lowButton.rx.tap
            .bind(onNext: {
                VM.importantTap("low")
            })
            .disposed(by: bag)
        
        middleButton.rx.tap
            .bind(onNext: {
                VM.importantTap("middle")
            })
            .disposed(by: bag)
        
        highButton.rx.tap
            .bind(onNext: {
                VM.importantTap("high")
            })
            .disposed(by: bag)
        
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
        
        [lowButton,middleButton,highButton].forEach{
            importantView.addArrangedSubview($0)
        }
        
        [importantView,addButton].forEach{
            buttonView.addSubview($0)
        }
        
        importantView.snp.makeConstraints{
            $0.leading.top.equalToSuperview()
        }
        
        [dateLabel,textView].forEach{
            view.addSubview($0)
        }
        dateLabel.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        textView.snp.makeConstraints{
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.bottom.equalToSuperview()
        }
        
    }
}
