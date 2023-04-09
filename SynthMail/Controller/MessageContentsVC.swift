/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class MessageContentsVC: UIViewController {
    
    @IBOutlet weak var mailView: UIWebView!
    
    var toEmail = String(); // PUT EMAIL HERE
    var ccEmail = String();
    var bccEmail = String();
    var fromEmail = String(); // YOUR EMAIL HERE
    var emailSubject = String();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendMailVC" {
            if let destination = segue.destination as? SendMailVC {
                destination.toEmail = fromEmail;
                destination.fromEmail = toEmail;
                destination.emailSubject = emailSubject;
                destination.ccEmail = ccEmail;
                destination.bccEmail = bccEmail;
                //destination.signature = MAIL_PARAMETERS.defaultSignature;
            }
        }
    }
    
    func useImapFetchContent(session: MCOIMAPSession, folder: MCOIMAPFolder, uidToFetch uid: UInt32)
    {
        session.dispatchQueue.async {
            let operation = session.fetchParsedMessageOperation(withFolder: folder.path, uid: UInt32(uid));
            operation?.start{ [self]( err, messageParser)-> Void in
                if let error = err {
                    log.error(error.localizedDescription);
                    self.displayErrorMessage(error: error.localizedDescription);
                } else {
                    if let msgParser = messageParser, let senderEmail = extractEmailAddrIn(text: msgParser.header.to.description).first, let receiverEmail = extractEmailAddrIn(text: msgParser.header.from.mailbox).first {
                        fromEmail = senderEmail;
                        toEmail = receiverEmail;
                        emailSubject = msgParser.header.subject;
                        log.info("The mail sender is: \(senderEmail)");
                        log.info("The mail receiver is : \(receiverEmail)")
                        log.info("Extracted Email Successfully!");
                    } else {
                        fromEmail = "Error";
                    }
        
                    let messageDescription =  """
                        To:     \(String(describing: messageParser?.header.to))
                        Cc:     \(String(describing: messageParser?.header.cc))
                        Bcc:    \(String(describing: messageParser?.header.bcc))
                        From:   \(String(describing: messageParser?.header.from))
                        Subject:\(String(describing: messageParser?.header.subject))
                        Date:   \(String(describing: messageParser?.header.date))
                        """
                    log.info(messageDescription);
                    if let htmlParsedMessage = messageParser?.htmlRendering(with: nil) {
                        self.mailView.loadHTMLString(htmlParsedMessage, baseURL: nil);
                    } else if let msgPlainBody = messageParser?.plainTextBodyRendering() {
                        //log.info("BODY");
                        messageParser?.htmlRendering(with: nil);
                        self.mailView.loadHTMLString(msgPlainBody, baseURL: nil);
                    } else {
                        log.warning("Unable to fetch message contents.");
                        self.displayErrorMessage(error: "Unable to fetch message contents.");
                    }
                    
                }
            }
        }
        
    }
    
    func extractEmailAddrIn(text: String) -> [String] {
        var results = [String]()

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
        let nsText = text as NSString
        
        let regExp = try? NSRegularExpression(pattern: emailRegex, options: .caseInsensitive)
        let range = NSMakeRange(0, text.count)
        if let matches = regExp?.matches(in: text, options: .reportProgress, range: range) {
            for match in matches {
                let matchRange = match.range
                results.append(nsText.substring(with: matchRange))
            }
        }
        return results
    }
    
    func displayErrorMessage(error: String) {
        let error = UIAlertController(title: "Error fetching message from the mail server.", message: error, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default);
        error.addAction(confirm);
        self.present(error, animated: true) //showing the URL entrance message
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
