package test.example.jms;

import foren.framework.model.BaseVO;

public class CrgMQMessage extends BaseVO {
    
    /**
     * 
     */
    private static final long serialVersionUID = -7253185011473991935L;
    
    private String jmsMessageID;
    private String docType;
    private String docNo;
    private String sendHostAddress;
    private String receiveHostAddress;
    private String sendDT;
    private String receivedDT;
    private String rcvCmpnyID;


    /**
     * @return the jmsMessageID
     */
    public String getJmsMessageID() {
        return jmsMessageID;
    }


    /**
     * @param jmsMessageID the jmsMessageID to set
     */
    public void setJmsMessageID(String jmsMessageID) {
        this.jmsMessageID = jmsMessageID;
    }

    private Object value;
    
    public CrgMQMessage(String docType) {
        this.docType = docType;
    }
    
    public CrgMQMessage(String docType, String rcvCmpnyID) {
        this.docType = docType;
        this.rcvCmpnyID = rcvCmpnyID;
    }
    
    
    /**
     * @return the docType
     */
    public final String getDocType() {
        return docType;
    }


    public void setValue(Object value) {
        this.value = value;
    }
 
    public Object getValue() {
        return value;
    }

    /**
     * @return the docNo
     */
    public String getDocNo() {
        return docNo;
    }

    /**
     * @param docNo the docNo to set
     */
    public void setDocNo(String docNo) {
        this.docNo = docNo;
    }

    /**
     * @return the senderHostAdress
     */
    public String getSendHostAddress() {
        return sendHostAddress;
    }

    /**
     * @param senderHostAdress the senderHostAdress to set
     */
    public void setSendHostAddress(String sendHostAddress) {
        this.sendHostAddress = sendHostAddress;
    }

    /**
     * @return the receiveHostAddress
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
     * @return the sendDt
     */
    public String getSendDT() {
        return sendDT;
    }


    /**
     * @param sendDt the sendDt to set
     */
    public void setSendDt(String sendDT) {
        this.sendDT = sendDT;
    }


    /**
     * @return the receivedDt
     */
    public String getReceivedDT() {
        return receivedDT;
    }


    /**
     * @param receivedDt the receivedDt to set
     */
    public void setReceivedDT(String receivedDT) {
        this.receivedDT = receivedDT;
    }





    /**
     * @return the rcvCmpnyID
     */
    public String getRcvCmpnyID() {
        return rcvCmpnyID;
    }


    /**
     * @param rcvCmpnyID the rcvCmpnyID to set
     */
    public void setRcvCmpnyID(String rcvCmpnyID) {
        this.rcvCmpnyID = rcvCmpnyID;
    }
 

 
}