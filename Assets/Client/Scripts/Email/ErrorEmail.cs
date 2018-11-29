using System;
using System.Net;
using System.Net.Mail;
using System.IO;

public class ErrorEmail 
{
    public static void Commit(string fromAddress, string toAddress, string subject, string body, string attachment, string password)
    {
        MailMessage mail = new MailMessage();

        mail.From = new MailAddress(fromAddress);
        mail.To.Add(toAddress);
        mail.Subject = subject;
        mail.Body = body;
        if (!string.IsNullOrEmpty(attachment) && File.Exists(attachment))
        {
            mail.Attachments.Add(new Attachment(attachment));
        }

        SmtpClient smtpServer = new SmtpClient("smtp.gmail.com");
        smtpServer.Port = 587;
        smtpServer.Credentials = new NetworkCredential(fromAddress, password) as ICredentialsByHost;
        smtpServer.EnableSsl = true;

        smtpServer.Send(mail);
    }
}
