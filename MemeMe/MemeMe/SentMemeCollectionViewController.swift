//
//  sentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by makramia on 20/11/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit

class sentMemeCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(_:)))
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }

   

    @objc func addMeme(_ sender: Any) {
        
        if let navigationController = navigationController {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "memeEditor") as! MemeEditorViewController
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension sentMemeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath ) as! MemeCollectionViewCell
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView?.contentMode = .scaleToFill
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let meme = memes[(indexPath as NSIndexPath).row]
        if let navigationController = navigationController {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailView") as! MemeDetailViewController
            vc.memedImage = meme.memedImage
            navigationController.pushViewController(vc, animated: true)
        }
        
    }

}
