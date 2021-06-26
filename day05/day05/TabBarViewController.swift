//
//  TabBarViewController.swift
//  day05
//
//  Created by Lidia Grigoreva on 26.06.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    
    func setupVCs() {
          viewControllers = [
              createNavController(for: ViewController(), title: NSLocalizedString("Map", comment: ""), image: UIImage(systemName: "map")!),
              createNavController(for: ViewController(), title: NSLocalizedString("Places", comment: ""), image: UIImage(systemName: "mappin")!),
          ]
      }
    
}