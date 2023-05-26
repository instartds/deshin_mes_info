package foren.unilite.modules.stock.biv;

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


@Service("biv122ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv122ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/** 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		if(param.get("COUNT_DATE") != null ) param.put("COUNT_DATE", ObjUtils.getSafeString( param.get("COUNT_DATE")).replaceAll("\\.", "")); 
		return super.commonDao.list("biv122ukrvServiceImpl.selectMasterList", param);
	}
	
	/** 바코드 입력 시, 해당 데이터 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnStockCounting (Map param) throws Exception {
		if(param.get("COUNT_DATE") != null ) param.put("COUNT_DATE", ObjUtils.getSafeString( param.get("COUNT_DATE")).replaceAll("\\.", "")); 
		return super.commonDao.list("biv122ukrvServiceImpl.fnStockCounting", param);
	}





	/**
	 * 실사등록정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramMaster:" + paramMaster);
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey(); 

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {   
			dataList = (List<Map>) paramData.get("data");
		
			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("data", super.commonDao.insert("biv122ukrvServiceImpl.insertLogMaster", param));
			}
			//4.매출저장 Stored Procedure 실행
			Map<String, Object> spParam = new HashMap<String, Object>();
	
			spParam.put("KeyValue", keyValue);
			spParam.put("LangCode", user.getLanguage());
	
			super.commonDao.queryForObject("biv122ukrvServiceImpl.spReceiving", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			
			//출하지시 마스터 출하지시 번호 update
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
	
			if(!ObjUtils.isEmpty(errorDesc)){
				dataMaster.put("COUNT_DATE", "");
				String[] messsage = errorDesc.split(";");
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				dataMaster.put("COUNT_DATE", ObjUtils.getSafeString(spParam.get("CountDate")));
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	 }
	
	/**
	 * 재고실사정보 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {

		return params;
	}
	
	/**
	 * 재고실사정보 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {

		return params;
	}
	
	/**
	 * 재고실사정보 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
	}
}
