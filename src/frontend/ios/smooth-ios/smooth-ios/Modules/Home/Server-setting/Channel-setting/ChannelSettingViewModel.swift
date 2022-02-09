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
    
    let serverService: ServerServiceProtocol
    
    let server: Server
    
    struct Input {
        let fetch = PublishSubject<Void>()
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
        var categories: [Category] = []
    }
    
    init(
        server: Server,
                    serverService: ServerServiceProtocol
    ) {
        self.server = server
        self.serverService =             serverService
        super.init()
    }
    
    override func bind() {
        self.input.fetch.bind(onNext: self.fetch)
            .disposed(by: disposeBag)
        
        self.input.tapEditCategory
            .bind(onNext: { category in
                self.output.showEditCateogory.accept(category)
            }).disposed(by: disposeBag)
    }
    
    private func fetch() {
        self.showLoading.accept(true)
        serverService.getServerById(server.id) {
            response, error in
            guard let response = response else {
                return
            }

            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
    
            if response.categories != nil {
                var sections: [ChannelSection] = []
                response.categories!.forEach {
                    sections.append(ChannelSection(header: $0.name, id: $0.id, items: $0.channels ?? []))
                }
                
                self.model.section = sections
                self.model.categories = response.categories!
                self.output.section.accept(sections)
            }
            self.showLoading.accept(false)
        }
    }
}
