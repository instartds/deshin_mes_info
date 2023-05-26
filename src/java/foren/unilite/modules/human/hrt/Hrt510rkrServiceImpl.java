package foren.unilite.modules.human.hrt;

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
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;
import foren.framework.sec.cipher.ase.AES256Cipher;

@Service("hrt510rkrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hrt510rkrServiceImpl  extends TlabAbstractServiceImpl {
//	private final Logger logger = LoggerFactory.getLogger(this.getClass());
//	private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
//	private AES256DecryptoUtils	decrypto = new AES256DecryptoUtils();



	/**
	 * 출력 master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hrt")
	public List<Map<String, Object>> selectPrintMData(Map param) throws Exception {
		return super.commonDao.list("hrt510rkrServiceImpl.selectPrintMData", param);
	}

	/**
	 * 출력 detail data 조회
	 * @param param
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hrt")
	public List<Map<String, Object>> selectPrintDData(Map param) throws Exception {
		return super.commonDao.list("hrt510rkrServiceImpl.selectPrintDData", param);
	}
}