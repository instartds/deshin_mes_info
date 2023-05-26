package foren.unilite.modules.stock.btr;

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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("btr130skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Btr130skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 창고코드 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {
		return super.commonDao.select("btr130skrvServiceImpl.userWhcode", param);
	}

	/**
	 * 조회 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("btr130skrvServiceImpl.selectList", param);
	}

	/**
	 * 사이트 뷰 존재여부 체크 - 20210803 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public String gsExistsSiteVeiw (Map param) throws Exception {
		return (String) super.commonDao.select("btr130skrvServiceImpl.gsExistsSiteVeiw", param);
	}
}