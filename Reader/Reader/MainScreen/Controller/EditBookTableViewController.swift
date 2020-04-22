//
//  EditBookTableViewController.swift
//  Reader
//
//  Created by Denis Makovets on 3/18/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit

class EditBookTableViewController: UITableViewController {
    
    var currentBook: BookModel?
    
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var bookName: UITextField!
    @IBOutlet weak var bookAuthor: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        bookName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    
    //   MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            let photo = UIAlertAction(title: "Галерея", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    func saveBook() {
        
        let image = imageBook.image
        let imageData = image?.pngData()
        let newBook = BookModel(name: bookName.text!, author: bookAuthor.text!, imageData: imageData)
        if currentBook != nil {
            try! realm.write {
                currentBook?.name = newBook.name
                currentBook?.author = newBook.author
                currentBook?.imageData = newBook.imageData
              //  currentPlace?.rating = newPlace.rating
            }
        }
    }

    
    private func setupEditScreen() {
          if currentBook != nil {
              
//              setupNavigationBar()
//              imageIsChanged = true
              
            guard let data = currentBook?.imageData, let image = UIImage(data: data) else { return }
              
            imageBook?.image = image
            imageBook.contentMode = .scaleAspectFill
            bookName.text = currentBook?.name
            bookAuthor.text = currentBook?.author
            
              //ratingControl.rating = Int(currentPlace.rating)
          }
      }
}

// MARK: Text field delegate

extension EditBookTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if bookName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

extension EditBookTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageBook.image = info[.editedImage] as? UIImage
        imageBook.contentMode = .scaleAspectFill
        imageBook.clipsToBounds = true
        
        //  imageIsChanged = true
        
        dismiss(animated: true)
    }
}
