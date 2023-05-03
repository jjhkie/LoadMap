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
import FSCalendar



class NoteView: UIViewController{
    
    private let bag = DisposeBag()
    

    private let viewModel = NoteViewModel()
    
    private let calendar = FSCalendar().then{
        $0.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell")
        $0.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        $0.scope = .week
        $0.backgroundColor = .white
        
    }
    
    private let tableView = UITableView().then{
        $0.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        calendar.delegate = self
        calendar.dataSource = self
        attribute()
        layout()
        bind(viewModel)
 
    }
}


extension NoteView: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        viewModel.selectedDate.onNext(date)
        print(try! viewModel.selectedDate.value())
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position) as! CalendarCell
        cell.dayLabel.text = "\(date.dayOfWeekString)"
        cell.dayOfWeekLabel.text = "\(date.dayOfWeekString)"
        //cell.subtitleLabel.text = "\(date.dayOfWeekString)"
        return cell
    }
    

}

extension NoteView: FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        return viewModel.noteData.filter(NSPredicate(format: "noteDate == %@", date.dayStringText)).count
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
        
    }
    
    private func attribute(){
        
        self.navigationController?.navigationBar.topItem?.title = "다이어리"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = addButton
    }
    
    @objc func addButtonPressed(){
        let view = NoteAddView()
        if let selectedDate = calendar.selectedDate{
            view.selectedDate = selectedDate
        }else{
            view.selectedDate = Date()
        }
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    private func layout(){
        
        [calendar,tableView].forEach{
            view.addSubview($0)
        }
        
        calendar.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
