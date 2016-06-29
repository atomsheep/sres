package nz.ac.otago.edtech.sres.util;

import java.io.File;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import nz.ac.otago.edtech.spring.util.OtherUtil;

public class MailUtil {

	/**
	 * Utility method to send simple HTML email
	 * 
	 * @param session
	 * @param toEmail
	 * @param subject
	 * @param body
	 */
	private static final Logger log = LoggerFactory.getLogger(OtherUtil.class);

	public static boolean sendEmail(String smtpServer, String fromEmail, String fromPersonal, String toEmail,
			String subject, String body) {
		return sendEmail(smtpServer, fromEmail, fromPersonal, null, null, 0,
				toEmail, subject, body, null, null);
	}

	public static boolean sendEmail(String smtpServer, String fromEmail, String fromPersonal, String smtpUsername,
			String smtpPassword, int smtpPort, String toEmail, String subject, String body, File attachment,
			String contentType) {
		boolean success = false;
		if (StringUtils.isNotBlank(smtpServer) && StringUtils.isNotBlank(fromEmail) && StringUtils.isNotBlank(toEmail)
				&& StringUtils.isNotBlank(subject)) {
			try {
				JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
				mailSender.setHost(smtpServer);
				if (smtpPort > 0)
					mailSender.setPort(smtpPort);
				if (StringUtils.isNotBlank(smtpUsername) && StringUtils.isNotBlank(smtpPassword)) {
					mailSender.setUsername(smtpUsername);
					mailSender.setPassword(smtpPassword);
					Properties props = new Properties();
					props.put("mail.smtps.auth", "true");
					props.put("mail.debug", "true");
					props.put("mail.smtp.starttls.enable","true");
					mailSender.setJavaMailProperties(props);
				}
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper helper = new MimeMessageHelper(message, (attachment != null));
				if (fromPersonal != null)
					helper.setFrom(fromEmail, fromPersonal);
				else
					helper.setFrom(new InternetAddress(fromEmail));
				helper.setTo(toEmail);
				helper.setReplyTo("no-reply@auckland.ac.nz", fromEmail);
				helper.setSubject(subject);
				helper.setText(body);
				body=StringEscapeUtils.unescapeHtml(body);
				message.setContent(body, "text/html");
				if (attachment != null) {
					FileSystemResource file = new FileSystemResource(attachment);
					if (StringUtils.isNotBlank(contentType))
						helper.addAttachment(attachment.getName(), file, contentType);
					else
						helper.addAttachment(attachment.getName(), file);
				}
				mailSender.send(message);
				success = true;
				log.info("send an email to \"{}\" with subject \"{}\"", toEmail, subject);
			} catch (Exception e) {
				log.error("Send email error", e);
			}
		} else {
			log.warn("sendEmail: required parameters are empty.");
		}
		return success;
	}

}
