package foren.unilite.modules.human.hum;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;


@Service("hum315skrService")
public class Hum315skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
	private AES256DecryptoUtils	decrypto = new AES256DecryptoUtils();
	/**
	 * 가족사항조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		List<Map<String, Object>> dataList = super.commonDao.list("hum315skrService.selectList", param);
		
		for(Map dataMap : dataList){
    		dataMap.put("REPRE_NUM_EXPOS", decrypto.getDecryptWithType(dataMap.get("REPRE_NUM"),param.get("S_COMP_CODE") , "hum315skr", "A"));
    	}
        return dataList;
	}
}
