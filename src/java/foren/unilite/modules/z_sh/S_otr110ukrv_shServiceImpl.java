package foren.unilite.modules.z_sh;

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



@Service("s_otr110ukrv_shService")
public class S_otr110ukrv_shServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주정보 Detail 조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("s_otr110ukrv_shServiceImpl.selectMasterList", param);		/* 조회 */
	}

	/**
	 * 수주정보검색 조회(Master)
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("s_otr110ukrv_shServiceImpl.selectDetailList", param);		/* 검색 */
	}

	/**
	 * 수주정보검색 조회(Detail)
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail2(Map param) throws Exception {
		return super.commonDao.list("s_otr110ukrv_shServiceImpl.selectDetailList2", param);		/* 예약참조 */
	}

	/**
	 * 견적 참조 조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail3(Map param) throws Exception {
		return super.commonDao.list("s_otr110ukrv_shServiceImpl.selectDetailList3", param);		/* 반춤가능 예약참조 */
	}
	/**
	 * 수주정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		  String keyValue = getLogKey();

		  //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		  List<Map> dataList = new ArrayList<Map>();
		  List<List<Map>> resultList = new ArrayList<List<Map>>();

		  for(Map paramData: paramList) {

			  dataList = (List<Map>) paramData.get("data");
			  String oprFlag = "N";
			  if(paramData.get("method").equals("insertDetail")) oprFlag="N";
			  if(paramData.get("method").equals("updateDetail")) oprFlag="U";
			  if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

			  for(Map param: dataList) {
				  param.put("KEY_VALUE", keyValue);
				  param.put("OPR_FLAG", oprFlag);
				  //param.put("INOUT_TYPE_DETAIL", '99');	// 쿼리의 고정값
				  param.put("data", super.commonDao.insert("s_otr110ukrv_shServiceImpl.insertLogMaster", param));
			  }
		  }

		//4.접수등록 Stored Procedure 실행
			Map<String, Object> spParam = new HashMap<String, Object>();

			spParam.put("KEY_VALUE", keyValue);
			spParam.put("LANG_CODE", user.getLanguage());

			super.commonDao.queryForObject("spS_otr110ukrv_sh", spParam);

			String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

			//접수등록 마스터 출하지시 번호 update
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

			if(!ObjUtils.isEmpty(errorDesc)){
				dataMaster.put("INOUT_NUM", "");
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				//마스터에 SET
				dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("INOUT_NUM")));
				//그리드에 SET
				for(Map param: paramList) {
					dataList = (List<Map>)param.get("data");
					if(param.get("method").equals("insertDetail")) {
						List<Map> datas = (List<Map>)param.get("data");
						for(Map data: datas){
							data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("INOUT_NUM")));
						}
					}
				}
			}

		  paramList.add(0, paramMaster);
		  return  paramList;
	 }

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param: paramList){
			super.commonDao.insert("s_otr100ukrv_shServiceImpl.insertDetail", param);
		}
		return paramList;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.update("s_otr100ukrv_shServiceImpl.updateDetail", param);
		}
		return paramList;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.delete("s_otr100ukrv_shServiceImpl.deleteDetail", param);
		}
		return paramList;
	}

	/**
	 * 수주정보검색 조회(Master)
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object selectProductNumInWh(Map param) throws Exception {
		return super.commonDao.select("s_otr110ukrv_shServiceImpl.selectProductNumInWh", param);		/* 검색 */
	}
}
