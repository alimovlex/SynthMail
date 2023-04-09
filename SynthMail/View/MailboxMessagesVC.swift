/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class MailboxMessagesVC: UIViewController {

    //Outlets
    @IBOutlet weak var menuBtn: UIButton!;
    @IBOutlet weak var channelNameLbl: UILabel!;
    
    var mailMessagesArray = Array<MCOIMAPMessage>();
    let session = MCOIMAPSession();
    var mailFoldersArray = Array<MCOIMAPFolder>();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside);
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer());
        
    }

}
