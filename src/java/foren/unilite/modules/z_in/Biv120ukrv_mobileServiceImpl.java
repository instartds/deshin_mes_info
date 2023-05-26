package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv120ukrv_mobileService")
public class Biv120ukrv_mobileServiceImpl extends TlabAbstractServiceImpl {
	@InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 실사등록(모바일) - 바코드 리딩 후 재고 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "biv")
	public List<Map<String, Object>>  selectStockInfo(Map param) throws Exception {
		return  super.commonDao.list("biv120ukrv_mobileServiceImpl.selectStockInfo", param);
	}

	/**
	 * 실사등록(모바일) - 실사재고 수량 업데이트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "biv")
	public ExtDirectFormPostResult  updateStockInfo(Biv120ukrv_mobileModel param, LoginVO user, BindingResult result) throws Exception {

		//param.setS_COMP_CODE(user.getCompCode());
		
		super.commonDao.update("biv120ukrv_mobileServiceImpl.updateStockInfo", param);
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}
}
