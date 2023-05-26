package foren.unilite.modules.accnt.atx;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("atx205ukrService")
public class Atx205ukrServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 전산매체작성(계산서합계표)	-	제출자 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList1(Map param) throws Exception {
		return  super.commonDao.select("atx205ukrServiceImpl.selectList1", param);
	}
    
    /**
	 * 전산매체작성(계산서합계표)	-	제출의무자 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList2(Map param) throws Exception {
		return  super.commonDao.select("atx205ukrServiceImpl.selectList2", param);
	}
    
    /**
	 * 전산매체작성(계산서합계표)	-	제출의무자별집계(매출) 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList3(Map param) throws Exception {
		return  super.commonDao.select("atx205ukrServiceImpl.selectList3", param);
	}
    
    /**
	 * 전산매체작성(계산서합계표)	-	매출처별거래명세서 그리드 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
		return  super.commonDao.list("atx205ukrServiceImpl.selectList4", param);
	}
	
	/**
	 * 전산매체작성(계산서합계표)	-	제출의무자별집계(매입) 폼 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object	selectList5(Map param) throws Exception {
		return  super.commonDao.select("atx205ukrServiceImpl.selectList5", param);
	}
	
	/**
	 * 전산매체작성(계산서합계표)	-	매입처별거래명세
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList6(Map param) throws Exception {
		return  super.commonDao.list("atx205ukrServiceImpl.selectList6", param);
	}	
}
