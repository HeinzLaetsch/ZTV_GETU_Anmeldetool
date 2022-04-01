package org.ztv.anmeldetool.service;

import java.io.UnsupportedEncodingException;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;

@Service
public class MailService {
	@Value("${spring.mail.username}")
	private String username;

	@Autowired
	private JavaMailSender sender;

	@Autowired
	AnlassService anlassSrv;

	private String getAnmeldeDaten(UUID anlassId, UUID orgId) {

		AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, orgId);
		StringBuilder sb = new StringBuilder();

		return sb.toString();
	}

	public void sendEmail(Person person) {
		SimpleMailMessage mail = new SimpleMailMessage();
		mail.setFrom(username);
		mail.setTo(person.getEmail());
		mail.setSubject("Testing Email Service");
		mail.setText("Test email content");
		this.sender.send(mail);
	}

	public void sendEmailWithAttachment(Person person) throws MessagingException, UnsupportedEncodingException {
		MimeMessage mimeMsg = this.sender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(mimeMsg, true);
		helper.setFrom(new InternetAddress(username, username));
		helper.setTo(person.getEmail());
		helper.setSubject("AnmeldeDate");
		helper.setText("Content of this email");
		this.sender.send(mimeMsg);
	}
}
