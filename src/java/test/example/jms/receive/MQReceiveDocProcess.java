package test.example.jms.receive;

import test.example.jms.CrgMQMessage;

/**
 * @Class Name : MQListener.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jul 10, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jul 10, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public interface MQReceiveDocProcess {
    public void processMessage(CrgMQMessage msg) throws Exception ;
}
