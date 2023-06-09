//
//  HomeHeaderView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/04.
//

import UIKit
import SnapKit
import Then
import RxSwift
final class HomeHeaderView:UICollectionReusableView{
    
    private let bag = DisposeBag()
    
    var headerTag: Int?
    
    private let mainLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 16)
    }
    
    private let prepareButton = UIButton().then{
        $0.configuration = $0.fillCustomButtony
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
    }
    
    private let pageControl = UIPageControl().then{
        $0.hidesForSinglePage = true
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainLabel.text = "header 입니다"
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeHeaderView{
    
    func setDate(_ labelText: String,_ section: Int){
        mainLabel.text = labelText
        headerTag = section
        prepareButton.tag = section
    }
    
    func bind(_ viewModel: MainViewModel){
        
        if headerTag == 0{
            pageControl.numberOfPages = viewModel.taskDataCount
        }else{
            pageControl.numberOfPages = viewModel.noteDataCount % 3 > 0 ? (viewModel.noteDataCount / 3) + 1 : (viewModel.noteDataCount / 3)
            
            
        }
       
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.currentPage = 0
        prepareButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] in
                guard let self = self else {return}
                if self.prepareButton.tag == 0{
                    viewModel._prepareTask.onNext(Void())
                }else{
                    viewModel._prepareNote.onNext(Void())
                }
            })
            .disposed(by: bag)
    }
    
    private func layout(){
        [mainLabel,prepareButton,pageControl].forEach{
            addSubview($0)
        }
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        prepareButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        pageControl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainLabel.snp.bottom)
        }
    }
}
