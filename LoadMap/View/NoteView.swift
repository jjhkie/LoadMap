//
//  NoteView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NoteView: UIViewController{
    
    let bag = DisposeBag()
    
    let testData : [Note] = [
        Note(noteDate: Date(), noteContent: "content1"),
        Note(noteDate: Date(), noteContent: "content2"),
        Note(noteDate: Date(), noteContent: "content3"),
        Note(noteDate: Date(), noteContent: "content4"),
        Note(noteDate: Date(), noteContent: "content5")
    ]
    
    var data = BehaviorRelay<[Note]>(value: [])
    
    
    let tableView = UITableView().then{
        $0.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.accept(testData)
        
        bind()
        layout()
    }
}

extension NoteView{

    func bind(){
        data.bind(to: tableView.rx.items(cellIdentifier: "noteCell",cellType: NoteCell.self)){row,data,cell in
            cell.textLabel?.text = data.noteContent
        }.disposed(by: bag)
        
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
