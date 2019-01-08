//
//  videoModel.swift
//  YouTubeApp
//
//  Created by Jordan on 2018-08-03.
//  Copyright © 2018 Jordan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_URL = "https://www.googleapis.com/youtube/v3/playlistItems"
    let API_KEY = // API Key goes here
    let PLAYLIST_ID = "PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9ua"
    
    var videoArray = [Video]()
    
    var delegate:VideoModelDelegate?
    
    func getFeedVideos() {
        //Fetch the videos dynamically through the YouTube Data API
        Alamofire.request(API_URL, method: .get, parameters: ["part":"snippet", "playlistId":PLAYLIST_ID,"key":API_KEY], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                print("json response: \(json)")
                
                var arrayOfVideos = [Video]()
                
                for i in 0..<json.count {
                    let videoObj = Video()
                    videoObj.videoID = json["items"][i]["snippet"]["resourceId"]["videoId"].stringValue
                    videoObj.videoTitle = json["items"][i]["snippet"]["title"].stringValue
                    videoObj.videoDescription = json["items"][i]["snippet"]["description"].stringValue
                    videoObj.videoThumbnailUrl = json["items"][i]["snippet"]["thumbnails"]["maxres"]["url"].stringValue
                    
                    arrayOfVideos.append(videoObj)
                }
                
                // When all the video objects have been constructed, assign the array to the VideoModel property
                self.videoArray = arrayOfVideos
                
                // Notify the delegate that the data is ready
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
            }
        }
    }

    func getVideos() -> [Video] {
        
        var videos = [Video]()
        
        // Create a video object
        let video1 = Video()
        // Assign properties
        video1.videoID = "jK3U6xUPFyE"
        video1.videoTitle = "History 1"
        video1.videoDescription = "Part 1"
        // Append it into the video array
        videos.append(video1)
        
        // Create a video object
        let video2 = Video()
        // Assign properties
        video2.videoID = "qxY6D6iaZzo"
        video2.videoTitle = "History 2"
        video2.videoDescription = "Part 2"
        // Append it into the video array
        videos.append(video2)
        
        // Create a video object
        let video3 = Video()
        // Assign properties
        video3.videoID = "TkoQltcEj3Q"
        video3.videoTitle = "History 3"
        video3.videoDescription = "Part 3"
        // Append it into the video array
        videos.append(video3)
        
        // Create a video object
        let video4 = Video()
        // Assign properties
        video4.videoID = "YVyxb63vLaQ"
        video4.videoTitle = "History 4"
        video4.videoDescription = "Part 4"
        // Append it into the video array
        videos.append(video4)
        
        return videos
    }
    
}
