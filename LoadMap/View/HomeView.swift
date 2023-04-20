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
    
    var goalData : Results<Goal>?
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
  
        goalData = realm.objects(Goal.self)
        
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
        if let data = goalData?[section].expanded{
            if data{
                return goalData?[section].items.count ?? 0
            }else{
                return 0
            }
        }else{
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalItemCell") as? HomeItemCell else { return UITableViewCell()}
        
        cell.titleLabel.text = goalData?[indexPath.row].title
        
        return cell
        
    }
    
    
}

//MARK: - TableView Delegate
extension HomeView: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        goalData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? HomeHeaderCell else {return nil}
        headerView.viewMore.tag = section
        headerView.viewMore.addTarget(self, action: #selector(sectionButtonTapped(sender:)), for: .touchDown)

        headerView.emojlabel.text = goalData?[section].icon
        headerView.titleLabel.text = goalData?[section].title
        return headerView
    }
    @objc func sectionButtonTapped(sender: UIButton){
        let section = sender.tag
        goalData?[section].expanded.toggle()
        tableView.reloadSections([section], with: .automatic)
    }
}
