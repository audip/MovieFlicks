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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let title = defaults.objectForKey("movie_title") as! String
//        let overview = defaults.objectForKey("movie_overview") as! String
//        let releaseDate = defaults.objectForKey("release_date") as! String
//        let backdropURL = defaults.objectForKey("backdrop_url") as! String
//        let rating = defaults.doubleForKey("movie_rating")
        
        //print(movie)
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        let releaseDate = movie["release_date"] as? String
        let rating = movie["vote_average"] as? Double
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        overviewLabel.text = overview
        titleLabel.text = title
        yearLabel.text = releaseDate
        ratingLabel.text = String(format: "%.2f", rating!)
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            backdropView.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            backdropView.image = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
