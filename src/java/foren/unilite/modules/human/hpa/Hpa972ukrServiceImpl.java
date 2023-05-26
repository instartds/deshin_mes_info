package foren.unilite.modules.human.hpa;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
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
import foren.unilite.com.tags.ComboItemModel;

@Service("hpa972ukrService")
public class Hpa972ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 지급명세서 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> fnCheckData( Map param, LoginVO user ) throws Exception {
		return super.commonDao.list("hpa972ukrServiceImpl.selectListC", param);
	}

	/**
	 * 간이지급명세서(근로소득) 신고자료 생성
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public FileDownloadInfo doBatch(Map param) throws Exception {
		FileDownloadInfo fInfo = null;
		
		List<Map<String,Object>> listA = super.commonDao.list("hpa972ukrServiceImpl.selectListA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpa972ukrServiceImpl.selectListB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpa972ukrServiceImpl.selectListC", param);
		
		if(listA != null && listA.size() > 0)	{
			Map<String, Object> map = listA.get(0);
			String fileName = ObjUtils.getSafeString(map.get("TAX_DT")) + ObjUtils.getSafeString(map.get("DOC_COD")) + ".1";
			
			File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
			if(!dir.exists())  dir.mkdir();
			fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), fileName);
			logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
			FileOutputStream fos = new FileOutputStream(fInfo.getFile());
			
			String data = "";
			byte[] bytesArray = data.getBytes("EUC-KR");
			
			for(Map<String, Object> mapA : listA) {

				//Map<String, Object> mapA = listA.get(0);
				data = this.csformat(mapA.get("DATA_DIV"), 2)
					 + this.csformat(mapA.get("DOC_COD"), 7)
					 + this.csformat(mapA.get("SIDO_COD"), 2)
					 + this.csformat(mapA.get("SGG_COD"), 3)
					 + this.csformat(mapA.get("LDONG_COD"), 5)
					 + this.csformat(mapA.get("TAX_ITEM"), 6)
					 + this.csformat(mapA.get("TAX_YYMM"), 6)
					 + this.csformat(mapA.get("TAX_DIV"), 1)
					 + this.csformat(mapA.get("REQ_DIV"), 1)
					 + this.csformat(mapA.get("TAX_DT"), 8)
					 + this.csformat(mapA.get("TPR_COD"), 2)
					 + this.csformat(mapA.get("REG_NO"), 13)
					 + this.csformat(mapA.get("REG_NM"), 80)
					 + this.csformat(mapA.get("BIZ_NO"), 10)
					 + this.csformat(mapA.get("CMP_NM"), 80)
					 + this.csformat(mapA.get("BIZ_ZIP_NO"), 6)
					 + this.csformat(mapA.get("BIZ_ADDR"), 200)
					 + this.csformat(mapA.get("BIZ_TEL"), 30)
					 + this.csformat(mapA.get("MO_TEL"), 30)
					 + this.csformat(mapA.get("SUP_YYMM"), 6)
					 + this.csformat(mapA.get("RVSN_YYMM"), 6)
					 + this.csformat(mapA.get("F_DUE_DT"), 8)
					 + this.csformat(mapA.get("DUE_DT"), 8)
					 + this.cnformat(mapA.get("TAX_RT"), 2) + "000"
					 + this.cnformat(mapA.get("TOT_STD_AMT"), 15)
					 + this.cnformat(mapA.get("PAY_RSTX"), 15)
					 + this.csformat(mapA.get("ADTX_YN"), 1)
					 + this.cnformat(mapA.get("ADTX_AM"), 15)
					 + this.cnformat(mapA.get("DLQ_ADTX"), 15)
					 + this.cnformat(mapA.get("DLQ_CNT"), 4)
					 + this.cnformat(mapA.get("PAY_ADTX"), 15)
					 + this.csformat(mapA.get("MEMO"), 100)
					 + this.cnformat(mapA.get("ADD_MM_RTN"), 15)
					 + this.cnformat(mapA.get("ADD_MM_AAMT"), 15)
					 + this.cnformat(mapA.get("ADD_YY_TRTN"), 15)
					 + this.cnformat(mapA.get("ADD_YY_TAMT"), 15)
					 + this.cnformat(mapA.get("ADD_ETC_RTN"), 15)
					 + this.cnformat(mapA.get("ADD_RDT_ADTX"), 15)
					 + this.cnformat(mapA.get("ADD_RDT_AADD"), 15)
					 + this.cnformat(mapA.get("ADD_SUM_RTN"), 15)
					 + this.cnformat(mapA.get("ADD_SUM_AAMT"), 15)
					 + this.cnformat(mapA.get("ADD_OUT_AMT"), 15)
					 + this.cnformat(mapA.get("ADD_TOT_AMT"), 15)
					 + this.cnformat(mapA.get("INTX"), 15)
					 + this.cnformat(mapA.get("TOT_ADTX"), 15)
					 + this.cnformat(mapA.get("ADD_OUT_SAMT"), 15)
					 + this.csformat(mapA.get("MINU_YN"), 1)
					 + this.csformat(mapA.get("RPT_REG_NO"), 13)
					 + this.csformat(mapA.get("RPT_NM"), 80)
					 + this.csformat(mapA.get("RPT_BIZ_NO"), 10)
					 + this.csformat(mapA.get("RPT_TEL"), 30)
					 + this.csformat(mapA.get("TAX_PRO_CD"), 4)
					 + this.csformat(mapA.get("A_SPACE"), 27);
				data += "\r\n";
				bytesArray = data.getBytes("EUC-KR");
				fos.write(bytesArray);
				
				String divCode = ObjUtils.getSafeString(mapA.get("DIV_CODE"));
				List<Map<String,Object>> subListB = this.filterList(listB, "DIV_CODE", divCode);
				List<Map<String,Object>> subListC = this.filterList(listC, "DIV_CODE", divCode);

				//소득구분목록
				for(Map<String,Object> mapB : subListB) {
					data = this.csformat(mapB.get("DATA_DIV"), 2)
						 + this.csformat(mapB.get("DOC_COD"), 7)
						 + this.csformat(mapB.get("TXTP_CD"), 2)
						 + this.cnformat(mapB.get("TXTP_EMP"), 8)
						 + this.cnformat(mapB.get("TXTP_STD"), 15)
						 + this.cnformat(mapB.get("TXTP_INTX"), 15);
					data += "\r\n";
					bytesArray = data.getBytes("EUC-KR");
					fos.write(bytesArray);

					String txtpCd = ObjUtils.getSafeString(mapB.get("TXTP_CD"));
					List<Map<String,Object>> subListC2 = this.filterList(subListC, "TXTP_CD", txtpCd);

					//소득자목록
					int cI = 1;
					for(Map<String,Object> mapC : subListC2)	{
	
						data = this.csformat(mapC.get("DATA_DIV"), 2)
							 + this.csformat(mapC.get("DOC_COD"), 7)
							 + this.cnformat(cI, 6)
							 + this.csformat(mapC.get("TXTP_CD"), 2)
							 + this.csformat(mapC.get("D_JING"), 8)
							 + this.csformat(mapC.get("REG_NM"), 30)
							 + this.csformat(mapC.get("REG_NO"), 13)
							 + this.cnformat(mapC.get("TAX_STD"), 15)
							 + this.cnformat(mapC.get("CALCUL_TX"), 15)
							 + this.cnformat(mapC.get("ADJ_TAX"), 15)
							 + this.cnformat(mapC.get("PAY_TAX"), 15)
							 + this.csformat(mapC.get("DTL_NOTE"), 300);
						data += "\r\n";
						bytesArray = data.getBytes("EUC-KR");
						fos.write(bytesArray);
						cI++;
					}
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
		
		if (!where && str.getBytes("EUC-KR").length > size && str.getBytes("EUC-KR").length != str.length()) {
			byte[] bytes = str.getBytes("EUC-KR");
			String strbyte=null, strChar=null;
			int j=0, k=0;
			
			for(int i=0; (i < str.length() && j < size) ; i++) {
				byte[] tmpbyte = new byte[1];
				k=j;	// 마지막 index 저장
				tmpbyte[0] = bytes[j];
				strbyte = new String(tmpbyte, "EUC-KR");
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
			str = new String(bytesSize, "EUC-KR");
		}
		else if (!where && str.getBytes("EUC-KR").length == size ) {
			return str;
		}
		else if (!where && str.getBytes("EUC-KR").length > size  && str.getBytes("EUC-KR").length == str.length() ) {
			return str.substring(0,size);
		}
		
		if (where && str.length() >= size) {
			return str;
		}
		String res = null;
		StringBuffer sb = new StringBuffer();
		String tmpStr = null;
		int tmpSize = size - str.getBytes("EUC-KR").length;

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
	
	public List<ComboItemModel> getBussOfficeCode(Map param) throws Exception {
		return (List<ComboItemModel>)super.commonDao.list("hpc952ukrServiceImpl.getBussOfficeCode" ,param);
	}
}
