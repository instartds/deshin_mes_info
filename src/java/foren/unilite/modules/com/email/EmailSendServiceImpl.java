package foren.unilite.modules.com.email;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Multipart;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import antlr.collections.List;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("emailSendService")
public class EmailSendServiceImpl  extends TlabAbstractServiceImpl {

	 private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@Autowired
    private JavaMailSenderImpl emailSender;

    @Autowired
    private SimpleMailMessage preConfiguredMessage;

    @Autowired
    private TlabCodeService tlabCodeService;

    /*public EmailSendServiceImpl(LoginVO loginVo)	{
    	String useDatabaseConfig = ConfigUtil.getString("emailSender.useDatabaseConfig", "false").toLowerCase();
    	logger.debug(">>>>>>>>>>>>>>>>>  user DB Properties : "+useDatabaseConfig);
    	if("true".equals(useDatabaseConfig))	{
    		logger.debug(">>>>>>>>>>>>>>>>>  user DB Properties");

        	this.setProperties(loginVo);
    	}
    }*/
    /**
     * This method will send compose and send the message
     **/
    public void sendMail(String to, String from, String subject, String body) throws Exception
    {

    	if(to == null)	{
    		throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
    	if(from == null)	{
    		throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setFrom(from);
        message.setSubject(subject);
        message.setText(body);

        emailSender.send(message);

    }

    public void sendMail(String to, String from, String subject, String body, String compCode) throws Exception
    {
    	String useDatabaseConfig = ConfigUtil.getString("emailSender.useDatabaseConfig", "false").toLowerCase();
    	if("true".equals(useDatabaseConfig))	{
    		this.setProperties(compCode);
    	}

    	if(to == null)	{
    		throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
    	if(from == null)	{
    		throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setFrom(from);
        message.setSubject(subject);
        message.setText(body);

        emailSender.send(message);

    }

    public void sendMail(Map param) throws Exception
    {
    	String useDatabaseConfig = ConfigUtil.getString("emailSender.useDatabaseConfig", "false").toLowerCase();
    	if("true".equals(useDatabaseConfig))	{
    		this.setProperties(ObjUtils.getSafeString(param.get("COMP_CODE")));
    	}
    	String newTo = (String) param.get("TO");
    	String[] words = newTo.split(";");
    	InternetAddress[] toAddr = new InternetAddress[words.length];

    	String newToref = (String) param.get("CC");
    	String[] wordsref = newToref.split(";");
    	InternetAddress[] toAddrRef = new InternetAddress[wordsref.length];

    	for(int i=0; i<words.length; i++){
    		if(ObjUtils.isEmpty(words[i])){
    			continue;
    		}
    		toAddr[i] = new InternetAddress( new String(words[i].getBytes("UTF-8"), "8859_1"));
    	}
    	
    	for(int i=0; i<wordsref.length; i++){
    		if(ObjUtils.isEmpty(wordsref[i])){
    			continue;
    		}
    		toAddrRef[i] = new InternetAddress( new String(wordsref[i].getBytes("UTF-8"), "8859_1"));
    	}    	
    	String to = param.get("TO").toString().replaceAll(";", ",");
        String from = param.get("FROM").toString();
        String subject = param.get("SUBJECT").toString();
        String body = param.get("TEXT").toString();
        String cc = param.get("CC").toString().replaceAll(";", ",");
        String bcc = param.get("BCC").toString();
        String fname = null;
        fname = (String) param.get("FILE_INFO");

//        boolean hasHtmlContents =  ObjUtils.parseBoolean(emailContents.hasHtmlText(),false);
        MimeMessage mMessage = emailSender.createMimeMessage();
        MimeMessageHelper  message = new MimeMessageHelper(mMessage, true, "utf-8");
        if(to == null)  {
            throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
        }else {
            if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
                throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
            }
        }
        if(from == null)    {
            throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
        }else {
            if(!(from.indexOf("@") > -1 && from.substring(from.indexOf("@"), from.length()).indexOf(".") > -1) ){
                throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
            }
        }
        //20181211 - 받는 메일 주소 2개이상 보낼 수 있도록 수정: 단, 구분자는 ";"

        message.setTo(toAddr);
//        message.setTo(to);
        message.setFrom(from);

        if(ObjUtils.isNotEmpty(subject))    message.setSubject(subject);
//        if(ObjUtils.isNotEmpty(body))  message.setText(body, hasHtmlContents);
        if(ObjUtils.isNotEmpty(body))  message.setText(body, true);
        if(ObjUtils.isNotEmpty(cc)) message.setBcc(toAddrRef);
        if(ObjUtils.isNotEmpty(bcc)) message.setBcc(bcc);

        if(ObjUtils.isNotEmpty(fname))  {
            FileSystemResource file = new FileSystemResource(fname);
            message.addAttachment( MimeUtility.encodeText(file.getFilename(), "euc-kr","B"), file);
        }
        emailSender.send(mMessage);

    }/*
    public void sendMail2(Map param ) throws Exception {
    	String useDatabaseConfig = ConfigUtil.getString("emailSender.useDatabaseConfig", "false").toLowerCase();
    	if("true".equals(useDatabaseConfig))	{
    		this.setProperties(ObjUtils.getSafeString(param.get("COMP_CODE")));
    	}
        String to = param.get("TO").toString().replaceAll(";", ",");
        String from = param.get("FROM").toString();
        String subject = param.get("SUBJECT").toString();
        String body = param.get("TEXT").toString();
        String cc = param.get("CC").toString();
        String bcc = param.get("BCC").toString();
        String fname = null;

        Properties emailProp = emailSender.getSession().getProperties();
        emailSender.setProtocol(emailProp.getProperty("mail.smtp.host"));
        emailSender.setHost(emailProp.getProperty("mail.smtp.protocol"));
        emailSender.setPort(ObjUtils.parseInt(emailProp.getProperty("mail.smtp.port")));
        //emailSender.setUsername(properties.getProperty("mail.smtp.username"));
        //emailSender.setPassword(properties.getProperty("mail.smtp.password"));

        properties.setProperty("mail.smtp.auth", "true");
        properties.setProperty("mail.smtp.starttls.enable", cdo.getRefCode9());
        properties.setProperty("mail.smtp.quitwait.enable", cdo.getRefCode10());
        properties.setProperty("mail.debug", "false");
        properties.setProperty("mail.smtp.ssl.enable", "true");
        emailProp.put("mail.smtp.socketFactory.port", ObjUtils.parseInt(emailProp.getProperty("mail.smtp.port"))); //SSL Port
        emailProp.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

		this.userName = emailProp.getProperty("mail.smtp.username");
		this.password = emailProp.getProperty("mail.smtp.password");

        emailSender.setJavaMailProperties(emailProp);

		Authenticator auth = new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(userName, password);
			}
		};
        // Setup mail server
        // Get the default Session object.
        Session session = Session.getDefaultInstance(emailProp, auth);


          MimeMessage mMessage = new MimeMessage(session);

          // Set From: header field of the header.
          message.setFrom(new InternetAddress(from));

          // Set To: header field of the header.
          message.addRecipient(Message.RecipientType.TO,
              new InternetAddress(ObjUtils.getSafeString(param.get("TO"))));

          message.setSubject(ObjUtils.getSafeString(param.get("SUBJECT")));
          message.setText(ObjUtils.getSafeString(param.get("TEXT")));

          //Transport trnsport;
          //trnsport = session.getTransport("smtps");
          //trnsport.connect(null, properties.getProperty("mail.password"));
          //message.saveChanges();
          //trnsport.sendMessage(message, message.getAllRecipients());
          //trnsport.close();
          Transport.send(message);
          System.out.println("Sent message successfully....");

          MimeMessageHelper  message = new MimeMessageHelper(mMessage, false, "utf-8");
          if(to == null)  {
              throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
          }else {
              if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
                  throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
              }
          }
          if(from == null)    {
              throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
          }else {
              if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
                  throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
              }
          }
          //20181211 - 받는 메일 주소 2개이상 보낼 수 있도록 수정: 단, 구분자는 ";"
          message.setTo(InternetAddress.parse(to));
//          message.setTo(to);
          message.setFrom(from);

          if(ObjUtils.isNotEmpty(subject))    message.setSubject(subject);
//          if(ObjUtils.isNotEmpty(body))  message.setText(body, hasHtmlContents);
          if(ObjUtils.isNotEmpty(body))  message.setText(body, true);
          if(ObjUtils.isNotEmpty(cc)) message.setBcc(cc);
          if(ObjUtils.isNotEmpty(bcc)) message.setBcc(bcc);

          if(ObjUtils.isNotEmpty(fname))  {
              FileSystemResource file = new FileSystemResource(fname);
              message.addAttachment(file.getFilename(), file);
          }
          emailSender.send(mMessage);
      }*/
    public void sendMail(EmailModel emailContents) throws Exception
    {
    	String useDatabaseConfig = ConfigUtil.getString("emailSender.useDatabaseConfig", "false").toLowerCase();
    	if("true".equals(useDatabaseConfig))	{
    		this.setProperties(ObjUtils.getSafeString(emailContents.getCOMP_CODE()));
    	}
    	String to = emailContents.getTO();
    	String from = emailContents.getFROM();
    	String subject = emailContents.getSUBJECT();
    	String body = emailContents.getTEXT();
    	String cc = emailContents.getCC();
    	String bcc = emailContents.getBCC();
    	String fname = emailContents.getFILE();
    	boolean hasHtmlContents =  ObjUtils.parseBoolean(emailContents.hasHtmlText(),false);

    	MimeMessage mMessage = emailSender.createMimeMessage();
    	MimeMessageHelper  message = new MimeMessageHelper(mMessage, false, "utf-8");
    	if(to == null)	{
    		throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
    	if(from == null)	{
    		throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
     	message.setTo(to);
     	message.setFrom(from);

    	if(ObjUtils.isNotEmpty(subject)) 	message.setSubject(subject);
    	if(ObjUtils.isNotEmpty(body))  message.setText(body,hasHtmlContents);
        if(ObjUtils.isNotEmpty(cc)) message.setBcc(cc);
    	if(ObjUtils.isNotEmpty(bcc)) message.setBcc(bcc);

    	if(ObjUtils.isNotEmpty(fname))	{
    		//FileSystemResource file = new FileSystemResource(fname);
    		//message.addAttachment(file.getFilename(), file);
    		BodyPart messageBodyPart = new MimeBodyPart();

            //messageBodyPart.setText(body);
            messageBodyPart.setContent(body, "text/html; charset=utf-8");
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            messageBodyPart = new MimeBodyPart();
            File file = new File(fname);
            FileDataSource fds = new FileDataSource(file);
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setFileName(fds.getName());
            multipart.addBodyPart(messageBodyPart);

            mMessage.setContent(multipart, "text/html; charset=UTF-8");
    	}
        emailSender.send(mMessage);

    }

    public void sendMailFileAttach(EmailModel emailContents) throws Exception
    {
    	String useDatabaseConfig = ConfigUtil.getString("emailSender.useDatabaseConfig", "false").toLowerCase();
    	if("true".equals(useDatabaseConfig))	{
    		this.setProperties(ObjUtils.getSafeString(emailContents.getCOMP_CODE()));
    	}
    	String to = emailContents.getTO();
    	String from = emailContents.getFROM();
    	String subject = emailContents.getSUBJECT();
    	String body = emailContents.getTEXT();
    	String cc = emailContents.getCC();
    	String bcc = emailContents.getBCC();
    	String fname = emailContents.getFILE();
    	boolean hasHtmlContents =  ObjUtils.parseBoolean(emailContents.hasHtmlText(),false);

    	MimeMessage mMessage = emailSender.createMimeMessage();
    	MimeMessageHelper  message = new MimeMessageHelper(mMessage, true, "utf-8");
    	if(to == null)	{
    		throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
    	if(from == null)	{
    		throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
     	message.setTo(to);
     	message.setFrom(from);

    	if(ObjUtils.isNotEmpty(subject)) 	message.setSubject(subject);
    	if(ObjUtils.isNotEmpty(body))  message.setText(body,hasHtmlContents);
        if(ObjUtils.isNotEmpty(cc)) message.setBcc(cc);
    	if(ObjUtils.isNotEmpty(bcc)) message.setBcc(bcc);

    	if(ObjUtils.isNotEmpty(fname))	{
    		//FileSystemResource file = new FileSystemResource(fname);
    		//message.addAttachment(file.getFilename(), file);
    		BodyPart messageBodyPart = new MimeBodyPart();

            //messageBodyPart.setText(body);
            messageBodyPart.setContent(body, "text/html; charset=utf-8");
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            messageBodyPart = new MimeBodyPart();
            File file = new File(fname);
            FileDataSource fds = new FileDataSource(file);
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setFileName(fds.getName());
            multipart.addBodyPart(messageBodyPart);

            mMessage.setContent(multipart, "text/html; charset=UTF-8");
    	}
        emailSender.send(mMessage);

    }

    public void sendMail(EmailModel emailContents, Map smtpInfo) throws Exception
    {
    	this.setSmtpInfo(smtpInfo);
    	String to = emailContents.getTO();
    	String from = emailContents.getFROM();
    	String subject = emailContents.getSUBJECT();
    	String body = emailContents.getTEXT();
    	String cc = emailContents.getCC();
    	String bcc = emailContents.getBCC();
    	String fname = emailContents.getFILE();
    	boolean hasHtmlContents =  ObjUtils.parseBoolean(emailContents.hasHtmlText(),false);

    	MimeMessage mMessage = emailSender.createMimeMessage();
    	MimeMessageHelper  message = new MimeMessageHelper(mMessage, false, "utf-8");
    	if(to == null)	{
    		throw new  UniDirectValidateException("받을 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("받을 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
    	if(from == null)	{
    		throw new  UniDirectValidateException("보내는 메일 주소가 입력되지 않았습니다.");
    	}else {
    		if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
    			throw new  UniDirectValidateException("보내는 메일 주소 형식이 올바르지 않습니다.");
    		}
    	}
     	message.setTo(to);
     	message.setFrom(from);

    	if(ObjUtils.isNotEmpty(subject)) 	message.setSubject(subject);
    	if(ObjUtils.isNotEmpty(body))  message.setText(body,hasHtmlContents);
        if(ObjUtils.isNotEmpty(cc)) message.setBcc(cc);
    	if(ObjUtils.isNotEmpty(bcc)) message.setBcc(bcc);

    	if(ObjUtils.isNotEmpty(fname))	{
    		//FileSystemResource file = new FileSystemResource(fname);
    		//message.addAttachment(file.getFilename(), file);
    		BodyPart messageBodyPart = new MimeBodyPart();

            //messageBodyPart.setText(body);
            messageBodyPart.setContent(body, "text/html; charset=utf-8");
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            messageBodyPart = new MimeBodyPart();
            File file = new File(fname);
            FileDataSource fds = new FileDataSource(file);
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setFileName(fds.getName());
            multipart.addBodyPart(messageBodyPart);

            mMessage.setContent(multipart, "text/html; charset=UTF-8");
    	}
        emailSender.send(mMessage);
        this.setBasicSmtpInfo();
    }

    public String sendMailAsync(EmailModel emailContents, Map smtpInfo) throws Exception
    {
    	String errorMessage = "";
    	this.setSmtpInfo(smtpInfo);
    	String to = emailContents.getTO();
    	String from = emailContents.getFROM();
    	String subject = emailContents.getSUBJECT();
    	String body = emailContents.getTEXT();
    	String cc = emailContents.getCC();
    	String bcc = emailContents.getBCC();
    	String fname = emailContents.getFILE();
    	boolean hasHtmlContents =  ObjUtils.parseBoolean(emailContents.hasHtmlText(),false);

    	MimeMessage mMessage = emailSender.createMimeMessage();
    	MimeMessageHelper  message = new MimeMessageHelper(mMessage, false, "utf-8");
    	if(to == null)	{
    		errorMessage = "받을 메일 주소가 입력되지 않았습니다.";
    		return errorMessage;
    	}else {
    		if(!(to.indexOf("@") > -1 && to.substring(to.indexOf("@"), to.length()).indexOf(".") > -1) ){
    			errorMessage = "받을 메일 주소 형식이 올바르지 않습니다.";
        		return errorMessage;
    		}
    	}
    	if(from == null)	{
    		errorMessage =  "보내는 메일 주소가 입력되지 않았습니다.";
    		return errorMessage;
    	}else {
    		if(!(from.indexOf("@") > -1 && from.substring(to.indexOf("@"), from.length()).indexOf(".") > -1) ){
    			errorMessage =  "보내는 메일 주소 형식이 올바르지 않습니다.";
    			return errorMessage;
    		}
    	}
     	message.setTo(to);
     	message.setFrom(from);

    	if(ObjUtils.isNotEmpty(subject)) 	message.setSubject(subject);
    	if(ObjUtils.isNotEmpty(body))  message.setText(body,hasHtmlContents);
        if(ObjUtils.isNotEmpty(cc)) message.setBcc(cc);
    	if(ObjUtils.isNotEmpty(bcc)) message.setBcc(bcc);

    	if(ObjUtils.isNotEmpty(fname))	{
    		//FileSystemResource file = new FileSystemResource(fname);
    		//message.addAttachment(file.getFilename(), file);
    		BodyPart messageBodyPart = new MimeBodyPart();

            //messageBodyPart.setText(body);
            messageBodyPart.setContent(body, "text/html; charset=utf-8");
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            
            messageBodyPart = new MimeBodyPart();
            File file = new File(fname);
            FileDataSource fds = new FileDataSource(file);
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setFileName(MimeUtility.encodeText(fds.getName(), "euc-kr","B"));
            multipart.addBodyPart(messageBodyPart);

            mMessage.setContent(multipart, "text/html; charset=UTF-8");
    	}
    	
    	try {
    		emailSender.send(mMessage);
    	} catch (Exception e) {
    		errorMessage = e.getMessage();
    		logger.error(e.toString());
    		e.printStackTrace();
    	}
    	
        this.setBasicSmtpInfo();
        return errorMessage;
    }
    
    private void setProperties(String compCode)	{

    	if(compCode == null || ObjUtils.isEmpty(compCode))	{
    		compCode = "MASTER";
    	}
    	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(compCode);
		CodeDetailVO cdo = codeInfo.getCodeInfo("BS32", "E1");;


    	Properties properties = new Properties();
        emailSender.setProtocol(cdo.getRefCode3());
        emailSender.setHost(cdo.getRefCode4());
        emailSender.setPort(ObjUtils.parseInt(cdo.getRefCode5()));
        emailSender.setUsername( cdo.getRefCode6());
        emailSender.setPassword( cdo.getRefCode7());
        properties.setProperty("mail.transport.protocol", cdo.getRefCode3());
        properties.setProperty("mail.host", cdo.getRefCode4());
        properties.setProperty("mail.smtp.port", cdo.getRefCode5());
        //properties.setProperty("mail.username",  cdo.getRefCode6());
        //properties.setProperty("mail.password",  cdo.getRefCode7());
        properties.setProperty("mail.smtp.auth", cdo.getRefCode8());
        properties.setProperty("mail.smtp.starttls.enable", cdo.getRefCode9());
        properties.setProperty("mail.smtp.quitwait.enable", cdo.getRefCode10());
        properties.setProperty("mail.debug", "false");
        emailSender.setJavaMailProperties(properties);
    }

    private void setSmtpInfo(Map smtpInfo)	{
    	//Properties properties =
    	emailSender.setHost(ObjUtils.getSafeString(smtpInfo.get("SERVER_NAME")));
    	emailSender.setPort(ObjUtils.parseInt(smtpInfo.get("SERVER_PROT")));
    	emailSender.setUsername(ObjUtils.getSafeString(smtpInfo.get("SEND_USER_NAME")));
    	emailSender.setPassword(ObjUtils.getSafeString(smtpInfo.get("SEND_PASSWORD")));
    }

    private void setBasicSmtpInfo()	{
    	emailSender.setHost(ObjUtils.getSafeString(ConfigUtil.getString("common.emailSender.host","127.0.0.1")));
    	emailSender.setPort(ObjUtils.parseInt(ConfigUtil.getString("common.emailSender.port","465")));
    	emailSender.setUsername(ObjUtils.getSafeString(ConfigUtil.getString("common.emailSender.username","*********")));
    	emailSender.setPassword(ObjUtils.getSafeString(ConfigUtil.getString("common.emailSender.password", "*********")));

    }
}
