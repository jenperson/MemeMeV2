//
//  DetailViewController.swift
//  Meme Me
//
//  Created by Jennifer Person on 6/14/16.
//  Copyright © 2016 udacity. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
