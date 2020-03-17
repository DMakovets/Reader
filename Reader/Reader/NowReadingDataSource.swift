//
//  NowReadingDataSource.swift
//  KotBook
//
//  Created by Oleg Marchik on 1/2/20.
//  Copyright © 2020 kotiki. All rights reserved.
//

import UIKit
import RealmSwift

final class NowReadingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var didSelectItem: ((_ book: BookEntity) -> Void)?
    
    let books:  Results<BookEntity> = {
        let realm = try! Realm()
        return realm.objects(BookEntity.self).sorted(byKeyPath: "lastReadDate")
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! SmallBookCollectionViewCell
        let book = books[indexPath.item]
        cell.nameLabel.text = book.name
        cell.authorLabel.text = book.author
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         CGSize(width: 257, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(books[indexPath.item])
    }
}
