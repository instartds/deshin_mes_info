package test.example.jms;

import test.example.jms.docs.GenResDoc;
import test.example.jms.model.JMSLogVO;

/**
 * @Class Name : JmsLoggerService.java
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

public interface JmsLoggerService {
    /**
     * After a message sent for sender ( JmsLoggerServiceImpl.insertSendLog )
     * @param msg
     */
    public void logSent(JMSLogVO logInfo);
    /**
     * insertReceiveLog for receiver
     * @param logInfo
     */
    public void logReceive(JMSLogVO logInfo);
    /**
     * updateReceivedLog for Receiver
     * @param logInfo
     */
    public void logReceived(JMSLogVO logInfo);
    
    /**
     * UPDATE CO_JMS_LOG for Sender : JmsLoggerServiceImpl.logGenRes
     * @param genRes
     */
    public void logGenRes(GenResDoc genRes);
}
