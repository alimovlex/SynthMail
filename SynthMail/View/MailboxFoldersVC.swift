/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class MailboxFoldersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!;
    
    var mailFoldersArray = Array<MCOIMAPFolder>();
    var mailFolderNames = Array<String>();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self;
        tableView.dataSource = self;
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60;

        imapSession.hostname = mailServerHostname;
        imapSession.port = UInt32(imapPort); //UInt32(imapPort);
        imapSession.username = mailLogin;
        imapSession.password = mailPassword;
        imapSession.connectionType = .TLS;
        connect(hostname: imapSession.hostname, port: imapSession.port, username: imapSession.username, password: imapSession.password, connectionType: imapSession.connectionType);
        
    }
    
    func connect(hostname: String, port: UInt32, username: String, password: String, connectionType: MCOConnectionType) {
        
        if let accountCheck = imapSession.checkAccountOperation() {
            accountCheck.start { err in
                if let error = err {
                    log.error(error.localizedDescription);
                    self.dismiss(animated: true) {
                        self.displayErrorMessage(error: error.localizedDescription);
                    }
                } else {
                    log.info("Successful IMAP connection!");
                    self.listAvailableFolders();
                }
            }
        }
    }
    
    func listAvailableFolders() {
        if let fetchFoldersOperation = imapSession.fetchAllFoldersOperation() {
            fetchFoldersOperation.start { [self] err, folderList in
                if let error = err {
                    log.error(error.localizedDescription);
                    displayErrorMessage(error: error.localizedDescription);
                }
                
                if let folders = folderList {
                    log.info("Listed all IMAP Folders: \(folders.debugDescription)");
                    mailFoldersArray = folders;
                    for folderName in mailFoldersArray {
                        mailFolderNames.append(folderName.path);
                    }
                    mailFolderNames.reverse();
                    tableView.reloadData();
                    /*
                    for folder in self.mailFoldersArray where folder.path == self.inboxFolder {
                        log.info(folder.path)
                        self.fetchMessageHeadersFromFolder(folder: folder.path, uids: self.uids);
                    }
                     */
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
        
        if mailFoldersArray.isEmpty {
            log.warning("There are no mail folders found on the server!!!");
            return UITableViewCell();
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mailboxFolderCell", for: indexPath) as? MailboxFolderCell;
            let mailFolder = mailFolderNames[indexPath.row];
            cell?.configureCell(folderName: mailFolder);
            return cell ?? UITableViewCell();
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailFolderNames.count;
        //return MessageService.instance.channels.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
