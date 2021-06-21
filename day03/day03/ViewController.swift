//
//  ViewController.swift
//  day03
//
//  Created by Lidia Grigoreva on 18.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var flag = Bool()
    private var images = [UIImage]()
    private var myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let ImagesURI: [String] = [
//        "https://www.nasa.gov/sites/default/files/thumbnails/image/curiosity_selfie1.jpg",
        "https://www.media.inaf.it/wp-content/uploads/2015/11/international-space-station-space-hd-wallpaper-1920x1200-3511.jpg",
        "https://loveopium.ru/content/2012/12/marble/04big.jpg",
        "https://s.yimg.com/os/creatr-images/2020-02/d5df5420-5945-11ea-9777-5eaf09879548",
        "https://assets.hongkiat.com/uploads/ww-falling-stars-meteors-wallpapers/4k/original/08.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images"
        view.backgroundColor = .white
        
        myCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        view.addSubview(myCollectionView)
        myCollectionView.backgroundColor = .white
        
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        myCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        
        (myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (myCollectionView.frame.width - 10) / 2, height: (myCollectionView.frame.width - 10) / 2)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCollectionViewCell
                
        myCell.backgroundView = myCell.tImage
        myCell.addSubview(myCell.spinner)
        myCell.spinner.centerYAnchor.constraint(equalTo: myCell.centerYAnchor).isActive = true
        myCell.spinner.centerXAnchor.constraint(equalTo: myCell.centerXAnchor).isActive = true
        myCell.delegate = self
        
        let imageId =  indexPath.section * 2 + indexPath.row
        myCell.imageURL = URL(string: ImagesURI[imageId])
        
        return myCell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.section) \(indexPath.row)")
        let cell = myCollectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        let secondVC = SecondVC(cell: cell)
        
        navigationController?.pushViewController(secondVC, animated: false)
    }
}
