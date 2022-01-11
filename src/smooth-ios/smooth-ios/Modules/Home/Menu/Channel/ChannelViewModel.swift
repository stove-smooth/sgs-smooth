//
//  ChannelViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/10.
//

import RxSwift
import RxCocoa

class ChannelViewModel: BaseViewModel {
    
    let input = Input()
    let output = Output()
    
    struct Input {
        let fetchServer = PublishRelay<String>()
        
        let value = PublishSubject<(id: UUID, value: Int)>()
        let selectedChanged = PublishSubject<(id: UUID, selected: Bool)>()
        let delete = PublishSubject<UUID>()
    }
    
    struct Output {
//        let counters: Driver<[Model]>
        let generator = PublishRelay<[Model]>()
    }
    
    
    override init() {
        super.init()
    }
    
    override func bind() {
        self.input.fetchServer
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
    }
}

struct CellInput {
    let select: Observable<Void>
}

struct CellViewModel {
    let label: Observable<String>
    let selected: Observable<Bool>
    
    let selectedChanged: Observable<Bool>
}

extension CellViewModel {
    init(_ input: CellInput, initialValue: Model) {
        selectedChanged = input.select
            .scan(initialValue.selected, accumulator: { val, _ in !val })
        selected = selectedChanged
            .startWith(initialValue.selected)

        label = Observable.combineLatest(selected, selectedChanged)
            .startWith((initialValue.selected, initialValue.selected))
            .map {"\($0) \($1)"}
    }
}

struct Model {
    let id = UUID()
    var value: Int
    var selected: Bool = Bool.random()
    
    init(_ v: Int) {
        self.value = v
    }
}
