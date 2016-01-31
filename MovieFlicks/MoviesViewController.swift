//
//  MoviesViewController.swift
//  MovieFlicks
//
//  Created by Aditya Purandare on 25/01/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nwerrorView: UIView!
    
    var movies: [NSDictionary]?
    var data: NSArray = []
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.rowHeight = 140.0

        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.nwerrorView.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                    }
                } else {
                    self.nwerrorView.hidden = false
                    self.tableView.hidden = true
                }

                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
        })
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                        }
                }
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()

        })
        task.resume()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            print(movies.count)
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell

        print(indexPath.row)
        cell.tintColor = UIColor.whiteColor()

        cell.posterView.alpha = 0.0
        cell.titleLabel.alpha = 0.0
        cell.overviewLabel.alpha = 0.0
        cell.ratingLabel.alpha = 0.0
        cell.yearLabel.alpha = 0.0
        
        let movie = movies![indexPath.row]
        let mTitle = movie["title"] as! String
        let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Double
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let releaseDate = movie["release_date"] as! String
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }
        
        cell.titleLabel.text = mTitle
        cell.overviewLabel.text = overview
        cell.ratingLabel.text = String(format: "%.2f", rating)
        cell.yearLabel.text = releaseDate
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseOut, animations:
            {
                cell.posterView.alpha = 1.0
                cell.titleLabel.alpha = 1.0
                cell.overviewLabel.alpha = 1.0
                cell.ratingLabel.alpha = 1.0
                cell.yearLabel.alpha = 1.0
            },
            completion:
            {
                (finished:Bool) in
            }
        )
        
        //print("row \(indexPath.row)")
        return cell
    }
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        print(indexPath.row)
//        let movie = movies![indexPath.row]
//        let mTitle = movie["title"] as! String
//        let overview = movie["overview"] as! String
//        let rating = movie["vote_average"] as! Double
//        let baseUrl = "http://image.tmdb.org/t/p/w500"
//        let releaseDate = movie["release_date"] as! String
//        let backdropPath = movie["backdrop_path"] as! String
//        
//        //print(movie)
//        
//        var backdropURL = ""
//        if let backdropPath = backdropPath as? String {
//            backdropURL = baseUrl + backdropPath
//        } else {
//            backdropURL = "nil"
//        }
//        
//        //Storing Data in NSUserDefaults to pass to the segue
//        defaults.setObject(mTitle, forKey: "movie_title")
//        defaults.setObject(overview, forKey: "movie_overview")
//        defaults.setDouble(rating, forKey: "movie_rating")
//        defaults.setObject(backdropURL, forKey: "backdrop_url")
//        defaults.setObject(releaseDate, forKey: "release_date")
//        defaults.synchronize()
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        
    }


}
