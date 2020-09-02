//
//  SentMemeCollectionViewController.swift
//  MemeEditor
//
//  Created by Mrunalini Gaddam on 9/2/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit


class SentMemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Variable to hold the saved memes
    var memes = [Meme]()
    
    
    // Instances of tableview and flowlayout to manipulate
    @IBOutlet weak var sentMemeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Collection view delegate and data source methods
        sentMemeCollectionView.delegate = self
        sentMemeCollectionView.dataSource = self
        
        // Collection view sizing
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Access to the shared data model
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        sentMemeCollectionView.reloadData()
    }
    
    // When the user taps on the add button
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! ViewController
        
        present(memeGeneratorVC, animated: true, completion: nil)
        
    }
    
}
extension SentMemeCollectionViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.cellImageView.image = meme.memedImage
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! ViewController
        
        memeGeneratorVC.sentTopText = memes[indexPath.row].topText
        memeGeneratorVC.sentBottomText = memes[indexPath.row].bottomText
        memeGeneratorVC.sentImage = memes[indexPath.row].originalImage
        
        present(memeGeneratorVC, animated: true, completion: nil)
        
    }
}
