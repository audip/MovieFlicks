//
//  MovieDetailsViewController.swift
//  MovieFlicks
//
//  Created by Aditya Purandare on 29/01/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        let releaseDate = movie["release_date"] as? String
        let rating = movie["vote_average"] as? Double
        
        overviewLabel.text = overview
        titleLabel.text = title
        yearLabel.text = releaseDate
        ratingLabel.text = String(format: "%.2f", rating!)
        
        overviewLabel.sizeToFit()
        infoView.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            
            //let posterUrl = NSURL(string: baseUrl + posterPath)
            //backdropView.setImageWithURL(posterUrl!)
            let smallBaseURL = "https://image.tmdb.org/t/p/w154"
            let largeBaseURL = "https://image.tmdb.org/t/p/original"
            
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallBaseURL + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeBaseURL + posterPath)!)
            
            self.backdropView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.backdropView.alpha = 0.0
                    self.backdropView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.backdropView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            self.backdropView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.backdropView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
        }
        else {
            backdropView.image = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
