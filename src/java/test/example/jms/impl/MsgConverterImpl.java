package test.example.jms.impl;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Session;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.support.converter.MessageConversionException;
import org.springframework.jms.support.converter.MessageConverter;

import test.example.jms.support.JmsUtils;




/**
 * MapMessage로의 conversion을 담당하는 class
 * 
 * 
 */
public class MsgConverterImpl implements MessageConverter {
    Logger logger = LoggerFactory.getLogger(MsgConverterImpl.class);
    
//    private final static String hostName = NetUtils.getHostName();
//    private final static  String hostAddress = NetUtils.getHostAddress();
    

    
    public MsgConverterImpl() {
    }
    
    /**
     * Convert general JMS Message to CrgMqMessage  for use in System.
     */
    public Object fromMessage(Message message) throws JMSException, MessageConversionException {
       return JmsUtils.fromMessage(message);
    }

    /**
     * Convert  CrgMqMessage to general JMS Message for send to MQ.
     */
    public Message toMessage(Object object, Session session) throws JMSException, MessageConversionException {
        return JmsUtils.toMessage(object, session);
    }
}