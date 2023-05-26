package foren.unilite.modules.human.ham;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "ham930ukrService" )
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ham930ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 일용근로전산신고자료 파일 대상 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> fnCheckData( Map param, LoginVO user ) throws Exception {
		List<Map<String,Object>> list = super.commonDao.list("ham930ukrServiceImpl.selectCheckData", param);
		
		if(list.size() < 1) {
			throw new UniDirectValidateException("신고자료 생성할 대상이 없습니다.");
		}
		
		return list;
	}

	/**
	 * 일용근로전산신고자료 파일 생성
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	public FileDownloadInfo createRetireFile( Map param, LoginVO loginVO ) throws Exception {
		
		AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
		logger.debug("param1 :: {}", param);

		String keyValue = getLogKey();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("LANG_TYPE", loginVO.getLanguage());
		param.put("USER_ID", loginVO.getUserID());
		param.put("KEY_VALUE", keyValue);
		
		// HPB100T테이블에서 암호화 대상 조회후  T_HPB100T테이블에 복호화된걸 insert함.. sp에서  T_HPB100T를 참조해 파일 생성함..
		List<Map<String, Object>> decrypList = (List<Map<String, Object>>)super.commonDao.list("ham930ukrServiceImpl.getDecryp", param);
		String repreNo = "";
		String repreNum = "";
		
		// 조회할 param 셑팅
		for (Map dec : decrypList) {
			repreNo = decrypto.getDecrypto("1", (String)dec.get("REPRE_NO"));     // 사업자번호
			repreNum = decrypto.getDecrypto("1", (String)dec.get("REPRE_NUM"));   // 주민등록번호

			dec.put("KEY_VALUE", keyValue);
			dec.put("REPRE_NO", repreNo);
			dec.put("REPRE_NUM", repreNum);
			dec.put("FOREIGN_NUM", "");
			this.insertDecLog(dec);
		}

		/*************************************************************************************************/
		/** 파일 생성 **/
		
		// 파일 데이터 생성
		List<Map<String, Object>> result = super.commonDao.list("ham930ukrServiceImpl.createFile", param);

		// error message가 존재할 경우
		String errorDesc = "";
		if(ObjUtils.isNotEmpty(result)){
			errorDesc = ObjUtils.getSafeString(result.get(0).get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, loginVO));
			}
		}
		
		// File명
		String fileName = result.get(0).get("FILENAME").toString();
		FileDownloadInfo fInfo = null;

		// 데이터 string값으로 생성
		String data = "";
		for(Map<String, Object> mapData : result) {
			data += mapData.get("ROW_DATA").toString();
			data += "\n";
		}
		logger.debug(">>> " + data);
		
		try {
			File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
			// 폴더 없으면 생성
			if(!dir.exists())  {
				dir.mkdir(); 
			}
			fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), fileName);
			FileOutputStream fos = new FileOutputStream(fInfo.getFile());
			
			byte[] bytesArray = data.getBytes();
			fos.write(bytesArray);
			fos.flush();
			fos.close(); 
			fInfo.setStream(fos);
			
		} catch (IOException e) {
			logger.error(e + "");
		}

		return fInfo;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
	public Integer insertDecLog( Map param ) throws Exception {
		super.commonDao.insert("ham930ukrServiceImpl.insertDecLog", param);
		return 0;
	}
}