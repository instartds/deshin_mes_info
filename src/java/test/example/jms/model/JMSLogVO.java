package test.example.jms.model;

import java.io.Serializable;

import test.example.jms.CrgMQMessage;



/**
 * @Class Name : JMSLogVO.java
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

public class JMSLogVO  implements Serializable {
    
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    private String jmsMsgId;
    private String sendHostAddress;
    private String receiveHostAddress;
    private String docType;
    private String docNo;
    private String sendDT;
    private String receivedDt;

    
    /**
     * @return the docNo
     */
    public String getDocNo() {
        return docNo;
    }

    private String resultMsg;
    private String statusCd;
    private String sndRcv;
    
    public JMSLogVO(String jmsMsgId, String docType, String docNo) {
        this.jmsMsgId = jmsMsgId;
        this.docType = docType;
        this.docNo = docNo;
    }
    
    public JMSLogVO(String sndRcv, CrgMQMessage msg) {
        this.sndRcv = sndRcv;
        this.jmsMsgId = msg.getJmsMessageID();
        this.docType = msg.getDocType();
        this.docNo = msg.getDocNo();
        this.sendHostAddress=msg.getSendHostAddress();
        this.receiveHostAddress=msg.getReceiveHostAddress();
        this.sendDT = msg.getSendDT();
        this.receivedDt = msg.getReceivedDT();
    }

    /**
     * @return the sendHostAddress
     */
    public String getSendHostAddress() {
        return sendHostAddress;
    }

    /**
     * @param sendHostAddress the sendHostAddress to set
     */
    public void setSendHostAddress(String sendHostAddress) {
        this.sendHostAddress = sendHostAddress;
    }

    /**
     * @return the receivHostAddress
     */
    public String getReceiveHostAddress() {
        return receiveHostAddress;
    }

    /**
     * @param receiveHostAddress the receiveHostAddress to set
     */
    public void setReceiveHostAddress(String receiveHostAddress) {
        this.receiveHostAddress = receiveHostAddress;
    }

    /**
     * @return the resultMsg
     */
    public String getResultMsg() {
        return resultMsg;
    }

    /**
     * @param resultMsg the resultMsg to set
     */
    public void setResultMsg(String resultMsg) {
        this.resultMsg = resultMsg;
    }

    /**
     * @return the jmsMsgId
     */
    public String getJmsMsgId() {
        return jmsMsgId;
    }

    /**
     * @return the docType
     */
    public String getDocType() {
        return docType;
    }

    /**
     * @return the statusCd
     */
    public String getStatusCd() {
        return statusCd;
    }

    /**
     * @return the sndRcv
     */
    public String getSndRcv() {
        return sndRcv;
    }

    /**
     * @param statusCd the statusCd to set
     */
    public void setStatusCd(String statusCd) {
        this.statusCd = statusCd;
    }

    /**
     * @param sndRcv the sndRcv to set
     */
    public void setSndRcv(String sndRcv) {
        this.sndRcv = sndRcv;
    }

    /**
     * @return the sendDT
     */
    public String getSendDT() {
        return sendDT;
    }

    /**
     * @param sendDT the sendDT to set
     */
    public void setSendDT(String sendDT) {
        this.sendDT = sendDT;
    }

    /**
     * @return the receivedDt
     */
    public String getReceivedDT() {
        return receivedDt;
    }

    /**
     * @param receivedDt the receivedDt to set
     */
    public void setReceivedDT(String receivedDt) {
        this.receivedDt = receivedDt;
    }

    
}
