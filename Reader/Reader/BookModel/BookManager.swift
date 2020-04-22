//
//  BookManager.swift
//  Reader
//
//  Created by Denis Makovets on 3/17/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class BookManager {
    
    static func saveBookInDB(_ book: BookModel ){
        try! realm.write {
            realm.add(book)
        }
    }
    
    static func deleteBookInDB(_ place: BookModel) {
           try! realm.write {
               realm.delete(place)
           }
       }
}
