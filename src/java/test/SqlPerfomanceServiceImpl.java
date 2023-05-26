package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sqlPerformanceService")
public class SqlPerfomanceServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "base")
	public Object mybatisTest(Map param) throws Exception {
		 long start = System.currentTimeMillis();
		 super.commonDao.list("sqlPerformanceService.mybatisTest", param);
	     long end = System.currentTimeMillis();
	     long time = (end - start)/1000;
			
		return "Excute Time : "+ time +" sec";
	}

	@ExtDirectMethod(group = "base")
	public Object sqlVariableTest(Map param) throws Exception {
		 long start = System.currentTimeMillis();
		 super.commonDao.list("sqlPerformanceService.sqlVariableTest", param);
	     long end = System.currentTimeMillis();
	     long time = (end - start)/1000;
			
		return "Excute Time : "+ time +" sec";
	}
}
