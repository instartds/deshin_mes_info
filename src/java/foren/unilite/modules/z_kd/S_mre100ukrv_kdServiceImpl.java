package foren.unilite.modules.z_kd;

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

@Service("s_mre100ukrv_kdService")
public class S_mre100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     *
     * 마스터 기안상태 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("S_mre100ukrv_kdServiceImpl.selectGwData", param);
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
        return super.commonDao.list("S_mre100ukrv_kdServiceImpl.makeDraftNum", param);
    }

	/**
     *
     * 환율 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> fnExchgRateO(Map param) throws Exception {
        return super.commonDao.list("S_mre100ukrv_kdServiceImpl.fnExchgRateO", param);
    }

	/**
	 *
	 * 품목의뢰등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("S_mre100ukrv_kdServiceImpl.selectList", param);
	}

	/**
     *
     * 품목의뢰번호 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectItemReqNumList(Map param) throws Exception {
        return super.commonDao.list("S_mre100ukrv_kdServiceImpl.selectItemReqNumList", param);
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

		return  super.commonDao.select("S_mre100ukrv_kdServiceImpl.userName", param);
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

		return  super.commonDao.select("S_mre100ukrv_kdServiceImpl.userWhcode", param);
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

		return  super.commonDao.select("S_mre100ukrv_kdServiceImpl.ref1", param);
	}*/

	/**
	 *
	 * 품질검사여부 관련 (부서별)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callDeptInspecFlag(Map param) throws Exception {

		return  super.commonDao.select("S_mre100ukrv_kdServiceImpl.callDeptInspecFlag", param);
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

		String itemReqNum = (String) dataMaster.get("ITEM_REQ_NUM");
		if (ObjUtils.isEmpty(dataMaster.get("ITEM_REQ_NUM") )) {
			//dataMaster.put("OPR_FLAG", "N");
			Map<String, Object> spParam = new HashMap<String, Object>();
			spParam.put("COMP_CODE", user.getCompCode());
			spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
			spParam.put("TABLE_ID","MRE010T");
			spParam.put("PREFIX", "MRE");
			spParam.put("BASIS_DATE", dataMaster.get("ITEM_REQ_DATE"));
			spParam.put("AUTO_TYPE", "1");

			super.commonDao.queryForObject("S_mre100ukrv_kdServiceImpl.spAutoNum", spParam);
			dataMaster.put("ITEM_REQ_NUM", ObjUtils.getSafeString(spParam.get("sAUTO_NUM")));
			itemReqNum = ObjUtils.getSafeString(spParam.get("sAUTO_NUM"));

			super.commonDao.insert("S_mre100ukrv_kdServiceImpl.insertMaster", dataMaster);

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
			if(insertList != null) this.insertDetail(insertList, user, itemReqNum);
			if(updateList != null) this.updateDetail(updateList, user, dataMaster);
		}else{

			//super.commonDao.insert("S_mre100ukrv_kdServiceImpl.insertMaster", dataMaster);
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
	public Integer  insertDetail(List<Map> paramList, LoginVO user, String itemReqNum) throws Exception {
		try {
			for(Map param : paramList )	{
				if(ObjUtils.isEmpty(param.get("ITEM_REQ_NUM"))) {
	                param.put("ITEM_REQ_NUM", itemReqNum);
//				    super.commonDao.insert("S_mre100ukrv_kdServiceImpl.insertMaster", param);
	                super.commonDao.update("S_mre100ukrv_kdServiceImpl.insertDetail", param);
				} else {
				    super.commonDao.update("S_mre100ukrv_kdServiceImpl.insertDetail", param);
				}
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
		int cnt = 0 ;
		for(Map param :paramList )	{
			 try {

				 super.commonDao.delete("S_mre100ukrv_kdServiceImpl.deleteDetail", param);
				 cnt = (int) super.commonDao.select("S_mre100ukrv_kdServiceImpl.deleteChk", param);
				 if(cnt == 0){
					 super.commonDao.delete("S_mre100ukrv_kdServiceImpl.deleteMaster", param);
				 }

			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("55523",user));//삭제할 수 없습니다.
			 }
		 }
		 return cnt;
	}


	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map<String, Object> mapData) throws Exception {
		int i = 0 ;
		logger.debug("[mapData]" + mapData);
		 for(Map param :paramList )	{
			if(i == 0 &&  param.get("SAVE_FLAG").equals("Y")){
				param.put("REMARK", mapData.get("REMARK"));
				param.put("SUPPLY_TYPE", mapData.get("SUPPLY_TYPE"));
				param.put("P_REQ_TYPE", mapData.get("P_REQ_TYPE"));
				param.put("DEPT_CODE", mapData.get("DEPT_CODE"));
				param.put("PERSON_NUMB", mapData.get("PERSON_NUMB"));
				param.put("MONEY_UNIT", mapData.get("MONEY_UNIT1"));
				param.put("EXCHG_RATE_O", mapData.get("EXCHG_RATE_O1"));
				super.commonDao.update("S_mre100ukrv_kdServiceImpl.updateMaster", param);
			}
			 super.commonDao.update("S_mre100ukrv_kdServiceImpl.updateDetail", param);
		 }
		 return 0;
	}
}
