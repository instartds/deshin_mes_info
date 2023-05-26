package test.example.jms.send;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Session;

import org.springframework.jms.core.MessageCreator;

import test.example.jms.CrgMQMessage;
import test.example.jms.support.JmsUtils;



/**
 * @Class Name : SendMessageCreator.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jul 11, 2012
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jul 11, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class SendMessageCreator implements MessageCreator {

    // message is of type javax.jms.Message
    private Message message = null;
    private CrgMQMessage crgMsg = null;
    
    public SendMessageCreator(CrgMQMessage crgMsg) {
        this.crgMsg = crgMsg;
    }
    
    public String getJMSMessageID() throws JMSException{
        if (this.message != null) {
            return message.getJMSMessageID();
        } else {
            return null;
        }
    }
    
    public Message createMessage(Session session) throws JMSException {
        message = JmsUtils.toMessage(crgMsg, session);
        return message;
    }

}
