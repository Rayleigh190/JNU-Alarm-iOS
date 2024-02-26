//
//  ViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/5/24.
//

import UIKit
import FirebaseMessaging

struct NotiResponseData: Codable {
    let success: Bool
    let response: [NotificationData]
    let error: String?
}

struct NotificationData: Codable {
    let title: String
    let body: String
    let link: String
    let created_at: String
}

class HistoryViewController: UIViewController {
    
    var models = [NotificationData]()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(setNotificationData), for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.indentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupSubViews()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(setNotificationData), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNotificationData()
    }
}

extension HistoryViewController {
    func setupNavigationController() {
        navigationItem.title = "알림 내역"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSubViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func setNotificationData() {
        self.models = [NotificationData]()
        
        fetchNotifications { [weak self] notifications in
            guard let self = self else { return }
            
            if let notifications = notifications {
                print("패치 완료 : \(notifications)")
                for notification in notifications {
                    self.models.append(NotificationData(title: notification.title, body: notification.body, link: notification.link, created_at: notification.created_at))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } else {
                print("알림 가져오기 실패")
            }
        }
    }

    
    func fetchNotifications(completion: @escaping ([NotificationData]?) -> Void) {
        // URL 세션을 생성합니다.
        let session = URLSession.shared
        
        // 요청할 URL을 정의합니다.
        let url = URL(string: Bundle.main.getSecret(name: "NOTIFICATIONS_API_URL"))!
        // POST할 데이터를 준비합니다.
        let postData = ["topic": UserDefaults.standard.array(forKey: "notifications")]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData) else {
            print("Error: Unable to serialize JSON data")
            completion(nil)
            return
        }
        
        // URLRequest를 생성합니다.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        var notifications = [NotificationData]()
        // 데이터를 보낸 후 처리할 작업을 정의합니다.
        let task = session.dataTask(with: request) { data, response, error in
            // 응답을 처리합니다.
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    // 응답 데이터를 파싱합니다.
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    // 응답 데이터에서 response 키의 값인 배열을 가져옵니다.
                    if let responseData = responseJSON?["response"] as? [[String: Any]] {
                        // 배열의 각 요소를 순회하면서 원하는 정보를 출력하거나 활용할 수 있습니다.
                        
                        for data in responseData {
                            if let title = data["title"] as? String,
                                let body = data["body"] as? String,
                                let link = data["link"] as? String,
                                let createdAt = data["created_at"] as? String {
                                let article = NotificationData(title: title, body: body, link: link, created_at: createdAt)
                                notifications.append(article)
                            }
                        }
                        completion(notifications)
                    } else {
                        print("Error: Unable to parse response data")
                        completion(nil)
                    }
                } catch {
                    print("Error: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

extension HistoryViewController: UITableViewDelegate {
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.indentifier,
            for: indexPath
        ) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(title: model.title, body: model.body)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        print("Open \(model.link)")
        if let url = URL(string: model.link) {
            UIApplication.shared.open(url)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "최대 20개의 알림 내역이 제공됩니다."
    }
    
}
