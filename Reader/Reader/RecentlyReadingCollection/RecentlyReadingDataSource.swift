//
//  RecentlyReadingDataSource.swift
//  Reader
//
//  Created by Denis Makovets on 3/17/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit
import RealmSwift

final class RecentlyReadingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var didSelectItem: ((_ book: BookModel) -> Void)?
    
    
    let books:  Results<BookModel> = {
        let realm = try! Realm()
        return realm.objects(BookModel.self).sorted(byKeyPath: "addedDate")
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! BigBookCollectionViewCell
        let book = books[indexPath.item]
        cell.bigNameLabel.text = book.name
        cell.bigAuthorLabel.text = book.author
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       CGSize(width: 257, height: 150)
   }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(books[indexPath.item])
        
    }

}
