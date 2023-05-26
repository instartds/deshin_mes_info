package foren.unilite.modules.accnt.atx;

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
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.accnt.atx.Atx425ukrModel;


@Service("atx425ukrService")
public class Atx425ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());




	/**
	 *  감각상각자산 취득내역 합계
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("atx425ukrServiceImpl.selectForm", param);
	}

	/**
	 * 거래처별 감가상각 자산취득명세
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		if(super.commonDao.list("atx425ukrServiceImpl.selectListFirst", param).isEmpty()){
			return super.commonDao.list("atx425ukrServiceImpl.selectListSecond", param);
		}else{
			return super.commonDao.list("atx425ukrServiceImpl.selectListFirst", param);
		}
	}

	/**
	 * 재참조버튼 관련 1
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> dataCheck(Map param) throws Exception {

		return  super.commonDao.list("atx425ukrServiceImpl.selectListFirst", param);
	}
	/**
	 * 재참조버튼 관련 2
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> reReference(Map param) throws Exception {

		return  super.commonDao.list("atx425ukrServiceImpl.selectListSecond", param);
	}

	/**
	 * 합계표 출력물 데이터
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListTo420Print(Map param) throws Exception {
		return  super.commonDao.list("atx425ukrServiceImpl.selectListTo420Print", param);
	}
	
	/**
	 * 명세서 출력물 데이터
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListTo425Print(Map param) throws Exception {
		return  super.commonDao.list("atx425ukrServiceImpl.selectListTo425Print", param);
	}
	
	/**
	 * 명세서 출력물 데이터 (Sub)
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListTo425PrintSub1(Map param) throws Exception {
		return  super.commonDao.list("atx425ukrServiceImpl.selectListTo425PrintSub1", param);
	}

	/**마스터 저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Atx425ukrModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());

		if(param.getSAVE_FLAG_MASTER().equals("N")){
			super.commonDao.delete("atx425ukrServiceImpl.deleteForm", param);
			int chk = (int) super.commonDao.select("atx425ukrServiceImpl.selectDataChk", param);
			if(chk > 0){
				super.commonDao.update("atx425ukrServiceImpl.updateForm", param);
			}else{
				super.commonDao.update("atx425ukrServiceImpl.insertForm", param);
			}
		}else if(param.getSAVE_FLAG_MASTER().equals("U")){
			int chk = (int) super.commonDao.select("atx425ukrServiceImpl.selectDataChk", param);
			if(chk > 0){
				super.commonDao.update("atx425ukrServiceImpl.updateForm", param);
			}else{
				super.commonDao.update("atx425ukrServiceImpl.insertForm", param);
			}

		}else if(param.getSAVE_FLAG_MASTER().equals("D")){
			super.commonDao.update("atx425ukrServiceImpl.deleteForm", param);
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}

	/**디테일 저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
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
			if(deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx425ukrServiceImpl.checkCompCode", compCodeMap);
//			param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
			dataMaster.put("COMP_CODE", user.getCompCode());
			if(dataMaster.get("reRefButtonClick").equals("DandN")){
				super.commonDao.delete("atx425ukrServiceImpl.reReferenceDelete", dataMaster);
			}
			for(Map param : paramList )	{
//				for(Map checkCompCode : chkList) {
					param.put("PUB_DATE_FR", dataMaster.get("PUB_DATE_FR"));
					param.put("PUB_DATE_TO", dataMaster.get("PUB_DATE_TO"));
					param.put("BILL_DIV_CODE", dataMaster.get("BILL_DIV_CODE"));
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx425ukrServiceImpl.insertDetail", param);
//					}
				}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx425ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
//			 for(Map checkCompCode : chkList) {
				 param.put("PUB_DATE_FR", dataMaster.get("PUB_DATE_FR"));
				 param.put("PUB_DATE_TO", dataMaster.get("PUB_DATE_TO"));
				 param.put("BILL_DIV_CODE", dataMaster.get("BILL_DIV_CODE"));
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

					 super.commonDao.insert("atx425ukrServiceImpl.updateDetail", param);
			 }
//		 }
		 return 0;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx425ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
//			 for(Map checkCompCode : chkList) {
				 param.put("PUB_DATE_FR", dataMaster.get("PUB_DATE_FR"));
				 param.put("PUB_DATE_TO", dataMaster.get("PUB_DATE_TO"));
				 param.put("BILL_DIV_CODE", dataMaster.get("BILL_DIV_CODE"));
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

					 try {
						 super.commonDao.delete("atx425ukrServiceImpl.deleteDetail", param);

					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}
				 }
//			 }
		 return 0;
	}



}
