import UIKit
import Appboy_iOS_SDK

class ViewController: UIViewController {
  @IBOutlet weak var userIdTextField: UITextField!
  @IBOutlet weak var customEventNameTextField: UITextField!
  @IBOutlet weak var unreadContentCardLabel: UILabel!
  @IBOutlet weak var modalOrNavigationPicker: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.numberOfTapsRequired = 1
    self.view.addGestureRecognizer(tapGesture)
    self.setUnreadContentCardLabelText()
    NotificationCenter.default.addObserver(self, selector: #selector(contentCardsUpdated(_:)), name: NSNotification.Name.ABKContentCardsProcessed, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Display the Braze user ID in the text field
    userIdTextField.text = Appboy.sharedInstance()?.user.userID
  }
  
  @IBAction func logCustomEventButtonTapped(sender: AnyObject) {
    let customEventName:String! = customEventNameTextField.text
    if (customEventName.count > 0) {
      Appboy.sharedInstance()?.logCustomEvent(customEventName!)
    }
  }
  
  @IBAction func updateUserId(sender: AnyObject) {
    userIdTextField.resignFirstResponder()
    Appboy.sharedInstance()?.changeUser(userIdTextField.text!)
  }

  @IBAction func contentCardButtonTapped(_ sender: Any) {
    if modalOrNavigationPicker.selectedSegmentIndex == 0 {
      let contentCards = ABKContentCardsViewController();
      contentCards.contentCardsViewController.navigationItem.title = "Modal Cards";
      self.navigationController?.present(contentCards, animated: true, completion: nil)
    } else {
      let contentCards = ABKContentCardsTableViewController();
      contentCards.navigationItem.title = "Navigation Cards"
      self.navigationController?.pushViewController(contentCards, animated: true)
    }
  }

  @objc func contentCardsUpdated(_ notification: NSNotification) {
    self.setUnreadContentCardLabelText();
  }

  func setUnreadContentCardLabelText() {
    let unreadContentCardCount = Appboy.sharedInstance()?.contentCardsController.unviewedContentCardCount() ?? 0
    let totalCardCount = Appboy.sharedInstance()?.contentCardsController.contentCardCount() ?? 0
    self.unreadContentCardLabel.text = "Unread Content Cards: \(unreadContentCardCount)/\(totalCardCount)";
    self.view.setNeedsDisplay();
  }

  @objc func dismissKeyboard() {
    self.view.endEditing(true)
  }
}
