import UIKit
import Appboy_iOS_SDK

class ViewController: UIViewController {
  @IBOutlet weak var userIdTextField: UITextField!
  @IBOutlet weak var customEventNameTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Display the Braze user ID in the text field
    userIdTextField.text = Appboy.sharedInstance()!.user.userID
  }
  
  @IBAction func logCustomEventButtonTapped(sender: AnyObject) {
    let customEventName:String! = customEventNameTextField.text
    if (customEventName.count > 0) {
      Appboy.sharedInstance()!.logCustomEvent(customEventName!)
    }
  }
  
  @IBAction func updateUserId(sender: AnyObject) {
    userIdTextField.resignFirstResponder()
    Appboy.sharedInstance()!.changeUser(userIdTextField.text!)
  }
}
