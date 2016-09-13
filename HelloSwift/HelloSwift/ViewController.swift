import UIKit
import Appboy_iOS_SDK

class ViewController: UIViewController {
  @IBOutlet weak var userIdTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Display the Appboy user ID in the text field
    userIdTextField.text = Appboy.sharedInstance()!.user.userID
  }
  
  @IBAction func logCustomEventButtonTapped(sender: AnyObject) {
    Appboy.sharedInstance()!.logCustomEvent("Swift Custom Event")
  }
  
  @IBAction func updateUserId(sender: AnyObject) {
    userIdTextField.resignFirstResponder()
    Appboy.sharedInstance()!.changeUser(userIdTextField.text!)
  }
}

