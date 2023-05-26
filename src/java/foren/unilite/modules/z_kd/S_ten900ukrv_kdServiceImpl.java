package foren.unilite.modules.z_kd;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_ten900ukrv_kdService")
public class S_ten900ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 디테일조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("s_ten900ukrv_kdServiceImpl.selectList", param);
	}
	/**
     * 
     * 검색창 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
        return super.commonDao.list("s_ten900ukrv_kdServiceImpl.selectOrderNumMaster", param);
    }
	/**
     * 
     * 품목 수출Local판가, nego가 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
    public Object  getSalePrice(Map param) throws Exception {         
        return  super.commonDao.select("s_ten900ukrv_kdServiceImpl.getSalePrice", param);
    }
    
    /**
	 * 
	 * 수주이력 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefList(Map param) throws Exception {
		return super.commonDao.list("s_ten900ukrv_kdServiceImpl.selectRefList", param);
	}
    
    /**
     * 
     * 기안번호 검색
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("s_ten900ukrv_kdServiceImpl.selectGwData", param);
    }
    
    /**
     *  기안버튼 눌렀을때 번호생성(UPDATE)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 기안버튼 눌렀을때 번호생성(UPDATE) */
    public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
        return super.commonDao.list("s_ten900ukrv_kdServiceImpl.makeDraftNum", param);
    }
    
	/**
	 *  저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		
	    Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
	    String autoNum  = (String) dataMaster.get("REPORT_NO");
	    if (ObjUtils.isEmpty(autoNum)) { //신규등록만 가능..
	        dataMaster.put("COMP_CODE", user.getCompCode());
	        dataMaster.put("TABLE_ID","S_TEN900T_KD");
	        dataMaster.put("PREFIX", "");
	        dataMaster.put("AUTO_TYPE", "1");
	        super.commonDao.select("s_ten900ukrv_kdServiceImpl.spAutoNum", dataMaster);
	        autoNum = (String) dataMaster.get("KEY_NUMBER");
	        dataMaster.put("REPORT_NO", autoNum);
	        super.commonDao.select("s_ten900ukrv_kdServiceImpl.insertMaster", dataMaster);
        }
	    dataMaster.put("REPORT_NO", autoNum);
	    if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, autoNum);
			if(insertList != null) this.insertList(insertList, user, autoNum);
			if(updateList != null) this.updateList(updateList, autoNum);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> insertList(List<Map> paramList, LoginVO user, String autoNum) throws Exception {
		try{
			for(Map param :paramList ) {
			    param.put("REPORT_NO", autoNum);
				super.commonDao.insert("s_ten900ukrv_kdServiceImpl.insertList", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}	
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> updateList(List<Map> paramList, String autoNum) throws Exception {
		for(Map param :paramList ) {
		    param.put("REPORT_NO", autoNum);
			super.commonDao.update("s_ten900ukrv_kdServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> deleteList(List<Map> paramList, String autoNum) throws Exception {
		for(Map param :paramList ) {
		    param.put("REPORT_NO", autoNum);
			super.commonDao.delete("s_ten900ukrv_kdServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
	
}
