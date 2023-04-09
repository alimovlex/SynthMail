/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class SendMailVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var toEmailTextField: UITextField!
    @IBOutlet weak var ccEmailTextField: UITextField!
    @IBOutlet weak var bccEmailTextField: UITextField!
    @IBOutlet weak var fromEmailTextField: UITextField!
    @IBOutlet weak var subjectMailTextField: UITextField!
    @IBOutlet weak var mailContentsTextField: UITextView!
    
    @IBOutlet weak var ccMailCell: UITableViewCell!
    @IBOutlet weak var bccMailCell: UITableViewCell!
    
    var toEmail = String();
    var ccEmail = String();
    var bccEmail = String();
    var fromEmail = String();
    let fromName = "Аλέξιος";
    var emailSubject = String();
    //let emailBody = "Hello this is my email\n\nIt is multi-line\n123\nFrom\nCodebrah"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        updateUI();
        MAIL_PARAMETERS.smtpSession = MCOSMTPSession();
        MAIL_PARAMETERS.smtpSession?.hostname = MAIL_PARAMETERS.mailServerHostname;
        MAIL_PARAMETERS.smtpSession?.port = UInt32(MAIL_PARAMETERS.smtpPort); //UInt32(imapPort);
        MAIL_PARAMETERS.smtpSession?.username = MAIL_PARAMETERS.mailLogin;
        MAIL_PARAMETERS.smtpSession?.password = MAIL_PARAMETERS.mailPassword;
        MAIL_PARAMETERS.smtpSession?.connectionType = .TLS;
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        toEmailTextField.text = toEmail;
        fromEmailTextField.text = MAIL_PARAMETERS.mailLogin;
        subjectMailTextField.text = emailSubject;
        bccEmailTextField.text = ccEmail;
        ccEmailTextField.text = ccEmail;
        mailContentsTextField.text.append(MAIL_PARAMETERS.defaultSignature);
    }
    
    func createMessage() -> MCOMessageBuilder {
        let builder = MCOMessageBuilder();
        
        if let receiversAddress = MCOAddress(mailbox: toEmailTextField.text) {
            builder.header.from = MCOAddress(displayName: self.fromName, mailbox: fromEmailTextField.text);
            builder.header.to = [receiversAddress];
            builder.header.subject = subjectMailTextField.text;
            builder.textBody = mailContentsTextField.text;
        } else {
            displayErrorMessage(error: "The email address is incorrect");
        }
        return builder;
    }
    
    func createSMTPAttachment(with image: UIImage) -> MCOAttachment {
        let fileName = Int.random(in: 0...500000).description + ".jpeg"
        let jpegData = image.jpegData(compressionQuality: 1)
        let attachment = MCOAttachment(data: jpegData, filename: fileName)
        attachment?.mimeType = "image/jpg";
        return attachment!
    }
    
    func sendSMTPMessage(with smtpSession: MCOSMTPSession?, and builder: MCOMessageBuilder) {
        smtpSession?.connectionLogger = { connectionID, type, data in
            log.info(connectionID!)
            log.info(type)
            if let dataBuffer = data {
                //log.info("sent package: \(dataBuffer.map { String(format: "%02x", $0) }.joined(separator: ""))");
                log.info("Sent Message");
                print(String(bytes: dataBuffer, encoding: .utf8));
            } else {
                log.info(data);
            }
            
        }
        let builderData = builder.data();
        smtpSession?.sendOperation(with: builderData).start { [self] err in
            if let error = err {
                displayErrorMessage(error: error.localizedDescription);
                log.error(error.localizedDescription);
            } else {
                log.info("The email has been sent successfully!");
            }
        }
    }
    
    func displayErrorMessage(error: String) {
        let error = UIAlertController(title: "Error sending message.", message: error, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default);
        error.addAction(confirm);
        self.present(error, animated: true) //showing the URL entrance message
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5;
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendEmailBtnPressed(_ sender: Any) {
        let messageBuilder = createMessage();
        //ADD IMAGEPICKER LIBRARY HERE!!!
        /*
        for image in images {
            let attachment = createSMTPAttachment(with: image);
            messageBuilder.addAttachment(attachment);
        }
         */
        sendSMTPMessage(with: MAIL_PARAMETERS.smtpSession, and: messageBuilder);
        dismiss(animated: true, completion: nil);
    }
    
    
    @IBAction func cancelEmailBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }

}
