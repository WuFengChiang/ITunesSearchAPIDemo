//
//  MainViewController.swift
//  M800Assignment
//
//  Created by wuufone on 2019/8/23.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate {
    var songs: [Song] {get set}
    func handleViewDidLoad()
    func doSearch(_ searchBar: UISearchBar)
    func playPreviewTrack(_ indexPath: IndexPath)
}

class MainViewController: UIViewController {

    var delegate: MainViewControllerDelegate?
    
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
        
        self.delegate = MainViewControllerManager(musicTableView: self.musicTableView)
        self.delegate?.handleViewDidLoad()
    }
}

// MARK: - SearchBar

extension MainViewController: UISearchBarDelegate {
    
    // MARK: Delegate implements
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.doSearch(searchBar)
    }
}

// MARK: - TableView UITableViewDelegate Implement

extension MainViewController: UITableViewDelegate {
    
    // MARK: implement methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELL_ID = "SONG_CELL"
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = self.delegate!.songs[indexPath.row].trackName
        cell.detailTextLabel?.text = self.delegate!.songs[indexPath.row].artistName
    
        return cellWhichWasloadedArtworkImage(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate!.playPreviewTrack(indexPath)
    }
    
    // MARK: Task methods
    
    func cellWhichWasloadedArtworkImage(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        if cell.imageView?.image == nil {
            cell.imageView?.image = UIImage(named: "default_track_image")
        }
        
        guard self.delegate!.songs[indexPath.row].artworkURLString != "" else {
            cell.imageView?.image = nil
            return cell
        }
        
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: URL(string: self.delegate!.songs[indexPath.row].artworkURLString)!)
                
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
        return self.delegate!.songs.count
    }
}

// MARK: - View Models

struct Song {
    var trackName: String
    var artistName: String
    var previewURLString: String
    var artworkURLString: String
}
