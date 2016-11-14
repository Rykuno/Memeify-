//
//  CollectionViewController.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/14/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class MemeCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]!
    let cellSpacing = CGFloat(5)

    override func viewDidLoad() {
        super.viewDidLoad() 
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddMeme))
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
    }
    
    override func viewWillLayoutSubviews() {
        let imageSideLength: CGFloat
        let screenSize = UIScreen.main.bounds.size
        if screenSize.height > screenSize.width {
            imageSideLength = (view.frame.width - (2 * cellSpacing)) / 3
        } else {
            imageSideLength = (view.frame.width - (4 * cellSpacing)) / 5
        }
        flowLayout.itemSize = CGSize(width: imageSideLength, height: imageSideLength)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memesArray
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.memedImage = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCell
        cell.configureCell(memeImage: memes[indexPath.row].memedImage)
        return cell
    }
    
    func AddMeme(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let AddMemeVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        self.navigationController?.present(AddMemeVC, animated: true, completion: nil)
    }


}
