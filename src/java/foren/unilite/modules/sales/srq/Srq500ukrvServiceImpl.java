package foren.unilite.modules.sales.srq;

import java.util.ArrayList;
import java.util.HashMap;
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

@Service("srq500ukrvService")
public class Srq500ukrvServiceImpl extends TlabAbstractServiceImpl {
	public final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 패킹등록
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListDetail(Map param) throws Exception {
		return super.commonDao.list("srq500ukrvServiceImpl.selectListDetail", param);
	}

//	/**
//	 * 패킹정보 저장
//	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
//	 * @param paramMaster 폼(마스터 정보)의 기본 정보
//	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
//	public List<Map> saveAllDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
//		if(paramList != null)	{
//			List<Map> insertList = null;
//			List<Map> updateList = null;
//			List<Map> deleteList = null;
//			
//			for(Map dataListMap: paramList) {
//				if(dataListMap.get("method").equals("insertDetail")) {
//					insertList = (List<Map>)dataListMap.get("data");
//				}
//				else if(dataListMap.get("method").equals("updateDetail")) {
//					updateList = (List<Map>)dataListMap.get("data");
//				}
//				else if(dataListMap.get("method").equals("deleteDetail")) {
//					deleteList = (List<Map>)dataListMap.get("data");
//				}
//			}
//			if(deleteList != null) this.deleteDetail(deleteList, user);
//			if(insertList != null) this.insertDetail(insertList, user);
//			if(updateList != null) this.updateDetail(updateList, user);
//		}
//		paramList.add(0, paramMaster);
//		
//		return  paramList;
//	}
//
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
//	public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList )	{
//			super.commonDao.update("srq500ukrvServiceImpl.insertDetail", param);
//		}
//		return 0;
//	}
//
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
//	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList )	{
//			super.commonDao.update("srq500ukrvServiceImpl.updateDetail", param);
//		}
//		return 0;
//	}
//
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
//	public Integer deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList )	{
//			super.commonDao.update("srq500ukrvServiceImpl.deleteDetail", param);
//		}
//		return 0;
//	}

	/**
	 * 패킹출고등록
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListLot(Map param) throws Exception {
		return super.commonDao.list("srq500ukrvServiceImpl.selectListLot", param);
	}

	/**
	 * 패킹출고 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllLot(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			Map<String, Object> masterParam = (Map<String, Object>) paramMaster.get("data");
			List<Map> dataList = new ArrayList<Map>();
			
			//	로그테이블에 데이터 입력
			for(Map paramData: paramList) {
				dataList = (List<Map>) paramData.get("data");
				String oprFlag = "N";
				if(paramData.get("method").equals("insertLot"))	oprFlag="N";
				if(paramData.get("method").equals("updateLot"))	oprFlag="U";
				if(paramData.get("method").equals("deleteLot"))	oprFlag="D";
				
				for(Map param:  dataList) {
					param.put("OPR_FLAG", oprFlag);
					param.put("PACK_USER", masterParam.get("PACK_USER"));
					param.put("PACK_DATE", masterParam.get("PACK_DATE"));
					
					param.put("data", super.commonDao.insert("srq500ukrvServiceImpl.insertLogDetail", param));
				}
			}
			
//			//	데이터 이관할 프로시져 실행
//			Map<String, Object> spParam = new HashMap<String, Object>();
//			
//			spParam.put("COMP_CODE"	, keyValue);
//			spParam.put("DIV_CODE"	, user.getLanguage());
//			spParam.put("PACK_NO"	, user.getLanguage());
//			spParam.put("USER_ID"	, dataMaster.get("INSPEC_NUM"));
			
			super.commonDao.queryForObject("srq500ukrvServiceImpl.spUSP_PDA_Srq510ukrv", masterParam);
			
			String errorDesc = ObjUtils.getSafeString(masterParam.get("ERROR_DESC"));
			
			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertLogDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("srq500ukrvServiceImpl.insertLogDetail", param);
		}
		return 0;
	}

//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
//	public Integer insertSrq500t(Map param, LoginVO user) throws Exception {
//		int cntMaster = (Integer)super.commonDao.select("srq500ukrvServiceImpl.checkSrq500t", param);
//		if(cntMaster < 1) {
//			super.commonDao.update("srq500ukrvServiceImpl.insertSrq500t", param);
//		}
//		return 0;
//	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertLot(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("srq500ukrvServiceImpl.insertLot", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateLot(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("srq500ukrvServiceImpl.updateLot", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteLot(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("srq500ukrvServiceImpl.deleteLot", param);
		}
		return 0;
	}
	

	/**
	 * 바코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkBarcode(Map param) throws Exception {
		return super.commonDao.list("srq500ukrvServiceImpl.checkBarcode", param);
	}
	
	
	/**
	 * 출하지시 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRequestList(Map param) throws Exception {
		return super.commonDao.list("srq500ukrvServiceImpl.selectRequestList", param);
	}
	
}
