//
//  Note.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import RealmSwift
import Foundation


class Note: Object{
    @objc dynamic var dateOfCreation : Date = Date()
    @objc dynamic var priority : String = "low"
    @objc dynamic var noteContent: String = ""
    @objc dynamic var important: String = ""
}


