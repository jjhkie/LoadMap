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
import RealmSwift
import RxDataSources


class NoteView: UIViewController{
    
    let bag = DisposeBag()
    let realm = try! Realm()
    
    var noteData : Results<Note>?
    
    let tableView = UITableView().then{
        $0.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        noteData = realm.objects(Note.self)
        attribute()
        bind()
        layout()
    }
}

extension NoteView{
    
    func bind(){
        
        //        Observable.from([testData])
        //            .bind(to: tableView.rx.items(cellIdentifier: "noteCell",cellType: NoteCell.self)){tableView,data,cell in
        //                cell.dateLabel.text = data.noteContent
        //            }
        //            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(onNext: {_ in
                print("click")
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

extension NoteView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteData?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as? NoteCell else {return UITableViewCell()}
        cell.textView.text = noteData?[indexPath.row].noteContent
        return cell
    }
    
    
}
