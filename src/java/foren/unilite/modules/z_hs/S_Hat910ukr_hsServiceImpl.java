package foren.unilite.modules.z_hs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.DevFreeUtils;
import foren.unilite.utils.ExtFileUtils;


@Service("s_hat910ukr_hsService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Hat910ukr_hsServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private String DutyRule = "";
//	private Map<String, Object> dataMaster;

	/**
	 * 근태 기준 조회 (Y: 출퇴근 시간, N: 근무 시간)
	 * @param comp_code
	 * @return
	 * @throws Exception
	 */
	public String getDutyRule(String comp_code) throws Exception{
		DutyRule = (String) super.commonDao.selectByPk("S_Hat910ukr_hsServiceImpl.getDutyRule", comp_code);
		return DutyRule;
	}

	/** ----------미사용----------
	 * 전체 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getAllDutycode(Map param) throws Exception {
		return (List)super.commonDao.list("S_Hat910ukr_hsServiceImpl.getAllDutycode" ,param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List getDutycodeTime(Map param) throws Exception {
		return (List)super.commonDao.list("S_Hat910ukr_hsServiceImpl.getDutycodeTime" ,param);
	}

	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getDutycode(Map param) throws Exception {
		return (List)super.commonDao.list("S_Hat910ukr_hsServiceImpl.getDutycode" ,param);
	}

	/**
	 * 근태코드 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	public List getComboList(Map param) throws Exception {
//		return (List)super.commonDao.list("hat500ukrServiceImpl.getComboList" ,param);
//	}

	/**
	 * 근태구분 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getComboList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("S_Hat910ukr_hsServiceImpl.getComboList", param);
	}

	/**
	 * 근태구분 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getComboList2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("S_Hat910ukr_hsServiceImpl.getComboList2", param);
	}

	/**
	 * 근태 등록 목록 조회
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		List dutyCode = getDutycode(param);
		param.put("DUTY_CODE", dutyCode);
		logger.debug(param+"");
		return (List) super.commonDao.list("S_Hat910ukr_hsServiceImpl.selectList", param);
	}

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hat")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList);
			if(insertList != null) this.updateList(insertList);
			if(updateList != null) this.updateList(updateList);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * 근무조 등록 / 업데이트
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (DutyRule != "") {
				if (DutyRule.equals("Y")) {
					if(param.get("FLAG").equals("N")){
						super.commonDao.update("S_Hat910ukr_hsServiceImpl.insertList_DutyRule_Y", param);
					}else{
						super.commonDao.update("S_Hat910ukr_hsServiceImpl.updateList_DutyRule_Y", param);
					}
				} else {
					// 1.기존의 데이터를 모두 삭제
					super.commonDao.delete("S_Hat910ukr_hsServiceImpl.deleteList_DutyRule_N", param);
					// 2. 새로운 데이터를 다시 인서트 함
					param.put("DUTY_RULE", DutyRule);
					List<Map> dutyCode = getDutycode(param);
					for (Map item : dutyCode) {
						Map map = new HashMap();
						String index = (String) item.get("SUB_CODE");
						map.put("DUTY_YYYYMMDD"	, param.get("DUTY_YYYYMMDD"));
						map.put("PERSON_NUMB"	, param.get("PERSON_NUMB"));
						map.put("WORK_TEAM"		, param.get("WORK_TEAM"));
						map.put("S_USER_ID"		, param.get("S_USER_ID"));
						map.put("S_COMP_CODE"	, param.get("S_COMP_CODE"));
						map.put("DUTY_CODE"		, index);
						map.put("DUTY_NUM"		, param.get("TIMEN"+index).toString());
						map.put("DUTY_TIME"		, param.get("TIMET"+index).toString());
						map.put("DUTY_MINU"		, param.get("TIMEM"+index).toString());
						super.commonDao.insert("S_Hat910ukr_hsServiceImpl.insertList_DutyRule_N01", map);
					}
					// 3. 등록 안 된 근태 0값으로 인서트함
					super.commonDao.insert("S_Hat910ukr_hsServiceImpl.insertList_DutyRule_N02", param);
					// 4. 근태코드가 입력 된 경우 DUTY_NUM을 1로 수정함

					if (param.get("NUMN").equals("1") && param.get("NUMC") != "") {
						super.commonDao.update("S_Hat910ukr_hsServiceImpl.updateList_DutyRule_N", param);
					}
				}
				param.put("FLAG", "");
				param.put("HIDDEN_FLAG", "");
			}
		}
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> insertList(List<Map> paramList) throws Exception {
		return updateList(paramList);
	}
	/**
	 * 근무조 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (DutyRule != "") {
				if (DutyRule.equals("Y")) {
					super.commonDao.update("S_Hat910ukr_hsServiceImpl.deleteList_DutyRule_Y", param);
				} else {
					super.commonDao.update("S_Hat910ukr_hsServiceImpl.deleteList_DutyRule_N", param);
				}
			}
		}
		return paramList;
	}



	/**
	 * 체크버튼을 이용한 마감/취소 로직 추가 - 20200401 추가
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hat")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> procClosingAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("runClosing2")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) {
				for(Map insertListMap: insertList) {
					this.procClosing(insertListMap, user);
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "hat")
	public Object runClosing2(Map param, LoginVO user) throws Exception {
		return true;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "hat")
	public Object procClosing(Map param, LoginVO user) throws Exception {
		try {
			super.commonDao.update("S_Hat910ukr_hsServiceImpl.procClosing", param);
		} catch(Exception e) {
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		return true;
	}

	/**
	 * secom 업로드관련
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "template" )
	public Map secomUpload( Map param, LoginVO loginVO ) throws Exception {
		logger.debug("FILE_ID :: {}", param.get("FILE_ID"));
		logger.debug("CSV_LOAD_YN :: {}", param.get("CSV_LOAD_YN"));

		String filePath = ConfigUtil.getString("common.upload.txt");
		String FILE_ID = (String)param.get("FILE_ID");
		String PGM_ID = (String)param.get("PGM_ID");
		String txtFile = filePath + FILE_ID + ".bin";

		logger.debug("txtFile :: {}", txtFile);

		// CSV 업로드를 위한 30개 컬럼 TEMPLATE 테이블
		super.commonDao.update("configService.createCSV30", null);

		FileReader fin = null;
		BufferedReader in = null;
		BufferedReader in2 = null;
		List<Map> resultList = new ArrayList<Map>();

		FileInputStream fin2 = null;

		try {
			fin = new FileReader(txtFile);
			in = new BufferedReader(fin);

			fin2 = new FileInputStream(new File(txtFile));
			InputStreamReader isr = new InputStreamReader(fin2, "MS949");  // 한글 처리 - 박종영
			in2 = new BufferedReader(isr);

			Map<String, Object> iMap = null;

			String txtline = "";
			int row = 1;
			String keyValue = getLogKey();
			long start = System.currentTimeMillis();
			//while (( txtline = in.readLine() ) != null) {
			while (( txtline = in2.readLine() ) != null) {
				logger.debug("textline :: {}", txtline);
				if(txtline.trim().length() > 0) {
					String[] cols = txtline.split("\t");
					logger.debug("cols.length :: {}", cols.length);

					iMap = new HashMap<String, Object>();
					iMap.put("PGM_ID", PGM_ID);
					iMap.put("FILE_ID", FILE_ID);
					iMap.put("SEQ", row);
					iMap.put("S_COMP_CODE", loginVO.getCompCode());
					iMap.put("S_USER_ID", loginVO.getUserID());
					iMap.put("KEY_VALUE", keyValue);

					for (int i = 0; i < cols.length; i++) {
						iMap.put("COL" + DevFreeUtils.addZero("" + ( i + 1 ), 2), cols[i].replaceAll("\"", "").trim());
					}

					logger.debug("iMap :: ", iMap);
					super.commonDao.update("S_Hat910ukr_hsServiceImpl.insertTXT", iMap);

					row++;
				}
			}
			super.commonDao.update("S_Hat910ukr_hsServiceImpl.insertHAT", iMap);


			Map<String, Object> spParam = new HashMap<String, Object>();

			spParam.put("KEY_VALUE", keyValue);
			spParam.put("LANG_TYPE", loginVO.getLanguage());
			spParam.put("COMP_CODE", loginVO.getCompCode());
			spParam.put("LOGIN_ID"  , loginVO.getUserID());
			spParam.put("WORK_DATE", iMap.get("COL01"));

			super.commonDao.queryForObject("S_Hat910ukr_hsServiceImpl.insertSP", spParam);
			String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
			param.put("RETURN_DATE", ObjUtils.getSafeString(spParam.get("RETURN_DATE")));
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, loginVO));
			}
			long finish = System.currentTimeMillis();

			logger.debug("TEXT 파일 읽은 시간 :: " + ( finish - start ) + "ms");

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
		return param;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
				
		return super.commonDao.list("S_Hat910ukr_hsServiceImpl.selectExcelUploadSheet", param);
	}
	

	
	/**
	 * 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("S_Hat910ukr_hsServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}

	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
    public String runProcedure( Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("COMP_CODE"		, user.getCompCode());
        spParam.put("WORK_DATE"		, paramMaster.get("WORK_DATE"));
        spParam.put("LOGIN_ID"		, user.getUserID());
        spParam.put("KEY_VALUE"		, paramMaster.get("KEY_VALUE"));
        spParam.put("LANG_TYPE"		, user.getLanguage());
        super.commonDao.queryForObject("S_Hat910ukr_hsServiceImpl.insertSP", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
        return "Y";
    }

}