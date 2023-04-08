/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self;
        tableView.dataSource = self;
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mailboxFolderCell", for: indexPath) as? MailboxFolderCell {
            //let channel = MessageService.instance.channels[indexPath.row];
            //cell.configureCell(channel: channel);
            return cell;
        } else {
            return UITableViewCell();
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
        //return MessageService.instance.channels.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
