//
//  SearchInteractor.swift
//  MusicApp
//
//  Created admin on 24/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class SearchInteractor: SearchInteractorInputProtocol {

    weak var presenter: SearchInteractorOutputProtocol?
    
    func requestSearchWith(keyword: String, maxResult: Int, pageToken: String) {
        Provider.shared.callApiGetListVideo(pageToken: pageToken, maxResult: maxResult, keyword: keyword, success: { (SearchResponse) in
            self.presenter?.onResponseSearchSuccess(response: SearchResponse)
        }) { (error) in
            self.presenter?.onResponseSearchFail(error: error)
        }
    }
    
}

