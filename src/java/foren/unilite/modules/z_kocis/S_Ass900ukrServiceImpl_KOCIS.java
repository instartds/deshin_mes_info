package foren.unilite.modules.z_kocis;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.swing.Spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_ass900ukrService_KOCIS")
@SuppressWarnings("rawtypes")
public class S_Ass900ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());
    public final static String FILE_TYPE_OF_PHOTO = "z_kocis";

	/**
	 *  고정자산등록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("s_ass900ukrServiceImpl_KOCIS.selectMaster", param);
	}
	
	
	/**
	 *  고정자산등록 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(S_Ass900ukrModel_KOCIS dataMaster, LoginVO user,  BindingResult result) throws Exception {		
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		spParam.put("S_COMP_CODE"		,user.getCompCode()					);
		spParam.put("S_USER_ID"			,user.getUserID()					);
		spParam.put("ITEM_CODE"			,dataMaster.getITEM_CODE()			);
		spParam.put("ITEM_NM"			,dataMaster.getITEM_NM()			);
		spParam.put("DEPT_CODE"			,dataMaster.getDEPT_CODE()			);
		spParam.put("DEPT_NAME"			,dataMaster.getDEPT_NAME()			);
		spParam.put("ADDR"				,dataMaster.getADDR()				);
		spParam.put("APP_USER"			,dataMaster.getAPP_USER()			);
		spParam.put("ACQ_AMT_I"			,dataMaster.getACQ_AMT_I()			);
		spParam.put("EXPECT_AMT_I"		,dataMaster.getEXPECT_AMT_I()		);
		spParam.put("INSUR_YN"			,dataMaster.getINSUR_YN()			);
		spParam.put("OPEN_YN"			,dataMaster.getOPEN_YN()			);
		spParam.put("REMARK"			,dataMaster.getREMARK()				);
		spParam.put("ITEM_DESC"			,dataMaster.getITEM_DESC()			);
		spParam.put("ITEM_GBN"			,dataMaster.getITEM_GBN()			);
		spParam.put("AUTHOR"			,dataMaster.getAUTHOR()				);
		spParam.put("AUTHOR_HO"			,dataMaster.getAUTHOR_HO()			);
		spParam.put("X_LENGTH"			,dataMaster.getX_LENGTH()			);
		spParam.put("Y_LENGTH"			,dataMaster.getY_LENGTH()			);
		spParam.put("Z_LENGTH"			,dataMaster.getZ_LENGTH()			);
		spParam.put("ITEM_DIR"			,dataMaster.getITEM_DIR()			);
		spParam.put("PURCHASE_WHY"		,dataMaster.getPURCHASE_WHY()		);
		spParam.put("VALUE_GUBUN"		,dataMaster.getVALUE_GUBUN()		);
		spParam.put("ITEM_STATE"		,dataMaster.getITEM_STATE()			);
		spParam.put("PURCHASE_DATE"		,dataMaster.getPURCHASE_DATE()		);
		spParam.put("ESTATE_AMT_I"		,dataMaster.getESTATE_AMT_I()		);
		spParam.put("SALES_AMT_I"		,dataMaster.getSALES_AMT_I()		);
		spParam.put("CLOSING_YEAR"		,dataMaster.getCLOSING_YEAR()		);
		spParam.put("FIRST_CHECK_YN"	,dataMaster.getFIRST_CHECK_YN()		);
		spParam.put("FIRST_CHECK_DATE"	,dataMaster.getFIRST_CHECK_DATE()	);
		spParam.put("FIRST_CHECK_DESC"	,dataMaster.getFIRST_CHECK_DESC()	);
		spParam.put("FIRST_CHECK_USR"	,dataMaster.getFIRST_CHECK_USR()	);
		spParam.put("SECOND_CHECK_YN"	,dataMaster.getSECOND_CHECK_YN()	);
		spParam.put("SECOND_CHECK_DATE"	,dataMaster.getSECOND_CHECK_DATE()	);
		spParam.put("SECOND_CHECK_DESC"	,dataMaster.getSECOND_CHECK_DESC()	);
		spParam.put("SECOND_CHECK_USR"	,dataMaster.getSECOND_CHECK_USR()	);
		//가로 x 세로 x 높이 입력
		//가로값이 있을 때
		if (ObjUtils.isNotEmpty(dataMaster.getX_LENGTH())) {
			//세로값이 있을 때
			if (ObjUtils.isNotEmpty(dataMaster.getY_LENGTH())) {
				//높이값이 있을 때
				if (ObjUtils.isNotEmpty(dataMaster.getZ_LENGTH())) {
					spParam.put("SPEC"				,dataMaster.getX_LENGTH() + 'x' + dataMaster.getY_LENGTH() + 'x' + dataMaster.getZ_LENGTH());
					
				//높이값이 없을 때
				} else {
					spParam.put("SPEC"				,dataMaster.getX_LENGTH() + 'x' + dataMaster.getY_LENGTH() + 'x' + "0");
				}

			//세로값이 없을 때		
			} else {
				//높이값이 있을 때
				if (ObjUtils.isNotEmpty(dataMaster.getZ_LENGTH())) {
					spParam.put("SPEC"				,dataMaster.getX_LENGTH() + 'x' + "0" + 'x' + dataMaster.getZ_LENGTH());
				
				//높이값이 없을 때
				} else {
					spParam.put("SPEC"				,dataMaster.getX_LENGTH() + 'x' + "0" + 'x' + "0");
				}
			}
			
		} else {
			//세로값이 있을 때
			if (ObjUtils.isNotEmpty(dataMaster.getY_LENGTH())) {
				//높이값이 있을 때
				if (ObjUtils.isNotEmpty(dataMaster.getZ_LENGTH())) {
					spParam.put("SPEC"				,"0" + 'x' + dataMaster.getY_LENGTH() + 'x' + dataMaster.getZ_LENGTH());
					
				//높이값이 없을 때
				} else {
					spParam.put("SPEC"				,"0" + 'x' + dataMaster.getY_LENGTH() + 'x' + "0");
				}

			//세로값이 없을 때		
			} else {
				//높이값이 있을 때
				if (ObjUtils.isNotEmpty(dataMaster.getZ_LENGTH())) {
					spParam.put("SPEC"				,"0" + 'x' + "0" + 'x' + dataMaster.getZ_LENGTH());
				
				//높이값이 없을 때
				} else {
					spParam.put("SPEC"				,"");
				}
			}
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
    	//자산코드 존재여부 확인
		Map checkData	= (Map) super.commonDao.select("s_ass900ukrServiceImpl_KOCIS.beforeSaveCheck", spParam);		//UPDATE, DELETE 경우 체크
		Map checkData1	= (Map) super.commonDao.select("s_ass900ukrServiceImpl_KOCIS.beforeInsertCheck", spParam);		//INSERT 경우 체크

		//신규입력(insert)일 경우,
		if(dataMaster.getSAVE_FLAG().equals("N")){

			if(ObjUtils.parseInt(checkData1.get("EXIST_YN")) != 0) {
				String error =  "2627;중복되는 자료가 입력 되었습니다.";
			    throw new  UniDirectValidateException(this.getMessage(error, user));		
			    
			} else {
				String autoNum = "";
					//자동채번
					Map getMaxNum = (Map) super.commonDao.select("s_ass900ukrServiceImpl_KOCIS.getMaxNum", spParam);
					
					//자동채번한 자산코드를 spParam에 추가하여 insert
					if(ObjUtils.isEmpty(getMaxNum.get("MAX_ITEM_CODE"))) {
						autoNum = (String) super.commonDao.select("s_ass900ukrServiceImpl_KOCIS.autoNum1", spParam);

					} else {
						autoNum = (String) super.commonDao.select("s_ass900ukrServiceImpl_KOCIS.autoNum2", spParam);
												
					}
					spParam.put("ITEM_CODE", autoNum);
					
					super.commonDao.insert("s_ass900ukrServiceImpl_KOCIS.insertForm", spParam);
					
					extResult.addResultProperty("ITEM_CODE", ObjUtils.getSafeString(autoNum));

			}
			
		//신규입력(insert)이 아닐 경우(수정 또는 삭제일 때 데이터 체크),
		} else if(ObjUtils.parseInt(checkData.get("EXIST_YN")) == 0) {
			String error =  "55306;참조된 데이터가 삭제되었습니다. \n 확인 후 작업하십시요.";
		    throw new  UniDirectValidateException(this.getMessage(error, user));	

		//수정(update)일 경우,
		} else if(dataMaster.getSAVE_FLAG().equals("U")){
			try {
				super.commonDao.update("s_ass900ukrServiceImpl_KOCIS.updateForm", spParam);
				
			}catch(Exception e){
				throw new  UniDirectValidateException("자료 저장 중 오류가 발생했습니다. \n 관리자에게 문의하시기 바랍니다.");
			}

		//삭제(delete)일 경우,
		} else if(dataMaster.getSAVE_FLAG().equals("D")){
			super.commonDao.update("s_ass900ukrServiceImpl_KOCIS.deleteForm", spParam);				
		}
		

		return extResult;
	}
	

	
	
    /**
     * 미술품내역등록 - 사진업로드
     * 
     * @param file1
     * @return
     * @throws IOException
     */
    //public ExtDirectFormPostResult photoUploadFile(@RequestParam("photoFile") MultipartFile file, @RequestParam("PERSON_NUMB") String personNumb) throws IOException, Exception {
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult photoUploadFile( @RequestParam( "photoFile" ) MultipartFile file, S_Ass900ukrModel_KOCIS param, LoginVO user ) throws IOException, Exception {
        
    	String itemCode = param.getITEM_CODE();
        
//    	ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();
            
            if (!"jpg".equals(fileExtension)) {
                throw new UniDirectValidateException("jpg 파일로 올려주세요.");
            }
            
            String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
            if (file.getSize() > 0) {
            	File tmpFile = new File(path);
            	//폴더가 존재하지 않을 경우, 폴더 생성
                if(!tmpFile.exists()) {
                    tmpFile.mkdirs();
                }
                tmpFile = new File(path + "/" + itemCode + '.' + fileExtension);
                file.transferTo(tmpFile);
                
        		Map<String, Object> spParam = new HashMap<String, Object>();
                spParam.put("S_COMP_CODE"	, user.getCompCode()		);
                spParam.put("S_USER_ID"		, user.getUserID()		);                
        		spParam.put("ITEM_CODE"		, param.getITEM_CODE()	);               
        		spParam.put("IMAGE_DIR"		, ObjUtils.getSafeString(tmpFile)	);

                logger.debug("IMAGE_DIR : " + spParam.get("IMAGE_DIR"));
                logger.debug("ITEM_CODE : " + spParam.get("ITEM_CODE"));
        		super.commonDao.update("s_ass900ukrServiceImpl_KOCIS.photoModified", spParam);
            }
            
        } else {
        	throw new UniDirectValidateException("등록할 사진을 선택해 주세요");
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;
    }
}
