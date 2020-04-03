//
//  SearchViewController.swift
//  MusicApp
//
//  Created admin on 24/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var tbView: UITableView!
    
    var presenter: SearchPresenterProtocol?
    
    private lazy var searchVC = { () -> UISearchController in
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = LocalizableKey.searchMusic.localizeLanguage
        search.searchBar.set(textColor: .white)
        search.searchBar.setTextField(color: UIColor(displayP3Red: 102/255, green: 90/255, blue: 240/255, alpha: 1))
        search.searchBar.setPlaceholder(textColor: .lightText)
        search.searchBar.setSearchImage(color: .lightText)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.delegate = self
        return search
    }()
    
    private var isSearch = false {
        didSet {
            tbView.reloadData()
        }
    }
    private var nextPageToken = ""
    private var results: [ItemSearch] = []
    private var searchText = ""
    private var timer: Timer?
    private var canLoadMore = false
    
    private var albums = ["Classical Music", "Nursery Rhymes","K-POP"]
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: LocalizableKey.search.localizeLanguage)
        setUpViews()
        setUpTbView()
    }
    
    private func setUpViews() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchVC
    }
    
    private func setUpTbView() {
        tbView.registerXibFile(TrendingView.self)
        tbView.registerXibFile(AlbumView.self)
        tbView.registerXibFile(SearchCell.self)
        tbView.separatorStyle = .none
        tbView.showsHorizontalScrollIndicator = false
        tbView.dataSource = self
        tbView.delegate = self
        tbView.contentInsetAdjustmentBehavior = .always

        tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
    }
    
    @objc func performSearch() {
        self.results = []
        self.presenter?.startSearchWith(keyword: searchText, maxResult: 25, pageToken: "")
    }
    
    override func didChangeLanguage() {
        searchVC.searchBar.placeholder = LocalizableKey.searchMusic.localizeLanguage
        setTitle(title: LocalizableKey.search.localizeLanguage)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, TrendingViewDelegate, AlbumViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return !isSearch ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? results.count : (section == 0 ? 1 : albums.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isSearch {
            if indexPath.section == 0 {
                let cell = tableView.dequeueTableCell(TrendingView.self)
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueTableCell(AlbumView.self)
                cell.delegate = self
                cell.keyword = albums[indexPath.row]
                return cell
            }
        } else {
            let cell = tableView.dequeueTableCell(SearchCell.self)
            let item = results[indexPath.row]
            if let snippet = item.snippet, let thumbnails = snippet.thumbnails {
                cell.img.loadImageFromInternet(link: thumbnails.defaults!.url!, completion: nil)
                cell.lblTitle.text = snippet.title
                cell.lblChanel.text = snippet.channelTitle
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = ["items": self.results,
                    "currentIndex": indexPath.row,
                    "type": PlaylistType.search] as [String : Any]
        NotificationCenter.default.post(name: .OpenPlayBar, object: nil, userInfo: data)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == results.count - 1  {
            self.presenter?.startSearchWith(keyword: searchText, maxResult: 25, pageToken: nextPageToken)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSearch ? 70 : (indexPath.section == 0 ? 415 : 290)
    }
    
    func onPressViewSeeAll(keyword: String) {
        let playlistVC = PlaylistRouter.createModule(type: .search, keyword: keyword)
        self.push(controller: playlistVC)
    }
    
    func onPressViewSeeAll() {
        let playlistVC = PlaylistRouter.createModule(type: .trending, keyword: LocalizableKey.trending.localizeLanguage + JsonHelper.getRegionName())
        self.push(controller: playlistVC)
    }
}

extension SearchViewController: SearchViewProtocol
{
    func responseSearchSuccess(response: SearchResponse) {
        if let items = response.items {
            results.append(contentsOf: items)
        }
        if let token = response.nextPageToken {
            nextPageToken = token
        }
        tbView.reloadData()
    }
    
    func responseSearchFail(error: String) {
        
    }
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.searchText = searchText
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
        } else {
            results = []
            tbView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearch = false
    }
}
