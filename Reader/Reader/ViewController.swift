//
//  ViewController.swift
//  Reader
//
//  Created by Denis Makovets on 3/9/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices

class ViewController: UIViewController {
    
       let books:  Results<BookModel> = {
                  let realm = try! Realm()
                  return realm.objects(BookModel.self)
              }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
            // startPresentation()
      }

    
//    func startPresentation(){
//
//          let userDefaults = UserDefaults.standard
//          let presentationWasViewed = userDefaults.bool(forKey: "presentationWasViewed")
//          if presentationWasViewed ==  false {
//              let storyboard = UIStoryboard(name: "StartPage", bundle: nil)
//              if let pageViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
//                  present(pageViewController, animated: false, completion: nil)
//              }
//          }
//      }
    
    @IBAction func downloadBook(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [(kUTTypeItem as String)], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
  
}

extension ViewController: UIDocumentPickerDelegate {
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
                let newBook = BookModel(name: String(sandboxFileUrl.lastPathComponent.dropLast(5)), path: sandboxFileUrl.path, author: "Автор", lastReadDate: Date(), addedDate: Date())
                BookManager.saveBookInDB(newBook)
                print("Copied file!")
                let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController  
                self.navigationController?.pushViewController(vc, animated: false)
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}
