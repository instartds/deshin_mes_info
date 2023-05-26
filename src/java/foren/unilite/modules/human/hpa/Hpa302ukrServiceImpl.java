package foren.unilite.modules.human.hpa;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpa302ukrService")
public class Hpa302ukrServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 보험기준 자료 검증
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public Map ssql1(Map param) throws Exception {		
		return  (Map) super.commonDao.select("hpa302ukrService.ssql1", param);
	}
	
	/**
	 * 보험기준 자료 검증 count
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 저장전 DATACOUNT 검사
	public List<Map<String, Object>>  ssql1Cnt(Map param) throws Exception {	
		return  super.commonDao.list("hpa302ukrService.ssql1Cnt", param);
	}
	
	
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param, LoginVO user) throws Exception {
		
		
		Map ssql1Cnt = (Map) super.commonDao.queryForObject("hpa302ukrService.ssql1Cnt", param);
		
		
		if (ObjUtils.parseInt(ssql1Cnt.get("BASE_YEAR")) == 0) {
			throw new  UniDirectValidateException(this.getMessage("55215", user)); // 해당년도의 보험기준자료을 등록하십시오.
		}else{
			return (int)super.commonDao.update("hpa302ukrService.doBatch", param);
		}
	}
}
