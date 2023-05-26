package foren.unilite.modules.z_kocis;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.cipher.seed.EncryptSHA256;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "s_bsa300ukrvService_KOCIS" )
public class S_Bsa300ukrvServiceImpl_KOCIS extends TlabAbstractServiceImpl {
    private final Logger       logger            = LoggerFactory.getLogger(this.getClass());
    
    public static final String csINIT_SYSTEM_PWD = "*FOREN*";
    
    //database replication을 위한 옵션
    private EncryptSHA256      enc               = new EncryptSHA256();
    
    /**
     * 사용자 정보 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bsa" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        param.put("csINIT_SYSTEM_PWD", csINIT_SYSTEM_PWD);
        List<Map<String, Object>> rv = super.commonDao.list("s_bsa300ukrvServiceImpl_KOCIS.getDataList", param);
        return rv;
    }
    
    /**
     * 사용자 정보 입력
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
    public List<Map> insertMulti( List<Map> paramList, LoginVO user ) throws Exception {
        
        //암호화여부 및 비밀번호 대소문자 구분 여부 체크
        boolean bSecurityFlag = false;
        String sCaseSensitiveYN = "N";
        
        Map<String, Object> setInfo = this.checkEncryptYN();
        if (setInfo == null) bSecurityFlag = false;
        else {
            bSecurityFlag = true;
            sCaseSensitiveYN = (String)setInfo.get("CASE_SENS_YN");
        }
        
        // 데모용인지 확인
        //      if("DEMO".equals(this.isUser()))    {
        //          throw new  UniDirectValidateException(this.getMessage("52103", user));
        //      }
        
        for (Map param : paramList) {
            //사용자 ID 중복체크
            Map<String, String> chkUniqueId = (Map<String, String>)super.commonDao.select("s_bsa300ukrvServiceImpl_KOCIS.checkUniqueID", param);
            if (chkUniqueId != null) {
                //              throw new  UniDirectValidateException(this.getMessage("[52113] 사용자 ID '" + chkUniqueId.get("USER_ID") + "'가  '" + chkUniqueId.get("COMP_NAME") + "' 법인에 등록되어 있습니다.", user));
                throw new UniDirectValidateException(this.getMessage("52113", user));
            }
            
            String strSecurityFlag = ( bSecurityFlag ) ? "True" : "False";
            param.put("bSecurityFlag", strSecurityFlag);
            param.put("FAIL_CNT", "0");
            
            if (param.get("PERSON_NUMB") == null || "".equals(param.get("PERSON_NUMB").toString().trim())) {
                param.put("PERSON_NUMB", "*");
            }

            if ("Y".equals(sCaseSensitiveYN)) {
                param.put("PASSWORD", param.get("PASSWORD").toString().toUpperCase());
            }
            String pw = ObjUtils.getSafeString(param.get("PASSWORD"));
            if (!csINIT_SYSTEM_PWD.equals(pw)) {
                
                logger.debug("   ######################   enc pw " + enc.encrypt(pw));
                param.put("PASSWORD", enc.encrypt(pw));
            }
            super.commonDao.insert("s_bsa300ukrvServiceImpl_KOCIS.insertMulti", param);
            //          if(bSecurityFlag) {
            //              super.commonDao.insert("s_bsa300ukrvServiceImpl_KOCIS.insertBSA301T", param);
            //          }
            
            //사용자 수를 초과했거나 등록된 유저가 아닌 경우 체크
            List<Map<String, Object>> mapUserList = super.commonDao.list("s_bsa300ukrvServiceImpl_KOCIS.selectUserList", param);
            if (!LicenseManager.getInstance().getLicenseProcessor().verifyUserCount(mapUserList, (String)param.get("USER_ID"))) {
                throw new UniDirectValidateException(this.getMessage("52106", user));
            }
        }
        
        return paramList;
    }
    
    /**
     * 사용자 정보 수정
     * 
     * @param paramList
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
    public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {
        
        //암호화여부 및 비밀번호 대소문자 구분 여부 체크
        boolean bSecurityFlag = false;
        String sCaseSensitiveYN = "N";
        
        Map<String, Object> setInfo = this.checkEncryptYN();
        if (setInfo == null) bSecurityFlag = false;
        else {
            bSecurityFlag = true;
            sCaseSensitiveYN = (String)setInfo.get("CASE_SENS_YN");
        }
        
        // 데모용인지 확인
        //      if("DEMO".equals(this.isUser()))    {
        //          throw new  UniDirectValidateException(this.getMessage("52103", user));
        //      }
        
        for (Map param : paramList) {
            String sUserPwd = param.get("PASSWORD").toString();
            
            String strSecurityFlag = ( bSecurityFlag ) ? "True" : "False";
            param.put("bSecurityFlag", strSecurityFlag);
            param.put("FAIL_CNT", "0");
            if ("Y".equals(sCaseSensitiveYN)) {
                param.put("PASSWORD", param.get("PASSWORD").toString().toUpperCase());
            }
            
            String pw = ObjUtils.getSafeString(param.get("PASSWORD"));
            if (!csINIT_SYSTEM_PWD.equals(pw)) {
                param.put("PASSWORD", enc.encrypt(pw));
            }
            logger.debug("   ######################   enc pw " + enc.encrypt(pw));
            super.commonDao.update("s_bsa300ukrvServiceImpl_KOCIS.updateMulti", param);
            
            if (!csINIT_SYSTEM_PWD.equals(sUserPwd)) {
                super.commonDao.update("s_bsa300ukrvServiceImpl_KOCIS.updatePassword", param);
                
                //              if(bSecurityFlag) {                 
                //                  super.commonDao.update("s_bsa300ukrvServiceImpl_KOCIS.updateBSA301T", param);
                //                  
                //                  if(replication){
                //                      super.commonDao.update("bsa300ukrvRepServiceImpl.updateBSA301T", param);
                //                  }
                //              }
                super.commonDao.update("s_bsa300ukrvServiceImpl_KOCIS.insertPasswordLog", param);
                
            }
        }
        
        return paramList;
    }
    
    /**
     * 사용자 정보 삭제
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
    public List<Map> deleteMulti( List<Map> paramList, LoginVO user ) throws Exception {
        
        boolean bSecurityFlag = false;
        String sCaseSensitiveYN = "N";
        
        Map<String, Object> setInfo = this.checkEncryptYN();
        if (setInfo == null) bSecurityFlag = false;
        else {
            bSecurityFlag = true;
            sCaseSensitiveYN = (String)setInfo.get("CASE_SENS_YN");
        }
        
        // 데모용인지 확인
        //      if("DEMO".equals(this.isUser()))    {
        //          throw new  UniDirectValidateException(this.getMessage("52103", user));
        //      }
        
        for (Map param : paramList) {
            super.commonDao.update("s_bsa300ukrvServiceImpl_KOCIS.deleteMulti", param);
            //          if(bSecurityFlag) {                 
            //              super.commonDao.update("s_bsa300ukrvServiceImpl_KOCIS.deleteSecurityFlagMulti", param);
            //          }
            
        }
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "bsa" )
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bsa" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        List<Map> dataList = new ArrayList<Map>();
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("insertMulti")) {
                    param.put("data", insertMulti(dataList, user));
                } else if (param.get("method").equals("updateMulti")) {
                    param.put("data", updateMulti(dataList, user));
                } else if (param.get("method").equals("deleteMulti")) {
                    param.put("data", deleteMulti(dataList, user));
                }
            }
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    /**
     * 비밀번호 암호화 체크 및 대소문자 구분 여부
     * 
     * @return
     */
    @SuppressWarnings( { "unchecked" } )
    private Map<String, Object> checkEncryptYN() {
        return (Map<String, Object>)super.commonDao.select("s_bsa300ukrvServiceImpl_KOCIS.checkEncryptYN");
    }
    
    //FIXME 유효사용자어부 체크 - IsUser()   
    private String isUser() {
        /*
         * //MBsa01Kr.bas 에서 정의됨 Public Function IsUser(ByVal gsCert As Variant, _ Optional oDAL As Variant) As Variant On Error GoTo IsUser_ErrorHandler Dim oBSQ As Object, oDGR As Object, rsUserNo As Object Dim sSetupInfo As String, sDeSetupInfo As String, sSql As String Dim sSysMacAddr As String, sRegMacAddr As String, lUserNo As Long Dim oMAC As New CMacAddress Dim lHumanNo As Long, lDivNo As Long, lLicenseKey As String Const csSysSQ = "RUDEHDRUDEHDRUDEHDRUDEHD " sSysMacAddr = oMAC.GetMACAddress Set oMAC = Nothing On Error Resume Next Set oBSQ = CreateObject("uniLITE5SysSq.CB2BPROFILE") If Err.Number <> 0 Then On Error GoTo IsUser_ErrorHandler IsUser = "DEMO" '"사용자 정보 모듈을 생성할 수 없습니다." GoTo IsUser_Exit End If Set oDGR = CreateObject("uniLITE5SysSq.CB2BDECODE") If Err.Number <> 0 Then On Error GoTo IsUser_ErrorHandler IsUser = "DEMO" '"사용자 정보 파싱 모듈을 생성할 수 없습니다." GoTo IsUser_Exit End If On Error GoTo IsUser_ErrorHandler IsUser = oBSQ.ProfileManager("^&*()!@#$%", "GetSetupInfo",
         * sSetupInfo) Set oBSQ = Nothing IsUser = oDGR.DegenerateKey(sSetupInfo, sDeSetupInfo, csSysSQ) Set oDGR = Nothing Select Case Len(sDeSetupInfo) '2008.09.08 모성현 추가, 라이센스에 따른 5.10 & 5.11 / 5.12 구분처리 Case 28 '5.12 sRegMacAddr = "" & Left$(sDeSetupInfo, 12) 'MAC Address 체크 lLicenseKey = Hex2Long(Mid$(sDeSetupInfo, 13, 9)) If Len(lLicenseKey) = 8 And Left$(lLicenseKey, 1) <> 0 Then '유저수가 2자리인 경우 lLicenseKey = "0" & lLicenseKey ElseIf Len(lLicenseKey) = 7 And Left$(lLicenseKey, 1) <> 0 Then '유저수가 1자리인 경우 lLicenseKey = "00" & lLicenseKey End If lHumanNo = Left$(Right$(lLicenseKey, 4) & "00", 2) * 10 '대사우 2자리 lDivNo = Left$(Right$(lLicenseKey, 6) & "00", 2) '사업장수 2자리 lUserNo = Left$(lLicenseKey, 3) '사용자수 3자리 Case 24 '5.10 & 5.11 sRegMacAddr = "" & Left$(sDeSetupInfo, 12) lUserNo = CLng(Left$(Right$(sDeSetupInfo, 12), 3)) '사용자 lDivNo = CLng(Left$(Right$(sDeSetupInfo, 9), 2)) '사업장 lHumanNo = CLng(Left$(Right$(sDeSetupInfo, 7), 2)) * 10 '대사우 Case Else On Error GoTo IsUser_ErrorHandler
         * 'IsExceedUser = "라이센스정보가 일치하지 않습니다." & vbCrLf & " (주)포렌에 문의하십시오." lUserNo = Chr(255) & "54114" End Select sRegMacAddr = "" & Left$(sDeSetupInfo, 12) If sSysMacAddr <> sRegMacAddr Then IsUser = "DEMO" '"시스템 식별자가 일치하지 않습니다." GoTo IsUser_Exit End If If IsMissing(oDAL) Then Set oDAL = CreateObject(csDALID) IsUser = oDAL.Connect(gsCert) End If sSql = "--UBsa01Krv.MBsa01Kr[IsUser] Query01             " sSql = sSql & vbCrLf & "SELECT COUNT(USER_ID) AS USER_CNT" sSql = sSql & vbCrLf & "  FROM BSA300T                   " sSql = sSql & vbCrLf & " WHERE USE_YN = 'Y'              " IsUser = oDAL.GetRecordSet(sSql, rsUserNo) If IsUser <> "" Then GoTo IsUser_ErrorHandler If rsUserNo("USER_CNT") > lUserNo Then IsUser = Chr(255) & "52106" GoTo IsUser_ErrorHandler End If Exit Function IsUser_Exit: If IsMissing(oDAL) Then Set oDAL = CreateObject(csDALID) IsUser = oDAL.Connect(gsCert) End If sSql = "--UBsa01Krv.MBsa01Kr[IsUser] Query02             " sSql = sSql & vbCrLf &
         * "SELECT COUNT(USER_ID) AS USER_CNT" sSql = sSql & vbCrLf & "  FROM BSA300T                   " IsUser = oDAL.GetRecordSet(sSql, rsUserNo) If IsUser <> "" Then GoTo IsUser_ErrorHandler If rsUserNo("USER_CNT") > 1 Then IsUser = "DEMO" '"사용자 수가 초과되었습니다." Else IsUser = "" End If If Not oMAC Is Nothing Then Set oMAC = Nothing If Not oBSQ Is Nothing Then Set oBSQ = Nothing If Not oDGR Is Nothing Then Set oDGR = Nothing Exit Function IsUser_ErrorHandler: If Err.Number <> 0 Then IsUser = "UBsa01Krv.MBsa01Kr[IsUser]" & vbCrLf & Err.Source & vbCrLf & Err.Description Err.Clear Else IsUser = "UBsa01Krv.MBsa01Kr[IsUser]" & vbCrLf & IsUser End If If Not oMAC Is Nothing Then Set oMAC = Nothing If Not oBSQ Is Nothing Then Set oBSQ = Nothing If Not oDGR Is Nothing Then Set oDGR = Nothing End Function
         */
        return "";
    }
    
}
