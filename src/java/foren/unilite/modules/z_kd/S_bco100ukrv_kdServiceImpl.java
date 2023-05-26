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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_bco100ukrv_kdService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_bco100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;


	/**
     *
     * 사원의 해당부서 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectPersonDept(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectPersonDept", param);
    }

    /**
     *
     * 거래처의 해당결제조건/운송방법 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectCustomData(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectCustomData", param);
    }

    /**
     *
     * 마스터 기안상태 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectGwData", param);
    }

	/**
	 *  입력데이타형태입력 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 조회 */
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectList", param);
    }

	/**
     *  검색팝업창 조회
     *
     * @param param
     * @return
     * @throws Exception
     */

    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 검색팝업창 조회 */
    public List<Map<String, Object>> selectReqNumList(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectReqNumList", param);
    }

    /**
     *  기존의뢰번호 조회
     *
     * @param param
     * @return
     * @throws Exception
     */

    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 기존의뢰번호 조회 */
    public List<Map<String, Object>> copyReqNumList(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.copyReqNumList", param);
    }

    /**
     *  품목복사 조회
     *
     * @param param
     * @return
     * @throws Exception
     */

    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 품목복사 조회 */
    public List<Map<String, Object>> selectPreSeqList(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectPreSeqSelect", param);
    }

    /**
     *  최근단가
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 품목복사 조회 */
    public List<Map<String, Object>> fnGetLastPriceInfo(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.fnGetLastPriceInfo", param);
    }

//    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
//    public Object  fnGetLastPriceInfo(List<Map> paramList, Map<String, String> param, LoginVO user) throws Exception {
//        List<Map> dataList = new ArrayList<Map>();
//        for(Map paramData: paramList) {
//            dataList = (List<Map>) paramData.get("data");
//            super.commonDao.queryForObject("s_bco100ukrv_kdService.fnGetLastPriceInfo", param);
//            String itemP = ObjUtils.getSafeString(param.get("ITEM_P"));
//            String priceType = ObjUtils.getSafeString(param.get("PRICE_TYPE"));
//            for(Map param1: paramList)  {
//                dataList = (List<Map>)param1.get("data");
//                List<Map> datas = (List<Map>)param1.get("data");
//                for(Map data: datas){
//                    data.put("ITEM_P", itemP);
//                    data.put("PRICE_TYPE", priceType);
//                }
//            }
//        }
//        paramList.add(0, param);
//
//        return  paramList;
//    }

    /**
     *  의뢰번호 조회(중복검사)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 의뢰번호 조회(중복검사) */
    public List<Map<String, Object>> selectMasterCheck(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.selectMasterCheck", param);
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
        return super.commonDao.list("s_bco100ukrv_kdService.beforeDeleteCheck", param);
    }

    /**
     *  기안버튼 눌렀을때 번호생성(UPDATE)
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 기안버튼 눌렀을때 번호생성(UPDATE) */
    public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
        return super.commonDao.list("s_bco100ukrv_kdService.makeDraftNum", param);
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

        String pReqNum = (String) dataMaster.get("P_REQ_NUM");
        logger.debug("[saveAll] pReqNum1111111111111111111111111:" + pReqNum);
        if (ObjUtils.isEmpty(dataMaster.get("P_REQ_NUM") )) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            spParam.put("TABLE_ID","s_bco100ukrv_kd");
            spParam.put("PREFIX", "A");
            spParam.put("BASIS_DATE", dateGetString);
            spParam.put("AUTO_TYPE", "1");

            super.commonDao.queryForObject("s_bco100ukrv_kdService.spAutoNum", spParam);
            List<Map>paramDetail = (List<Map>) paramList.get(0).get("data");
            String gwFlag = (String) paramDetail.get(0).get("GW_FLAG");
            dataMaster.put("GW_FLAG",   gwFlag);
            dataMaster.put("P_REQ_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
            pReqNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
            super.commonDao.insert("s_bco100ukrv_kdService.insertMaster", dataMaster);

        } else {

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
               if(insertList != null) this.insertDetail(insertList, paramMaster, user, pReqNum);
           }

           dataMaster.put("P_REQ_NUM", pReqNum);


           paramList.add(0, paramMaster);

           return  paramList;
   }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user, String pReqNum) throws Exception {
        Map compCodeMap = new HashMap();
        int i = 0;
        for(Map param :paramList ) {
        	 logger.debug("[paramList]" + paramList);
            if(ObjUtils.isEmpty(param.get("P_REQ_NUM"))) {
                param.put("P_REQ_NUM", pReqNum);
                param.put("SER_NO", i + 1);
                i++;
            } else {
                int maxSeq = (int)super.commonDao.select("s_bco100ukrv_kdService.selectMaxSeq", param);
                param.put("P_REQ_NUM", pReqNum);
                param.put("SER_NO", maxSeq + 1);
            }
          //  param.put("SPEC",               ((String)param.get("SPEC")).replaceAll("'", "''"));
          //  param.put("NEW_ITEM_FREFIX",    ((String)param.get("NEW_ITEM_FREFIX")).replaceAll("'", "''"));
          //  param.put("ITEM_NAME",          ((String)param.get("ITEM_NAME")).replaceAll("'", "''"));
          //  param.put("CUSTOM_FULL_NAME",   ((String)param.get("CUSTOM_FULL_NAME")).replaceAll("'", "''"));
          //  param.put("REMARK",             ((String)param.get("REMARK")).replaceAll("'", "''"));
          //  param.put("ITEM_NAME2",         ((String)param.get("ITEM_NAME2")).replaceAll("'", "''"));
          //  param.put("SPEC2",              ((String)param.get("SPEC2")).replaceAll("'", "''"));
          //  param.put("NEW_CAR_TYPE",       ((String)param.get("NEW_CAR_TYPE")).replaceAll("'", "''"));
          //  param.put("CUSTOM_NAME2",       ((String)param.get("CUSTOM_NAME2")).replaceAll("'", "''"));
          //  param.put("CUSTOM_FULL_NAME2",  ((String)param.get("CUSTOM_FULL_NAME2")).replaceAll("'", "''"));
            super.commonDao.update("s_bco100ukrv_kdService.insertDetail", param);
        }
        return 0;
    }

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        Map compCodeMap = new HashMap();
        logger.debug("[paramList]" + paramList);
        int i = 0;
        for(Map param :paramList ) {
        	if(i==0){
        		super.commonDao.update("s_bco100ukrv_kdService.updateMaster1", param);
        	}
        	param.put("SPEC", ((String)param.get("SPEC")).replaceAll("'", "''"));
            param.put("NEW_ITEM_FREFIX",    ((String)param.get("NEW_ITEM_FREFIX")).replaceAll("'", "''"));
            param.put("ITEM_NAME",          ((String)param.get("ITEM_NAME")).replaceAll("'", "''"));
            param.put("CUSTOM_FULL_NAME",   ((String)param.get("CUSTOM_FULL_NAME")).replaceAll("'", "''"));
            param.put("REMARK",             ((String)param.get("REMARK")).replaceAll("'", "''"));
            param.put("ITEM_NAME2",         ((String)param.get("ITEM_NAME2")).replaceAll("'", "''"));
            param.put("SPEC2",              ((String)param.get("SPEC2")).replaceAll("'", "''"));
            param.put("NEW_CAR_TYPE",       ((String)param.get("NEW_CAR_TYPE")).replaceAll("'", "''"));
            param.put("CUSTOM_NAME2",       ((String)param.get("CUSTOM_NAME2")).replaceAll("'", "''"));
            param.put("CUSTOM_FULL_NAME2",  ((String)param.get("CUSTOM_FULL_NAME2")).replaceAll("'", "''"));
            super.commonDao.update("s_bco100ukrv_kdService.updateDetail", param);
            i += 1;
        }
        return 0;
    }


    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail (List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {
            //1 디테일 삭제
            super.commonDao.delete("s_bco100ukrv_kdService.deleteDetail", param);

            //2 체크
            String pReqNum2 = (String)super.commonDao.select("s_bco100ukrv_kdService.beforeDeleteCheck", param);
            if(ObjUtils.isEmpty(pReqNum2)) {
                //3 디테일 없으면 마스터 삭제
                super.commonDao.delete("s_bco100ukrv_kdService.deleteMaster", param);
            } else {

            }
        }
        return 0;
    }

	/**
	 * WB22 리스트
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> wb22List(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("s_bco100ukrv_kdService.wb22List", param);

	}



	/**
	 * 20191216 추가 - BSA400T의 최종단가 가져오는 로직
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
	public double getPreItemP(Map param) throws Exception {
		return (double) super.commonDao.select("s_bco100ukrv_kdService.getPreItemP", param);
	}
}