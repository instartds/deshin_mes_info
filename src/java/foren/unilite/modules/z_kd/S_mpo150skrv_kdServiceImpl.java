package foren.unilite.modules.z_kd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.email.EmailSendServiceImpl;

@Service("s_mpo150skrv_kdService")
public class S_mpo150skrv_kdServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    
    
    @Resource( name = "emailSendService" )
    private EmailSendServiceImpl emailSendService;
    
    /**
     * 
     * 화면 초기화용 메일 주소, 사용자명, 메일 pasword 가져오기
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
    public Map<String, Object>  getUserMailInfo(Map param) throws Exception { 
        return  (Map<String, Object>) super.commonDao.select("s_mpo150skrv_kdServiceImpl.getUserMailInfo", param); 
    }    
    
	/**
	 * 발주서메일전송
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_mpo150skrv_kdServiceImpl.selectList", param);
	}
	
	/**
     * 발주서메일전송
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {
        return  super.commonDao.list("s_mpo150skrv_kdServiceImpl.selectList2", param);
    }
    
    /**
     * 발주서메일전송_양평공사
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
    public List<Map<String, Object>>  selectList_yp(Map param) throws Exception {
        return  super.commonDao.list("s_mpo150skrv_kdServiceImpl.selectList_yp", param);
    }
   /* 
    *//**
     * 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     *//*
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        if(paramList != null)   {
            List<Map> deleteList = null;
            List<Map> insertList = null;
            List<Map> updateList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//            if(insertList != null) this.insertList(insertList, dataMaster, user);
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }*/
    
    /**
     * 메일 발송
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
    public Map sendMail(Map param, LoginVO user) throws Exception {
        String to = ObjUtils.getSafeString(param.get("CUST_MAIL_ID"));
        String from = ObjUtils.getSafeString(param.get("FROM_EMAIL"));
        
        //실제 메일발송  
        Map contentsMap = new HashMap();
        contentsMap.put("SUBJECT", param.get("SUBJECT"));
        contentsMap.put("TO", param.get("CUST_MAIL_ID"));
        contentsMap.put("FROM", param.get("FROM_EMAIL"));
        contentsMap.put("TEXT", param.get("CONTENTS"));
        contentsMap.put("CC", param.get("CC"));
        contentsMap.put("BCC", param.get("BCC"));
        contentsMap.put("COMP_CODE",user.getCompCode());
        emailSendService.sendMail(contentsMap);
        
        String rtnVal = "1";
        
        param.put("STATUS", rtnVal);
        param.put("S_COMP_CODE", user.getCompCode()); 
        
        if(rtnVal.equals("1")){ //전송 성공시 전송상태값 업데이트
            super.commonDao.update("s_mpo150skrv_kdServiceImpl.updateMailYn", param);
        }
        return param;
    }
    
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteList(List<Map> params, LoginVO user) throws Exception {
    
    }
}
	