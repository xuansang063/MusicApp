//
//  MoreProtocols.swift
//  MusicApp
//
//  Created admin on 22/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol MoreWireframeProtocol: class {

}
//MARK: Presenter -
protocol MorePresenterProtocol: class {

}

//MARK: Interactor -
protocol MoreInteractorProtocol: class {

  var presenter: MorePresenterProtocol?  { get set }
}

//MARK: View -
protocol MoreViewProtocol: class {

  var presenter: MorePresenterProtocol?  { get set }
}
