//
//  BaseRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya
import RxSwift

class BaseRepository<API: TargetType> {
    let disposeBag = DisposeBag()
    
    private let provider = MoyaProvider<API>()
    lazy var rx = provider.rx
}
