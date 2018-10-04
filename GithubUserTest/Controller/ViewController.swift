//
//  ViewController.swift
//  GithubUserTest
//
//  Created by Chris Ferdian on 04/10/18.
//  Copyright © 2018 Chris Ferdian. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ViewControllerHome: UIViewController {

    @IBOutlet weak var tableUser:UITableView!
    
    var users = [User]()
    var filteredSearch = [User]()

    var isLoading = false
    var currentPage = 1
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableUser.delegate = self
        tableUser.dataSource = self
        tableUser.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search by username"
        definesPresentationContext = true
        tableUser.tableHeaderView = searchController.searchBar
        
        getUserData()
    }
    
    func getUserData(){
        isLoading = true
        self.showLoadingView()
        Alamofire.request("https://api.github.com/repos/git/git/contributors?page=\(currentPage)&per_page=10").responseArray { (response: DataResponse<[User]>) in
            
            let forecastArray = response.result.value
            
            if let userArray = forecastArray {
                for user in userArray {
                    self.users.append(user)
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableUser.reloadData()
                }
            }
        }
    }
    func showLoadingView(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableUser.bounds.width, height: CGFloat(44))
        
        self.tableUser.tableFooterView = spinner
        self.tableUser.tableFooterView?.isHidden = false
    }
    @IBAction func sort(){
        let sortedMovies = users.sorted { $0.login!.lowercased() < $1.login!.lowercased() }
        users = sortedMovies
        DispatchQueue.main.async {
            self.tableUser.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}

extension ViewControllerHome : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.searchBar.text! == "" && !searchController.isActive {
            let lastData = self.users.count - 1
            if !isLoading && indexPath.row == lastData {
                self.currentPage += 1
                self.getUserData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        cell.bind(user: users[indexPath.row])
        return cell
    }
}

extension ViewControllerHome: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredSearch = users
        } else {
            users = users.filter { $0.login!.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableUser.reloadData()
    }
}
