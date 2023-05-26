package test.example.jms.send;
import java.util.Map;

import org.springframework.jms.core.JmsTemplate;

import test.example.jms.CrgMQMessage;

import foren.framework.model.LoginVO;

/**
 * @Class Name : MsgProducer.java
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



public interface MsgProducer {
    /**
     * JMS Message Producer for Internal Service
     */
    public final static String FOR_INTERNAL = "producerIN";
    /**
     * JMS Message Producer for External Service
     */
    public final static String FOR_EXTERNAL = "producerEX";
  
    
    /**
     * crgMsg' requireds
     * @param crgMsg
     */
    public void send(final CrgMQMessage crgMsg);
    
    /**
     * send received message
     * @param crgMsg
     */
    public void sendRcvOkNti(final CrgMQMessage crgMsg);
    
    /**
     * crgMsg' requireds
     * @param crgMsg
     */
    public void sendDeclaration(final CrgMQMessage crgMsg, LoginVO loginVO) throws Exception;
  
    /**
     * crgMsg' requireds
     * @param crgMsg
     */
    public void sendDeclaration(final CrgMQMessage crgMsg, LoginVO loginVO, Map<String, Object> data) throws Exception;

    public void setJmsTemplate(JmsTemplate jmsTemplate);
  
}