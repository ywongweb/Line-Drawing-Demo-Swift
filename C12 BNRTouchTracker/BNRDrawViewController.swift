import UIKit

class BNRDrawViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        self.view = BNRDrawView(frame: CGRectZero)
    }
    
}
