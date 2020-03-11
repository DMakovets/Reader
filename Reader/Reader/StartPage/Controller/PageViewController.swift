//
//  PageViewController.swift
//  Reader
//
//  Created by Denis Makovets on 3/9/20.
//  Copyright © 2020 Denis Makovets. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let boldTextContent = ["Книги ePub","Шрифты и настройки","Любимые цитаты","Чтение офлайн"]
    let normalTextContent = ["Загружай книги в формате ePub",
                             "Меняй шрифты, яркость на экрана и режим(дневной, ночной)",
                             "Сохраняй понравившееся цитаты в избранное и перечитывай их в любое время",
                             "Читай книги когда угодно без доступа в интернет"]
    let imageContent = [
        UIImage(named: "landing1.png"),
        UIImage(named: "landing2.png"),
        UIImage(named: "landing3.png"),
        UIImage(named: "landing4.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataSource = self
        
        if let contentViewController = showViewControllerAtIndex(0){
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil )
        }
    }
    
    func showViewControllerAtIndex(_ index: Int) -> ContentViewController? {
        
        let storyboard = UIStoryboard(name: "StartPage", bundle: nil) 
        guard index >= 0 else { return nil }
        guard index < boldTextContent.count else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "presentationWasViewed")
            dismiss(animated: true, completion: nil)
            return nil
            
        }
        guard let contentViewController = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {return nil}
        
        contentViewController.boldText = boldTextContent[index]
        contentViewController.normalText = normalTextContent[index]
        contentViewController.image = imageContent[index]!
        contentViewController.currentPage = index
        contentViewController.numberOfPages = boldTextContent.count
        
        return contentViewController 
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    
}
