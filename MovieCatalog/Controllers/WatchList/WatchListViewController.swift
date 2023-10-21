

import UIKit
// this view should be a tableview
// cell should have a collectionview (netflix (homeviewcontroiller, collectioncustomcell, downloadcontroller)
// save your watch list
// remove item from watchlist
// be able to do some kind of sorting in app
// later feature, add a folder or a section to display different added films?

class WatchListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Watchlist"

    }
    
    

}
