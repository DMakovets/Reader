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
import MobileCoreServices

class MainViewController: UIViewController {
    
    
   
    let bookReader = FolioReader()
    
    @IBOutlet weak var nowReadingCollectionView: UICollectionView!
    @IBOutlet weak var recentlyAddedCollectionView: UICollectionView!
    
    
    
    let nowReadingDataSource = NowReadingDataSource()
    let recentlyReadingDataSource = RecentlyReadingDataSource()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        viewLoadSetup()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    func reloadData(){
        recentlyAddedCollectionView.reloadData()
        nowReadingCollectionView.reloadData()
    }
    
    func viewLoadSetup(){
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
    
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//               if segue.identifier == "editSegue" {
//                guard let book = self.nowReadingDataSource.selectedBook else { return }
//                let newBookVC = segue.destination as! EditBookTableViewController
//                  newBookVC.currentBook = book
//               }
//           }
    
    @IBAction func menuActionButton(_ sender: Any) {
        actionSheetCell()
        print(self.nowReadingDataSource.books)
        print(self.nowReadingDataSource.books.count)
    }
    
    @IBAction func addNewBook(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [(kUTTypeItem as String)], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)

    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
           guard let EditVC = segue.source as? EditBookTableViewController else { return }
           EditVC.saveBook()
            self.reloadData()
       }
}

extension MainViewController {
    
    func actionSheetCell() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        guard let book = self.nowReadingDataSource.selectedBook else { return }
        
        let edit = UIAlertAction(title: "Редактировать", style: .default) { _ in
            let editVC = self.storyboard?.instantiateViewController(identifier: "EditVC") as! EditBookTableViewController
            editVC.currentBook = book
            self.navigationController?.pushViewController(editVC, animated: true)
            }
         
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            do {
                try FileManager.default.removeItem(atPath: book.path)
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
            BookManager.deleteBookInDB(book)
            self.reloadData()
            if self.nowReadingDataSource.books.count == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "noBookVC") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cansel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cansel)
        self.present(actionSheet, animated: true)
    }
}

extension MainViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else {
            return
        }
        
        guard selectedFileUrl.relativeString.contains(".epub") else {
            return print("Error file")
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileUrl = dir.appendingPathComponent(selectedFileUrl.lastPathComponent)
        if  FileManager.default.fileExists(atPath: sandboxFileUrl.path){
            print("Already exists! Do Nithing")
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileUrl, to: sandboxFileUrl)
               let imageForBook: [UIImage] = [#imageLiteral(resourceName: "cover3"),#imageLiteral(resourceName: "cover7"),#imageLiteral(resourceName: "cover2"),#imageLiteral(resourceName: "cover6"),#imageLiteral(resourceName: "cover5"),#imageLiteral(resourceName: "cover8")]
                let randomImage = imageForBook.randomElement()
                let imageData = randomImage?.pngData()
                let newBook = BookModel(name: String(sandboxFileUrl.lastPathComponent.dropLast(5)), path: sandboxFileUrl.path, author: "Автор", imageData: imageData, lastReadDate: Date(), addedDate: Date())
                BookManager.saveBookInDB(newBook)
                reloadData()
                dismiss(animated: true, completion: nil)
                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}




