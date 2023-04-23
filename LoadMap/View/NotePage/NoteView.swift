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
    
    let viewModel = NoteViewModel()
    
    let tableView = UITableView().then{
        $0.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        
        bind(viewModel)
        layout()
    }
}

extension NoteView{
    
    func bind(_ VM: NoteViewModel){
        
        let input = NoteViewModel.Input()
        let output = VM.inOut(input: input)
        
        output.cellData
            .drive(tableView.rx.items(cellIdentifier: "noteCell",cellType: NoteCell.self)){row,data,cell in
                cell.textView.text = data.noteContent
            }
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(onNext: {_ in
                self.tableView.reloadData()
            })
            .disposed(by: bag)

    }
    
    private func attribute(){
        self.navigationController?.navigationBar.topItem?.title = "다이어리"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = addButton
    }
    
    @objc func addButtonPressed(){
        self.navigationController?.pushViewController(NoteAddView(), animated: true)
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
