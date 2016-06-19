//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Jennifer Person on 6/16/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    


    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var contentView = UIView()
    
    override func viewWillAppear(animated: Bool) {
        // refresh data when returning to screen to add new memes
        collectionView!.reloadData()
        collectionView?.hidden = false
        tabBarController!.tabBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        collectionView?.hidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make memes readable in the collection view
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 6
        let heightDimension = (view.frame.size.height - (2 * space)) / 6
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // return the current number of memed images in the collection view
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }
    
    // configure data for each cell of collection view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        // Configure the cell...
        cell.memedImage.image = meme.memedImage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
    // show the meme selected in the collection view
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = memes[indexPath.item] as Meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueFromCollection") {
            tabBarController!.tabBar.hidden = true
        }
    }
    
    
    @IBAction func addMeme(sender: AnyObject) {
        performSegueWithIdentifier("segueFromCollection", sender: "addMeme")
    }

}
