package foren.unilite.modules.human.hcn;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hcn100skrService")
public class Hcn100skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
     * 부서장, 관리자 구분 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hcn")
    public Object checkCnlnGrp(Map param) throws Exception {
        return super.commonDao.select("hcn100skrServiceImpl.checkCnlnGrp", param);
    }
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hcn")		
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	    
		return  super.commonDao.list("hcn100skrServiceImpl.selectList", param);
	}
}
