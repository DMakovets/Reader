//
//  MainViewController.swift
//  KotBook
//
//  Created by Bojan Vukovic on 25/12/2019.
//  Copyright © 2019 kotiki. All rights reserved.
//

import UIKit
import FolioReaderKit

class MainViewController: UIViewController {
    @IBOutlet weak var nowReadingCollectionView: UICollectionView!
    @IBOutlet weak var recentlyAddedCollectionView: UICollectionView!
    
    let nowReadingDataSource = NowReadingDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nowReadingCollectionView.dataSource = nowReadingDataSource
        nowReadingCollectionView.delegate = nowReadingDataSource
        nowReadingDataSource.didSelectItem = { [unowned self] book in
            let bookReader = FolioReader()
            var path = book.path
            #if DEBUG
            path = Book.findBookPath(path) ?? path
            #endif
            bookReader.presentReader(parentViewController: self, withEpubPath: path, andConfig: FolioReaderConfig())
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
