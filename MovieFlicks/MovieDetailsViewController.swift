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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var title = defaults.objectForKey("movie_title") as! String
        var overview = defaults.objectForKey("movie_overview") as! String
        var releaseDate = defaults.objectForKey("release_date") as! String
        var backdropURL = defaults.objectForKey("backdrop_url") as! String
        var rating = defaults.doubleForKey("movie_rating")
        
        overviewLabel.text = overview
        titleLabel.text = title
        yearLabel.text = releaseDate
        ratingLabel.text = String(format: "%.2f", rating)
        
        if let backdropPath = backdropURL as? String {
            let posterUrl = NSURL(string: backdropPath)
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
