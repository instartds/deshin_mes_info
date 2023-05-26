package foren.unilite.modules.z_sd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hpa901rkr_sdService")
public class S_Hpa901rkr_sdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hpa")
	public void createReportData(Map param) throws Exception {
		
		  super.commonDao.update("s_hpa901rkr_sdServiceImpl.createTable", param);

	       Map wagesMap = new HashMap();

		   List<Map> wList1 = (List<Map>) super.commonDao.list("s_hpa901rkr_sdServiceImpl.selectWages1", param);

			for(Map wCode : wList1) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
				wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

				super.commonDao.insert("s_hpa901rkr_sdServiceImpl.insertWages1", wCode);

			 }

			List<Map> wList2 = (List<Map>) super.commonDao.list("s_hpa901rkr_sdServiceImpl.selectWages2", param);

			for(Map wCode : wList2) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
				wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

				super.commonDao.insert("s_hpa901rkr_sdServiceImpl.insertWages2", wCode);

			 }

			List<Map> wList3 = (List<Map>) super.commonDao.list("s_hpa901rkr_sdServiceImpl.selectWages3", param);

			for(Map wCode : wList3) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
				wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
				wCode.put("WAGES_SEQ", wCode.get("WAGES_SEQ"));

				super.commonDao.insert("s_hpa901rkr_sdServiceImpl.insertWages3", wCode);

			 }
	}
}
