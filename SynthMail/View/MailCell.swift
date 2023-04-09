/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit

class MailCell: UITableViewCell {
    
    
    @IBOutlet weak var mailSubject: UILabel!
    @IBOutlet weak var mailAddress: UILabel!
    @IBOutlet weak var mailDate: UILabel!
    
    func configureCell(subject: String, sender: String, date: Date) {
        self.mailSubject.text = subject;
        self.mailAddress.text = sender;
        
        let timestamp = date;
        let dateFormatter = DateFormatter();
        log.info("The Message timestamp = \(timestamp.timeIntervalSince1970)");
        dateFormatter.dateFormat = "HH:mm";
        let messageTiming = dateFormatter.string(from: timestamp);
        log.info("The incoming message time = \(messageTiming)");
        
        self.mailDate.text = messageTiming;
    }
    
}
