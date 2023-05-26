package foren.unilite.modules.matrl.mre;

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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("mre100ukrvService")
public class Mre100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
     * 
     * 환율 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> fnExchgRateO(Map param) throws Exception {
        return super.commonDao.list("mre100ukrvServiceImpl.fnExchgRateO", param);
    }

	/**
	 * 
	 * 구매요청등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("mre100ukrvServiceImpl.selectList", param);
	}

	/**
	 * 
	 * 구매요청등록 -> 발주번호 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("mre100ukrvServiceImpl.selectOrderNumMasterList", param);
	}
	
	/**
	 * 
	 * 구매요청등록 -> 자재소요량 참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMrpList(Map param) throws Exception {
		return super.commonDao.list("mre100ukrvServiceImpl.selectMrpList", param);
	}
	
	/**
     * 
     * 구매요청등록 -> 외주P/L 참조
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectOutsidePlList(Map param) throws Exception {
        return super.commonDao.list("mre100ukrvServiceImpl.selectOutsidePlList", param);
    }
    
    /**
     * 
     * 구매요청등록 -> 물품의뢰 참조
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectItemRequestList(Map param) throws Exception {
        return super.commonDao.list("mre100ukrvServiceImpl.selectItemRequestList", param);
    }

	/**
	 * 
	 * 구매요청등록 -> BPR200T에서 품질대상여부(INSPEC_YN) 가져와서 그리드의 품질대상여부(INSPEC_FLAG)에 넣어준다.
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callInspecyn(Map param) throws Exception {	
		
		return  super.commonDao.select("mre100ukrvServiceImpl.callInspecyn", param);
	}
	/**
	 * 
	 *  구매담당 선택시 승인자 가져옴
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userName(Map param) throws Exception {	
		
		return  super.commonDao.select("mre100ukrvServiceImpl.userName", param);
	}

	/**
	 * 
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		
		return  super.commonDao.select("mre100ukrvServiceImpl.userWhcode", param);
	}
/*	*//**
	 * 
	 *  userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  ref1(Map param) throws Exception {	
		
		return  super.commonDao.select("mre100ukrvServiceImpl.ref1", param);
	}*/
	/**
	 * 단가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnOrderPrice(Map param) throws Exception {	

		return  super.commonDao.select("mre100ukrvServiceImpl.fnOrderPrice", param);
	}
	
	/**
     * 현재고 조회
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public Object  fnStockQ(Map param) throws Exception {   

        return  super.commonDao.select("mre100ukrvServiceImpl.fnStockQ", param);
    }
    
	/**
	 * 
	 * 품질검사여부 관련 (부서별)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callDeptInspecFlag(Map param) throws Exception {	
		
		return  super.commonDao.select("mre100ukrvServiceImpl.callDeptInspecFlag", param);
	}
	
	/**
	 * 구매요청등록-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");	
		dataMaster.put("COMP_CODE", user.getCompCode());
		
		String poReqNum = (String) dataMaster.get("PO_REQ_NUM");
		if (ObjUtils.isEmpty(dataMaster.get("PO_REQ_NUM") )) {
			//dataMaster.put("OPR_FLAG", "N");
			Map<String, Object> spParam = new HashMap<String, Object>();
			spParam.put("COMP_CODE", user.getCompCode());			 
			spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
			spParam.put("TABLE_ID","MRE100T");
			spParam.put("PREFIX", "MRE");
			spParam.put("BASIS_DATE", dataMaster.get("PO_REQ_DATE"));
			spParam.put("AUTO_TYPE", "1");

			super.commonDao.queryForObject("mre100ukrvServiceImpl.spAutoNum", spParam);
			dataMaster.put("PO_REQ_NUM", ObjUtils.getSafeString(spParam.get("sAUTO_NUM")));		
			poReqNum = ObjUtils.getSafeString(spParam.get("sAUTO_NUM"));	 
					
			super.commonDao.insert("mre100ukrvServiceImpl.insertMaster", dataMaster);
			
		} else {
			//dataMaster.put("OPR_FLAG", "U");
		}

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
			if(insertList != null) this.insertDetail(insertList, user, poReqNum);
			if(updateList != null) this.updateDetail(updateList, user);				
		}else{
			
			//super.commonDao.insert("mre100ukrvServiceImpl.insertMaster", dataMaster);
		}
		
		//5.마스터 정보 + 발주디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, String poReqNum) throws Exception {		
		try {
			for(Map param : paramList )	{
				param.put("PO_REQ_NUM", poReqNum);
				super.commonDao.update("mre100ukrvServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));//중복되는 자료가 입력 되었습니다.
		}		
		return 0;
	}

	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
             Map mpo200tCnt = (Map) super.commonDao.select("mre100ukrvServiceImpl.selectMPO200T", param); //진행중인지 체크
             if(ObjUtils.parseInt(mpo200tCnt.get("COUNT")) > 0){
                 throw new UniDirectValidateException("진행중인 자료입니다. 확인바랍니다.");
             } else {
                 super.commonDao.delete("mre100ukrvServiceImpl.deleteMaster", param);
                 super.commonDao.delete("mre100ukrvServiceImpl.deleteDetail", param);
             }
		 }
		 return 0;
	}
		
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
		     Map checkCnt = (Map) super.commonDao.select("mre100ukrvServiceImpl.selectCheckCnt", param); //발주 진행건 있는지 체크
             Map mpo200tCnt = (Map) super.commonDao.select("mre100ukrvServiceImpl.selectMPO200T", param); //진행중인지 체크
		     if(ObjUtils.parseInt(checkCnt.get("CNT")) > 0){
		         throw new UniDirectValidateException(this.getMessage("54619", user)+"\n[품목코드:"+ObjUtils.getSafeString(param.get("ITEM_CODE"))+ " 순번:" + ObjUtils.getSafeString(param.get("PO_SER_NO")) + "]");
		     } else if(ObjUtils.parseInt(mpo200tCnt.get("COUNT")) > 0){
		         throw new UniDirectValidateException("진행중인 자료입니다. 확인바랍니다.");
             } else {
                 super.commonDao.update("mre100ukrvServiceImpl.updateDetail", param);
             }
		 }		 
		 return 0;
	} 
}
