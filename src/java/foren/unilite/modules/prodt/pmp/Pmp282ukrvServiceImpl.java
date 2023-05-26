package foren.unilite.modules.prodt.pmp;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;


@Service("pmp282ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Pmp282ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 출고후 남은 소요량
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public Object getJanOutstockReqQ(Map param) throws Exception{
		return super.commonDao.select("pmp282ukrvServiceImpl.getJanOutstockReqQ", param);
	}
	/**
	 * 라벨출력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> printList(Map param) throws Exception{
		return super.commonDao.list("pmp282ukrvServiceImpl.printList", param);
	}
	/**
	 * 라벨출력 노비스용
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> printList_novis(Map param) throws Exception{
		return super.commonDao.list("pmp282ukrvServiceImpl.printList_novis", param);
	}
	/**
	 * 메인그리드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("pmp282ukrvServiceImpl.selectList", param);
	}

	/**
	 * 팝업그리드1
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> pop1SelectList(Map param) throws Exception{
		logger.debug("[param]" + param);
		return super.commonDao.list("pmp282ukrvServiceImpl.pop1SelectList", param);
	}
	/**
	 * 팝업그리드1_2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> pop1_2SelectList(Map param) throws Exception{
		return super.commonDao.list("pmp282ukrvServiceImpl.pop1_2SelectList", param);
	}
	/**
	 * 팝업그리드2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> pop2SelectList(Map param, LoginVO user) throws Exception{

		Map<String, Object> chkMap = (Map<String, Object>) super.commonDao.select("pmp282ukrvServiceImpl.pop2SelectEarlierCheckList", param);
		int chkCount = (int) super.commonDao.select("pmp282ukrvServiceImpl.pop2SelectCheckList", param);
		String scanYn = "N";
		if(ObjUtils.isNotEmpty(param.get("SCAN_YN"))){
			scanYn = (String) param.get("SCAN_YN");
		}
		if(chkCount == 0 && scanYn.equals("Y")){
			String lotNo = (String) param.get("LOT_NO");
			throw new  UniDirectValidateException(this.getMessage("스캔한 LOT_NO [[ " + lotNo + " ]]의 재고가 없습니다.", user));
		}
		if(chkMap != null && scanYn.equals("Y")){
			logger.debug((String) chkMap.get("EARLIER_LOT_NO"));
			String earlierLotNo = (String) chkMap.get("EARLIER_LOT_NO");
			String itemCode = (String) chkMap.get("ITEM_CODE");
			String itemName = (String) chkMap.get("ITEM_NAME");
			String lotNo = (String) param.get("LOT_NO");
			throw new  UniDirectValidateException(this.getMessage("스캔한 LOT_NO보다 이전의 재고 [[ " + earlierLotNo + " ]]가 있습니다.", user));
		}

		return super.commonDao.list("pmp282ukrvServiceImpl.pop2SelectList", param);
	}

	/**
	 * 팝업1_2 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> savePop1_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deletePop1_2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deletePop1_2(deleteList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void deletePop1_2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {

			String keyValue2 = getLogKey();

			param.put("KEY_VALUE", keyValue2);
			param.put("OPR_FLAG", "D");

			super.commonDao.insert("pmp282ukrvServiceImpl.insertPop1_2", param);

			Map<String, Object> spParam2 = new HashMap<String, Object>();

			spParam2.put("KeyValue", keyValue2);
			spParam2.put("LangCode", user.getLanguage());

			super.commonDao.queryForObject("pmp282ukrvServiceImpl.spCallPop2_2", spParam2);

			String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));

			if(!ObjUtils.isEmpty(errorDesc2)){

				String[] messsage2 = errorDesc2.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage2[0], user));
			}
		}
		return;
	}


	/**
	 * 팝업2 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> savePop2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
//				if(dataListMap.get("method").equals("deleteDetail")) {
//					deleteList = (List<Map>)dataListMap.get("data");
//				}else
				if(dataListMap.get("method").equals("insertPop2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updatePop2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
//			if(deleteList != null) this.deleteDetail(deleteList, user);

			if(insertList != null) this.insertPop2(insertList, user);
			if(updateList != null) this.updatePop2(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void insertPop2(List<Map> paramList, LoginVO user ) throws Exception {
		for(Map param : paramList ) {

            Map checkLotNo = (Map) super.commonDao.select("pmp282ukrvServiceImpl.checkLotNo", param);
            if(ObjUtils.isEmpty(checkLotNo)){
			    throw new  UniDirectValidateException("해당 LOT번호에 따른 입고 데이터가 없습니다.");
            }else{
            	Map checkIn = (Map) super.commonDao.select("pmp282ukrvServiceImpl.checkIn", param);
                if(ObjUtils.isEmpty(checkIn)){
    			    throw new  UniDirectValidateException("해당 LOT번호에 따른 입고 데이터가 없습니다.");
                }else{
                	param.put("INOUT_CODE", checkIn.get("INOUT_CODE"));
                	param.put("WH_CODE", checkIn.get("WH_CODE"));

                }

            }

            	param.put("OPR_FLAG", "N");
    			param.put("INOUT_SEQ", 1);

    			param.put("CREATE_LOC", "2");			//'2' 자재  (입고,출고)                    /* 생성경로 : (B031) */
    			param.put("INOUT_TYPE_DETAIL", "10");	//'10' 구매입고,생산출고 (입고,출고)          /* 수불유형 : ( M103, M104) */

    			param.put("ITEM_STATUS", "1");			//'1' 양품                     					 /* 품목상태  */

    	//		param.put("WH_CODE", "");				//품목에 따른 주창고                       			/* 창고 코드  */

    			param.put("MONEY_UNIT", user.getCurrency());			//'KRW'                     		/* 수불 화폐단위 : (B004) */

    			param.put("BILL_TYPE", "*");			//'*'                       		/* 매출유형  */
    			param.put("SALE_TYPE", "*");			//'*'                       		/* 매출구분  */

    			param.put("PRICE_YN", "Y");				//									/* 단가구분 */

    			param.put("SALE_DIV_CODE", "*");		//'*'                       		/* 매출사업장 */
    			param.put("SALE_CUSTOM_CODE", "*");		//'*'                       		/* 매출처 */

    			param.put("SALE_C_YN", "N");			//									/* 미매출마감여부 */

    			param.put("INOUT_P", 0);//													/* 수불 단가(원화) */
    			param.put("INOUT_I", 0);//													/* 수불 금액(원화) */
    			param.put("INOUT_Q", param.get("INOUT_Q"));	//출고량 지시분할 수량으로
//    	        INOUT_CODE            NVARCHAR(08)    NOT NULL ,  --?                       /* 수불처 코드 */



//    	        INOUT_Q               NUMERIC(30, 6)  NOT NULL DEFAULT 0 ,              /* 수불 수량                                */
//    	        INOUT_P               NUMERIC(30, 6)  NOT NULL DEFAULT 0 ,              /* 수불 단가(원화) */
//    	        INOUT_I               NUMERIC(30, 6)  NOT NULL DEFAULT 0 ,              /* 수불 금액(원화) */



    			//REF_WKORD_NUM   에 작업지시번호 넣어야함
    			//, OUTSTOCK_NUM   에 출고요청번호 넣어야함

    /*			//입고		(20190408 업무로직 변경으로 인해 입고 로직 제거 함)
    			String keyValue = getLogKey();

    			param.put("KEY_VALUE", keyValue);
    			param.put("INOUT_TYPE","1");


    			param.put("INOUT_METH", '2');		//'2'예외,'1'정상  (입고,출고)                        수불방법      : (B036)

    			param.put("INOUT_CODE_TYPE", "4");		//'4' 거래처   , '3' 작업장  (입고,출고)               수불처구분 : (B005)

    			param.put("INOUT_DATE", param.get("INOUT_DATE_1"));	//입고일자


    			super.commonDao.insert("pmp282ukrvServiceImpl.insertPop2", param);

    			Map<String, Object> spParam = new HashMap<String, Object>();

    			spParam.put("KeyValue", keyValue);
    			spParam.put("LangCode", user.getLanguage());
    			spParam.put("CreateType", "1");

    			super.commonDao.queryForObject("pmp282ukrvServiceImpl.spCallPop2_1", spParam);

    			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

    			if(!ObjUtils.isEmpty(errorDesc)){

    				String[] messsage = errorDesc.split(";");
    			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
    			}
    			*/

    			//출고
    			String keyValue2 = getLogKey();

    			param.put("KEY_VALUE", keyValue2);
    			param.put("INOUT_TYPE","2");

    			param.put("INOUT_METH", '1');		//'2'예외,'1'정상  (입고,출고)                       /* 수불방법      : (B036)                   */

    			param.put("INOUT_CODE_TYPE", "3");		//'4' 거래처   , '3' 작업장  (입고,출고)              					  /* 수불처구분 : (B005) */
    			param.put("INOUT_DATE", param.get("INOUT_DATE_2"));	//출고일자

    			param.put("INOUT_CODE", param.get("WORK_SHOP_CODE"));

    			super.commonDao.insert("pmp282ukrvServiceImpl.insertPop2", param);

    			Map<String, Object> spParam2 = new HashMap<String, Object>();

    			spParam2.put("KeyValue", keyValue2);
    			spParam2.put("LangCode", user.getLanguage());

    			super.commonDao.queryForObject("pmp282ukrvServiceImpl.spCallPop2_2", spParam2);

    			String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));

    			if(!ObjUtils.isEmpty(errorDesc2)){

    				String[] messsage2 = errorDesc2.split(";");
    			    throw new  UniDirectValidateException(this.getMessage(messsage2[0], user));
    			}
            }

		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void updatePop2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			param.put("OPR_FLAG", "N");
			param.put("INOUT_SEQ", 1);

			param.put("CREATE_LOC", "2");			//'2' 자재  (입고,출고)                    /* 생성경로 : (B031) */

		   //if(ObjUtils.isNotEmpty(param.get("PMP200T_WH_CODE"))){
			//	param.put("INOUT_CODE_TYPE", "2");
			//	param.put("INOUT_TYPE_DETAIL", "95");
			//	param.put("INOUT_METH", '3');
			//	param.put("INOUT_CODE", param.get("PMP200T_WH_CODE"));
			//}else{
			//	param.put("INOUT_CODE_TYPE", "3");		//'3' 작업장               					  /* 수불처구분 : (B005) */
			//	param.put("INOUT_TYPE_DETAIL", "10");	//'10' 구매입고,생산출고 (입고,출고)          /* 수불유형 : ( M103, M104) */
			//	param.put("INOUT_METH", '1');		//'2'예외,'1'정상  (입고,출고)                       /* 수불방법      : (B036)                   */
			//	param.put("INOUT_CODE", param.get("WORK_SHOP_CODE"));
			//}
			param.put("INOUT_CODE_TYPE", "3");		//'3' 작업장               					  /* 수불처구분 : (B005) */
			param.put("INOUT_TYPE_DETAIL", "10");	//'10' 구매입고,생산출고 (입고,출고)          /* 수불유형 : ( M103, M104) */
			param.put("INOUT_METH", '1');		//'2'예외,'1'정상  (입고,출고)                       /* 수불방법      : (B036)                   */
			param.put("INOUT_CODE", param.get("WORK_SHOP_CODE"));
				 param.put("ITEM_STATUS", "1");			//'1' 양품                     					 /* 품목상태  */



					param.put("MONEY_UNIT", user.getCurrency());			//'KRW'                     		/* 수불 화폐단위 : (B004) */
					//화폐단위 로그인사용자 데이터 가져와서 저장해야함


					param.put("BILL_TYPE", "*");			//'*'                       		/* 매출유형  */
					param.put("SALE_TYPE", "*");			//'*'                       		/* 매출구분  */

					param.put("PRICE_YN", "Y");				//									/* 단가구분 */

					param.put("SALE_DIV_CODE", "*");		//'*'                       		/* 매출사업장 */
					param.put("SALE_CUSTOM_CODE", "*");		//'*'                       		/* 매출처 */

					param.put("SALE_C_YN", "N");			//									/* 미매출마감여부 */

					param.put("INOUT_P", 0);//													/* 수불 단가(원화) */
					param.put("INOUT_I", 0);//													/* 수불 금액(원화) */


					//출고
					String keyValue2 = getLogKey();

					param.put("KEY_VALUE", keyValue2);
					param.put("INOUT_TYPE","2");

//					param.put("INOUT_METH", '1');		//'2'예외,'1'정상  (입고,출고)                       /* 수불방법      : (B036)                   */
					param.put("INOUT_DATE", param.get("INOUT_DATE_2"));	//출고일자
					param.put("INOUT_Q", param.get("INOUT_Q"));
//					param.put("INOUT_CODE", param.get("WORK_SHOP_CODE"));

					super.commonDao.insert("pmp282ukrvServiceImpl.insertPop2", param);

					Map<String, Object> spParam2 = new HashMap<String, Object>();

					spParam2.put("KeyValue", keyValue2);
					spParam2.put("LangCode", user.getLanguage());

					super.commonDao.queryForObject("pmp282ukrvServiceImpl.spCallPop2_2", spParam2);

					String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));

					if(!ObjUtils.isEmpty(errorDesc2)){

						String[] messsage2 = errorDesc2.split(";");
					    throw new  UniDirectValidateException(this.getMessage(messsage2[0], user));
					}

			 }

		return;
	}




}
