//
//  ViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/5/24.
//

import UIKit
import FirebaseMessaging

class HistoryViewController: UIViewController {
    
    let topics = ["archi", "mse"]
    
    
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("구독하기", for: .normal)
        button.addTarget(self, action: #selector(setFcmTopic), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupSubviews()
    }
    
    @objc func setFcmTopic() {
        print("topic 구독 시작")
        for topic in topics {
            Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error = error {
                    print("Error subscribe: \(error)")
                  } else {
                      print("Subscribed to \(topic) topic")
                  }
            }
        }
        print("topic 구독 끝")
    }
    
    func setupSubviews() {
        // Add button to view
        view.addSubview(subscribeButton)
        
        // Set button constraints to center it in the view
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subscribeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
