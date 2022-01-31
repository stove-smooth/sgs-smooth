//
//  ChannelSettingViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import RxSwift
import RxCocoa

class ChannelSettingViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model = Model()
    
    let serverRepository: ServerRepositoryProtocol
    
    let server: Server
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tapEditCategory = PublishRelay<Category>()
    }
    
    struct Output {
        let section = PublishRelay<[ChannelSection]>()
        let pastedBoard = PublishRelay<Invitation>()
        
        let showEmpty = PublishRelay<Bool>()
        
        let showEditCateogory = PublishRelay<Category>()
    }
    
    struct Model {
        var section: [ChannelSection] = []
    }
    
    init(
        server: Server,
        serverRepository: ServerRepositoryProtocol
    ) {
        self.server = server
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
        self.input.viewDidLoad.bind(onNext: self.fetch)
            .disposed(by: disposeBag)
        
        self.input.tapEditCategory
            .bind(onNext: { category in
                self.output.showEditCateogory.accept(category)
            }).disposed(by: disposeBag)
    }
    
    private func fetch() {
        self.showLoading.accept(true)
        serverRepository.getServerById(server.id) {
            response, error in
            guard let response = response else {
                return
            }

            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
            
            self.output.showEmpty.accept(response.categories.count == 0)
            response.categories.forEach {
                self.model.section.append(ChannelSection(header: $0.name, id: $0.id, items: $0.channels ?? []))
            }
            self.output.section.accept(self.model.section)
            
            self.showLoading.accept(false)
        }
    }
}
