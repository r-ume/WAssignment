//
//  ViewController.swift
//  WAssignment
//
//  Created by 梅木綾佑 on 2017/03/05.
//  Copyright © 2017年 梅木綾佑. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    final let urlString = "https://api.github.com/search/repositories"
    
    var allRepository = [String]()
    
    var searchResultRepository = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchResultRepository = allRepository
        let requestUrl = createRequestUrl()
        downloadJsonWithURL(requestUrl: requestUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        performSegue(withIdentifier: "DetailDestination", sender: indexPath)
    }

    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultRepository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = searchResultRepository[indexPath.row]
        return cell
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let requestUrl = createRequestUrl()
        downloadJsonWithURL(requestUrl: requestUrl)
        reloadSearchRepositoryResult()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let requestUrl = createRequestUrl()
        downloadJsonWithURL(requestUrl: requestUrl)
        reloadSearchRepositoryResult()
        return true
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailDestination" {
            let detailViewController = segue.destination as! DetailViewController
            if let indexPath = sender as? NSIndexPath{
                detailViewController.repositoryName = searchResultRepository[indexPath.row]
            }
        }
    }

    func reloadSearchRepositoryResult(){
        if searchBarTextWithNoSpace() == "" {
            //searchBarが空なら全て表示する
            searchResultRepository = allRepository
        }else{
            //searchBarに文字があればそれを含むレポジトリのみ表示する
            searchResultRepository.removeAll()
            for repository in allRepository{
                if repository.lowercased().contains(searchBarTextWithNoSpace().lowercased()){
                    searchResultRepository.append(repository)
                }
            }
        }
        tableView.reloadData()
    }

    
    // searchBarのテキストの前後の空白をトリムして返す
    func searchBarTextWithNoSpace() -> String {
        return searchBar.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func downloadJsonWithURL(requestUrl: String) {
        let url = NSURL(string: requestUrl)
        print("start")
        
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                if let repositoryArray = jsonObj!.value(forKey: "items") as? NSArray {
                    for repository in repositoryArray{
                        if let repositoryDict = repository as? NSDictionary {
                            if let name = repositoryDict.value(forKey: "name") {
                                self.allRepository.append(name as! String)
                            }
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }).resume()
    }
    
    func createRequestUrl() -> String {
        let searchBarText = searchBar.text!
        let requestUrl = urlString + "?q=" + searchBarText
        return requestUrl
    }
}
