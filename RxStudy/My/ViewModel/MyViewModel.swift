//
//  MyViewModel.swift
//  RxStudy
//
//  Created by season on 2021/6/16.
//  Copyright © 2021 season. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

class MyViewModel: BaseViewModel {
    
    let currentDataSource = BehaviorRelay<[My]>(value: [])
    
    let myCoin = BehaviorRelay<CoinRank?>(value: nil)
    
    override init() {
        super.init()
        /// 单例的myCoin与VM的myCoin进行绑定
        AccountManager.shared.myCoin.bind(to: myCoin).disposed(by: disposeBag)
        
        /// 单例的isLogin通过map后,与VM的currentDataSource进行绑定
        AccountManager.shared.isLogin
            .map { isLogin in
                isLogin ? MyViewModel.loginDataSource : MyViewModel.logoutDataSource
            }
            .bind(to: currentDataSource)
            .disposed(by: disposeBag)
    }
}

extension MyViewModel {
    func getMyCoin() -> Single<BaseModel<CoinRank>> {
        return myProvider.rx.request(MyService.userCoinInfo)
            .map(BaseModel<CoinRank>.self)

    }
    
    func logout() -> Single<BaseModel<String>> {
        return accountProvider.rx.request(AccountService.logout)
            .map(BaseModel<String>.self)
    }
}

extension MyViewModel {
    static let logoutDataSource: [My] = [.myGitHub, .myJueJin, .openSource, .ranking, .login]
    
    static let loginDataSource: [My] = [.myGitHub, .myJueJin, .openSource, .ranking, .myCoin, .myCollect, .logout]
}
