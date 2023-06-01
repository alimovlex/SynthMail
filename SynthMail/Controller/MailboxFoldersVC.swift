/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class MailboxFoldersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var accountNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self;
        tableView.dataSource = self;
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60;
        accountNameLbl.text = MAIL_PARAMETERS.mailLogin;
        MAIL_PARAMETERS.imapSession?.hostname = MAIL_PARAMETERS.mailServerHostname;
        MAIL_PARAMETERS.imapSession?.port = UInt32(MAIL_PARAMETERS.imapPort); //UInt32(imapPort);
        MAIL_PARAMETERS.imapSession?.username = MAIL_PARAMETERS.mailLogin;
        MAIL_PARAMETERS.imapSession?.password = MAIL_PARAMETERS.mailPassword;
        MAIL_PARAMETERS.imapSession?.connectionType = .TLS;
        self.listAvailableFolders();
    }
    
    func listAvailableFolders() {
        if let fetchFoldersOperation = MAIL_PARAMETERS.imapSession?.fetchAllFoldersOperation() {
            fetchFoldersOperation.start { [self] err, folderList in
                if let error = err {
                    log.error(error.localizedDescription);
                    displayErrorMessage(error: error.localizedDescription);
                }
                
                if let folders = folderList {
                    log.info("Listed all IMAP Folders: \(folders.debugDescription)");
                    MAIL_PARAMETERS.mailFoldersArray = folders;
                    
                    if MAIL_PARAMETERS.mailFolderNames.isEmpty {
                        for folderName in MAIL_PARAMETERS.mailFoldersArray {
                            MAIL_PARAMETERS.mailFolderNames.append(folderName.path);
                        }
                        MAIL_PARAMETERS.mailFolderNames.reverse();
                        tableView.reloadData();
                    } else {
                        log.info("All mail folders have been already gathered!!!");
                    }
                }
                
            }
            
        }
    }
    
    func displayErrorMessage(error: String) {
        let error = UIAlertController(title: "Error fetching messages from the mail server.", message: error, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default);
        error.addAction(confirm);
        self.present(error, animated: true) //showing the URL entrance message
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if MAIL_PARAMETERS.mailFoldersArray.isEmpty {
            log.warning("There are no mail folders found on the server!!!");
            return UITableViewCell();
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mailboxFolderCell", for: indexPath) as? MailboxFolderCell;
            let mailFolder = MAIL_PARAMETERS.mailFolderNames[indexPath.row];
            cell?.configureCell(folderName: mailFolder);
            return cell ?? UITableViewCell();
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MAIL_PARAMETERS.mailFolderNames.count;
        //return MessageService.instance.channels.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mailFolder = MAIL_PARAMETERS.mailFolderNames[indexPath.row];
        log.info(mailFolder);
        NotificationCenter.default.post(name: .didUserChooseMailFolder, object: mailFolder);
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {

        let logout = MAIL_PARAMETERS.imapSession?.disconnectOperation();
            logout?.start({ (error) in
                if let error = error {
                    log.error(error.localizedDescription);
                    self.displayErrorMessage(error: error.localizedDescription);
                } else {
                    log.info("logout succeeded!");
                    self.dismiss(animated: true) {
                        userDefaults.removeObject(forKey: "userEmail");
                        userDefaults.removeObject(forKey: "userPassword");
                    };
                }
            })
        MAIL_PARAMETERS.mailFolderNames.removeAll();
        MAIL_PARAMETERS.mailFoldersArray.removeAll();
        MAIL_PARAMETERS.imapSession = nil;
        MAIL_PARAMETERS.smtpSession = nil;
    }
    
    
}
