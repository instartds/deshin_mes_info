package foren.unilite.modules.z_in;

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



@Service("s_pmp110ukrv_inService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_pmp110ukrv_inServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 작업지시내역
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_pmp110ukrv_inServiceImpl.mainReport", param);
	}

	/**
	 * 자재내역
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("s_pmp110ukrv_inServiceImpl.subReport", param);
	}


	/**
	 *
	 * 생산정보 Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> selectMasterForm(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_inServiceImpl.selectMasterForm", param);
	}

	/**
	 *
	 * 생산정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_inServiceImpl.selectDetailList", param);
	}

	/**
	 *
	 * 작업지시 조회 (팝업창)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWorkNum(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_inServiceImpl.selectWorkNum", param);
	}

	/**
	 *
	 * 생산계획참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_inServiceImpl.selectEstiList", param);
	}

	/**
	 *
	 * 공정정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectProgInfo(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_inServiceImpl.selectProgInfo", param);
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
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
	      logger.debug("[saveAll] paramDetail:" + paramList);

	      //1.로그테이블에서 사용할 KeyValue 생성
	      String keyValue = getLogKey();
	      Map<String, Object> masterParam = new HashMap<String, Object>();
	      masterParam = (Map<String, Object>) paramMaster.get("data");
	      //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
	      List<Map> dataList = new ArrayList<Map>();
	      List<List<Map>> resultList = new ArrayList<List<Map>>();

	      for(Map paramData: paramList) {

	          dataList = (List<Map>) paramData.get("data");
	          String oprFlag = "N";
	          if(paramData.get("method").equals("insertDetail")) oprFlag="N";
	          if(paramData.get("method").equals("updateDetail")) oprFlag="U";
	          if(paramData.get("method").equals("deleteDetail")) oprFlag="D";
	          for(Map param:  dataList) {
	            param.put("KEY_VALUE", keyValue);
	            param.put("OPR_FLAG", oprFlag);
	            param.put("LOT_NO", masterParam.get("LOT_NO") );
	            param.put("PRODT_WKORD_DATE", masterParam.get("PRODT_WKORD_DATE") );
	            param.put("PRODT_START_DATE", masterParam.get("PRODT_START_DATE") );
	            param.put("PRODT_DATE", masterParam.get("PRODT_DATE") );
	            param.put("PRODT_END_DATE", masterParam.get("PRODT_END_DATE") );
	            param.put("EXPIRATION_DATE", masterParam.get("EXPIRATION_DATE") );
	            param.put("GAMMA", masterParam.get("GAMMA") );
	            logger.debug("[[masterParam]]" + masterParam);
	            param.put("data", super.commonDao.insert("s_pmp110ukrv_inServiceImpl.insertLogMaster", param));
	          }
	      }
	    //4.매출저장 Stored Procedure 실행
	            Map<String, Object> spParam = new HashMap<String, Object>();

	            spParam.put("KeyValue", keyValue);
	            spParam.put("LangCode", user.getLanguage());

	            super.commonDao.queryForObject("s_pmp110ukrv_inServiceImpl.USP_PRODT_Pmp100ukr", spParam);
	            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

	            //출하지시 마스터 출하지시 번호 update
	            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

	            if(!ObjUtils.isEmpty(errorDesc)){
	                dataMaster.put("WKORD_NUM", "");
	                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
	            } else {
	            	dataMaster.put("WKORD_NUM", ObjUtils.getSafeString(spParam.get("WKORD_NUM")));
                    dataMaster.put("LOT_NO", ObjUtils.getSafeString(spParam.get("LOT_NO")));
	            }

	            super.commonDao.queryForObject("s_pmp110ukrv_inServiceImpl.USP_PRODT_Pmp100ukr_PACK", spParam);
	            errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
	            if(!ObjUtils.isEmpty(errorDesc)){
	                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
	            }
	      paramList.add(0, paramMaster);
	      return  paramList;
	     }

	@ExtDirectMethod(group = "prodt")
	public Integer closeWok(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_pmp110ukrv_inServiceImpl.close", param);
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 return 0;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 return 0;
	}
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public int selectExpirationdate(Map param) throws Exception {
		return (int)super.commonDao.select("s_pmp110ukrv_inServiceImpl.selectExpirationdate", param);
	}




	/**
	 * BPR100T.REMARK3 가져오는 로직: 20200507 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt")
	public Integer fnGetRemark3(Map param, LoginVO user) throws Exception {
		int i = (int) super.commonDao.select("s_pmp110ukrv_inServiceImpl.fnGetRemark3", param); 
		return i;
	}
}
