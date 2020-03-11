//
//  ContentViewController.swift
//  Reader
//
//  Created by Denis Makovets on 3/9/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var boldLabel: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var boldText = ""
    var normalText = ""
    var image = UIImage()
    var currentPage = 0
    var numberOfPages = 0
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boldLabel.text = boldText
        normalLabel.text = normalText
        imageLabel.image = image
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        
    }
    

}
