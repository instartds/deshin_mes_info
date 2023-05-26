package foren.unilite.modules.prodt.pmp;

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



@Service("pmp120ukrvService")
public class Pmp120ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());




	/**
	 *
	 * 생산정보 Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> selectMasterForm(Map param) throws Exception {
		return super.commonDao.list("pmp120ukrvServiceImpl.selectMasterForm", param);
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
		return super.commonDao.list("pmp120ukrvServiceImpl.selectDetailList", param);
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
		return super.commonDao.list("pmp120ukrvServiceImpl.selectWorkNum", param);
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
		return super.commonDao.list("pmp120ukrvServiceImpl.selectEstiList", param);
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
		return super.commonDao.list("pmp120ukrvServiceImpl.selectProgInfo", param);
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
	      logger.debug("[saveAll] paramMaster:" + paramMaster);

	      //1.로그테이블에서 사용할 KeyValue 생성
	      String keyValue = getLogKey();

	      //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
	      List<Map> dataList = new ArrayList<Map>();
	      List<List<Map>> resultList = new ArrayList<List<Map>>();
	      Map<String, Object> masterData = (Map<String, Object>) paramMaster.get("data");

	      for(Map paramData: paramList) {

	          dataList = (List<Map>) paramData.get("data");
	          String oprFlag = "N";
	          if(paramData.get("method").equals("insertDetail")) oprFlag="N";
	          if(paramData.get("method").equals("updateDetail")) oprFlag="U";
	          if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

	          for(Map param:  dataList) {
	            param.put("KEY_VALUE", keyValue);
	            param.put("OPR_FLAG", oprFlag);
	            param.put("BOX_TYPE", masterData.get("BOX_TYPE"));
	            param.put("BOX_WKORD_Q", masterData.get("BOX_WKORD_Q"));
	            param.put("data", super.commonDao.insert("pmp120ukrvServiceImpl.insertLogMaster", param));

	          }
	      }

	    //4.매출저장 Stored Procedure 실행
	            Map<String, Object> spParam = new HashMap<String, Object>();

	            spParam.put("KeyValue", keyValue);
	            spParam.put("LangCode", user.getLanguage());
	            spParam.put("COMP_CODE", masterData.get("S_COMP_CODE"));
	            spParam.put("DIV_CODE", masterData.get("S_DIV_CODE"));
	            spParam.put("ORDER_NUM", masterData.get("ORDER_NUM"));
	            spParam.put("SER_NO", masterData.get("SER_NO"));
	           // spParam.put("LOT_NO", masterData.get("LOT_NO"));
	            if(! ObjUtils.isEmpty(masterData.get("SER_NO")) && ! ObjUtils.isEmpty( masterData.get("ORDER_NUM"))){
	            	 super.commonDao.update("pmp120ukrvServiceImpl.updateS_sof120t_in", spParam);
	            }
	            super.commonDao.queryForObject("pmp120ukrvServiceImpl.USP_PRODT_Pmp100ukr", spParam);
	            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

	            //출하지시 마스터 출하지시 번호 update
	            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

	            if(!ObjUtils.isEmpty(errorDesc)){
	                dataMaster.put("WKORD_NUM", "");
	                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
	            } else {
	              if(ObjUtils.isEmpty(dataMaster.get("WKORD_NUM"))){
	            	dataMaster.put("WKORD_NUM", ObjUtils.getSafeString(spParam.get("WKORD_NUM")));
	              }
                    dataMaster.put("LOT_NO", ObjUtils.getSafeString(spParam.get("LOT_NO")));
	            }

	      paramList.add(0, paramMaster);
	      return  paramList;
	     }

	@ExtDirectMethod(group = "prodt")
	public Integer closeWok(Map param, LoginVO user) throws Exception {
		super.commonDao.update("pmp120ukrvServiceImpl.close", param);
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

	/**
	 *
	 * SEMI_ITEM_CODE 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> selectSemiItem(Map param) throws Exception {
		return super.commonDao.list("pmp120ukrvServiceImpl.selectSemiItem", param);
	}

}
