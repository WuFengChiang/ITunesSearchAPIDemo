//
//  MainViewControllerManager.swift
//  M800Assignment
//
//  Created by wuufone on 2019/8/24.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit

class MainViewControllerManager: NSObject, MainViewControllerDelegate {
    
    var songs: [Song] = [Song]()
    var musicTableView: UITableView
    
    public init(musicTableView tableView: UITableView) {
        self.musicTableView = tableView
    }
    
    func handleViewDidLoad() {
        addDefaultMessageToFirstRowWhenSongDataIsEmpty()
    }
    
    func doSearch(_ searchBar: UISearchBar) {
        triggerSeach(searchBar)
        unfocuseSearchBar(searchBar)
    }
    
    private func triggerSeach(_ searchBar: UISearchBar) {
        if let inputText = searchBar.text {
            ITunesSearchAPIHelper().search(term: inputText, handler: loadSongData(_:))
        }
    }
    
    private func unfocuseSearchBar(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
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
    
    private func addDefaultMessageToFirstRowWhenSongDataIsEmpty() {
        let emptySong = Song(trackName: "無任何歌曲資訊", artistName: "請執行搜尋", previewURLString: "", artworkURLString: "")
        songs.append(emptySong)
    }
}
