//
//  MainViewController.swift
//  KotBook
//
//  Created by Denis Makovets on 3/9/20.
//  Copyright © 2019 Denis Makovets. All rights reserved.
//

import UIKit
import FolioReaderKit
import RealmSwift

class MainViewController: UIViewController {
    
    
    var books:  Results<BookModel>!
    let bookReader = FolioReader()
    
    @IBOutlet weak var nowReadingCollectionView: UICollectionView!
    @IBOutlet weak var recentlyAddedCollectionView: UICollectionView!

    
    
    let nowReadingDataSource = NowReadingDataSource()
    let recentlyReadingDataSource = RecentlyReadingDataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.nowReadingDataSource.books.count == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "noBookVC") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        nowReadingCollectionView.dataSource = nowReadingDataSource
        nowReadingCollectionView.delegate = nowReadingDataSource
        recentlyAddedCollectionView.dataSource = recentlyReadingDataSource
        recentlyAddedCollectionView.delegate = recentlyReadingDataSource
        nowReadingDS()
        recentlyReadingDS()
    }
    
    func nowReadingDS(){
        self.nowReadingDataSource.didSelectItem = { [unowned self] book in
            let path = book.path
            self.bookReader.presentReader(parentViewController: self, withEpubPath: path, andConfig: FolioReaderConfig(), animated: true)
        }
    }
    
    
    func recentlyReadingDS(){
        self.recentlyReadingDataSource.didSelectItem = { [unowned self] book in
            let path = book.path
            self.bookReader.presentReader(parentViewController: self, withEpubPath: path, andConfig: FolioReaderConfig(), animated: true)
        }
    }
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //           if segue.identifier == "editBook" {
    //            guard let book = self.nowReadingDataSource.selected else { return }
    //            let newBookVC = segue.destination as! EditBookTableViewController
    //              newBookVC.currentBook = book
    //           }
    //       }
    
    @IBAction func menuActionButton(_ sender: Any) {
        actionSheetCell()
    }
    
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
      viewControllerToPresent.modalPresentationStyle = .fullScreen
      super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
}

extension MainViewController {
    
    func actionSheetCell() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "Редактировать", style: .default) { _ in
            
        }
        let book = self.nowReadingDataSource.selectedBook
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            BookManager.deleteBookInDB(book!)
            if self.nowReadingDataSource.books.count == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "noBookVC") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cansel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cansel)
        present(actionSheet, animated: true)
    }
}



