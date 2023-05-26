package foren.unilite.modules.matrl.mba;

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
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.matrl.mba.Mba020ukrvModel;


@Service("mba030ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Mba030ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;


	/**
	 * 단위환산등록
	 * @param param 재고단위
	 * @return
	 * @throws Exception
	 */
	//조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  select (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.select", param);
    }

    /**
     * 구매단가등록 마스터 조회
     * @param param 재고단위
     * @return
     * @throws Exception
     */
    //조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  select2 (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.select2", param);
    }

    /**
     * 구매단가등록 디테일 조회
     * @param param 재고단위
     * @return
     * @throws Exception
     */
    //조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  select2_1 (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.select2_1", param);
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {

        if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteDetail")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   }else if(dataListMap.get("method").equals("insertDetail")) {
                       insertList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateDetail")) {
                       updateList = (List<Map>)dataListMap.get("data");
                   }
               }
               if(deleteList != null) this.deleteDetail(deleteList, user);
               if(insertList != null) this.insertDetail(insertList, user);
               if(updateList != null) this.updateDetail(updateList, user);
           }
           paramList.add(0, paramMaster);

           return  paramList;
   }

   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
   public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
       for(Map param : paramList ) {
           super.commonDao.update("mba030ukrvServiceImpl.insertDetail", param);
       }
       return 0;
   }

   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
   public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
       for(Map param :paramList ) {
           super.commonDao.update("mba030ukrvServiceImpl.updateDetail", param);
       }
       return 0;
   }


   @ExtDirectMethod(group = "base", needsModificatinAuth = true)                   // DELETE
   public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
       for(Map param :paramList ) {
           super.commonDao.update("mba030ukrvServiceImpl.deleteDetail", param);
       }
       return 0;
   }

	/** 단위환산등록 여기까지 */








	/**
	 * 구매단가/거래처품목등록
	 * @param param
	 * @return
	 * @throws Exception
	 */

	/** 구매단가/거래처품목등록  여기까지 */








	/**
	 * 외주 P/L 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	//main 조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  select3_1 (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.select3_1", param);
    }

    /**
     * 외주 P/L 등록(대체품목)
     * @param param
     * @return
     * @throws Exception
     */
    //main 조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  select3_2 (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.select3_2", param);
    }

	//bomCopy 조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  bomCopySelectList (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.bomCopySelectList", param);
    }


	//기존 P/L 조회
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  custCopySelectList (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.bomCopySelectList", param);
    }


    //저장
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll3_1 (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertDetail3_1 = null;
			List<Map> updateDetail3_1 = null;
			List<Map> deleteDetail3_1 = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail3_1")) {
					insertDetail3_1 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail3_1")) {
					updateDetail3_1 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail3_1")) {
					deleteDetail3_1 = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteDetail3_1 != null) this.deleteDetail3_1(deleteDetail3_1, user, dataMaster);
			if(insertDetail3_1 != null) this.insertDetail3_1(insertDetail3_1, user, dataMaster);
			if(updateDetail3_1 != null) this.updateDetail3_1(updateDetail3_1, user, dataMaster);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	//insert
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertDetail3_1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{
				super.commonDao.insert("mba030ukrvServiceImpl.insertDetail3_1", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(e.getMessage());
		}

		return 0;
	}

	//update
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail3_1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			 for(Map param :paramList )	{
				 //수정할 데이터 존재여부 확인
				int checkCount = (int) super.commonDao.select("mba030ukrvServiceImpl.checkCount", param);
				if (checkCount != 0) {
					super.commonDao.update("mba030ukrvServiceImpl.updateDetail3_1", param);
				} else {
//					throw new  UniDirectValidateException("54622, 수정중인 자료가 삭제되었습니다.\n 재조회 후 작업하십시요.");
					throw new  UniDirectValidateException(this.getMessage("54622", user));
				}
			 }

		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("54622", user));
		}
		 return 0;
	}

	//delete
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail3_1(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{
			 try {
				int checkCount = (int) super.commonDao.select("mba030ukrvServiceImpl.checkCount", param);
				if (checkCount != 0) {
					super.commonDao.delete("mba030ukrvServiceImpl.deleteDetail3_1", param);
				} else {
//					throw new  UniDirectValidateException("54623, 삭제중인 자료가 이미 삭제되었습니다.\n 재조회 후 작업하십시요.");
					throw new  UniDirectValidateException(this.getMessage("54623", user));
				}

			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("54623",user));
	    	}
		 }
		 return 0;
	}

	//저장
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll3_2 (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

        if(paramList != null)   {
            List<Map> insertDetail3_2 = null;
            List<Map> updateDetail3_2 = null;
            List<Map> deleteDetail3_2 = null;

            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("insertDetail3_2")) {
                    insertDetail3_2 = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("updateDetail3_2")) {
                    updateDetail3_2 = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("deleteDetail3_2")) {
                    deleteDetail3_2 = (List<Map>)dataListMap.get("data");
                }
            }
            if(deleteDetail3_2 != null) this.deleteDetail3_2(deleteDetail3_2, user, dataMaster);
            if(insertDetail3_2 != null) this.insertDetail3_2(insertDetail3_2, user, dataMaster);
            if(updateDetail3_2 != null) this.updateDetail3_2(updateDetail3_2, user, dataMaster);
        }
        paramList.add(0, paramMaster);

        return  paramList;
    }

    //insert
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Integer insertDetail3_2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
        /* 데이터 insert */
        try {
            for(Map param : paramList ) {
                super.commonDao.insert("mba030ukrvServiceImpl.insertDetail3_2", param);
            }
        }catch(Exception e){
            throw new  UniDirectValidateException(e.getMessage());
        }

        return 0;
    }

    //update
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Integer updateDetail3_2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
        try {
             for(Map param :paramList ) {
                super.commonDao.update("mba030ukrvServiceImpl.updateDetail3_2", param);
             }

        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("54622", user));
        }
         return 0;
    }

    //delete
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Integer deleteDetail3_2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
         for(Map param :paramList ) {
             try {
                super.commonDao.delete("mba030ukrvServiceImpl.deleteDetail3_2", param);
             }catch(Exception e)    {
                    throw new  UniDirectValidateException(this.getMessage("54623",user));
            }
         }
         return 0;
    }


    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")      // UPDATE
    public Integer partListCopy(Map param, LoginVO user) throws Exception {
    	param.put("COMP_CODE", user.getCompCode());
    	param.put("USER_ID", user.getUserID());
        super.commonDao.update("mba030ukrvServiceImpl.partListCopy", param);

        return 0;
    }
	/** 외주 P/L 등록  여기까지 */








	/**
	 * 외주 기초재고등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	/* 기초년월 구하기 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectYYYYMM (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.selectYYYYMM", param);
    }

    /* 조회 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList4 (Map param) throws Exception {
        return  super.commonDao.list("mba030ukrvServiceImpl.selectList4", param);
    }

    /* 엑셀 */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("mba030ukrvServiceImpl.selectExcelUploadSheet1", param);
    }

    public void excelValidate(String jobID, Map param) {                            // 엑셀 Validate
        logger.debug("validate: {}", jobID);
        super.commonDao.update("mba030ukrvServiceImpl.excelValidate", param);
    }

    /**
     *  detail 저장
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll4 (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        Map<String, Object> spParam = new HashMap<String, Object>();
        List<Map> dataList = new ArrayList<Map>();
        String errorDesc = "";
        String keyValue = getLogKey();
        String oprFlag = null;
        if(paramList != null)   {
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("insertDetail4")) {
                	dataList = (List<Map>)dataListMap.get("data");
                	for(Map param:dataList ){
                		logger.debug("param: {}", param);
	                	oprFlag = "N";
	                	param.put("OPR_FLAG",oprFlag);
	                	param.put("KEY_VALUE" ,keyValue);
	                	super.commonDao.insert("mba030ukrvServiceImpl.insertDetail4", param);
                	}
                }else if(dataListMap.get("method").equals("updateDetail4")) {
                	dataList = (List<Map>)dataListMap.get("data");
                	for(Map param:dataList ){
                		logger.debug("param: {}", param);
	                	oprFlag = "U";
	                	param.put("OPR_FLAG",oprFlag);
	                	param.put("KEY_VALUE" ,keyValue);
	                	super.commonDao.insert("mba030ukrvServiceImpl.insertDetail4", param);
                	}
                } else if(dataListMap.get("method").equals("deleteDetail4")) {
                	dataList = (List<Map>)dataListMap.get("data");
                	for(Map param:dataList ){
                		logger.debug("param: {}", param);
	                	oprFlag = "D";
	                	param.put("OPR_FLAG",oprFlag);
	                	param.put("KEY_VALUE" ,keyValue);
	                	super.commonDao.insert("mba030ukrvServiceImpl.insertDetail4", param);
                	}
                }
            }
        }
        spParam.put("KEY_VALUE", keyValue);
        super.commonDao.queryForObject("mba030ukrvServiceImpl.insertSP", spParam);
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        paramList.add(0, paramMaster);

        return  paramList;
    }

    //insert
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Integer insertDetail4(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
        /* 데이터 insert */
        try {
            for(Map param : paramList ) {
            	param.put("CUSTOM_CODE", paramMaster.get("CUSTOM_CODE"));
                super.commonDao.insert("mba030ukrvServiceImpl.insertDetail4", param);
            }
        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("54622", user));
        }

        return 0;
    }

    //update
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Integer updateDetail4(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
        try {
             for(Map param :paramList ) {
             	param.put("CUSTOM_CODE", paramMaster.get("CUSTOM_CODE"));
                super.commonDao.update("mba030ukrvServiceImpl.updateDetail4", param);
             }

        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("54622", user));
        }
         return 0;
    }

    //delete
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public Integer deleteDetail4(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
         for(Map param :paramList ) {
             try {
             	param.put("CUSTOM_CODE", paramMaster.get("CUSTOM_CODE"));
                super.commonDao.delete("mba030ukrvServiceImpl.deleteDetail4", param);
             }catch(Exception e)    {
                    throw new  UniDirectValidateException(this.getMessage("54623",user));
            }
         }
         return 0;
    }

	/** 외주 기초재고등록  여기까지 */
}
