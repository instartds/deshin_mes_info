package foren.unilite.modules.stock.btr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("btr160rkrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Btr160rkrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {
		return super.commonDao.select("btr160rkrvServiceImpl.userWhcode", param);
	}

	/**
	 * 출고요청 데이터 / 출력 데이터 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("btr160rkrvServiceImpl.selectList", param);
	}

	/**
	 * 출력 master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("btr160rkrvServiceImpl.selectMasterList", param);
	}

	/**
	 * 출력한 데이터 출력여부 UPDATE 로직 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public int updatePrintStatus(Map param, LoginVO user) throws Exception {
		//20210128 수정: 재고이동요청 등록 (btr101ukrv)에서 출력 기능 같이 사용하기 위해 로직 수정
		if(ObjUtils.isNotEmpty(param.get("reqInfo"))) {
			String[] reqOrderInfoArry	= param.get("reqInfo").toString().split(",");
			List<Map> reqOrderInfoList	= new ArrayList<Map>();
	
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				map.put("REQ_ORDER_INFO", reqOrderInfoArry[i]);
				reqOrderInfoList.add(map);
			}
			param.put("REQ_ORDER_LIST", reqOrderInfoList);
		}
		super.commonDao.update("btr160rkrvServiceImpl.updatePrintStatus", param);
		return 0;
	}
}