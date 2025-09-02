package org.ztv.anmeldetool.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.ztv.anmeldetool.models.Person;

import jakarta.activation.DataSource;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;

@Service("EmailService")
@Slf4j
public class EmailServiceImpl implements EmailService {

	@Value("${spring.mail.enabled}")
	private boolean enableEmail;

	@Value("${spring.mail.username}")
	private String sender;

	@Value("${spring.mail.simulateemail}")
	private String simulateEmail;

	@Value("${spring.mail.simulate}")
	private boolean simulate;

	@Autowired
	private JavaMailSender emailSender;

	@Autowired
	private SpringTemplateEngine thymeleafTemplateEngine;

	@Value("classpath:/ZTV_Logo_CMYK_freigestellt.png")
	private Resource resourceFile;

	@Override
	public void sendMessage(Person to, String subject, String mailTemplate, Map<String, Object> templateModel,
			DataSource... dataSourceArray) {
		try {
			MimeMessage message = emailSender.createMimeMessage();
			MimeMessageHelper helper = generateHtmlMessage(message, to, subject, mailTemplate, templateModel);

			if (null != dataSourceArray) {
				int i = 1;
				for (DataSource datasource : dataSourceArray) {
					helper.addAttachment(datasource.getName() + "_" + i, datasource);
				}
			}
			if (enableEmail) {
				emailSender.send(message);
			} else {
				log.warn("Mail Service is disabled");
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}

	private String getHtmlBody(String mailTemplate, Map<String, Object> templateModel) {
		Context thymeleafContext = new Context();
		thymeleafContext.setVariables(templateModel);

		String htmlBody = thymeleafTemplateEngine.process(mailTemplate, thymeleafContext);
		return htmlBody;
	}

	private MimeMessageHelper generateHtmlMessage(MimeMessage message, Person to, String subject, String mailTemplate,
			Map<String, Object> templateModel) throws MessagingException {

		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		helper.setFrom(sender);
		if (simulate) {
			helper.setTo(simulateEmail);
		} else {
			helper.setTo(to.getEmail());
		}
		helper.setSubject(subject);
		helper.setText(getHtmlBody(mailTemplate, templateModel), true);
		helper.addInline("attachment.png", resourceFile);
		return helper;
	}

}
