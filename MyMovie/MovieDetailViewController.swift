//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Duc Dinh on 10/15/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  
  var movie: NSDictionary!
  lazy var reachabilityManager = ReachabilityManager()
  
  @IBOutlet weak var popularityLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var largePosterImageView: UIImageView!
  
  @IBOutlet weak var detailScrollView: UIScrollView!
  @IBOutlet weak var infoView: UIView!
  
  override func viewWillAppear(_ animated: Bool) {
    if reachabilityManager.isUnreachable() {
      reachabilityManager.showNetworkProblemAlert(sender: self)
    }
  }
  
  func loadLargePoster() {
    if reachabilityManager.isUnreachable() {
      largePosterImageView.image = nil
      return
    }
    
    let largePosterBaseUrl = "https://image.tmdb.org/t/p/original"
    if let posterPath = movie["poster_path"] as? String {
      largePosterImageView.setImageWith(URL(string: largePosterBaseUrl + posterPath)!)
    } else {
      largePosterImageView.image = nil
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reachabilityManager.reachibilityDelegate = self
    
    // set up scroll view
    detailScrollView.contentSize = CGSize(
      width: detailScrollView.frame.size.width,
      height: infoView.frame.origin.y + infoView.frame.size.height
    )
    
    loadLargePoster()
    titleLabel.text = (movie["title"] as! String)
    releaseDateLabel.text = (movie["release_date"] as! String)
    popularityLabel.text = String(format: "%.2f", movie["popularity"] as! Double)
    overviewLabel.text = (movie["overview"] as! String)
    
    titleLabel.sizeToFit()
    overviewLabel.sizeToFit()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension MovieDetailViewController : ReachabilityDelegate {
  func didReachableInternet() {
    loadLargePoster()
  }
  
  func didUnreachableInternet() {
    // do something that different from showing network error
  }
}
