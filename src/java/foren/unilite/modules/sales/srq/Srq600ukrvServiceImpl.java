package foren.unilite.modules.sales.srq;

import java.util.ArrayList;
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

@Service("srq600ukrvService")
public class Srq600ukrvServiceImpl extends TlabAbstractServiceImpl {
	public final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 패킹출고내역 조회
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("srq600ukrvServiceImpl.selectList1", param);
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
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			Map<String, Object> masterParam = (Map<String, Object>) paramMaster.get("data");
			List<Map> dataList = new ArrayList<Map>();
			
			String keyValue = getLogKey();
			
			//	로그테이블에 데이터 입력
			for(Map paramData: paramList) {
				dataList = (List<Map>) paramData.get("data");
				
//				String oprFlag = "N";
//				if(paramData.get("method").equals("insertLot"))	oprFlag="N";
//				if(paramData.get("method").equals("updateLot"))	oprFlag="U";
//				if(paramData.get("method").equals("deleteLot"))	oprFlag="D";
				
				for(Map param : dataList) {
					if(ObjUtils.isEmpty(param.get("ISSUE_DATE"))) {
						param.put("ISSUE_DATE", masterParam.get("ISSUE_DATE"));
					}
					if(ObjUtils.isEmpty(param.get("ISSUE_PRSN"))) {
						param.put("ISSUE_PRSN", masterParam.get("ISSUE_PRSN"));
					}
					
					super.commonDao.insert("srq600ukrvServiceImpl.insert", param);
				}
			}
			
			masterParam.put("KEY_VALUE", keyValue);
			
			super.commonDao.insert("srq600ukrvServiceImpl.insertLogTransaction", masterParam);
			super.commonDao.insert("srq600ukrvServiceImpl.spUSP_SALES_Str103ukr", masterParam);
			
			super.commonDao.queryForObject("srq600ukrvServiceImpl.updateMaster", masterParam);
			
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
	public Integer update(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
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
		return super.commonDao.list("srq600ukrvServiceImpl.checkBarcode", param);
	}
	
	/**
	 * 출하지시 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRequestList(Map param) throws Exception {
		return super.commonDao.list("srq600ukrvServiceImpl.selectRequestList", param);
	}
	
}
