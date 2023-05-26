 package foren.unilite.modules.human.ham;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("ham910rkrService")
public class Ham910rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> fnHam911nQ_2(Map param) throws Exception {
		
		Map personMap = new HashMap();
		
		List<Map> personList = (List<Map>) super.commonDao.list("ham910rkrServiceImpl.fnHam911nQ", param);
		
		if (!ObjUtils.isEmpty(personList)) {
			List newData = new ArrayList();
			
			for(Map strPer : personList) {
				newData.add(strPer.get("PERSON_NUMB"));
			};
			param.put("strPer",      newData);
		};		

		
		return (List) super.commonDao.list("ham910rkrServiceImpl.fnHam911nQ_2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")			// 조회
	public List<Map<String, Object>>  ds_sub01(Map param) throws Exception {
		return  super.commonDao.list("ham910rkrServiceImpl.ds_sub01", param);	
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")			// 조회
	public List<Map<String, Object>>  checkPerson(Map param) throws Exception {
		return  super.commonDao.list("ham910rkrServiceImpl.fnHam911nQ_2", param);	
	}	

}
