using System;
using System.Net;
using System.Net.Mail;
using System.IO;

public class ErrorEmail 
{
    public static void Commit(string fromAddress, string toAddress, string subject, string body, string attachment, string password)
    {
        try
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

            SmtpClient smtpClient = new SmtpClient("smtp.exmail.qq.com", 465);
            smtpClient.Credentials = new NetworkCredential(fromAddress, password) as ICredentialsByHost;
            smtpClient.EnableSsl = true;

            smtpClient.Send(mail);
        }
        catch (Exception ex)
        {
            Logger.Log(ex.Message);
        }
    }
}
