//
//  Note.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import Foundation
import RealmSwift


class Note: Object{
    
    @objc dynamic var noteDate : String?
    @objc dynamic var priority : String?
    @objc dynamic var noteContent: String?
}


