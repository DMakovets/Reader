//
//  BookEntity.swift
//  KotBook
//
//  Created by Denis Makovets on 3/9/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import Realm
import RealmSwift

final class BookModel: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var path = ""
    @objc dynamic var author = ""
    @objc dynamic var lastReadDate: Date?
    @objc dynamic var addedDate = Date()
    @objc dynamic var imageData: Data?
    
    convenience init(name: String, path: String, author: String, imageData: Data?, lastReadDate: Date, addedDate: Date){
        
        self.init()
        self.name = name
        self.path = path
        self.author = author
        self.imageData = imageData
        self.lastReadDate = lastReadDate
        self.addedDate = addedDate
    }
    
    convenience init(name: String, author: String, imageData: Data?) {
        self.init()
        self.name = name
        self.author = author
        self.imageData = imageData
    }
}

