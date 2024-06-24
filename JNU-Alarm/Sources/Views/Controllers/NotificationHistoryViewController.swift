//
//  NotificationHistoryViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/5/24.
//

import UIKit
import FirebaseMessaging
import SafariServices
import Combine

class NotificationHistoryViewController: UIViewController {
    var notificationHistoryView: NotificationHistoryView!
    let notificationHistoryViewModel = NotificationHistoryViewModel()
    var disposalbleBag = Set<AnyCancellable>()
    var notificationHistoryDataList = [NotificationHistoryData]()
    
    override func loadView() {
        super.loadView()
        notificationHistoryView = NotificationHistoryView(frame: self.view.frame)
        self.view = notificationHistoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupAddTarget()
        notificationHistoryView.tableView.delegate = self
        notificationHistoryView.tableView.dataSource = self
        // 뷰모델의 데이터 상태를 연동시킵니다.
        setBindings()
        // 백그라운드에서 포그라운드 시 알림내역을 업데이트 합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationHistoryData), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NotificationHistoryViewController - viewWillAppear()")
        if NetworkMonitor.shared.isConnected {
            updateNotificationHistoryData()
        }else{
            Alert.showAlertAndExit(title: "네트워크 연결 오류", message: "인터넷에 연결되어 있지 않습니다. 앱을 종료합니다.")
        }
    }
    
    func setupNavigationController() {
        navigationItem.title = "알림 내역"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupAddTarget() {
        notificationHistoryView.refreshControl.addTarget(self, action: #selector(updateNotificationHistoryData), for: .valueChanged)
    }
    
    @objc func updateNotificationHistoryData() {
        self.notificationHistoryViewModel.updateNotificationHistoryData()
    }
}

// ViewModel 관련 코드 입니다.
extension NotificationHistoryViewController {
    fileprivate func setBindings() {
        print("NotificationHistoryViewController - setBindings()")
        self.notificationHistoryViewModel.$notificationHistoryDataList.sink { (updatedList: [NotificationHistoryData]) in
            self.notificationHistoryDataList = updatedList
            DispatchQueue.main.async {
                self.notificationHistoryView.tableView.reloadData()
                self.notificationHistoryView.refreshControl.endRefreshing()
                // 알림내역이 없으면 안내문구 보이도록 설정합니다.
                if self.notificationHistoryDataList.isEmpty {
                    self.notificationHistoryView.infoLabel.isHidden = false
                } else {
                    self.notificationHistoryView.infoLabel.isHidden = true
                }
            }
            
        }.store(in: &disposalbleBag)
    }
}

extension NotificationHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notificationHistoryData = notificationHistoryViewModel.notificationHistoryData(at: indexPath.row)
        
        if notificationHistoryData.link.count > 0 {
            guard let url = URL(string: notificationHistoryData.link) else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .automatic
            present(safariVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

extension NotificationHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationHistoryTableViewCell.indentifier,
            for: indexPath
        ) as? NotificationHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        if notificationHistoryViewModel.numOfNotificationHistoryDataList > 0 {
            let notificationHistoryData = notificationHistoryViewModel.notificationHistoryData(at: indexPath.row)
            cell.configure(title: notificationHistoryData.title, body: notificationHistoryData.body, date: notificationHistoryData.created_at)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationHistoryViewModel.numOfNotificationHistoryDataList
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "최대 20개의 알림 내역이 제공됩니다."
    }
    
}
