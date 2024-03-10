//
//  ContactViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/29/24.
//

import UIKit

class ContactViewController: UIViewController {
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.backgroundColor = .systemGray6
        textField.addLeftRightPadding()
        return textField
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        textField.backgroundColor = .systemGray6
        textField.addLeftRightPadding()
        return textField
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "내용"
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = .lightGray
        textView.backgroundColor = .systemGray6
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
        return textView
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("제출", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(postQuestion), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationController()
        setupSubviews()
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ContactViewController {
    
    func setupNavigationController() {
        navigationItem.title = "문의 및 제안"
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSubviews() {
        view.addSubview(inputStackView)
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(titleTextField)
        inputStackView.addArrangedSubview(bodyTextView)
        inputStackView.addArrangedSubview(submitButton)
        
        view.addSubview(inputStackView)
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            inputStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            inputStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
        ])

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title:  "내리기", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        emailTextField.inputAccessoryView = doneToolbar
        titleTextField.inputAccessoryView = doneToolbar
        bodyTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // 이메일 형식에 맞는 정규 표현식
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        // NSPredicate를 사용하여 이메일 형식이 맞는지 확인
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc func postQuestion() {
        
        if !isValidEmail(emailTextField.text!) {
            Alert.showAlert(title: "안내", message: "이메일 형식이 잘못됐습니다.")
            return
        }
        
        if titleTextField.text!.count < 1 || bodyTextView.text.count < 1 {
            Alert.showAlert(title: "안내", message: "내용을 입력하세요.")
            return
        }
        
        // URL 세션을 생성합니다.
        let session = URLSession.shared
        
        // 요청할 URL을 정의합니다.
        let url = URL(string: Bundle.main.getSecret(name: "QUESTION_API_URL"))!
        // POST할 데이터를 준비합니다.
        let postData = [
            "email": emailTextField.text,
            "title": titleTextField.text,
            "content": bodyTextView.text,
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData) else {
            print("Error: Unable to serialize JSON data")
            return
        }
        
        // URLRequest를 생성합니다.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // 데이터를 보낸 후 처리할 작업을 정의합니다.
        let task = session.dataTask(with: request) { data, response, error in
            // 응답을 처리합니다.
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    Alert.showAlert(title: "오류", message: "전송 오류가 발생했습니다.")
                }
            } else {
                DispatchQueue.main.async {
                    Alert.showAlert(title: "안내", message: "성공적으로 제출 됐습니다.")
                    self.emailTextField.text?.removeAll()
                    self.titleTextField.text?.removeAll()
                    self.bodyTextView.text.removeAll()
                }
                
            }
        }
        task.resume()
    }
}

extension ContactViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyTextView.text == "내용" {
            bodyTextView.text = nil
            bodyTextView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            bodyTextView.text = "내용"
            bodyTextView.textColor = .lightGray
        }
    }
}
