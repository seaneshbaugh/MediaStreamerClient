import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var serverAddress: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        serverAddress.text = appDelegate.serverAddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveServerAddress(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        appDelegate.saveServerAddress(serverAddress.text)

        sender.resignFirstResponder()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
