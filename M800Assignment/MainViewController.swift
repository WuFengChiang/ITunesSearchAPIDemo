//
//  MainViewController.swift
//  M800Assignment
//
//  Created by wuufone on 2019/8/23.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit
import MediaPlayer

class MainViewController: UIViewController {

    var songs: [Song] = [Song]()
    var audioPlayer: AVPlayer?
    
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
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDefaultMessageToFirstRowWhenSongDataIsEmpty()
    }
    
    // MARK: - Task methods
    
    private func addDefaultMessageToFirstRowWhenSongDataIsEmpty() {
        let emptySong = Song(trackName: "無任何歌曲資訊", artistName: "請執行搜尋", previewURLString: "", artworkURLString: "")
        songs.append(emptySong)
    }
    
    private func loadSongData(_ valueOfResultsItem: [[String : AnyObject]]) {
        self.songs = [Song]()
        for aSong in valueOfResultsItem {
            self.songs.append(Song(trackName: aSong["trackName"] as! String,
                                   artistName: aSong["artistName"] as! String,
                                   previewURLString: aSong["previewUrl"] as! String,
                                   artworkURLString: aSong["artworkUrl60"] as! String))
        }
        if self.songs.count == 0 {
            addDefaultMessageToFirstRowWhenSongDataIsEmpty()
        }
        self.musicTableView.reloadData()
    }
}

// MARK: - SearchBar

extension MainViewController: UISearchBarDelegate {
    
    // MARK: Delegate implements
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        triggerSeach(searchBar)
        unfocuseSearchBar(searchBar)
    }
    
    // MARK: Task methods
    
    fileprivate func triggerSeach(_ searchBar: UISearchBar) {
        if let inputText = searchBar.text {
            ITunesSearchAPIHelper().search(term: inputText, handler: loadSongData(_:))
        }
    }
    
    fileprivate func unfocuseSearchBar(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: - TableView UITableViewDelegate Implement

extension MainViewController: UITableViewDelegate {
    
    // MARK: implement methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELL_ID = "SONG_CELL"
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = songs[indexPath.row].trackName
        cell.detailTextLabel?.text = songs[indexPath.row].artistName
    
        return cellWhichWasloadedArtworkImage(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let prviewURL = URL(string: songs[indexPath.row].previewURLString) {
            let urlAsset = AVURLAsset(url: prviewURL)
            let playerItem = AVPlayerItem(asset: urlAsset)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer!.play()
        }
    }
    
    // MARK: Task methods
    
    func cellWhichWasloadedArtworkImage(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        if cell.imageView?.image == nil {
            cell.imageView?.image = UIImage(named: "default_track_image")
        }
        
        guard self.songs[indexPath.row].artworkURLString != "" else {
            cell.imageView?.image = nil
            return cell
        }
        
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: URL(string: self.songs[indexPath.row].artworkURLString)!)
                
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: imageData)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return cell
    }
}

// MARK: - TableView UITableViewDataSource Implement

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
}

// MARK: - Models

struct Song {
    var trackName: String
    var artistName: String
    var previewURLString: String
    var artworkURLString: String
}
