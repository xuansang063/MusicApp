//
//  AlbumView.swift
//  MusicApp
//
//  Created by admin on 26/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

protocol AlbumViewDelegate: class {
    func onPressViewSeeAll(keyword: String)
}

class AlbumView: BaseTableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: AlbumViewDelegate!
    
    var items: [ItemSearch]! = [] {
        didSet {
            if items != nil {
                collectionView.reloadData()
            }
        }
    }
    
    var keyword: String! = "" {
        didSet {
            self.callGetListVideo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func callGetListVideo() {
        if let items = self.items, items.count <= 0 {
            Provider.shared.callApiGetListVideo(pageToken: "", maxResult: 6, keyword: keyword, success: { (BaseResponse) in
                self.items = BaseResponse.items
                self.lblTitle.text = self.keyword
            }) { (error) in
                print(error)
            }
        }
    }
    
    @IBAction func onPressViewAll(_ sender: UIButton) {
        delegate.onPressViewSeeAll(keyword: self.lblTitle.text ?? "")
    }
}

extension AlbumView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count >= 6 ? 6 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AlbumCell
        let item = items[indexPath.row]
        if let snippet = item.snippet, let thumbnails = snippet.thumbnails {
            cell.img.loadImageFromInternet(link: thumbnails.defaults!.url!)
            cell.lblTitle.text = snippet.title
            cell.lblChanel.text = snippet.channelTitle
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppConstant.SREEEN_WIDTH - 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = ["items": self.items ?? [],
                    "currentIndex": indexPath.row,
                    "type": PlaylistType.search] as [String : Any]
        NotificationCenter.default.post(name: .OpenPlayBar, object: nil, userInfo: data)
    }
    
}
