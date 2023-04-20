//
//  GoalAddView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import SnapKit
import Then
import RealmSwift


class GoalAddView:UIViewController{
    
    let realm = try! Realm()
    
    var goalData = Goal()
    
    var goaladdItem = GoalItem()
    
    
    let tableView = UITableView().then{
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        $0.register(GoalAddMainCell.self, forCellReuseIdentifier: "mainCell")
        $0.register(GoalDateCell.self, forCellReuseIdentifier: "dateCell")
        $0.register(GoalColorCell.self, forCellReuseIdentifier: "colorCell")
        $0.register(GoalItemCell.self, forCellReuseIdentifier: "itemCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        layout()
        navigationBarAdd()
    }
}

//MARK: - Layout 설정
extension GoalAddView{
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - NavigationBar
extension GoalAddView{
    private func navigationBarAdd(){
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    @objc func addButton(){
        try! self.realm.write{
            self.realm.add(goalData)
        }
        self.navigationController?.popViewController(animated: true)
    }
}



//MARK: - TableView DataSource
extension GoalAddView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    @objc func addView(){
        goalData.items.append(goaladdItem)
        print("abcde")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as? GoalAddMainCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.imageTextView.delegate = self
            cell.imageTextView.tag = 1
            cell.titleTextView.delegate = self
            cell.titleTextView.tag = 2
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else { return UITableViewCell()}
            cell.backgroundColor = .red
            cell.textLabel?.text = "test"
            return cell
        case 2,3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as? GoalDateCell else { return UITableViewCell()}
            cell.titleLabel.text = "날짜"
            cell.dateLabel.text = "\(Date())"
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? GoalColorCell else { return UITableViewCell()}
       
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? GoalItemCell else { return UITableViewCell()}
            cell.contentTextView.delegate = self
            cell.contentTextView.tag = 3
            cell.addButton.setTitle("Click", for: .normal)
            cell.addButton.addTarget(self, action: #selector(addView), for: .touchDown)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else { return UITableViewCell()}
            return cell
        }
    }
    ///이모티콘 * 글 제목
    ///color
    ///startDay
    ///endDay
    ///goalItem AddButton
    ///goalItem
    
    
}


extension GoalAddView:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag{
        case 1:
            goalData.icon = textField.text
        case 2:
            goalData.title = textField.text

        case 3:
            goaladdItem.itemName = textField.text
        default:
            break;
        }
    }
}
