//
// LoginViewController.swift
//
// Copyright (c) 2015 Mathias Koehnke (http://www.mathiaskoehnke.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import WKZombie

class LoginViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton : UIButton!
    
    fileprivate let url = URL(string: "https://sis.rpi.edu/")!
    fileprivate var snapshots = [Snapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKZombie.sharedInstance.snapshotHandler = { [weak self] snapshot in
            self?.snapshots.append(snapshot)
        }
    }
    
    @IBAction func loginButtonTouched(_ button: UIButton) {
        guard let user = nameTextField.text, let password = passwordTextField.text else { return }
        button.isEnabled = false
        snapshots.removeAll()
        clearCache()
        activityIndicator.startAnimating()
        getProvisioningProfiles(url, user: user, password: password)
    }
    
    //========================================
    // MARK: HTML Navigation
    //========================================
    
    func getProvisioningProfiles(_ url: URL, user: String, password: String) {

               open(url)
                 >>* get(by: .contains("href", "https://sis.rpi.edu/rss/twbkwbis.P_WWWLogin"))
                >>> click(then: .validate("true"))
//<a href="https://sis.rpi.edu/rss/twbkwbis.P_WWWLogin">Login</a>
//                >>* get(by: .contains("href", "hr"))
//                >>> click(then: .wait(2.5))
            //<a href="https://webforms.rpi.edu/hr" target="_blank">Human Resources Contact Form </a>
           >>* get(by: .name("sid"))
           >>> setAttribute("value", value: user)
           >>* get(by: .name("PIN"))
           >>> setAttribute("value", value: password)
                
           >>* get(by: .name("loginform"))
           >>> submit(then: .validate("true"))

//
           >>* get(by: .contains("onmouseover", "Student Menu")) //<a href="/rss/twbkwbis.P_GenMenu?name=bmenu.P_StuMainMnu" class="submenulinktext2 " onmouseover="window.status='Student Menu'; return true" onmouseout="window.status=''; return true" onfocus="window.status='Student Menu'; return true" onblur="window.status=''; return true">Student Menu</a>
           >>> press(then: .validate("true"))
////
//                //<a href="/rss/bwskfshd.P_CrseSchdDetl" class="submenulinktext2 " onmouseover="window.status='View Weekly Schedule'; return true" onmouseout="window.status=''; return true" onfocus="window.status='View Weekly Schedule'; return true" onblur="window.status=''; return true"><img src="/gengifs/hwggbbal.gif" class="headerImg" title="" name="Blue Ball" hspace="0" vspace="0" border="0" height="15" width="15"></a>
//                
//            >>* get(by: .contains("href", "CrseSchdDetl"))
//            >>> click(then: .wait(2.5))
//            >>* get(by: .name("Submit"))
//            >>> submit(then: .wait(2.0))
//
//
           >>* getAll(by: .contains("captiontext", "pagebodydiv"))
           === handleResult
    }
    
    //========================================
    // MARK: Handle Result
    //========================================
    
    func handleResult(_ result: Result<[HTMLTableRow]>) {
        dump()
    }
    
    //========================================
    // MARK: Segue
    //========================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let vc = segue.destination as? ProfileViewController, let items = sender as? [HTMLTableColumn] {
                vc.items = items
                vc.snapshots = snapshots
            }
        }
    }
}
