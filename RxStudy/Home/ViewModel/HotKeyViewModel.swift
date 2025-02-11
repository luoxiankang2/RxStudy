//
//  HotKeyViewModel.swift
//  RxStudy
//
//  Created by season on 2021/5/28.
//  Copyright © 2021 season. All rights reserved.
//

import RxSwift
import RxCocoa
import NSObject_Rx
import Moya

class HotKeyViewModel: BaseViewModel {
    
    /// outputs
    let dataSource = BehaviorRelay<[HotKey]>(value: [])
    
    /// inputs
    func loadData() {
        requestData()
    }
}

//MARK: - 网络请求
private extension HotKeyViewModel {
    func requestData() {
        homeProvider.rx.request(HomeService.hotKey)
            .map(BaseModel<[HotKey]>.self)
            .map{ $0.data }
            /// 去掉其中为nil的值
            .compactMap{ $0 }
            .asObservable()
            .asSingle()
            .subscribe { event in
                switch event {
                case .success(let items):
                    self.networkError.onNext(nil)
                    self.dataSource.accept(items)
                case .error(let error):
                    guard let moyarror = error as? MoyaError else { return }
                    self.networkError.onNext(moyarror)
                }
            }
            .disposed(by: disposeBag)
    }
}

