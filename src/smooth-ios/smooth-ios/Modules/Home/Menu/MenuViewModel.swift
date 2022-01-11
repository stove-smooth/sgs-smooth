//
//  MenuViewModel.swift
//  smooth-ios
//
//  Created by 김하나 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

struct Input {
    let value: Observable<(id: UUID, value: Int)>
    let selectedChanged: Observable<(id: UUID, selected: Bool)>
    //    let add: Observable<Void>
    //    let delete: Observable<UUID>
}

struct ViewModel {
    let counters: Driver<[Model]>
    let fetchServer = BehaviorRelay<String>(value: "")
}

extension ViewModel {
    private enum Action {
        //        case add(model: [Model])
        case value(id: UUID, value: Int)
        case selectedChanged(id: UUID, selected: Bool)
        //        case delete(id: UUID)
    }
    
    init(_ input: Input, refreshTask: @escaping () -> Observable<[Model]>) {
        //        let addAction = input.add
        //            .flatMapLatest(refreshTask)
        //            .map(Action.add)
        let valueAction = input.value.map(Action.value)
        let selectedChangedAction = input.selectedChanged.map(Action.selectedChanged)
        //        let deleteAction = input.delete.map(Action.delete)
        
        self.fetchServer
            .asObservable()
            .subscribe(onNext: { value in
                print("self.roomViewModel.data[indexPath.row] \(value)")
            }) .disposed(by: DisposeBag())
        
        counters = Observable.merge(valueAction, selectedChangedAction)
            .scan(into: []) { model, new in
                switch new {
                //                case .add(let values):
                //                    model = values
                case .value(let id, let value):
                    if let index = model.firstIndex(where: { $0.id == id }) {
                        model[index].value = value
                    }
                case .selectedChanged(let id, let selected):
                    if let index = model.firstIndex(where: { $0.id == id }) {
                        model[index].selected = selected
                    }
                //                case .delete(let id):
                //                    if let index = model.index(where: { $0.id == id }) {
                //                        model.remove(at: index)
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
