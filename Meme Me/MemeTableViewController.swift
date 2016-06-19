//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Jennifer Person on 6/13/16.
//  Copyright © 2016 udacity. All rights reserved.
//

//import Foundation
import UIKit

class MemeTableViewController: UITableViewController {

    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // set up view of table
    override func viewWillAppear(animated: Bool) {
        tableView.hidden = false
        // reload table data to show new memes
        tableView.reloadData()
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        tableView.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    // set up cells in table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row] as Meme
        
        // Configure the cell
        cell.memedImage.image = meme.memedImage
        cell.topLabel.text = meme.topTextField
        cell.bottomLabel.text = meme.bottomTextField
        
        return cell
    }
    
    // show corret meme in detail view controller when selected from the table view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController:DetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = memes[indexPath.row] as Meme
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueFromTable") {
            tabBarController!.tabBar.hidden = true
        }
    }
    
    // add new meme
    @IBAction func addMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("segueFromTable", sender: "addMeme")
    }
    
}