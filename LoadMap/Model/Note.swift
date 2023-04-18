//
//  Note.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import Foundation
import RealmSwift
import RxRealm

class Note: Object{
    @objc dynamic var noteDate : Date?
    @objc dynamic var noteContent: String?
}
