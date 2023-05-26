package foren.unilite.modules.human.ham;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
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
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "ham920ukrService" )
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ham920ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
//		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "ham")
//		public Map procHam920(Map param, LoginVO loginVO) throws Exception {
//			param.put("S_COMP_CODE", loginVO.getCompCode());
//			
//			String arr[] = param.toString().split(",");
//			for(int i=0;i<arr.length;i++){
//				System.out.println(arr[i]);
//			}
//			Map result = (Map)super.commonDao.queryForObject("ham920ukrServiceImpl.proc", param);
//			
//			System.out.println(result.toString());
//			return result;
//		}

//	/**
//	 * 일용근로전산신고자료 파일 생성
//	 * 
//	 * @param param
//	 * @param loginVO
//	 * @return
//	 * @throws Exception
//	 */
//	public Map createRetireFile( Map param, LoginVO loginVO ) throws Exception {
//		AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
//		String path = "";
//		
//		logger.debug("param1 :: {}", param);
//		
//		String keyValue = getLogKey();
//		param.put("S_COMP_CODE", loginVO.getCompCode());
//		//param.put("HOMETAX_ID", loginVO.getUserID());
//		param.put("LANG_TYPE", loginVO.getLanguage());
//		param.put("USER_ID", loginVO.getUserID());
//		param.put("KEY_VALUE", keyValue);
//		
//		// HPB100T테이블에서 암호화 대상 조회후  T_HPB100T테이블에 복호화된걸 insert함.. sp에서  T_HPB100T를 참조해 파일 생성함..
//		List<Map<String, Object>> decrypList = (List<Map<String, Object>>)super.commonDao.list("ham920ukrServiceImpl.getDecryp", param);
//		String repreNo = "";
//		String repreNum = "";
//		
//		for (Map dec : decrypList) {
//			repreNo = decrypto.getDecrypto("1", (String)dec.get("REPRE_NO"));
//			repreNum = decrypto.getDecrypto("1", (String)dec.get("REPRE_NUM"));
//			
//			dec.put("KEY_VALUE", keyValue);
//			dec.put("REPRE_NO", repreNo);
//			dec.put("REPRE_NUM", repreNum);
//			dec.put("FOREIGN_NUM", "");
//			
//			this.insertDecLog(dec);
//		}
//		
//		logger.debug("param2 :: {}", param);
//		
//		Map result = (Map)super.commonDao.queryForObject("ham920ukrServiceImpl.createFile", param);
//		logger.debug(">>> " + result);
//		if (ObjUtils.isNotEmpty(result.get("RETURN_VALUE"))) {
//			Object resultInt = result.get("RETURN_VALUE");
//			if (ObjUtils.parseInt(resultInt) != -1) {
//				String fileName = result.get("FILE_NAME").toString();
//				
//				Object data = result.get("RETURN_VALUE");
//				//				List<Map> data = super.commonDao.list("ham920ukrServiceImpl.loadFileData", param);
//				logger.debug(">>> " + data);
//				
//				try {
//					path = file_open(fileName);
//					if (path != "") {
//						BufferedWriter out = new BufferedWriter(new FileWriter(path));
//						out.write(data.toString());
//						out.newLine();
//						out.close();
//					} else {
//						result.put("RETURN_VALUE", 2);
//					}
//				} catch (IOException e) {
//					logger.error(e + "");
//				}
//				//				try {
//				//					path = file_open(fileName);
//				//					if (path != "") {
//				//						BufferedWriter out = new BufferedWriter(new FileWriter(path));
//				//						for (int i = 0; i < data.size(); i++) {
//				//							out.write(data.get(i).get("DATA").toString());
//				//							if (i < data.size() - 1) {
//				//								out.newLine();
//				//							}
//				//						}
//				//						out.close();
//				//					} else {
//				//						result.put("RETURN_VALUE", 2);
//				//					}
//				//				} catch (IOException e) {
//				//					logger.error(e + "");
//				//				}
//			}
//		} /*
//		   * else { throw new UniDirectValidateException("파일을 생성할 데이터가 없습니다."); }
//		   */
//		
//		return result;
//	}

	/**
	 * 일용근로전산신고자료 파일 대상 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> fnCheckData( Map param, LoginVO user ) throws Exception {
		List<Map<String,Object>> list = super.commonDao.list("ham920ukrServiceImpl.selectCheckData", param);
		
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
		String path = "";
		FileDownloadInfo fInfo = null;

		logger.debug("param1 :: {}", param);

		String keyValue = getLogKey();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		//param.put("HOMETAX_ID", loginVO.getUserID());
		param.put("LANG_TYPE", loginVO.getLanguage());
		param.put("USER_ID", loginVO.getUserID());
		param.put("KEY_VALUE", keyValue);
		
		// HPB100T테이블에서 암호화 대상 조회후  T_HPB100T테이블에 복호화된걸 insert함.. sp에서  T_HPB100T를 참조해 파일 생성함..
		List<Map<String, Object>> decrypList = (List<Map<String, Object>>)super.commonDao.list("ham920ukrServiceImpl.getDecryp", param);
		String repreNo = "";
		String repreNum = "";
		
		for (Map dec : decrypList) {
			repreNo = decrypto.getDecrypto("1", (String)dec.get("REPRE_NO"));
			repreNum = decrypto.getDecrypto("1", (String)dec.get("REPRE_NUM"));

			dec.put("KEY_VALUE", keyValue);
			dec.put("REPRE_NO", repreNo);
			dec.put("REPRE_NUM", repreNum);
			dec.put("FOREIGN_NUM", "");
			this.insertDecLog(dec);
		}

		logger.debug("param2 :: {}", param);

		Map result = (Map)super.commonDao.queryForObject("ham920ukrServiceImpl.createFile", param);
		logger.debug(">>> " + result);
		if (ObjUtils.isNotEmpty(result.get("RETURN_VALUE"))) {
			Object resultInt = result.get("RETURN_VALUE");
			if (ObjUtils.parseInt(resultInt) != -1) {
				String fileName = result.get("FILE_NAME").toString();
				//20200703 수정: 한글 깨지는 현상으로 수정
//				String data = new String(result.get("RETURN_VALUE").toString().getBytes(), "utf-8");
				String data = new String(result.get("RETURN_VALUE").toString().getBytes());
				logger.debug(">>> " + data);

				try {
					File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
					if(!dir.exists())  dir.mkdir(); 
					fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), fileName);
					logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
					FileOutputStream fos = new FileOutputStream(fInfo.getFile());
					
					byte[] bytesArray = data.getBytes();
					fos.write(bytesArray);
					fos.flush();
					fos.close(); 
					fInfo.setStream(fos);
				} catch (IOException e) {
					logger.error(e + "");
				}
			}
		} /*
		   * else { throw new UniDirectValidateException("파일을 생성할 데이터가 없습니다."); }
		   */
		return fInfo;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
	public Integer insertDecLog( Map param ) throws Exception {
		super.commonDao.insert("ham920ukrServiceImpl.insertDecLog", param);
		return 0;
	}

	public static String file_open( String fileName ) {
		String path = "";
		Frame f = new Frame("Save as..");
		f.setSize(0, 0);
		FileDialog fileOpen = new FileDialog(f, "Save as..", FileDialog.SAVE);
		fileOpen.setFile(fileName);	// 기본 파일명`
		f.setVisible(true);
		f.setVisible(false);
		fileOpen.setVisible(true);
		
		if (fileOpen.getFile() == null) {
			path = "";
		} else {
			path = fileOpen.getDirectory() + fileOpen.getFile();
		}
		f.dispose();
		return path;
	}

	// sync All
	@ExtDirectMethod( group = "hpa" )
	public Integer syncAll( Map param ) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}
}