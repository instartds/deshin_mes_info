package test.example.jms.docs;

import foren.framework.model.BaseVO;

/**
 * @Class Name : GenResDoc.java
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

public class GenResDoc extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 2569172367620799462L;
//    private boolean hasError = false;
    private String refDocType;
    private String refDocNo;
    private String jmsMsgId;
    private String resultMsg;
    private String receivedDT;
    private String receiveHostAddress;
    private boolean rejected = false;
    
    
    /**
     * @return the rejected ( if receiver system has error )
     */
    public boolean isRejected() {
        return this.rejected;
    }
    /**
     * @param rejected the rejected to set
     */
    public void setRejected(boolean rejected) {
        this.rejected = rejected;
    }
//    /**
//     * @return the error
//     */
//    public boolean isHasError() {
//        return hasError;
//    }
//    /**
//     * @param error the error to set
//     */
//    public void setHasError(boolean error) {
//        this.hasError = error;
//    }
    /**
     * @return the jmsMsgId
     */
    public String getJmsMsgId() {
        return jmsMsgId;
    }
    /**
     * @param jmsMsgId the jmsMsgId to set
     */
    public void setJmsMsgId(String jmsMsgId) {
        this.jmsMsgId = jmsMsgId;
    }

    /**
     * @return the receivedDT
     */
    public String getReceivedDT() {
        return receivedDT;
    }
    /**
     * @param receivedDT the receivedDT to set
     */
    public void setReceivedDT(String receivedDT) {
        this.receivedDT = receivedDT;
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
     * @return the refDocType
     */
    public String getRefDocType() {
        return refDocType;
    }
    /**
     * @param refDocType the refDocType to set
     */
    public void setRefDocType(String refDocType) {
        this.refDocType = refDocType;
    }
    /**
     * @return the refDocNo
     */
    public String getRefDocNo() {
        return refDocNo;
    }
    /**
     * @param refDocNo the refDocNo to set
     */
    public void setRefDocNo(String refDocNo) {
        this.refDocNo = refDocNo;
    }

    

}
