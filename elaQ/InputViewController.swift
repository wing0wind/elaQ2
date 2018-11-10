//
//  InputViewController.swift
//  elaQ
//
//  Created by ビ ユウ on 2018/11/11.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

class InputViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    /// Rx
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 6
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerRadius = 6
        submitButton.layer.shadowOpacity = 0.8
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        submitButton.layer.shadowRadius = 6
        submitButton.layer.shadowColor = UIColor.gray.cgColor
        submitButton.layer.masksToBounds = false
        
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(InputViewController.commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        
        inputTextView.inputAccessoryView = kbToolBar
    }
    
    @objc func commitButtonTapped() {
        inputTextView.endEditing(true)
    }
    
    func bind() {
        let tValidation = titleField.rx.text.orEmpty
            .map({!$0.isEmpty})
            .share(replay: 1)
        
        let dValidation = inputTextView
            .rx.text.orEmpty
            .map({!$0.isEmpty})
            .share(replay: 1)
        
        let enableButton = Observable.combineLatest(tValidation, dValidation) { (login, name) in
            return login && name
        }
        
        enableButton
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inputTextView.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        titleField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }

    @IBAction func submitButtonAction(_ sender: Any) {
        let title = titleField.text ?? "No title"
        let detail = inputTextView.text ?? "No detail"
        startAnimating(CGSize(width: 20, height: 20),message: "Loading")
        NetWorkUtil.testPostArticle(title: title, detail: detail, completion: {result in
            self.stopAnimating()
            self.postSuccess(result: result)
        })
    }
    
    func postSuccess(result: postResult) {
        //save token
        let userDef = UserDefaults.standard
        var aList = userDef.object(forKey: NetWorkUtil.USERDEF_ARTICLE_LIST_ID_KEY) as! [String]
        aList.append(result.result)
        userDef.setValue(aList, forKey: NetWorkUtil.USERDEF_ARTICLE_LIST_ID_KEY)
        print(aList)
        userDef.synchronize()
        
        navigationController?.popViewController(animated: true)
    }

}
