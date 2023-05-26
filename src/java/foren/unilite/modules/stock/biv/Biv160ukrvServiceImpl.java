package foren.unilite.modules.stock.biv;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("biv160ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv160ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 실사재고보정 - 실사재고 수량 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "biv")
	public Object selectForm(Map param) throws Exception {	
		return super.commonDao.select("biv160ukrvServiceImpl.selectForm", param);
	}
	
	/**
	 * 실사재고보정 - 실사재고 보정수량 업데이트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "biv")
	public ExtDirectFormPostResult excuteStockAdjust(Biv160ukrvModel param, LoginVO user, BindingResult result) throws Exception {

		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		//param.setCOUNT_DATE(param.getCOUNT_DATE().replaceAll(".", ""));
		
		Map list = (Map)super.commonDao.select("biv160ukrvServiceImpl.excuteStockAdjust", param);
		String errDesc = list.get("ERR_DESC").toString();
		
		if(ObjUtils.isNotEmpty(errDesc))
            throw new UniDirectValidateException(this.getMessage(errDesc, user));
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}
}
