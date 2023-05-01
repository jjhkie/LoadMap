//
//  Constants.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/01.
//

import UIKit

struct Constants {
    struct Fonts {
        static let topItem = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    struct Images{
        static let startImage = UIImage(systemName: "star")!
        static let statusImage = UIImage(systemName: "playpause.fill")!
    }
}

enum DetailViewType{
    case title
    case status
}
