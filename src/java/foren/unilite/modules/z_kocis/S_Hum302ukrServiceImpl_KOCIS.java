package foren.unilite.modules.z_kocis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_hum302ukrService_KOCIS")
public class S_Hum302ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_hum302ukrServiceImpl_KOCIS.select", param);
	}
	
	/**
	 * H096 상벌종류 코드로 포상/징계 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> fnRptGubunCheck(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_hum302ukrServiceImpl_KOCIS.fnRptGubunCheck", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
        String retireYN   = "";
        String msgAlert   = "";
        String msgAlertYN = "";
        
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("s_hum302ukrServiceImpl_KOCIS.checkCompCode", compCodeMap);
            
			for(Map param : paramList )  {
                //인사기본자료등록의 퇴사일로 퇴사여부 확인 후 퇴사자인 경우, 등록되지 않게 메시지 호출
                retireYN = (String) super.commonDao.select("s_hum302ukrServiceImpl_KOCIS.retireYN", param);
                
                param.put("EXIST_YN", retireYN);
                
                if(retireYN.equals("Y")){
                    msgAlertYN = "Y";
                    msgAlert = "퇴사자인 경우 등록할 수 없습니다."+ "\n직원: " + param.get("NAME");
                    throw new  UniDirectValidateException("퇴사자인 경우 등록할 수 없습니다."+ "\n직원: " + param.get("NAME"));
                }
            }
            
            for(Map param : paramList ) {                
                    
                for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     super.commonDao.update("s_hum302ukrServiceImpl_KOCIS.insertDetail", param);
                }
            }
		}catch(Exception e){
            if(msgAlertYN == "Y"){
                throw new  UniDirectValidateException(msgAlert);
            }
            else{
                throw new  UniDirectValidateException(this.getMessage("2627", user));
            }
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("s_hum302ukrServiceImpl_KOCIS.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("s_hum302ukrServiceImpl_KOCIS.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("s_hum302ukrServiceImpl_KOCIS.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("s_hum302ukrServiceImpl_KOCIS.deleteDetail", param);
			 }
		 }
		 return 0;
	}
}
