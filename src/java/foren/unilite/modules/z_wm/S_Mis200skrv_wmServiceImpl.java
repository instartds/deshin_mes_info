package foren.unilite.modules.z_wm;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;


@Service("s_mis200skrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Mis200skrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 생산진행현황 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mis200skrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 생산진행현황 조회(현황판)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "z_wm")		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public Map<String, Object> selectBList(Map param) throws Exception {
		Map<String, Object> rMap		= new HashMap();
		List<Map<String, Object>> rList	= new ArrayList();

		rList = (List)super.commonDao.list("s_mis200skrv_wmServiceImpl.selectBList", param);

		int total = 0;
		if (rList.size() > 0) {
			Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
			total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
//			total = rList.size();
		}
		rMap.put("data"	, rList);
		rMap.put("total", total);

		return rMap;
	}
}