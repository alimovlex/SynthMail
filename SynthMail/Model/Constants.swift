/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import Foundation
import MailCore

let smackPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5);
let imapSession = MCOIMAPSession();
let smtpSessiom = MCOSMTPSession();
var imapServerHostname = "imap.";
var smtpServerHostname = "smtp.";
var mailServerHostname = "mail.";
let imapPort = 993;
let smtpPort = 465;
var mailLogin = String();
var mailPassword = String();
let defaultSignature = """
 


 Sent with SynthMail for iOS.
""";
