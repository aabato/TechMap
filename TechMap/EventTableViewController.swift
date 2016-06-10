//
//  EventTableViewController.swift
//  TechMap
//
//  Created by Angelica Bato on 6/9/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit



class EventTableViewController: UITableViewController {
    
    var events:[EventPlace] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        let event = self.events[indexPath.row]
        cell.textLabel!.text = event.name
        cell.detailTextLabel!.text = event.time
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event:EventPlace! = events[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewControllerWithIdentifier("eventDetailVC") as! EventDetailsViewController
        detailVC.event = event
        detailVC.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(detailVC, animated: true, completion: nil)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
