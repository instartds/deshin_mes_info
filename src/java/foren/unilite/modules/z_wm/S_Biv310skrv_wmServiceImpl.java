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


@Service("s_biv310skrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Biv310skrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 동적 그리드 구현(공통코드(입고처, Q012)에서 컬럼 가져오는 로직)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_biv310skrv_wmServiceImpl.selectColumns", loginVO);
	}

	/**
	 * 동적 그리드 구현(창고정보 테이블에서 컬럼 가져오는 로직)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List selectColumns2(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_biv310skrv_wmServiceImpl.selectColumns2", loginVO);
	}

	/**
	 * 동적 그리드 구현(창고정보 테이블에서 컬럼 가져오는 로직) - 사업장에 따라 창고가 다를 수 있어 조회시 마다 다시 창고정보 가져옴
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List selectColumns2_1(Map param) throws Exception {
		return (List)super.commonDao.list("s_biv310skrv_wmServiceImpl.selectColumns2", param);
	}



	/**
	 * 재고현황 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_biv310skrv_wmServiceImpl.selectList", param);
	}
}