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


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nwerrorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.rowHeight = 140.0
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // change title color and drop the shadow like it's hot
        let shadow = NSShadow();
        shadow.shadowColor = UIColor.blackColor();
        shadow.shadowOffset = CGSizeMake(1,2);
        navigationController!.navigationBar.titleTextAttributes = NSDictionary(objects: [UIColor.whiteColor(), shadow], forKeys: [NSForegroundColorAttributeName, NSShadowAttributeName]) as! [String : AnyObject];
        
        self.nwerrorView.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                            self.filteredData = self.movies
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
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
        if let movies = filteredData {
            //print(movies.count)
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
        
        // No color when the user selects cell
        cell.selectionStyle = .None

        
        let movie = filteredData![indexPath.row]
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
//        if let posterPath = movie["poster_path"] as? String {
//            //let posterUrl = NSURL(string: baseUrl + posterPath)
//            //cell.posterView.setImageWithURL(posterUrl!)
//            let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
//
//            cell.posterView.setImageWithURLRequest(
//                imageRequest,
//                placeholderImage: nil,
//                success: { (imageRequest, imageResponse, image) -> Void in
//                
//                    // imageResponse will be nil if the image is cached
//                    if imageResponse != nil {
//                        print("Image was NOT cached, fade in image")
//                        //cell.posterView.alpha = 0.0
//                        cell.posterView.image = image
//                        UIView.animateWithDuration(0.5, animations: { () -> Void in
//                            cell.posterView.alpha = 1.0
//                        })
//                    } else {
//                        print("Image was cached so just update the image")
//                        cell.posterView.image = image
//                    }
//                },
//                failure: { (imageRequest, imageResponse, error) -> Void in
//                    // do something for the failure condition
//            })
//
//        } else {
//                // No poster image. Can either set to nil (no image) or a default movie poster image
//                // that you include as an asset
//                cell.posterView.image = nil
//        }
        
        //print("row \(indexPath.row)")
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movies!.filter({(dataItem: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let title = dataItem["title"] as! String
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = movies
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = filteredData![indexPath!.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        
    }


}
