package foren.unilite.modules.z_kodi;

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
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_pms410ukrv_kodiService")
public class S_pms410ukrv_kodiServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 *
	 * @param param 조회
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_pms410ukrv_kodiServiceImpl.selectList", param);
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
			

		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
			for(Map paramData: paramList) {			
				
				dataList = (List<Map>) paramData.get("data");
				String oprFlag = "N";
				if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
	
				for(Map param:  dataList) {	
		        
			      //update 실행
			        Map<String, Object> upParam = new HashMap<String, Object>();
			        
			        upParam.put("COMP_CODE", user.getCompCode());
			        upParam.put("DIV_CODE", param.get("DIV_CODE"));
			        upParam.put("INSPEC_NUM", param.get("INSPEC_NUM"));
			        upParam.put("INSPEC_SEQ", param.get("INSPEC_SEQ"));
			        upParam.put("MICROBE_DATE", param.get("MICROBE_DATE"));
			        upParam.put("EXPECTED_END_DATE", param.get("EXPECTED_END_DATE"));
			        upParam.put("USER_ID",	user.getUserID());        

					super.commonDao.update("s_pms410ukrv_kodiServiceImpl.updateQms400t", upParam);        

			}
		}    
  
      paramList.add(0, paramMaster);
      return  paramList;
     }	
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        
        return 0;
    } 	

}
