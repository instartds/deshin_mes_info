package foren.unilite.modules.z_kd;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.utils.DevFreeUtils;
import foren.unilite.utils.ExtFileUtils;


@Service("s_str900ukrv_kdService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_str900ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger  = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	
	/**
	 * 입고일에따른 출고일 계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOutDate(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.selectOutDate", param);
	}

	/**
	 * 출고등록(검수용) 조회(TEMP)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)	// 조회(temp)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.selectList", param);
	}



	/**
	 * 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kd")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramMaster:" + paramMaster);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
		dataMaster.put("COMP_CODE", user.getCompCode());
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateDetail(updateList, user);
			if(deleteList != null) this.deleteDetail(deleteList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")		  // UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		for(Map param :paramList ) {	
			super.commonDao.update("s_str900ukrv_kdService.updateDetail", param);
		}
		return 0;
	}

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_kd", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{
			//1 디테일 삭제
			String pReqNum2 = (String)super.commonDao.select("s_str900ukrv_kdService.beforeDeleteCheck", param);
			if(ObjUtils.isEmpty(pReqNum2)) {
				super.commonDao.delete("s_str900ukrv_kdService.deleteDetail", param); 
			} else {
			}
		}
		return 0;
	}



	/**
	 * 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)	// 엑셀 업로드
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.selectExcelUploadSheet1", param);
	}

	public void excelValidate(String jobID, Map param) throws Exception {					// 엑셀 Validate
		logger.debug("validate: {}", jobID);
		super.commonDao.update("s_str900ukrv_kdService.excelValidate", param);
		
//		try{
//			super.commonDao.list("s_str900ukrv_kdService.insertSBtr900tKd", param);
//		}catch(Exception e){
//			throw e;
//		}
		return;
		
	}

	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)	// 엑셀t -> s_btr900t_kd
	public List<Map<String, Object>> insertSBtr900tKd(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.insertSBtr900tKd", param);
	}

	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)	// 결과COUNT
	public List<Map<String, Object>> selectResultCount(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.selectResultCount", param);
	}

	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)	// 결과COUNT2
	public List<Map<String, Object>> selectResultCount2(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.selectResultCount2", param);
	}

	@ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)	// excel조회
	public List<Map<String, Object>> selectExcel(Map param) throws Exception {
		return super.commonDao.list("s_str900ukrv_kdService.selectExcel", param);
	}



	/**
	 * CSV업로드
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "template" )
	public List<Map<String, Object>> select( Map param, LoginVO loginVO ) throws Exception {
		logger.debug("FILE_ID :: {}", param.get("FILE_ID"));
		logger.debug("CSV_LOAD_YN :: {}", param.get("CSV_LOAD_YN"));
		if ("N".equals((String)param.get("CSV_LOAD_YN"))) {
			return (List)super.commonDao.list("s_str900ukrv_kdService.selectList", param);
		} else {
			String filePath = ConfigUtil.getString("common.upload.csv");
			String FILE_ID = (String)param.get("FILE_ID");
			String PGM_ID = (String)param.get("PGM_ID");
			String csvFile = filePath + FILE_ID + ".bin";
			logger.debug("csvFile :: {}", csvFile);

			// CSV 업로드를 위한 30개 컬럼 TEMPLATE 테이블
			super.commonDao.update("s_str900ukrv_kdService.createCSV", null);

			FileReader fin = null;
			BufferedReader in = null;

			try {
				fin = new FileReader(csvFile);
				in = new BufferedReader(fin);
				Map<String, Object> iMap = null;
				String csvline = "";
				int row = 1;

				long start = System.currentTimeMillis();
				while (( csvline = in.readLine() ) != null) {
					logger.debug("csvline :: {}", csvline);
					if(csvline.trim().length() > 0) {
						String[] cols = csvline.split(",");
						logger.debug("cols.length :: {}", cols.length);
						
						iMap = new HashMap<String, Object>();
						iMap.put("PGM_ID", PGM_ID);
						iMap.put("FILE_ID", FILE_ID);
						iMap.put("COMP_CODE", loginVO.getCompCode());
						
						for (int i = 0; i < cols.length; i++) {
							iMap.put("COL" + DevFreeUtils.addZero("" + ( i + 1 ), 2), cols[i].replaceAll("\"", "").trim());
						}
						
						logger.debug("iMap :: ", iMap);
						
						super.commonDao.update("s_str900ukrv_kdService.insertTempCsv", iMap);
						super.commonDao.update("s_str900ukrv_kdService.csvValidate", iMap);
						
						row++;
					}
				}
				iMap.put("FILE_TYPE", ObjUtils.getSafeString(iMap.get("FILE_TYPE")));
				
				
//				super.commonDao.update("s_str900ukrv_kdService.insertCSV", iMap);
				
				param.put("FILE_ID", iMap.get("FILE_ID"));
				param.put("COL04", iMap.get("COL04"));
				
				long finish = System.currentTimeMillis();
				logger.debug("CSV 파일 읽은 시간 :: " + ( finish - start ) + "ms");
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (in != null) in.close();
					logger.debug("임시파일삭제.... 시작");
					ExtFileUtils.delFile(filePath + FILE_ID + ".bin");
					ExtFileUtils.delFile(filePath + FILE_ID + ".txt");
					logger.debug("임시파일삭제.... 종료");
				} catch (IOException ex) {
					ex.printStackTrace();
				}
			}
			return (List)super.commonDao.list("s_str900ukrv_kdService.csvSelect", param);
		}
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
	public Object autoOutTrans(Map spParam, LoginVO user) throws Exception {
		super.commonDao.queryForObject("s_str900ukrv_kdService.USP_SALES_AutoOutTrans_KD", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return spParam;
		}
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
	public void deleteTemp(Map spParam, LoginVO user) throws Exception {

		super.commonDao.delete("s_str900ukrv_kdService.deleteTemp", spParam);

	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
	public Object autoOutTrans2(Map spParam, LoginVO user) throws Exception {
		

//		super.commonDao.insert("s_str900ukrv_kdService.insertSBtr900tKd", spParam);
		
		super.commonDao.queryForObject("s_str900ukrv_kdService.sptest1", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		
		return spParam;
		
	}
	
	
	
	
}