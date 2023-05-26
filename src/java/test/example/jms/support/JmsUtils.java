package test.example.jms.support;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.support.converter.MessageConversionException;

import test.example.jms.CrgMQMessage;



/**
 * @Class Name : JmsUtils.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jul 11, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jul 11, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class JmsUtils {
    public final static String JMS_MESSAGE_BODY_KEY = "KEY_" + CrgMQMessage.class.toString();
    public final static String DOC_TYPE = "KEY_DOC_TYPE";
    public final static String DOC_NO = "KEY_DOC_NO";
    public final static String SEND_HOST_ADDRESS = "KEY_SEND_HOST_ADDRESS";
    public final static String SEND_TIME = "KEY_SEND_DATETIME";
    public final static String RECEIVE_HOST_ADDRESS = "KEY_RECEIVE_HOST_ADDRESS";
    
    private static final String FORMAT_FULL_DATE_TIME = "yyyyMMddHHmmss:SSS";
    private static Logger   logger = LoggerFactory.getLogger(JmsUtils.class);
    private  static SimpleDateFormat formatter = new SimpleDateFormat(FORMAT_FULL_DATE_TIME);
    
    public static  String getTimeString() {
        return formatter.format(Calendar.getInstance().getTime());
    }
    /**
     * Convert  CrgMqMessage to general JMS Message for send to MQ.
     */
    public static Message toMessage(Object object, Session session) throws JMSException, MessageConversionException {
        if( object == null) {
            throw new MessageConversionException("Can't not convert NULL message." ); 
        }
        if (!(object instanceof CrgMQMessage)) {
            throw new MessageConversionException("Message type must be " + CrgMQMessage.class + ". but it's class is " + object.getClass());
        }
        CrgMQMessage crgMsg = (CrgMQMessage) object;        
        crgMsg.setSendDt(getTimeString());
        
        logger.debug("Convert CrgMqMessage to general JMS Message." );

        MapMessage mapMessage = session.createMapMessage();
        
        try {
            mapMessage.setBytes(JMS_MESSAGE_BODY_KEY, NetUtils.serialize(crgMsg));
            
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new MessageConversionException(e.getMessage(), e);
        }
        mapMessage.setString(DOC_TYPE, crgMsg.getDocType() );//MsgConverterImpl.hostName);
        mapMessage.setString(DOC_NO, crgMsg.getDocNo() );//MsgConverterImpl.hostName);
        mapMessage.setString(SEND_HOST_ADDRESS, crgMsg.getSendHostAddress());//MsgConverterImpl.hostName);
        mapMessage.setString(SEND_TIME, crgMsg.getSendDT());

        return mapMessage;
    }
    
    
    /**
     * Convert general JMS Message to CrgMqMessage  for use in System.
     */
    public static Object fromMessage(Message message) throws JMSException, MessageConversionException {
        if (!(message instanceof MapMessage)) {
            throw new MessageConversionException("not MapMessage");
        }
        logger.debug("Convert general JMS Message to CrgMqMessage. ID = [{}]", message.getJMSMessageID());

        MapMessage mapMessage = (MapMessage) message;
        //String messageID = message.getJMSMessageID();
        CrgMQMessage crgMsg;
        try {
            crgMsg = ( CrgMQMessage ) NetUtils.deserialize( mapMessage.getBytes(JMS_MESSAGE_BODY_KEY));
            crgMsg.setJmsMessageID(mapMessage.getJMSMessageID());
            crgMsg.setReceiveHostAddress(NetUtils.getInstance().getHostAddress());
            crgMsg.setReceivedDT(getTimeString());
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new MessageConversionException(e.getMessage(), e);
        }
        logger.debug("Converted.");
        return crgMsg;
    }
}
