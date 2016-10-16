//
//  MoviesViewController.swift
//  MyMovie
//
//  Created by Duc Dinh on 10/10/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UITableViewController {
  
  lazy var reachabilityManager = ReachabilityManager()
  var movies = [NSDictionary]()
  lazy var searchBar = UISearchBar()
  lazy var refreshCtl = UIRefreshControl()
  
  @IBOutlet var movieTableView: UITableView!
  
  func loadData() {
    if reachabilityManager.isUnreachable() {
      return
    }
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
    let request = URLRequest(
      url: url!,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
      timeoutInterval: 10)
    
    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main
    )
    
    // Display HUD right before the request is made
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    let task: URLSessionDataTask =
      session.dataTask(
        with: request,
        completionHandler: { (dataOrNil, response, error) in
          if let data = dataOrNil {
            if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
              print("response: \(responseDictionary)")
              // Hide HUD once the network request comes back (must be done on main UI thread)
              MBProgressHUD.hide(for: self.view, animated: true)
              
              let moviesData = responseDictionary["results"] as! [NSDictionary]
              if moviesData.count != 0 {
                self.movies = moviesData
                self.movieTableView.reloadData()
                self.refreshCtl.endRefreshing()
              }
            }
          }
      })
    task.resume()
  }
  
  func initSearchBar() {
    searchBar.delegate = self
    searchBar.placeholder = "Search"
    navigationItem.titleView = searchBar
  }
  
  func initPullToRefresh() {
    refreshCtl.addTarget(self, action: #selector(MoviesViewController.loadData), for: UIControlEvents.valueChanged)
    movieTableView.insertSubview(refreshCtl, at: 0)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
    reachabilityManager.reachibilityDelegate = self
    initPullToRefresh()
    initSearchBar()
    movieTableView.dataSource = self
    movieTableView.delegate = self
    loadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if reachabilityManager.isUnreachable() {
      reachabilityManager.showNetworkProblemAlert(sender: self)
    }
  }
  
  // in iOS10, UITableViewController already conforms 2 protocol UITableViewDataSource, UITableViewDelegate
  // overried methods or UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    print("movie: \(movies)")
    return movies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCellView
    let movie = movies[indexPath.row]
    
    if let posterPath = movie["poster_path"] as? String {
      let posterBaseUrl = "http://image.tmdb.org/t/p/w45" // low resolution for thumbnail
      cell.posterImageView.setImageWith(URL(string: posterBaseUrl + posterPath)!)
    } else {
      cell.posterImageView.image = nil
    }
    
    cell.overviewLabel.text = (movie["overview"] as! String)
    cell.titleLabel.text = (movie["title"] as! String)
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // sender is instance of MovieDetailViewController
    let movieDetailViewController = segue.destination as! MovieDetailViewController
    let selectedIdx = movieTableView.indexPathForSelectedRow?.row
    movieDetailViewController.movie = movies[selectedIdx!]
  }
}

extension MoviesViewController : UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //
  }
}

extension MoviesViewController : ReachabilityDelegate {
  func didReachableInternet() {
    loadData()
  }
  
  func didUnreachableInternet() {
    // do something that different from showing network error
  }
}
