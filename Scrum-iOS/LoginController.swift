//
//  LoginController.swift
//  Maven Scrum
//
//  Created by Jonghwi Lee on 2017. 6. 14..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit

class LoginController : UIViewController {
    @IBOutlet var id: UITextField!
    @IBOutlet var pw: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        btnLogin.layer.cornerRadius = 5;
    }
    
    @IBAction func login(_ sender: Any) {
        
        let myURL = NSURL(string: "http://api.mismaven.kr/auth")!
        let request = NSMutableURLRequest(url: myURL as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "id=\(self.id.text!)&pw=\(self.pw.text!)"
        request.httpBody = bodyStr.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

//            let httpStatus = response as? HTTPURLResponse
//            var httpStatusCode: Int = (httpStatus?.statusCode)!
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                    print(json)
                    
                    if json["status"]! as! Bool { // success
                        DispatchQueue.main.async {
                            let ud = UserDefaults.standard
                            
                            // 로컬 저장소 변수에 값을 대입.
                            ud.set(self.id.text, forKey: "sessionId")
                            
                            let alert = UIAlertController(title: "로그인", message: "환영합니다", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default, handler: {_ in
                                CATransaction.setCompletionBlock({
                                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                                })
                            })
                            alert.addAction(ok)
                            self.present(alert, animated: false, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async { // fail to login
                            let alert = UIAlertController(title: "로그인", message: "아이디, 또는 비밀번호를 확인하여 주세요.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            self.present(alert, animated: false, completion: nil)
                        }
                    }
                }
            } catch let err{
                print(err.localizedDescription)
            }
        }
        
        task.resume()
    }
}
