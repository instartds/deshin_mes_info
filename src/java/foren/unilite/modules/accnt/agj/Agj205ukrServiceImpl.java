package foren.unilite.modules.accnt.agj;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("agj205ukrService")
public class Agj205ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 결의전표등록(전표번호별) 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("agj205ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 결의전표등록(전표번호별) 이전 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getPrevSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj205ukrServiceImpl.getPrevSlipNum", param);
	}

	/**
	 * 결의전표등록(전표번호별) 이후 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getNextSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj205ukrServiceImpl.getNextSlipNum", param);
	}	
	 
}
