/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit

class ChatVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!;
    @IBOutlet weak var channelNameLbl: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside);
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer());
        
    }
    

}
