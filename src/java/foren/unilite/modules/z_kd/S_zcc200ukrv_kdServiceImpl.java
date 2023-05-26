package foren.unilite.modules.z_kd;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_zcc200ukrv_kdService")
public class S_zcc200ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;

	/**
	 *   조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.selectList", param);
    }

    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.selectList2", param);
    }

    /**
     * 내역생성
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> createList1(Map param, LoginVO user) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.createList1", param);
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> createList2(Map param, LoginVO user) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.createList2", param);
    }

	/**
     *  검색팝업창 조회
     *
     * @param param
     * @return
     * @throws Exception
     */

    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 검색팝업창 조회 */
    public List<Map<String, Object>> selectEstNumList(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.selectEstNumList", param);
    }

    /**
     *  의뢰번호 조회(중복검사)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 의뢰번호 조회(중복검사) */
    public List<Map<String, Object>> selectMasterCheck(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.selectMasterCheck", param);
    }

    /**
     *  디테일 없을시 마스터 같이 삭제
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 디테일 없을시 마스터 같이 삭제 */
    public List<Map<String, Object>> beforeDeleteCheck(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.beforeDeleteCheck", param);
    }

    /**
     *  저장
     *
     * @param param
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
	    logger.debug("[saveAll] paramMaster:" + paramMaster);
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        dataMaster.put("COMP_CODE", user.getCompCode());

        String pEstNum = (String) dataMaster.get("EST_NUM");
        logger.debug("[saveAll] pEstNum1111111111111111111111111:" + pEstNum);
        if (ObjUtils.isEmpty(dataMaster.get("EST_NUM") )) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            spParam.put("TABLE_ID","s_zcc200ukrv_kd");
            spParam.put("PREFIX", "E");
            spParam.put("BASIS_DATE", dateGetString);
            spParam.put("AUTO_TYPE", "1");

            super.commonDao.queryForObject("s_zcc200ukrv_kdService.spAutoNum", spParam);
            List<Map>paramDetail = (List<Map>) paramList.get(0).get("data");
            dataMaster.put("EST_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
            pEstNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
            super.commonDao.insert("s_zcc200ukrv_kdService.insertMaster", dataMaster);

        } else {
        	if (ObjUtils.isNotEmpty(super.commonDao.select("s_zcc200ukrv_kdService.selectMasterCheck", dataMaster))){
        		super.commonDao.insert("s_zcc200ukrv_kdService.updateMaster", dataMaster);
        	}
        }

        if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteDetail")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateDetail")) {
                       updateList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("insertDetail")) {
                       insertList = (List<Map>)dataListMap.get("data");
                   }
               }
               if(deleteList != null) this.deleteDetail(deleteList, user);
               if(updateList != null) this.updateDetail(updateList, user);
               if(insertList != null) this.insertDetail(insertList, paramMaster, user, pEstNum);
           }

           dataMaster.put("EST_NUM", pEstNum);

           paramList.add(0, paramMaster);

           return  paramList;
   }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user, String pEstNum) throws Exception {
        Map compCodeMap = new HashMap();
        int i = 0;
        for(Map param :paramList ) {
            if(ObjUtils.isEmpty(param.get("EST_NUM"))) {
                param.put("EST_NUM", pEstNum);
                i++;
            } else {
                param.put("EST_NUM", pEstNum);
            }
            super.commonDao.update("s_zcc200ukrv_kdService.insertDetail", param);
        }
        return 0;
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        Map compCodeMap = new HashMap();
        for(Map param :paramList ) {
            super.commonDao.update("s_zcc200ukrv_kdService.updateDetail", param);
        }
        return 0;
    }

    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail (List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList) {
            //1 디테일 삭제
            super.commonDao.delete("s_zcc200ukrv_kdService.deleteDetail", param);

            //2 체크
            String pEstNum2 = (String)super.commonDao.select("s_zcc200ukrv_kdService.beforeDeleteCheck", param);
            if(ObjUtils.isEmpty(pEstNum2)) {
                //3 디테일 없으면 마스터 삭제
                super.commonDao.delete("s_zcc200ukrv_kdService.deleteMaster", param);
            } else {

            }
        }
        return 0;
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramMaster:" + paramMaster);
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        dataMaster.put("COMP_CODE", user.getCompCode());

        String pEstNum = (String) dataMaster.get("EST_NUM");
        logger.debug("[saveAll] pEstNum1111111111111111111111111:" + pEstNum);
        if (ObjUtils.isEmpty(dataMaster.get("EST_NUM") )) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            spParam.put("TABLE_ID","s_zcc200ukrv_kd");
            spParam.put("PREFIX", "E");
            spParam.put("BASIS_DATE", dateGetString);
            spParam.put("AUTO_TYPE", "1");

            super.commonDao.queryForObject("s_zcc200ukrv_kdService.spAutoNum", spParam);
            List<Map>paramDetail = (List<Map>) paramList.get(0).get("data");
            String gwFlag = (String) paramDetail.get(0).get("GW_FLAG");
            dataMaster.put("GW_FLAG",   gwFlag);
            dataMaster.put("EST_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
            pEstNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
            super.commonDao.insert("s_zcc200ukrv_kdService.insertMaster", dataMaster);

        } else {
        	if (ObjUtils.isNotEmpty(super.commonDao.select("s_zcc200ukrv_kdService.selectMasterCheck", dataMaster))){
        		super.commonDao.insert("s_zcc200ukrv_kdService.updateMaster", dataMaster);
        	}
        }

        if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteDetail2")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateDetail2")) {
                       updateList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("insertDetail2")) {
                       insertList = (List<Map>)dataListMap.get("data");
                   }
               }
               if(deleteList != null) this.deleteDetail2(deleteList, user);
               if(updateList != null) this.updateDetail2(updateList, user);
               if(insertList != null) this.insertDetail2(insertList, paramMaster, user, pEstNum);
           }

           dataMaster.put("EST_NUM", pEstNum);

           paramList.add(0, paramMaster);

           return  paramList;
   }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user, String pEstNum) throws Exception {
        Map compCodeMap = new HashMap();
        int i = 0;
        for(Map param :paramList ) {
            if(ObjUtils.isEmpty(param.get("EST_NUM"))) {
                param.put("EST_NUM", pEstNum);
                i++;
            } else {
                param.put("EST_NUM", pEstNum);
            }
            super.commonDao.update("s_zcc200ukrv_kdService.insertDetail", param);
        }
        return 0;
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
        Map compCodeMap = new HashMap();
        for(Map param :paramList ) {
            super.commonDao.update("s_zcc200ukrv_kdService.updateDetail", param);
        }
        return 0;
    }

    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail2 (List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList) {
            //1 디테일 삭제
            super.commonDao.delete("s_zcc200ukrv_kdService.deleteDetail", param);

            //2 체크
            String pEstNum2 = (String)super.commonDao.select("s_zcc200ukrv_kdService.beforeDeleteCheck", param);
            if(ObjUtils.isEmpty(pEstNum2)) {
                //3 디테일 없으면 마스터 삭제
                super.commonDao.delete("s_zcc200ukrv_kdService.deleteMaster", param);
            } else {

            }
        }
        return 0;
    }
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 전년도 자료삭제
	public List<Map<String, Object>>  deleteMaster_t(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.deleteMaster", param);
    }
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 전년도 자료삭제
	public List<Map<String, Object>>  deleteDetail_t(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.deleteDetail_t", param);
    }

    @ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> calcYN(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.calcYN", param);
    }

    @ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> existsYN(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.existsYN", param);
    }

    /**
	 *   그리드1 초기화
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회1 */
    public List<Map<String, Object>> selectResetList1(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.selectResetList1", param);
    }

	/**
	 *  그리드2초기화
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회 2*/
    public List<Map<String, Object>> selectResetList2(Map param) throws Exception {
        return super.commonDao.list("s_zcc200ukrv_kdService.selectResetList2", param);
    }

	/**
	 * 마스터정보 업데이트
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object updateMasterInfo(Map spParam, LoginVO user) throws Exception {
		super.commonDao.update("s_zcc200ukrv_kdService.updateMaster", spParam);
		return true;
	}
}
