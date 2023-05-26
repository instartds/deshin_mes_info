package test.example.jms.receive;

import javax.jms.JMSException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import test.example.jms.CMDocTypes;
import test.example.jms.CrgMQMessage;
import test.example.jms.JmsLoggerService;
import test.example.jms.docs.GenResDoc;
import test.example.jms.model.JMSLogVO;
import test.example.jms.send.MsgProducer;



/**
 * @Class Name : MsgMDP.java
 * @Description : Document receive
 * @author SangJoon Kim
 * @since Jun 29, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jun 29, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public abstract class MsgMDP {
    
    private Logger logger = LoggerFactory.getLogger(MsgMDP.class);
    
    private JmsLoggerService jmsLoggerService;
    private MsgProducer  msgProducer ;
    
    public void setJmsLoggerService(JmsLoggerService jmsLoggerService) {
        this.jmsLoggerService = jmsLoggerService;
    }      
    
    public void setMsgProducer(MsgProducer msgProducer) {
        this.msgProducer = msgProducer;
    }    

    public abstract void procMessage(CrgMQMessage msg) throws JMSException;
    
    /**
     * Process a received JMS Message
     * 
     * @param crgMsg
     * @throws JMSException
     */
    public  void handleMessage(CrgMQMessage crgMsg) throws JMSException {
        String errorMessage = null;
        String technicalErrorMessage = null;
        boolean isRejected = true;
        boolean isGenRes = false;
        GenResDoc genRes = null;
        
        // Logging GENRES
        if(CMDocTypes.ANY_RCVNTI.equals(crgMsg.getDocType())) {
            isGenRes = true;
            genRes = (GenResDoc) crgMsg.getValue();
            try {
                // insert log info into local DB
                jmsLoggerService.logGenRes(genRes);
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        } 
        
       
        try {
            if(! isGenRes ) {
                preLogging(crgMsg, errorMessage);
            }

            // Received Document Process
            procMessage(crgMsg);
            
            isRejected = false;
        } catch (Exception e) {
            logger.error(e.getMessage());
            technicalErrorMessage = e.getMessage();
            errorMessage = "Your message was rejected by System.";
        }

        if(! isGenRes ) {            
            postLogging(crgMsg,  technicalErrorMessage, errorMessage, isRejected);           
        }
        if (isRejected) {
            logger.error("========== Message was rejected !!! \n" + errorMessage);
        }
    }
    

    
    private void postLogging(CrgMQMessage crgMsg,  String technicalErrorMessage, String errorMessage, boolean isRejected) {
        JMSLogVO logInfo = new JMSLogVO("R", crgMsg);
        if(isRejected) {
            logInfo.setStatusCd("REJECTED");
            logInfo.setResultMsg(technicalErrorMessage);
        } else {
            logInfo.setStatusCd("RECEIVED");
        }        

        
        GenResDoc genRes = new GenResDoc();
        genRes.setRejected(isRejected);
        genRes.setResultMsg(errorMessage);
        genRes.setJmsMsgId(crgMsg.getJmsMessageID());
        genRes.setReceivedDT(crgMsg.getReceivedDT());
        genRes.setReceiveHostAddress(crgMsg.getReceiveHostAddress());
        genRes.setRefDocType(crgMsg.getDocType());
        genRes.setRefDocNo(crgMsg.getDocNo());
        
        if(isRejected) {
            CrgMQMessage returnCrgMsg = new CrgMQMessage(CMDocTypes.ANY_RCVNTI);
            returnCrgMsg.setDocNo(crgMsg.getDocNo());
            returnCrgMsg.setReceivedDT(crgMsg.getReceivedDT());//  JmsUtils.getTimeString());
            returnCrgMsg.setReceiveHostAddress(crgMsg.getReceiveHostAddress());
            
            
            returnCrgMsg.setValue(genRes);
            msgProducer.send(returnCrgMsg );
        }
        jmsLoggerService.logReceived(logInfo);
    }
    
      private void preLogging(CrgMQMessage crgMsg,  String errorMessage) {
        JMSLogVO logInfo = new JMSLogVO("R", crgMsg);

        logInfo.setStatusCd("RECEIVE");       

//        move to each docuemt resolve processor         
//        GenResDoc genResForSend = new GenResDoc();
//        genResForSend.setResultMsg(errorMessage);
//        genResForSend.setJmsMsgId(crgMsg.getJmsMessageID());
//        genResForSend.setReceivedDT(crgMsg.getReceivedDT());
//        genResForSend.setReceiveHostAddress(crgMsg.getReceiveHostAddress());
//        genResForSend.setRefDocType(crgMsg.getDocType());
//        genResForSend.setRefDocNo(crgMsg.getDocNo());
        
//        CrgMQMessage rcvNtiMsg = new CrgMQMessage(CMDocTypes.ANY_RCVNTI);
//        rcvNtiMsg.setDocNo(crgMsg.getDocNo());
//        rcvNtiMsg.setReceivedDT(crgMsg.getReceivedDT());//  JmsUtils.getTimeString());
//        rcvNtiMsg.setReceiveHostAddress(crgMsg.getReceiveHostAddress());
//        rcvNtiMsg.setRcvCmpnyID(crgMsg.getDclrntCd());
//        rcvNtiMsg.setValue(genResForSend);
        
//        msgProducer.send(rcvNtiMsg);
        
        jmsLoggerService.logReceive(logInfo);
    }    
    
    

}
