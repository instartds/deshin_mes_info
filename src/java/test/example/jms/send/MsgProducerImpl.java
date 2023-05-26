package test.example.jms.send;

/**
 * @Class Name : MsgProducerImpl.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jun 18, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jun 18, 2012 by SangJoon Kim: initial version
 * </pre>
 */

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.core.JmsTemplate;

import test.example.jms.CMDocTypes;
import test.example.jms.CrgMQMessage;
import test.example.jms.JmsLoggerService;
import test.example.jms.docs.GenResDoc;
import test.example.jms.model.JMSLogVO;
import test.example.jms.support.NetUtils;

import foren.framework.model.LoginVO;

public class MsgProducerImpl implements MsgProducer {
    Logger logger = LoggerFactory.getLogger(MsgProducerImpl.class);

    private JmsTemplate jmsTemplate;
    
    @Resource(name = "jmsLoggerService")
    private JmsLoggerService jmsLoggerService;

    public void setJmsTemplate(JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

    public void send(  CrgMQMessage msg) {
        if(msg == null) {
            logger.error("Message is Null. Can't process more.");
        } else {
            SendMessageCreator messageCreator = new SendMessageCreator(msg);
            
            logger.debug(" >>> Start send a message process. ");            

            
            msg.setSendHostAddress(NetUtils.getInstance().getHostAddress());

            //Send the message
            jmsTemplate.send(messageCreator);
            
            try {
                  //now access the message id from the messageCreator
                  String msgId = messageCreator.getJMSMessageID();
                  msg.setJmsMessageID(msgId);
                  logger.debug(" [{}] message sent. " , msgId);
              } catch (Exception e){
                  logger.error(e.getMessage());
              }
            if(!CMDocTypes.ANY_RCVNTI.equals(msg.getDocType())) {
                JMSLogVO logInfo = new JMSLogVO("S", msg);
                jmsLoggerService.logSent(logInfo);
            }
            logger.debug(" <<< Finished send a message process " );
        }
    }
    
    public void sendDeclaration(  CrgMQMessage msg, LoginVO loginVO)   throws Exception{
    	sendDeclaration(msg, loginVO, null);
    }
    public void sendDeclaration(  CrgMQMessage msg, LoginVO loginVO, Map<String, Object> data) throws Exception {
        if(msg == null) {
            logger.error("Message is Null. Can't process more.");
        } else {
            
            logger.debug(" >>> send a Declaration. ");
            
//            LoginVO loginVO = (LoginVO) RequestContextHolder.getRequestAttributes().getAttribute(CommonConstants.SESSION_KEY, RequestAttributes.SCOPE_SESSION);
            if(loginVO == null) {
                throw new Exception(" Invalide session !!!");
            }
            
            
            

            logger.debug(msg.toString());
           
            
            msg.setSendHostAddress(NetUtils.getInstance().getHostAddress());
            
            // jmsTemplate.convertAndSend(msg);
          //Send the message

            SendMessageCreator messageCreator = new SendMessageCreator(msg);
            jmsTemplate.send(messageCreator);
            
            try {
                  //now access the message id from the messageCreator
                  String msgId = messageCreator.getJMSMessageID();
                  msg.setJmsMessageID(msgId);
                  logger.debug(" [{}] message sent. " , msgId);
              } catch (Exception e){
                  logger.error(e.getMessage());
              }
            if(!CMDocTypes.ANY_RCVNTI.equals(msg.getDocType())) {
                JMSLogVO logInfo = new JMSLogVO("S", msg);
                jmsLoggerService.logSent(logInfo);
            }
            logger.debug(" <<< sent a message. " );
        }
    }
    
    /**
     * send received message
     * @param crgMsg
     */
    public void sendRcvOkNti(final CrgMQMessage crgMsg) {
      GenResDoc genResForSend = new GenResDoc();
      genResForSend.setResultMsg(null);
      genResForSend.setJmsMsgId(crgMsg.getJmsMessageID());
      genResForSend.setReceivedDT(crgMsg.getReceivedDT());
      genResForSend.setReceiveHostAddress(crgMsg.getReceiveHostAddress());
      genResForSend.setRefDocType(crgMsg.getDocType());
      genResForSend.setRefDocNo(crgMsg.getDocNo());
      
      CrgMQMessage rcvNtiMsg = new CrgMQMessage(CMDocTypes.ANY_RCVNTI);
      rcvNtiMsg.setDocNo(crgMsg.getDocNo());
      rcvNtiMsg.setReceivedDT(crgMsg.getReceivedDT());//  JmsUtils.getTimeString());
      rcvNtiMsg.setReceiveHostAddress(crgMsg.getReceiveHostAddress());
      rcvNtiMsg.setValue(genResForSend);
      
      this.send(rcvNtiMsg);
    }

}