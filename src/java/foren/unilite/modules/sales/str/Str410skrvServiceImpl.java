package foren.unilite.modules.sales.str;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.email.EmailModel;
import foren.unilite.modules.com.email.EmailSendServiceImpl;

@Service("str410skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Str410skrvServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	@Resource( name = "emailSendService" )
	private EmailSendServiceImpl emailSendService;

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("str410skrvServiceImpl.selectList1", param);
	}

	public List<Map<String, Object>> clipselect(Map param) throws Exception {
		return super.commonDao.list("str410skrvServiceImpl.clipselect", param);
	}

	public List<Map<String, Object>> clipselectsub(Map param) throws Exception {
		return super.commonDao.list("str410skrvServiceImpl.clipselectsub", param);
	}

	/**
	 * 납품거래명세서(shin) - 20191220 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> clipselect_sh_main(Map param) throws Exception {
		return super.commonDao.list("str410skrvServiceImpl.clipselect_sh_main", param);
	}
	public List<Map<String, Object>> clipselect_sh_sub(Map param) throws Exception {
		return super.commonDao.list("str410skrvServiceImpl.clipselect_sh_sub", param);
	}



	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public void insertFax(Map paramMap) throws Exception {
		super.commonDao.insert("str410skrvServiceImpl.insertFaxMeta", paramMap);
		super.commonDao.insert("str410skrvServiceImpl.insertFaxMsg", paramMap);
	}

	/**
	 * 메일 발송
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Map sendMail(Map param, LoginVO user) throws Exception {
		String to = ObjUtils.getSafeString(param.get("CUST_MAIL_ID"));
		String from = ObjUtils.getSafeString(param.get("FROM_EMAIL"));

		EmailModel emailModel = new EmailModel();
		emailModel.setFROM((String) param.get("FROM_EMAIL"));
		emailModel.setTO((String) param.get("TO_EMAIL"));
		emailModel.setSUBJECT((String) param.get("TITLE"));
		emailModel.setTEXT((String) param.get("TEXT"));
		emailModel.setCOMP_CODE(user.getCompCode());
		emailModel.setCC("");
		emailModel.setBCC("");
		emailModel.setFILE((String) param.get("FILE_INFO"));

		emailModel.setHasHtmlText(true);
		emailSendService.sendMailFileAttach(emailModel);

		String rtnVal = "1";

		param.put("STATUS", rtnVal);
		param.put("S_COMP_CODE", user.getCompCode());

		return param;
	}


	/**
	 * 20210311 추가: 최우선적으로 공통코드 S148 검색해서 없으면 기존로직 수행하도록 변경
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public String getReportFileInfo(Map param) throws Exception {
		return (String) super.commonDao.select("str410skrvServiceImpl.getReportFileInfo", param);
	}
}