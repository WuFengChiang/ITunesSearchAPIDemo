//
//  MainViewController.swift
//  M800Assignment
//
//  Created by wuufone on 2019/8/23.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var songs: [Song] = [Song]()
    
    @IBOutlet weak var musicSearchBar: UISearchBar! {
        didSet {
            musicSearchBar.placeholder = "Track name or artist name"
            musicSearchBar.delegate = self
            musicSearchBar.returnKeyType = .search
            musicSearchBar.enablesReturnKeyAutomatically = true
        }
    }
    
    @IBOutlet weak var musicTableView: UITableView! {
        didSet {
            musicTableView.delegate = self
            musicTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func loadSongData(_ valueOfResultsItem: [[String : AnyObject]]) {
        for aSong in valueOfResultsItem {
            self.songs.append(Song(trackName: aSong["trackName"] as! String,
                                   artistName: aSong["artistName"] as! String,
                                   previewURL: aSong["previewUrl"] as! String,
                                   artworkURL: aSong["artworkUrl60"] as! String))
        }
        self.musicTableView.reloadData()
    }
}

// MARK: SearchBar

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let inputText = searchBar.text {
            ITunesSearchAPIHelper().search(term: inputText, handler: loadSongData(_:))
        }
        searchBar.endEditing(true)
    }
}

// MARK: TableView

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELL_ID = "SONG_CELL"
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = songs[indexPath.row].trackName
        cell.detailTextLabel?.text = songs[indexPath.row].artistName
        
        do {
            let imageData = try Data(contentsOf: URL(string: songs[indexPath.row].artworkURL)!)
            cell.imageView?.image = UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }
        return cell
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
}

struct Song {
    var trackName: String
    var artistName: String
    var previewURL: String
    var artworkURL: String
}
