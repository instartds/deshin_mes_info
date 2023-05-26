package test.example.jms;

/**
 * @Class Name : CMDocTypes.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since Jul 2, 2012
 * @version 1.0
 * @see 
 *
 * @Modification Information
 * <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  Jul 2, 2012 by SangJoon Kim: initial version
 * </pre>
 */

public class CMDocTypes {
    
    /**
    *RECeived(GENRES)  
    */
     public final static String ANY_RCVNTI = "RCVNTI";
     
     /**
      *Receive Error(RJTNTI) Rejected by System
      */
       public final static String ANY_RJTNTI = "RJTNTI";    
     
    /**
    *ERRor(Customs -> External ) : for Dodument validation or Audit Error
    */
     public final static String IN_ERRNTI = "ERRNTI";
    /**
    *RESult(Customs -> External )
    */
     
     
     
//    /**
//     * for Manifest
//     */
//    public final static String CUSMAN="CUSMAN";
//    /**
//     * for Discharge
//     */
//    public final static String CUSAGD="CUSAGD";
    
    
    /**
    *MANifest Declaration
    */
     public final static String EX_MANDEC = "MANDEC";
    /**
    *MRN Amend Declaration
    */
     public final static String EX_MRADEC = "MRADEC";
    /**
    *Manifest AmenD Declaration
    */
     public final static String EX_MADDEC = "MADDEC";
    /**
    *MAnifest Data
    */
     public final static String IN_MADDAT = "MADDAT";
    /**
    *DIScharge Declaration
    */
     public final static String EX_DISDEC = "DISDEC";
    /**
    *LODing Declaration
    */
     public final static String EX_LODDEC = "LODDEC";
    /**
    *DIScharge List
    */
     public final static String IN_DISDAT = "DISDAT";
    /**
    *Discharge Amend by Authority
    */
     public final static String IN_DIADAT = "DIADAT";
    /**
    *LODing List
    */
     public final static String IN_LODDAT = "LODDAT";
    /**
    *LOding Amend by Authority
    */
     public final static String IN_LOADAT = "LOADAT";
    /**
    *Short And Over Landed Report(DISCHARGE REPORT)
    */
     public final static String EX_DISREP = "DISREP";
    /**
    *Short And Over Loaded Report(LODING REPORT)
    */
     public final static String EX_LODREP = "LODREP";
    /**
    *ICD Transfer Declaration
    */
     public final static String EX_ITDDEC = "ITDDEC";
    /**
    *ICD Transfer Cancel Declaration
    */
     public final static String EX_ITCDEC = "ITCDEC";
    /**
    *Bonded TRansport Declaration
    */
     public final static String EX_BTRDEC = "BTRDEC";
    /**
    *Bonded Transport Cancel Declaration
    */
     public final static String EX_BTCDEC = "BTCDEC";
    /**
    *Extension Of Period Declaration
    */
     public final static String EX_EOPDEC = "EOPDEC";
    /**
    *Extension Of period Cancel Declaration
    */
     public final static String EX_EOCDEC = "EOCDEC";
    /**
    *CArry In REPort
    */
     public final static String EX_CAIREP = "CAIREP";
    /**
    *CArry In Cancel REPort
    */
     public final static String EX_CICREP = "CICREP";
    /**
    *CArry Out REPort
    */
     public final static String EX_CAOREP = "CAOREP";
    /**
    *Carry Out Cancel REPort
    */
     public final static String EX_COCREP = "COCREP";
    /**
    *OVeRstaied Cargo Report
    */
     public final static String EX_OVRREP = "OVRREP";
     /**
      *Available Space Report
      */
       public final static String EX_AASREP = "AASREP";
    /**
    *Prior Carry In/Out Notice
    */
     public final static String IN_PCIDAT = "PCIDAT";
    /**
    *Prior carry  In/Out Notice  Cancel
    */
     public final static String IN_PICDAT = "PICDAT";
     
     
     /**
      *Checkpoint out notice
      */
       public final static String II_CHECKPOINT_OUT = "ICOTDAT";
//    /**
//    *Pre Carry Out
//    */
//     public final static String IN_PCODAT = "PCODAT";
//    /**
//    *Pre carry Out Cancel
//    */
//     public final static String IN_POCDAT = "POCDAT";

       /**
        * Audit or inspect result notice
        */
     public final static String IN_RESNTI = "RESNTI";

     /**
      *INVoice(Customs -> External )
      */
       public final static String IN_INVNTI = "INVNTI";
       
       /**
       *Bonded Transport Cancel Declaration
       */
       public final static String IN_BTCT1D = "BTCT1D";

       /**
       * Manifest Data Notice
       */
       public final static String IN_MADNTI = "MADNTI";
       
        

}
