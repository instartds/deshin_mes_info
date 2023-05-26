package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_out300ukrv_mitService") 
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_out300ukrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return   super.commonDao.list("s_out300ukrv_mitServiceImpl.selectList", param);
	}
	
	
	/**
	 *  저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		Map checkCloseMap = (Map) super.commonDao.select("s_out300ukrv_mitServiceImpl.checkClose", dataMaster);
		if(checkCloseMap != null && "Y".equals(ObjUtils.getSafeString(checkCloseMap.get("CLOSE_YN"))))	{
			throw new  UniDirectValidateException("마감 되어 수정할 수 없습니다.");
		}
		
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**
	 * 수정
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			param.put("FLAG", "");
			super.commonDao.update("s_out300ukrv_mitServiceImpl.updateList", param);
		}
		return paramList;
	}

	/**
	 * 삭제
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("s_out300ukrv_mitServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
	/**
	 * 마감
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "z_mit")
	public Map updatClose(Map paramMaster) throws Exception {
		super.commonDao.update("s_out300ukrv_mitServiceImpl.updateClose", paramMaster);
		return paramMaster;
	}
	
	/**
	 * 명세서출력 - 작업내역 테이블 컬럼 레이블
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
//	public Map<String, Object> selectReportLabel(Map param) throws Exception {
//		return (Map<String, Object>)	super.commonDao.select("s_out300ukrv_mitServiceImpl.selectReportLabel", param);
//	}
	public List<Map<String, Object>> selectReportLabel(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectReportLabel", param);
	}
	
	/**
	 * 명세서출력 - 작업내역
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map<String, Object>> selectReportByItemCode(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectReportByItemCode", param);
	}

	/**
	 * 명세서출력 - 당월부적합
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
//	public Map<String, Object> selectReportBadWorkQ(Map param) throws Exception {
//		return (Map<String, Object>)	super.commonDao.select("s_out300ukrv_mitServiceImpl.selectReportBadWorkQ", param);
//	}
	public List<Map<String, Object>> selectReportBadWorkQ(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectReportBadWorkQ", param);
	}
    
	/**
	 * 명세서출력 - 수당내역
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
//	public Map<String, Object> selectReportAllowance(Map param) throws Exception {
//		return (Map<String, Object>)	super.commonDao.select("s_out300ukrv_mitServiceImpl.selectReportAllowance", param);
//	}
	public List<Map<String, Object>> selectReportAllowance(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectReportAllowance", param);
	}
	/**
	 * 명세서출력 - 소급적용내역
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map<String, Object>> selectReportRetroAmt(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectReportRetroAmt", param);
	}
    /**
     * 명세서출력 - 비용 
     * @param param
     * @param user
     * @param paramMaster
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
//	public Map<String, Object> selectReportSummary(Map param) throws Exception {
//		return (Map<String, Object>)	super.commonDao.select("s_out300ukrv_mitServiceImpl.selectReportSummary", param);
//	}
	public List<Map<String, Object>> selectReportSummary(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectReportSummary", param);
	}
    

	/**
	 * 명세서 - 마스터
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map<String, Object>> selectPrintMaster(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectPrintMaster", param);
	}

	/**
	 * 명세서 - 디테일
	 * @param param
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map<String, Object>> selectPrintDetail(Map param) throws Exception {
		return super.commonDao.list("s_out300ukrv_mitServiceImpl.selectPrintDetail", param);
	}
}
