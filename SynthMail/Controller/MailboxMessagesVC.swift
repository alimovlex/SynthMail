/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class MailboxMessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var menuBtn: UIButton!;
    @IBOutlet weak var mailFolderNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var mailMessagesArray = Array<MCOIMAPMessage>();
    var currentMailFolder = MCOIMAPFolder();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside);
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer());
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.isHidden = false;
        
        if MAIL_PARAMETERS.currentMessageFolder.isEmpty {
            fetchMessageHeadersFromFolder(folder: "INBOX", uids: MAIL_PARAMETERS.uids);
            self.mailFolderNameLbl.text = "INBOX";
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: .didUserChooseMailFolder, object: nil, queue: .current) { notification in
            log.info(notification.object.debugDescription);
            if let folderNotification = notification.object as? String {
                    self.fetchMessageHeadersFromFolder(folder: folderNotification, uids: MAIL_PARAMETERS.uids);
                    self.mailFolderNameLbl.text = folderNotification;
                } else {
                    log.warning("Unable to cast notification to the String type");
                }
            }
    }
    
    func fetchMessageHeadersFromFolder(folder: String, uids: MCOIndexSet?) {
        
        if let fetchOperation = MAIL_PARAMETERS.imapSession?.fetchMessagesOperation(withFolder: folder, requestKind: .headers, uids: uids) {
            fetchOperation.start { err, fetchedMessages, vanishedMessages in
                if let error = err {
                    log.error("Error downloading message headers: \(error.localizedDescription)");
                    self.displayErrorMessage(error: error.localizedDescription);
                } else {
                    if let inboxMessages = fetchedMessages {
                        print("The post man delivered: \(inboxMessages.reversed())");
                        self.mailMessagesArray = inboxMessages;
                        self.mailMessagesArray.reverse();
                        self.tableView.reloadData();
                    } else {
                        log.warning("The Inbox mail folder is empty!!!");
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailMessagesArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mailCell") as? MailCell else {
            return UITableViewCell();
        }
        let message = mailMessagesArray[indexPath.row];
        //cell.textLabel?.text = message.header.subject.description;
        //cell.detailTextLabel?.text = message.header.sender.mailbox;
        cell.configureCell(subject: message.header.subject.description, sender: message.header.sender.mailbox, date: message.header.date);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = mailMessagesArray[indexPath.row];
        currentMailFolder.path = mailFolderNameLbl.text;
        performSegue(withIdentifier: "MessageContentsVC", sender: message.uid);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        log.info(segue.identifier);
        log.info(sender.debugDescription);
        log.info(mailFolderNameLbl.text);
        if segue.identifier == "MessageContentsVC" {
            if let destination = segue.destination as? MessageContentsVC, let messageId = sender as? UInt32, let imapSession = MAIL_PARAMETERS.imapSession {
                destination.useImapFetchContent(session: imapSession, folder: currentMailFolder, uidToFetch: messageId);
            } else {
                log.warning("The UI sender with messageId is nil or Imap session is nil.");
                self.displayErrorMessage(error: "The UI sender with messageId is nil or Imap session is nil.");
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if #available(iOS 10.0, *) {
        return .none;
        } else {
            return .delete;
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            //self.removeGoal(atIndexPath: indexPath);
            //self.fetchCoreDataObjects();
            tableView.deleteRows(at: [indexPath], with: .automatic);
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1);
        
        return [deleteAction];
    }

}
