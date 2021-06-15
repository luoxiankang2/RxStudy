//
//  MyController.swift
//  RxStudy
//
//  Created by season on 2021/6/1.
//  Copyright © 2021 season. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import AcknowList

class MyController: BaseTableViewController {
    
    let logoutDataSource: [My] = [.ranking, .openSource, .login]
    
    let loginDataSource: [My] = [.ranking, .openSource, .myCoin, .myCollect, .logout]
    
    var currentDataSource = BehaviorRelay<[My]>(value: [])
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        AccountManager.shared.isLogin.subscribe(onNext: { isLogin in
            print("\(self.className)收到了关于登录状态的值")
            self.currentDataSource.accept(isLogin ? self.loginDataSource : self.logoutDataSource)
            self.tableView.reloadData()
        }).disposed(by: rx.disposeBag)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.mj_header = nil
        tableView.mj_footer = nil
        
        tableView.emptyDataSetSource = nil
        tableView.emptyDataSetDelegate = nil
        
        let isLogin = AccountManager.shared.isLogin.value
        currentDataSource.accept(isLogin ? loginDataSource : logoutDataSource)
            
        currentDataSource.asDriver()
            .drive(tableView.rx.items) { (tableView, row, my) in
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
                    cell.textLabel?.text = my.title
                    return cell
                }else {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                    cell.textLabel?.text = my.title
                    return cell
                }
            }
            .disposed(by: rx.disposeBag)
        
        
        tableView.rx.itemSelected
            .bind { [weak self] (indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: false)
                let my = self?.currentDataSource.value[indexPath.row]
                guard let strongMy = my else { return }
                
                switch strongMy {
                case .logout:
                    break
                case .openSource:
                    self?.navigationController?.pushViewController(AcknowListViewController(), animated: true)
                default:
                    guard let vc = self?.creatInstance(by: strongMy.path) as? UIViewController else {
                        return
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: rx.disposeBag)
    }
}

extension MyController {
    public func creatInstance<T: NSObject>(by className: String) -> T? {
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        
        guard let `class` = NSClassFromString(nameSpace + "." + className), let typeClass = `class` as? T.Type else {
            return nil
        }
        return typeClass.init()
    }
}
