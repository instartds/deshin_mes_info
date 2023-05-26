package foren.unilite.modules.human.hat;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hat200skrService")
public class Hat200skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 서비스 연결
	 */
	@Resource(name="hat520skrService")
	private Hat520skrServiceImpl hat520skrService;
	
	/**
	 * 근무조현황 목록 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		List dutyCode = (List)super.commonDao.list("hat200skrServiceImpl.selectDutycode" ,loginVO.getCompCode());
		param.put("DUTY_CODE", dutyCode);
		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
						
		return (List) super.commonDao.list("hat200skrServiceImpl.selectList", param);
	}

	

}
