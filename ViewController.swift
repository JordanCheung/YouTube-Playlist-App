//
//  ViewController.swift
//  YouTubeApp
//
//  Created by Jordan on 2018-08-03.
//  Copyright © 2018 Jordan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.model.delegate = self
        //self.videos = model.getVideos()
        
        // Fire off request to get videos
        model.getFeedVideos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // VideoModel Delegate Methods
    
    func dataReady() {
        // Access video objects that have been downloaded
        self.videos = self.model.videoArray
        // Tell tableview to reload
        self.tableView.reloadData()
    }
    
    // TableView Delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 320) * 180
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        let videoTitle = videos[indexPath.row].videoTitle
        
        // Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        // Customize the cell to display the video title
        // cell.textLabel?.text = videoTitle
        
        // Construct the video thumnail url
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        
        // Create a NSURL object
        let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
        
        if videoThumbnailUrl != nil {
            
            // Create a NSURLRequest object
            let request = NSURLRequest(url: videoThumbnailUrl! as URL)
            
            // Create a NSURLSession
            let session = URLSession.shared
            
            
            // Create a datatask and pass in the request
            let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
                DispatchQueue.main.sync {
                    
                    // Get a reference to the imageview element of the cell
                    let imageView = cell.viewWithTag(1) as? UIImageView
                    // Create an image object from the data and assign it into the imageview
                    imageView?.image = UIImage(data: (data)!)
                    
                }
            }
            dataTask.resume()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Find which video is selected
        self.selectedVideo = self.videos[indexPath.row]
        
        // Call the segue
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get a reference to the destination view controller
        let detailViewController = segue.destination as! VideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
    
}

