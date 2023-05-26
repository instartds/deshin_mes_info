package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sof110skrv_shService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_sof110skrv_shServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static Logger  logger;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주진행현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_sh")
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return  super.commonDao.list("s_sof110skrv_shServiceImpl.selectList", param);
	}

	/**
	 * 수주진행현황- 생산내역 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_sh")
	public List<Map<String, Object>> detailList (Map param) throws Exception {
		return  super.commonDao.list("s_sof110skrv_shServiceImpl.detailList", param);
	}

	/**
	 * 수주진행현황- 구매내역 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_sh")
	public List<Map<String, Object>> detailList2 (Map param) throws Exception {
		return  super.commonDao.list("s_sof110skrv_shServiceImpl.detailList2", param);
	}

	/**
	 * 수주진행현황(통합) - 20200120 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_sh")
	public List<Map<String, Object>> detailListAll (Map param) throws Exception {
		return  super.commonDao.list("s_sof110skrv_shServiceImpl.detailListAll", param);
	}



	/**
	 * 품목 관련 파일 업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "z_sh", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> getItemInfo( Map param ) throws Exception {
		return super.commonDao.list("s_sof110skrv_shServiceImpl.getItemInfo", param);
	}


	/**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_sh", value = ExtDirectMethodType.FORM_LOAD)
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("s_sof110skrv_shServiceImpl.getFileList", param);
	}
}