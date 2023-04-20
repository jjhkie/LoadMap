//
//  HomeView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import Then
import RealmSwift



class HomeView: UIViewController{
    
    //let bag = DisposeBag()
    
    let realm = try! Realm()
    
    let tableView = UITableView().then{
        $0.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
        $0.register(HomeHeaderCell.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    let addButton = UIButton().then{
        $0.backgroundColor = .yellow
        $0.addTarget(self, action: #selector(addPageMove), for: .touchDown)
    }

    @objc func addPageMove(){
        self.navigationController?.pushViewController(GoalAddView(), animated: true)
    }

    
    var data: [Goal] = [
        Goal(header: GoalHeader(icon: "😺", title: "title", startDay: Date(), endDay: Date()), items: [GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false)]),
        Goal(header: GoalHeader(icon: "abc", title: "title", startDay: Date(), endDay: Date()), items: [GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false)]),
        Goal(header: GoalHeader(icon: "abc", title: "title", startDay: Date(), endDay: Date()), items: [GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false)])
    ]
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.delegate = self
        tableView.dataSource = self
        bind()
        layout()
    }
}

extension HomeView{

    func bind(){

    }
    
    private func layout(){
        [tableView,addButton].forEach{
            view.addSubview($0)
        }
        
        // 테이블뷰 오토레이아웃
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        //글작성 버튼 오토레이아웃
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

//MARK: - TableView DataSource
extension HomeView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[section].header.expanded{
            return  data[section].items?.count ?? 0
        }else{
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalItemCell") as? HomeItemCell else { return UITableViewCell()}
        cell.titleLabel.text = data[indexPath.section].items?[indexPath.row].itemName
        
        return cell
        
    }
    
    
}

//MARK: - TableView Delegate
extension HomeView: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? HomeHeaderCell else {return nil}
        headerView.viewMore.tag = section
        headerView.viewMore.addTarget(self, action: #selector(sectionButtonTapped(sender:)), for: .touchDown)

        headerView.emojlabel.text = data[section].header.icon
        headerView.titleLabel.text = data[section].header.title
        return headerView
    }
    @objc func sectionButtonTapped(sender: UIButton){
        let section = sender.tag
        data[section].header.expanded.toggle()
        tableView.reloadSections([section], with: .automatic)
    }
}
