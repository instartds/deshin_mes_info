package foren.unilite.modules.z_jw;

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

@Service( "s_hat500ukr_jwService" )
public class S_hat500ukr_jwServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger   = LoggerFactory.getLogger(this.getClass());
    private String       DutyRule = "";

    /**
     * 그리드 조회
     *
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "template" )
    public List<Map<String, Object>> select( Map param, LoginVO loginVO ) throws Exception {

       
            return (List)super.commonDao.list("s_hat500ukr_jwServiceImpl.selectList", param);
//        } else {
//            String filePath = ConfigUtil.getString("common.upload.txt");
//            String FILE_ID = (String)param.get("FILE_ID");
//            String PGM_ID = (String)param.get("PGM_ID");
//            String txtFile = filePath + FILE_ID + ".bin";
//
//            logger.debug("txtFile :: {}", txtFile);
//
//            // CSV 업로드를 위한 30개 컬럼 TEMPLATE 테이블
//            super.commonDao.update("configService.createCSV30", null);
//
//            FileReader fin = null;
//            BufferedReader in = null;
//            BufferedReader in2 = null;
//            List<Map> resultList = new ArrayList<Map>();
//
//            FileInputStream fin2 = null;
//
//            try {
//                fin = new FileReader(txtFile);
//                in = new BufferedReader(fin);
//
//                fin2 = new FileInputStream(new File(txtFile));
//                InputStreamReader isr = new InputStreamReader(fin2, "MS949");
//                in2 = new BufferedReader(isr);
//
//                Map<String, Object> iMap = null;
//
//                String txtline = "";
//                int row = 1;
//                String keyValue = getLogKey();
//                long start = System.currentTimeMillis();
//                //while (( txtline = in.readLine() ) != null) {
//                while (( txtline = in2.readLine() ) != null) {
//                    logger.debug("textline :: {}", txtline);
//                    if (txtline.trim().length() > 0) {
//                        String[] cols = txtline.split("\t");
//                        logger.debug("cols.length :: {}", cols.length);
//
//                        iMap = new HashMap<String, Object>();
//                        iMap.put("PGM_ID", PGM_ID);
//                        iMap.put("FILE_ID", FILE_ID);
//                        iMap.put("SEQ", row);
//                        iMap.put("S_COMP_CODE", loginVO.getCompCode());
//                        iMap.put("S_USER_ID", loginVO.getUserID());
//                        iMap.put("KEY_VALUE", keyValue);
//
//                        for (int i = 0; i < cols.length; i++) {
//                            iMap.put("COL" + DevFreeUtils.addZero("" + ( i + 1 ), 2), cols[i].replaceAll("\"", "").trim());
//                        }
//
//                        logger.debug("iMap :: ", iMap);
//                        super.commonDao.update("s_hat500ukr_jwServiceImpl.insertTXT", iMap);
//
//                        row++;
//                    }
//
//                }
//                super.commonDao.update("s_hat500ukr_jwServiceImpl.insertHAT", iMap);
//
//                Map<String, Object> spParam = new HashMap<String, Object>();
//
//                spParam.put("KEY_VALUE", keyValue);
//                spParam.put("LANG_TYPE", loginVO.getLanguage());
//                spParam.put("COMP_CODE", loginVO.getCompCode());
//                spParam.put("LOGIN_ID", loginVO.getUserID());
//                spParam.put("WORK_DATE", iMap.get("COL03"));
//
//                //              spParam.put("S_USER_ID"  , loginVO.getUserID());
//                //                spParam.put("PERSON_NUMB", dataMaster.get("PERSON_NUMB"));
//                //                spParam.put("DUTY_GUBUN", dataMaster.get("DUTY_GUBUN"));
//                //                spParam.put("DUTY_TIME", dataMaster.get("DUTY_TIME"));
//                //                spParam.put("REPRE_NUM", dataMaster.get("REPRE_NUM"));
//                //
//
//                resultList = super.commonDao.list("s_hat500ukr_jwServiceImpl.insertSP", spParam);
//
//                //    			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
//                String errorDesc = (String)resultList.get(0).get("errorDesc");
//                Map<String, Object> dataMaster = (Map<String, Object>)param.get("data");
//
//                if (!ObjUtils.isEmpty(errorDesc)) {
//                    String[] messsage = errorDesc.split(";");
//                    throw new UniDirectValidateException(this.getMessage(messsage[0], loginVO));
//                }
//                long finish = System.currentTimeMillis();
//
//                logger.debug("TEXT 파일 읽은 시간 :: " + ( finish - start ) + "ms");
//
//            } catch (IOException e) {
//                e.printStackTrace();
//            } finally {
//                try {
//                    if (in != null) in.close();
//
//                    logger.debug("임시파일삭제.... 시작");
//                    ExtFileUtils.delFile(filePath + FILE_ID + ".bin");
//                    ExtFileUtils.delFile(filePath + FILE_ID + ".txt");
//                    logger.debug("임시파일삭제.... 종료");
//                } catch (IOException ex) {
//                    ex.printStackTrace();
//                }
//            }

//            return (List)resultList;
//        }
    }

    /**
     * 근태 기준 조회 (Y: 출퇴근 시간, N: 근무 시간)
     *
     * @param comp_code
     * @return
     * @throws Exception
     */
    public String getDutyRule( String comp_code ) throws Exception {
        DutyRule = (String)super.commonDao.selectByPk("s_hat500ukr_jwServiceImpl.getDutyRule", comp_code);
        return DutyRule;
    }

    /**
     * ----------미사용---------- 전체 근태코드 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    public List getAllDutycode( Map param ) throws Exception {
        return (List)super.commonDao.list("s_hat500ukr_jwServiceImpl.getAllDutycode", param);
    }

    /**
     * 근태코드 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    public List getDutycode( Map param ) throws Exception {
        return (List)super.commonDao.list("s_hat500ukr_jwServiceImpl.getDutycode", param);
    }

    /**
     * 근태코드 콤보박스 리스트 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    //	public List getComboList(Map param) throws Exception {
    //		return (List)super.commonDao.list("s_hat500ukr_jwServiceImpl.getComboList" ,param);
    //	}
    /**
     * 근태구분 콤보박스 리스트 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ )
    public List<ComboItemModel> getComboList( Map param ) throws Exception {
        return (List<ComboItemModel>)super.commonDao.list("s_hat500ukr_jwServiceImpl.getComboList", param);

    }

    /**
     * 근태 등록 목록 조회
     *
     * @param param
     * @param loginVO
     * @return
     * @throws Exception
     */
    @Transactional( readOnly = true )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hat" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {

        //		List dutyCode = getDutycode(param);
        //		param.put("DUTY_CODE", dutyCode);
        //		logger.debug(param+"");
        return (List)super.commonDao.list("s_hat500ukr_jwServiceImpl.selectList", param);
    }

    /**
     * 저장
     *
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hat" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {

        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteList(deleteList);
            if (updateList != null) this.updateList(updateList);
            if (insertList != null) this.insertList(insertList, user);
        }
        paramList.add(0, paramMaster);

        return paramList;
    }

    /**
     * 선택된 행을 추가함
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hat" )
    public List<Map> insertList( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("s_hat500ukr_jwServiceImpl.insertList", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return paramList;
    }


    /**
     * 근무조 등록 / 업데이트
     *
     * @param paramList
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hat" )
    public List<Map> updateList( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("s_hat500ukr_jwServiceImpl.updateList", param);
        }
        return paramList;
    }

    /**
     * 근무조 삭제
     *
     * @param paramList
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hat" )
    public List<Map> deleteList( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.delete("s_hat500ukr_jwServiceImpl.deleteList", param);
        }
        return paramList;
    }

    /**
	 * 데이터 일괄생성
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
   	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})

   	public Map<String, Object> procSP( Map param, LoginVO user ) throws Exception {

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("COMP_CODE", user.getCompCode());
		spParam.put("DUTY_DATE", param.get("DUTY_DATE"));
		spParam.put("KEY_VALUE", "");
		spParam.put("LOGIN_ID", user.getUserID());
		spParam.put("LANG_TYPE", user.getLanguage());
		spParam.put("RE_TRY", param.get("RE_TRY"));

		super.commonDao.queryForObject("s_hat500ukr_jwServiceImpl.procSP", spParam);

		return spParam;
	}
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public String selectExcelUploadSheet1(Map<String, Object> param, LoginVO loginVO) throws Exception {
    	logger.debug("validate: {}", param);
        String dutyDate = (String) super.commonDao.select("s_hat500ukr_jwServiceImpl.selectExcelUploadSheet1", param);
        String keyValue = (String) super.commonDao.select("s_hat500ukr_jwServiceImpl.selectExcelUploadSheet2", param);
		    	param.put("COMP_CODE", loginVO.getCompCode());
		    	param.put("LOGIN_ID", loginVO.getUserID());
		    	param.put("KEY_VALUE", keyValue);
		    	param.put("WORK_DATE", dutyDate);
		    	param.put("LANG_TYPE", loginVO.getLanguage());
		    	
		        Map ErrorMap = (Map) super.commonDao.select("s_hat500ukr_jwServiceImpl.insertSP",param);
		        if(!ObjUtils.isEmpty(ErrorMap.get("errorDesc"))){
		    	   throw new  UniDirectValidateException(this.getMessage((String)ErrorMap.get("errorDesc"),loginVO ));
		        }
		    	

    	return dutyDate;

    }
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_hat500ukr_jwServiceImpl.getData", param);

		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  {
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("PERSON_NUMB", data.get("PERSON_NUMB"));

			}
		}
	}
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectDutycode(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_hat500ukr_jwServiceImpl.selectDutycode" ,comp_code);
	}

}
