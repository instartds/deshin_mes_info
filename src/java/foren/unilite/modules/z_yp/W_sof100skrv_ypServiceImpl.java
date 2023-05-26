package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("w_sof100skrv_ypService")
public class W_sof100skrv_ypServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		

		
/*		if(param.get("TXT_FR_ORDER_QTY")!=null) {				
			param.put("TXT_FR_ORDER_QTY", ObjUtils.parseInt(param.get("TXT_FR_ORDER_QTY"), 0) );
		}
		if(param.get("TXT_TO_ORDER_QTY")!=null) {				
			param.put("TXT_TO_ORDER_QTY", ObjUtils.parseInt(param.get("TXT_TO_ORDER_QTY"), 0) );
		}*/
		return  super.commonDao.list("w_sof100skrv_ypServiceImpl.selectList1", param);
	}
	
	private int parseInt(String text) {
		// TODO Auto-generated method stub
		return 0;
	}

	/**
	 * 수주현황- 고객별별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		
/*		if(param.get("TXT_FR_ORDER_QTY")!=null) {				
			param.put("TXT_FR_ORDER_QTY", ObjUtils.parseInt(param.get("TXT_FR_ORDER_QTY"), 0) );
		}
		if(param.get("TXT_TO_ORDER_QTY")!=null) {				
			param.put("TXT_TO_ORDER_QTY", ObjUtils.parseInt(param.get("TXT_TO_ORDER_QTY"), 0) );
		}*/
		return  super.commonDao.list("w_sof100skrv_ypServiceImpl.selectList2", param);
	}
	
	/**
	 * 수주현황- 납기일별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		
/*		if(param.get("TXT_FR_ORDER_QTY")!=null) {				
			param.put("TXT_FR_ORDER_QTY", ObjUtils.parseInt(param.get("TXT_FR_ORDER_QTY"), 0) );
		}
		if(param.get("TXT_TO_ORDER_QTY")!=null) {				
			param.put("TXT_TO_ORDER_QTY", ObjUtils.parseInt(param.get("TXT_TO_ORDER_QTY"), 0) );
		}*/
		return  super.commonDao.list("w_sof100skrv_ypServiceImpl.selectList3", param);
	}
	
	
}
