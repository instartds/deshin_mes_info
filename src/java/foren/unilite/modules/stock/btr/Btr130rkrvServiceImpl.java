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

@Service("btr130rkrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Btr130rkrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {
		return super.commonDao.select("btr130rkrvServiceImpl.userWhcode", param);
	}

	/**
	 * 출고 데이터 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("btr130rkrvServiceImpl.selectList", param);
	}




	/**
	 * 출력 master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("btr130rkrvServiceImpl.selectMasterList", param);
	}

	/**
	 * 출력 detail data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("btr130rkrvServiceImpl.selectDetailList", param);
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
		if(ObjUtils.isNotEmpty(param.get("inoutInfo"))) {
			String[] inoutInfoArry	= param.get("inoutInfo").toString().split(",");
			List<Map> inoutInfoList	= new ArrayList<Map>();
	
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				map.put("INOUT_INFO", inoutInfoArry[i]);
				inoutInfoList.add(map);
			}
			param.put("INOUT_INFO_LIST", inoutInfoList);
		}
		super.commonDao.update("btr130rkrvServiceImpl.updatePrintStatus", param);
		return 0;
	}
}