package foren.unilite.modules.human.hpe;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
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

@Service( "hpe500ukrService" )
public class Hpe500ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 지급명세서 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> fnCheckData( Map param, LoginVO user ) throws Exception {
		List<Map<String,Object>> list = null;
		String dataFlag = ObjUtils.getSafeString(param.get("DATA_FLAG"));

		if("1".equals(dataFlag)) {
			list = super.commonDao.list("hpe500ukrServiceImpl.selectWorkPayListC", param);
		}
		if("2".equals(dataFlag)) {
			list = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveInListC", param);
		}
		if("3".equals(dataFlag)) {
			list = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveOutListC", param);
		}
		
		if(list.size() < 1) {
			throw new UniDirectValidateException("신고자료 생성할 대상이 없습니다.");
		}
		
		return list;
	}

	/**
	 * 간이지급명세서(근로소득) 신고자료 생성 - 근로소득간이지급명세서(근로소득)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpe")
	public FileDownloadInfo doBatchWorkPay(Map param) throws Exception {
		String sTaxAgentNo = ObjUtils.getSafeString(param.get("TAX_AGENT_NO"));
		String sSubmitter = "";
		FileDownloadInfo fInfo = null;
		
		if(ObjUtils.isNotEmpty(sTaxAgentNo))	{        //관리번호가 있으면 세무대리인 처리
			sSubmitter = "1";
		}
		else {                            				//자료제출자가 세무대리인이 아닌 경우, 관리번호에 공백수록
			sSubmitter = "2";
			sTaxAgentNo = "";
		}

		List<Map<String,Object>> listA = super.commonDao.list("hpe500ukrServiceImpl.selectWorkPayListA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpe500ukrServiceImpl.selectWorkPayListB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpe500ukrServiceImpl.selectWorkPayListC", param);
		
		if(listA != null && listA.size() > 0)	{
			Map<String, Object> map = listA.get(0);
			String companyNum = ObjUtils.getSafeString(map.get("COMPANY_NUM"));
			
			File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
			if(!dir.exists())  dir.mkdir(); 
			fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), "SC" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
			logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
			FileOutputStream fos = new FileOutputStream(fInfo.getFile());
			
			String data = "";
			byte[] bytesArray = data.getBytes();
			//int i=1;
			//for(Map<String, Object> mapA : listA) {
			Map<String, Object> mapA = listA.get(0);
			data = "A77"											// A1+A2 레코드 구분(A) + 자료구분(77)
				 + this.csformat(mapA.get("SAFFER"), 3)				// A3:세무서코드
				 + this.csformat(param.get("SUBMIT_DATE"), 8)		// A4:제출연월일
				 + sSubmitter										// A5:제출자 구분 (1:세무대리인 2:법인 3:개인)
				 + this.csformat(sTaxAgentNo, 6)					// A6:세무대리인 관리번호
				 + this.csformat(param.get("HOMETAX_ID"), 20)		// A7:홈택스 ID
				 + "9000"											// A8:세무프로그램코드
				 + this.csformat(mapA.get("COMPANY_NUM"), 10)		// A9:사업자등록번호
				 + this.csformat(mapA.get("DIV_NAME"), 30)			// A10:법인명(상호)
				 + this.csformat(mapA.get("DEPT_NAME"), 30)			// A11:담당자 부서
				 + this.csformat(mapA.get("REPRE_NAME"), 30)		// A12:담당자 성명
				 + this.csformat(mapA.get("TELEPHON"), 15)			// A13:담당자 전화번호
				 + this.cnformat(mapA.get("CNT"), 5)				// A14:신고의무자수
				 + this.csformat(mapA.get("A_SPACE"), 25);			// A15:공란
			data += "\n";

			bytesArray = data.getBytes();
			fos.write(bytesArray);
			//	i++;
			//}

			//사업장목록
			int bI = 1;
			for(Map<String,Object> mapB : listB) {
				String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
				
				//C 레코드 - 사원목록
				List<Map<String,Object>> subListC = this.filterList(listC, "SECT_CODE", sectCode);

				data = "B77"													// B1+B2:레코드 구분+자료구분
					 + this.csformat(mapB.get("SAFFER"), 3)						// B3:세무서코드
					 + this.cnformat(bI, 6)										// B4:일련번호
					 + this.csformat(mapB.get("DIV_NAME"), 40)					// B5:①상호(법인명)
					 + this.csformat(mapB.get("REPRE_NAME"), 30)				// B6:성명(대표자)
					 + this.csformat(mapB.get("COMPANY_NUM"), 10)				// B7:사업자등록번호
					 + this.csformat(mapB.get("REPRE_NO"), 13)					// B8:주민(법인)등록번호
					 + this.csformat(mapB.get("YEAR_YYYY"), 4)					// B9:귀속년도
					 + this.csformat(mapB.get("HALF_YEAR"), 1)					// B10:근무시기
					 + this.cnformat(subListC.size(), 10)						// B11:근로자총인원
					 + this.cnformat(mapB.get("TAXABLE_INCOME_AMT"), 13)		// B12:과세소득(급여 등합계)
					 + this.cnformat(mapB.get("ETC_INCOME_AMT"), 13)			// B13:과세소득(인정상여합계)
					 + this.csformat(mapB.get("B_SPACE"), 44);					// B14:공란
				data += "\n";

				bytesArray = data.getBytes();
				fos.write(bytesArray);
				bI++;
				
				int cI = 1;
				for(Map<String,Object> mapC : subListC)	{

					data = "C77"												// C1+C2:레코드 구분+자료구분
						 + this.csformat(mapC.get("SAFFER"), 3)					// C3:세무서코드
						 + this.cnformat(cI, 7)									// C4:일련번호
						 + this.csformat(mapC.get("COMPANY_NUM"), 10)			// C5:사업자등록번호
						 + this.csformat(mapC.get("REPRE_NUM"), 13)				// C6:주민등록번호
						 + this.csformat(mapC.get("NAME"), 30)					// C7:성명
						 + this.csformat(mapC.get("C_SPACE"), 20)				// C8:전화번호 (공란으로 수록)
						 + this.csformat(mapC.get("FORIGN"), 1)					// C9:내ㆍ외국인
						 + this.csformat(mapC.get("LIVE_GUBUN"), 1)				// C10:거주자구분
						 + this.csformat(mapC.get("LIVE_CODE"), 2)				// C11:거주지국코드
						 + this.csformat(mapC.get("WORKDATE_FR"), 8)			// C12:근무기간시작년월일
						 + this.csformat(mapC.get("WORKDATE_TO"), 8)			// C13:근무기간종료년월일
						 + this.cnformat(mapC.get("TAXABLE_INCOME_AMT"), 13)	// C14:급여 등
						 + this.cnformat(mapC.get("ETC_INCOME_AMT"), 13)		// C15:인정상여
						 + this.csformat(mapC.get("C_SPACE"), 58);				// C16:공란
					data += "\n";

					bytesArray = data.getBytes();
					fos.write(bytesArray);
					cI++;
				}
			}
			fos.flush();
			fos.close(); 
			fInfo.setStream(fos);
		}
		
		return fInfo;
	}

	/**
	 * 간이지급명세서(거주자 사업소득) 신고자료 생성
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpe")
	public FileDownloadInfo doBatchBusiPayLiveIn(Map param) throws Exception {
		String sTaxAgentNo = ObjUtils.getSafeString(param.get("TAX_AGENT_NO"));
		String sSubmitter = "";
		FileDownloadInfo fInfo = null;
		
		if(ObjUtils.isNotEmpty(sTaxAgentNo))	{        //관리번호가 있으면 세무대리인 처리
			sSubmitter = "1";
		}
		else {                            				//자료제출자가 세무대리인이 아닌 경우, 관리번호에 공백수록
			sSubmitter = "2";
			sTaxAgentNo = "";
		}

		List<Map<String,Object>> listA = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveInListA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveInListB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveInListC", param);
		
		if(listA != null && listA.size() > 0)	{
			Map<String, Object> map = listA.get(0);
			String companyNum = ObjUtils.getSafeString(map.get("COMPANY_NUM"));
			
			File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
			if(!dir.exists())  dir.mkdir(); 
			fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), "SF" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
			logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
			FileOutputStream fos = new FileOutputStream(fInfo.getFile());
			
			String data = "";
			byte[] bytesArray = data.getBytes();
			//int i=1;
			//for(Map<String, Object> mapA : listA) {
			Map<String, Object> mapA = listA.get(0);
			data = "A50"											// A1+A2:레코드 구분 + 자료구분
				 + this.csformat(mapA.get("SAFFER"), 3)				// A3:세무서코드
				 + this.csformat(param.get("SUBMIT_DATE"), 8)		// A4:제출연월일
				 + sSubmitter										// A5:제출자 구분
				 + this.csformat(sTaxAgentNo, 6)					// A6:세무대리인관리번호
				 + this.csformat(param.get("HOMETAX_ID"), 20)		// A7:홈택스 ID
				 + "9000"											// A8:세무프로그램코드
				 + this.csformat(mapA.get("COMPANY_NUM"), 10)		// A9:사업자등록번호
				 + this.csformat(mapA.get("DIV_NAME"), 30)			// A10:법인명(상호)
				 + this.csformat(mapA.get("DEPT_NAME"), 30)			// A11:담당자 부서
				 + this.csformat(mapA.get("REPRE_NAME"), 30)		// A12:담당자 성명
				 + this.csformat(mapA.get("TELEPHON"), 15)			// A13:담당자 전화번호
				 + this.cnformat(mapA.get("CNT"), 5)				// A14:신고의무자수
				 + this.csformat(mapA.get("A_SPACE"), 5);			// A15:공란
			data += "\n";

			bytesArray = data.getBytes();
			fos.write(bytesArray);
			//	i++;
			//}

			//사업장목록
			int bI = 1;
			for(Map<String,Object> mapB : listB) {
				String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));

				//C 레코드 - 사원목록
				List<Map<String,Object>> subListC = this.filterList(listC, "SECT_CODE", sectCode);
				
				data = "B50"										// B1+B2:레코드 구분 + 자료구분
					 + this.csformat(mapB.get("SAFFER"), 3)			//B3:세무서코드
					 + this.cnformat(bI, 6)							//B4:일련번호
					 + this.csformat(mapB.get("DIV_NAME"), 40)		//B5:①법인명(상호, 성명)
					 + this.csformat(mapB.get("C_SPACE"), 30)		//B6:성명(대표자) 공란이 아니면 오류 
					 + this.csformat(mapB.get("COMPANY_NUM"), 10)	//B7:사업자등록번호
					 + this.csformat(mapB.get("REPRE_NO"), 13)		//B8:주민(법인)등록번호
					 + this.csformat(mapB.get("YEAR_YYYY"), 4)		//B9:귀속년도
					 + this.csformat(mapB.get("HALF_YEAR"), 1)		//B10:근무시기
					 + this.cnformat(subListC.size(), 10)			//B11:반기소득인원
					 //+ this.cnformat(mapB.get("CNT"), 10)
					 + this.cnformat(mapB.get("PAY_AMOUNT_I"), 13)	//B12:반기총지급액계
					 + this.csformat(mapB.get("C_SPACE"), 37);		//B13:공란
				data += "\n";
				bytesArray = data.getBytes();
				fos.write(bytesArray);
				bI++;
				
				int cI = 1;
				for(Map<String,Object> mapC : subListC)	{

					data = "C50"										//C1+C2:레코드 구분+자료구분
						 + this.csformat(mapC.get("SAFFER"), 3)			//C3:세무서코드
						 + this.cnformat(cI, 7)							//C4:일련번호
						 + this.csformat(mapC.get("COMPANY_NUM"), 10)	//C5:사업자등록번호
						 + this.csformat(mapC.get("DED_CODE"), 6)		//C6:업종코드
						 + this.csformat(mapC.get("NAME"), 30)			//C7:소득자 성명 (상호)
						 + this.csformat(mapC.get("REPRE_NUM"), 13)		//C8:주민(사업자)등록번호
						 + this.csformat(mapC.get("FORIGN"), 1)			//C9:내외국인구분
						 + this.csformat(mapC.get("LIVE_CODE"), 2)		//C10:거주지국코드
						 + this.csformat(mapC.get("C_SPACE"), 4)		//C11:지급연도
						 + this.csformat(mapC.get("C_SPACE"), 4)		//C12:소득귀속년도
						 + this.cnformat(mapC.get("C_SPACE"), 4)		//C13:지급건수
						 + this.cnformat(mapC.get("PAY_AMOUNT_I"), 13)	//C14:지급총액
						 + this.csformat(mapC.get("C_SPACE"), 70);		//C15:공란
					data += "\n";
					bytesArray = data.getBytes();
					fos.write(bytesArray);
					cI++;
				}
			}
			fos.flush();
			fos.close(); 
			fInfo.setStream(fos);
		}
		
		return fInfo;
	}

	/**
	 * 간이지급명세서(비거주자 사업소득) 신고자료 생성
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpe")
	public FileDownloadInfo doBatchBusiPayLiveOut(Map param) throws Exception {
		String sTaxAgentNo = ObjUtils.getSafeString(param.get("TAX_AGENT_NO"));
		String sSubmitter = "";
		FileDownloadInfo fInfo = null;
		
		if(ObjUtils.isNotEmpty(sTaxAgentNo))	{        //관리번호가 있으면 세무대리인 처리
			sSubmitter = "1";
		}
		else {                            				//자료제출자가 세무대리인이 아닌 경우, 관리번호에 공백수록
			sSubmitter = "2";
			sTaxAgentNo = "";
		}

		List<Map<String,Object>> listA = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveOutListA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveOutListB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpe500ukrServiceImpl.selectBusiPayLiveOutListC", param);
		
		if(listA != null && listA.size() > 0)	{
			Map<String, Object> map = listA.get(0);
			String companyNum = ObjUtils.getSafeString(map.get("COMPANY_NUM"));
			
			File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
			if(!dir.exists())  dir.mkdir(); 
			fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), "SBI" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
			logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
			FileOutputStream fos = new FileOutputStream(fInfo.getFile());
			
			String data = "";
			byte[] bytesArray = data.getBytes();
			//int i=1;
			//for(Map<String, Object> mapA : listA) {
			Map<String, Object> mapA = listA.get(0);
			data = "A49"										//A1+A2:레코드 구분+자료구분
				 + this.csformat(mapA.get("SAFFER"), 3)			//A3:세무서코드
				 + this.csformat(param.get("SUBMIT_DATE"), 8)	//A4:제출연월일
				 + sSubmitter									//A5:제출자 구분
				 + this.csformat(sTaxAgentNo, 6)				//A6:세무대리인 관리번호
				 + this.csformat(param.get("HOMETAX_ID"), 20)	//A7:홈택스 ID
				 + "9000"										//A8:세무프로그램코드
				 + this.csformat(mapA.get("COMPANY_NUM"), 10)	//A9:사업자등록번호
				 + this.csformat(mapA.get("DIV_NAME"), 40)		//A10:법인명(상호)
				 + this.csformat(mapA.get("DEPT_NAME"), 30)		//A11:담당자 부서
				 + this.csformat(mapA.get("REPRE_NAME"), 30)	//A12:담당자 성명
				 + this.csformat(mapA.get("TELEPHON"), 15)		//A13:담당자 전화번호
				 + this.cnformat(mapA.get("CNT"), 5)			//A14:신고의무자수
				 + this.csformat(mapA.get("A_SPACE"), 85);		//A15:공란
			data += "\n";
			bytesArray = data.getBytes();
			fos.write(bytesArray);
			//	i++;
			//}

			//사업장목록
			int bI = 1;
			for(Map<String,Object> mapB : listB) {
				String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
				
				//C 레코드 - 사원목록
				List<Map<String,Object>> subListC = this.filterList(listC, "SECT_CODE", sectCode);

				data = "B49"										//B1+B2:레코드 구분+자료구분
					 + this.csformat(mapB.get("SAFFER"), 3)			//B3:세무서코드
					 + this.cnformat(bI, 6)							//B4:일련번호
					 + this.csformat(mapB.get("DIV_NAME"), 50)		//B5:①법인명(상호)
					 + this.csformat(mapB.get("COMPANY_NUM"), 10)	//B6:사업자등록번호
					 + this.csformat(mapB.get("ADDR"), 140)			//B7:소재지(주소)
					 + this.csformat(mapB.get("YEAR_YYYY"), 4)		//B8:귀속년도
					 + this.csformat(mapB.get("HALF_YEAR"), 1)		//B9:근무시기
					 + this.cnformat(subListC.size(), 10)			//B10:반기소득 지급인원
					 //+ this.cnformat(mapB.get("CNT"), 10)			
					 + this.cnformat(mapB.get("PAY_AMOUNT_I"), 13)	//B11:반기지급총액 합계
					 + this.csformat(mapB.get("B_SPACE"), 20);		//B12:공란
				data += "\n";
				bytesArray = data.getBytes();
				fos.write(bytesArray);
				bI++;
				
				int cI = 1;
				for(Map<String,Object> mapC : subListC)	{

					data = "C49"										//C1+C2:레코드 구분+자료구분
						 + this.csformat(mapC.get("SAFFER"), 3)			//C3:세무서코드
						 + this.cnformat(cI, 7)							//C4:일련번호
						 + this.csformat(mapC.get("COMPANY_NUM"), 10)	//C5:사업자등록번호
						 + this.csformat(mapC.get("DED_CODE"), 2)		//C6:소득구분코드
						 + this.csformat(mapC.get("NAME"), 30)			//C7:소득자 성명 (상호)
						 + this.csformat(mapC.get("REPRE_NUM"), 20)		//C8:주민(사업자)등록번호C9:소득자의 주소 (공란(Space)으로 수록)
						 + this.csformat(mapC.get("C_SPACE"), 140)		//C9:소득자의 주소(공란(Space)으로 수록)
						 + this.csformat(mapC.get("FORIGN"), 1)			//C10:내ㆍ외국인
						 + this.csformat(mapC.get("LIVE_CODE"), 2)		//C11:거주지국코드
						 + this.csformat(mapC.get("C_SPACE"), 4)		//C12:지급연도(공란(Space)으로 수록)
						 + this.csformat(mapC.get("C_SPACE"), 4)		//C13:소득귀속년도(공란(Space)으로 수록)
						 + this.cnformat(mapC.get("PAY_AMOUNT_I"), 13)	//C14:지급총액
						 + this.csformat(mapC.get("C_SPACE"), 21);		//C15:공란
					data += "\n";
					bytesArray = data.getBytes();
					fos.write(bytesArray);
					cI++;
				}
			}
			fos.flush();
			fos.close(); 
			fInfo.setStream(fos);
		}
		
		return fInfo;
	}

	private String csformat(Object obj, int leng)throws Exception 	{
		String str = ObjUtils.getSafeString(obj);
		return this.strPad(str, leng, " ", false);
	}
	
	private String cnformat(Object obj, int leng)throws Exception {
		String str = ObjUtils.getSafeString(obj, "0");
		if(str.indexOf(".") >=0)
			str = str.substring(0, str.indexOf("."));
		
		return this.strPad(str, leng, "0", true);
	}
	
	private String strPad( String str, int size, String padStr, boolean where ) throws Exception {
		if (str == null) str = "";
		
		if (!where && str.getBytes("MS949").length > size && str.getBytes("MS949").length != str.length()) {
			byte[] bytes = str.getBytes("MS949");
			String strbyte=null, strChar=null;
			int j=0, k=0;
			
			for(int i=0; (i < str.length() && j < size) ; i++) {
				byte[] tmpbyte = new byte[1];
				k=j;	// 마지막 index 저장
				tmpbyte[0] = bytes[j];
				strbyte = new String(tmpbyte);
				strChar = str.substring(i, i+1);
				
				if(strChar.equals(strbyte))	{
					//한글이 아님
					j++;
				}
				else {
					//한글
					j = j+2;
				}
			}
			
			int subLen = size;
			// 마지막 byte 가 깨진 글자인지 검사
			if(j-k == 2 && k == size-1)	{
				subLen = subLen-1;
			}
			byte[] bytesSize = new byte[subLen];
			System.arraycopy(bytes, 0, bytesSize, 0, subLen);
			str = new String(bytesSize);
		}
		else if (!where && str.getBytes("MS949").length == size ) {
			return str;
		}
		else if (!where && str.getBytes("MS949").length > size  && str.getBytes("MS949").length == str.length() ) {
			return str.substring(0,size);
		}
		
		if (where && str.length() >= size) {
			return str;
		}
		String res = null;
		StringBuffer sb = new StringBuffer();
		String tmpStr = null;
		int tmpSize = size - str.getBytes("MS949").length;

		for (int i = 0; i < size; i = i + padStr.length()) {
			sb.append(padStr);
		}
		tmpStr = sb.toString().substring(0, tmpSize);

		if(where)
			res = tmpStr.concat(str);
		else
			res = str.concat(tmpStr);
		
		return res;
	}

	private int convertInt(Object obj)	{
		String str = ObjUtils.getSafeString(obj, "0");
		if(str.indexOf(".") >=0)
			str= str.substring(0, str.indexOf("."));
		
		return ObjUtils.parseInt(str);
	}

	private List<Map<String, Object>> filterList(List<Map<String,Object>> list, String name, Object value)	{
		List<Map<String,Object>> rList = new ArrayList<Map<String,Object>>();
		for(Map<String, Object> map : list){
			if(map.get(name).equals(value))	{
				rList.add(map);
			}
		}
		return rList;
	}
	
}
