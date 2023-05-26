package foren.unilite.modules.sales.str;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("str800ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Str800ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;


	/**
	 * 라벨출력시 사용할 데이터 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPrintList(Map param) throws Exception {
		return super.commonDao.list("str800ukrvServiceImpl.selectPrintList", param);
	}

	/**
	 * BOX포장 조회팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectInNumMasterList(Map param) throws Exception {
		return super.commonDao.list("str800ukrvServiceImpl.selectInNumMaster", param);
	}

	/**
	 * BOX포장 실제 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("str800ukrvServiceImpl.selectDetailList", param);
	}	
	



	/**
	 * LOT_NO만 입력했을 경우, ITEM_CODE 가져오는 로직(BIV150T)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getItemInfo (Map param) throws Exception {
		return super.commonDao.list("str800ukrvServiceImpl.getItemInfo", param);
	}



	/**
	 * BOX포장정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteDetail != null) this.deleteDetail(deleteDetail, dataMaster, user);
			if(insertDetail != null) this.insertDetail(insertDetail, dataMaster, user);
			if(updateDetail != null) this.updateDetail(updateDetail, dataMaster, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	//INSERT
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	 
		try {
			Map<String, Object> spParam	= new HashMap<String, Object>();

			spParam.put("S_COMP_CODE"	, user.getCompCode());
			spParam.put("DIV_CODE"		, paramMaster.get("DIV_CODE"));
			spParam.put("TABLE_ID"		, "STR800T");
			spParam.put("PREFIX"		, "X");
			spParam.put("BASIS_DATE"	, paramMaster.get("PACK_DATE"));
			spParam.put("AUTO_TYPE"		, "1");

			Map<String, Object> autoNumMap = (Map<String, Object>)super.commonDao.select("str800ukrvServiceImpl.makeAutoNum", spParam);

			for(Map param : paramList ) {
				if(ObjUtils.isEmpty(param.get("BOX_BARCODE")) && autoNumMap != null){
					param.put("BOX_BARCODE", autoNumMap.get("AUTO_NUM"));
				}
				super.commonDao.insert("str800ukrvServiceImpl.insertDetail", param);
				
				paramMaster.put("BOX_BARCODE", param.get("BOX_BARCODE"));
			}
			
		} catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}
	
	//UPDATE
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		 // UPDATE
	public Integer updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("str800ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	}
	
	//DELETE
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		 // DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{
			try {
				super.commonDao.delete("str800ukrvServiceImpl.deleteDetail", param);
				 
			}catch(Exception e)	{
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		}
		return 0;
	}
}
