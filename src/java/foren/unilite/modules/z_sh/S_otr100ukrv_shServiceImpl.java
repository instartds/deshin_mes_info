package foren.unilite.modules.z_sh;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("s_otr100ukrv_shService")
public class S_otr100ukrv_shServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 발주 Master/Detail 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 메인1
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("s_otr100ukrv_shServiceImpl.selectMasterlList", param);
	}

	/**
	 *
	 * 외주예약 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 메인2
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("s_otr100ukrv_shServiceImpl.selectDetailList", param);
	}

	/**
     * 대체품목 팝업 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectReplaceItemList(Map param) throws Exception {
        return super.commonDao.list("s_otr100ukrv_shServiceImpl.selectReplaceItemList", param);
    }

	/**
	 * 외주예약정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramList:" + paramList);

		if(paramList != null)	{
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


	/**
	 * 외주예약 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY, needsModificatinAuth = true)
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 /*출고 진행정보 체크*/
				 checkProgress(param, "delete", user);

				 super.commonDao.delete("s_otr100ukrv_shServiceImpl.deleteDetail", param);

			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));//사용중인 코드는 삭제할 수 없습니다.
			 }
		 }
	}


	/**
	 * 수주 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param: paramList)		{

			//beforeSaveDetail(param, user, "insert");
			super.commonDao.insert("s_otr100ukrv_shServiceImpl.insertDetail", param);
		}

		return paramList;
	}


	/**
	 * 수주 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param: paramList)		{
			/*출고 진행정보 체크*/
			checkProgress(param, "update", user);

			super.commonDao.insert("s_otr100ukrv_shServiceImpl.updateDetail", param);
		}

		return paramList;
	}


	/**
	 * 출고 진행정보 체크
	 * @param param
	 * @param type : Master, Detail
	 * @param user
	 * @throws Exception
	 */
	private void  checkProgress(Map param, String oprType, LoginVO user)  throws Exception {
		// (Map<String, Object>)
		Map<String, Object> obj = null;
		obj = (Map<String, Object>)super.commonDao.select("s_otr100ukrv_shServiceImpl.checkProgress", param);

		if(ObjUtils.isEmpty(obj))	{
			if("delete".equals(oprType))	{
				throw new  UniDirectValidateException(this.getMessage("54623", user));	/* 54623: 삭제하려는 자료가 이미 삭제되었습니다.*/
			}else if("update".equals(oprType)){
				throw new  UniDirectValidateException(this.getMessage("54622", user));	/* 54622: 수정하려는 자료가 삭제되었습니다.*/
			}

		} else {
			if(ObjUtils.parseInt(obj.get("INOUT_Q")) > 0 && "delete".equals(oprType))	{
				throw new  UniDirectValidateException(this.getMessage("54636", user));	/* "54636" ' 출고가 진행되어 삭제할수 없습니다.*/
			}

			logger.debug("@@@@@@@@@@@@@@@@@@@@@========="+param.toString());
			if(ObjUtils.parseInt(obj.get("INOUT_Q")) > 0 && "update".equals(oprType))	{

				throw new  UniDirectValidateException(this.getMessage("54620", user));	/* "54620" ' 출고가 진행되어 수정할수 없습니다.*/
				//ALLOC_Q 체크로 대체 나중에
				/*
				If CDbl(aSaveData(lLoop)(iAllocQ)) < CDbl(rsChk("INOUT_Q")) Then
	                fnOtr100Save = Chr(255) & "54632" ' 발주수량은 입고수량 보다 크거나 같아야 합니다.
	                GoTo fnOtr100Save_ErrorHandler
	            End If
	            */
			}

		}
	}


///////////==========================================================


	/**
	 * 디테일 데아타 저장(Insert,Update) 전 확인
	 * @param param
	 * @param user
	 */
	private void beforeSaveDetail(Map param, LoginVO user, String saveMode) throws Exception	{
		if("Y".equals(ObjUtils.getSafeString(param.get("gsDraftFlag"))))	{
			Map<String, Object> itemInfo = (Map<String, Object>)super.commonDao.select("s_otr100ukrv_shServiceImpl.itemInfo", param);
			if(!ObjUtils.isEmpty(itemInfo))	{
				throw new  UniDirectValidateException(this.getMessage("54445", user));	/* 54445:존재하지 않는 품목입니다. 품목정보를 확인하세요(영업공통) */
			}else {
				if("N".equals(itemInfo.get("USE_YN")))	{
					throw new  UniDirectValidateException(this.getMessage("54444", user));	 /* 54444:사용불가 품목입니다.품목정보의 사용유무를 확인하세요.(영업공통) */
				}
			}
		}

		//데이타 비교
		if("update".equals(saveMode) )
		{
			checkCompare(param, user);
		}

	}



	/**
	 * 수주 마스터 저장(등록/수정)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult syncMaster(s_otr100ukrv_shModel param, LoginVO user,  BindingResult result) throws Exception {
		Map<String, Object> paramMap = this.makeMapParam(param, user);

		if (ObjUtils.isEmpty(paramMap.get("ORDER_NUM") )) {
			Map<String, Object> autoNum = (Map<String, Object>)super.commonDao.select("s_otr100ukrv_shServiceImpl.autoNum", paramMap);
			String OrderNum = ObjUtils.getSafeString(autoNum.get("ORDER_NUM"));
			paramMap.put("ORDER_NUM", OrderNum);
			beforeSaveMaster(paramMap, user);
			super.commonDao.insert("s_otr100ukrv_shServiceImpl.insertMaster", paramMap);
		}else {
			beforeSaveMaster(paramMap, user);
			super.commonDao.update("s_otr100ukrv_shServiceImpl.updateMaster", paramMap);
		}

		super.commonDao.update("s_otr100ukrv_shServiceImpl.updatePrice", paramMap);

		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("ORDER_NUM", ObjUtils.getSafeString(paramMap.get("ORDER_NUM")));
		return extResult;
	}


	private Map<String, Object> makeMapParam(s_otr100ukrv_shModel param, LoginVO user)	{
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ORDER_NUM", param.getORDER_NUM());
		paramMap.put("COMP_CODE", param.getCOMP_CODE());
		paramMap.put("DIV_CODE", param.getDIV_CODE());

		paramMap.put("CUSTOM_CODE", param.getCUSTOM_CODE());
		paramMap.put("AGENT_TYPE", param.getAGENT_TYPE());
		paramMap.put("ORDER_DATE", param.getORDER_DATE());
		paramMap.put("ORDER_TYPE", param.getORDER_TYPE());
		paramMap.put("MONEY_UNIT", param.getMONEY_UNIT());
		paramMap.put("ORDER_O", param.getORDER_O());
		paramMap.put("ORDER_TAX_O", param.getORDER_TAX_O());
		paramMap.put("EXCHG_RATE_O", param.getEXCHG_RATE_O());
		paramMap.put("ORDER_PRSN", param.getORDER_PRSN());
		paramMap.put("DEPT_CODE", param.getDEPT_CODE());
		paramMap.put("PO_NUM", param.getPO_NUM());
		paramMap.put("CREATE_LOC", param.getCREATE_LOC());
		paramMap.put("TAX_INOUT", param.getTAX_INOUT());
		paramMap.put("BILL_TYPE", param.getBILL_TYPE());
		paramMap.put("RECEIPT_SET_METH", param.getRECEIPT_SET_METH());
		paramMap.put("PROJECT_NO", param.getPROJECT_NO());
		paramMap.put("REMARK", param.getREMARK());
		paramMap.put("PROMO_NUM", param.getPROMO_NUM());
		paramMap.put("STATUS", param.getSTATUS());
		paramMap.put("APP_1_ID", param.getAPP_1_ID());
		paramMap.put("APP_1_DATE", param.getAPP_1_DATE());
		paramMap.put("AGREE_1_YN", param.getAGREE_1_YN());
		paramMap.put("APP_2_ID", param.getAPP_2_ID());
		paramMap.put("APP_2_DATE", param.getAPP_2_DATE());
		paramMap.put("AGREE_2_YN", param.getAGREE_2_YN());
		paramMap.put("APP_3_ID", param.getAPP_3_ID());
		paramMap.put("APP_3_DATE", param.getAPP_3_DATE());
		paramMap.put("AGREE_3_YN", param.getAGREE_3_YN());
		paramMap.put("APP_STEP", param.getAPP_STEP());
		paramMap.put("RETURN_ID", param.getRETURN_ID());
		paramMap.put("RETURN_DATE", param.getRETURN_DATE());
		paramMap.put("RETURN_MSG", param.getRETURN_MSG());

		paramMap.put("ORDER_NAME", param.getORDER_NAME());
		paramMap.put("PAY_METHOD", param.getPAY_METHOD());
		paramMap.put("INSPECT_ORG", param.getINSPECT_ORG());
		paramMap.put("DEF_RATE", param.getDEF_RATE());
		paramMap.put("DEF_TERM", param.getDEF_TERM());
		paramMap.put("DEF_RESP_TERM", param.getDEF_RESP_TERM());
		paramMap.put("DEFERMENT_RATE", param.getDEFERMENT_RATE());
		paramMap.put("PAY_COND", param.getPAY_COND());
		paramMap.put("gsDraftFlag", param.getGsDraftFlag());

		paramMap.put("S_COMP_CODE", user.getCompCode());
		paramMap.put("S_USER_ID", user.getUserID());

		return paramMap;
	}

	/**
	 * 마스터 데아타 저장(Insert,Update) 전 확인
	 * @param param
	 * @param user
	 */
	private void beforeSaveMaster(Map param, LoginVO user) throws Exception	{
		if("Y".equals(ObjUtils.getSafeString(param.get("gsDraftFlag"))))	{
			//수주 진행 정보 확인
			checkProgress(param, "Master", user);
			//수불정보 update
			super.commonDao.queryForObject("s_otr100ukrv_shServiceImpl.checkOrderType", param);
		}
	}


	private void checkCompare(Map<String, Object> param, LoginVO user) throws Exception {
		Map<String, Object> checkDetailData = (Map<String, Object>)super.commonDao.select("s_otr100ukrv_shServiceImpl.checkDetailData", param);
		int sCase=0;

		if(!ObjUtils.isEmpty(checkDetailData))	{
			double saleQ =  ObjUtils.parseDouble(checkDetailData.get("SALE_Q"));
			String orderStatus =  ObjUtils.getSafeString(checkDetailData.get("ORDER_STATUS"));
			String accountYnc =  ObjUtils.getSafeString(checkDetailData.get("ACCOUNT_YNC"));
			String priceYn =  ObjUtils.getSafeString(checkDetailData.get("PRICE_YN"));
			double orderP =  ObjUtils.parseDouble(checkDetailData.get("ORDER_P"));
			String itemCode =  ObjUtils.getSafeString(checkDetailData.get("ITEM_CODE"));
			double orderQ =  ObjUtils.parseDouble(checkDetailData.get("ORDER_Q"));
			String dvryDate =  ObjUtils.getSafeString(checkDetailData.get("DVRY_DATE"));
			String taxType =  ObjUtils.getSafeString(checkDetailData.get("TAX_TYPE"));
			String orderUnit =  ObjUtils.getSafeString(checkDetailData.get("ORDER_UNIT"));
			String saleCustCd =  ObjUtils.getSafeString(checkDetailData.get("SALE_CUST_CD"));
			String dvryCustCd =  ObjUtils.getSafeString(checkDetailData.get("DVRY_CUST_CD"));
			String outDivCode =  ObjUtils.getSafeString(checkDetailData.get("OUT_DIV_CODE"));
			double transRate =  ObjUtils.parseDouble(checkDetailData.get("TRANS_RATE"));
			String prodEndDate =  ObjUtils.getSafeString(checkDetailData.get("PROD_END_DATE"));
			double prodQ =  ObjUtils.parseDouble(checkDetailData.get("PROD_Q"));
			double issueReqQ =  ObjUtils.parseDouble(checkDetailData.get("ISSUE_REQ_Q"));
			double outStockQ =  ObjUtils.parseDouble(checkDetailData.get("OUTSTOCK_Q"));
			double returnQ =  ObjUtils.parseDouble(checkDetailData.get("RETURN_Q"));
			double reqIssueQty =  ObjUtils.parseDouble(checkDetailData.get("REQ_ISSUE_QTY"));
			String maxPubNum =  ObjUtils.getSafeString(checkDetailData.get("MAX_PUB_NUM"));

			if(saleQ > 0)	{
		             if(
			                 !orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS")))
			            	 &&
				             (  	!accountYnc.equals(param.get("ACCOUNT_YNC"))  ||
					                ( !priceYn.equals(param.get("PRICE_YN")) && priceYn.equals("1") ) ||
					                ( orderP != ObjUtils.parseDouble(param.get("ORDER_P")) && priceYn.equals("1") )
				             )
				             &&
			                 (
			                    itemCode.equals(param.get("ITEM_CODE")) &&
			                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
			                    dvryDate.equals(param.get("DVRY_DATE")) &&
			                    taxType.equals(param.get("TAX_TYPE")) &&
			                    orderUnit.equals(param.get("ORDER_UNIT")) &&
			                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
			                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
			                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
			                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
			                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
			                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
			                )
		               )
		            {
		            	 	sCase = 6;

		            }
		             else if(
			                 	!orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
			                 	itemCode.equals(param.get("ITEM_CODE")) &&
			                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
			                    orderP == ObjUtils.parseDouble(param.get("ORDER_P")) &&
			                    dvryDate.equals(param.get("DVRY_DATE")) &&
			                    priceYn.equals(param.get("PRICE_YN")) &&
			                    taxType.equals(param.get("TAX_TYPE")) &&
			                    orderUnit.equals(param.get("ORDER_UNIT")) &&
			                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
			                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
			                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
			                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
			                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
			                    accountYnc.equals(param.get("ACCOUNT_YNC")) &&
			                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
		            	   )
		             {
		                sCase = 5;
		             }
		             else if(
			                 	!orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
			                 	(!itemCode.equals(param.get("ITEM_CODE")) ||
			                    orderQ != ObjUtils.parseDouble(param.get("ORDER_Q")) ||
			                    orderP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
			                    !dvryDate.equals(param.get("DVRY_DATE")) ||
			                    !priceYn.equals(param.get("PRICE_YN")) ||
			                    !taxType.equals(param.get("TAX_TYPE")) ||
			                    !orderUnit.equals(param.get("ORDER_UNIT")) ||
			                    !saleCustCd.equals(param.get("SALE_CUST_CD")) ||
			                    !dvryCustCd.equals(param.get("DVRY_CUST_CD")) ||
			                    !outDivCode.equals(param.get("OUT_DIV_CODE")) ||
			                    transRate != ObjUtils.parseDouble(param.get("TRANS_RATE")) ||
			                    !prodEndDate.equals(param.get("PROD_END_DATE")) ||
			                    !accountYnc.equals(param.get("ACCOUNT_YNC")) ||
			                    prodQ != ObjUtils.parseDouble(param.get("PROD_Q")) 	)
		            		 )
		             {
		            	 sCase = 4;
		             }
		             else if(
			            		 orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS")))
				            	 &&
					             (  	!accountYnc.equals(param.get("ACCOUNT_YNC"))  ||
						                ( !priceYn.equals(param.get("PRICE_YN")) && priceYn.equals("1") ) ||
						                ( orderP != ObjUtils.parseDouble(param.get("ORDER_P")) && priceYn.equals("1") )
					             )
					             &&
				                 (
				                    itemCode.equals(param.get("ITEM_CODE")) &&
				                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
				                    dvryDate.equals(param.get("DVRY_DATE")) &&
				                    taxType.equals(param.get("TAX_TYPE")) &&
				                    orderUnit.equals(param.get("ORDER_UNIT")) &&
				                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
				                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
				                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
				                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
				                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
				                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
				                )
		            		 )
		             {
		                sCase = 3;
		             }
		             else if(
			                 	orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
			                 	(!itemCode.equals(param.get("ITEM_CODE")) ||
			                    orderQ != ObjUtils.parseDouble(param.get("ORDER_Q")) ||
			                    orderP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
			                    !dvryDate.equals(param.get("DVRY_DATE")) ||
			                    !priceYn.equals(param.get("PRICE_YN")) ||
			                    !taxType.equals(param.get("TAX_TYPE")) ||
			                    !orderUnit.equals(param.get("ORDER_UNIT")) ||
			                    !saleCustCd.equals(param.get("SALE_CUST_CD")) ||
			                    !dvryCustCd.equals(param.get("DVRY_CUST_CD")) ||
			                    !outDivCode.equals(param.get("OUT_DIV_CODE")) ||
			                    transRate != ObjUtils.parseDouble(param.get("TRANS_RATE")) ||
			                    !prodEndDate.equals(param.get("PROD_END_DATE")) ||
			                    !accountYnc.equals(param.get("ACCOUNT_YNC")) ||
			                    prodQ != ObjUtils.parseDouble(param.get("PROD_Q")) 	)
		            		 )
		             {
		                sCase = 2;
		             } else {
		                sCase = 1;
		             }
			}

	        if("1".equals(priceYn))	{
	        	if(
	        			orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
	                 	itemCode.equals(param.get("ITEM_CODE")) &&
	                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
	                    dvryDate.equals(param.get("DVRY_DATE")) &&
	                    priceYn.equals(param.get("PRICE_YN")) &&
	                    taxType.equals(param.get("TAX_TYPE")) &&
	                    orderUnit.equals(param.get("ORDER_UNIT")) &&
	                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
	                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
	                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
	                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
	                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
	                    accountYnc.equals(param.get("ACCOUNT_YNC")) &&
	                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
	        	  )
	        	{
	        		sCase = 0;
	        	}


	        }

	        if(sCase != 0)	{
	        	if( !(sCase == 1 || sCase == 3 ||
	        	   ((sCase == 5 || sCase == 6) && orderQ > issueReqQ)
	        	  ) )
		        {
		        	throw new  UniDirectValidateException(this.getMessage("54460", user));
		        }
	        }

	        if(outStockQ > 0 || returnQ > 0) {
	        	if(ObjUtils.parseDouble(param.get("OUTSTOCK_Q")) < outStockQ )	{
	        		throw new  UniDirectValidateException(this.getMessage("54461", user));
	        	}
	        	if(itemCode.equals(param.get("ITEM_CODE")))	{
	        		throw new  UniDirectValidateException(this.getMessage("54431", user));
	        	}
	        }

	        if("N".equals(orderStatus) && "Y".equals(param.get("ORDER_STATUS")))	{
	        	if((orderQ + returnQ - outStockQ) == 0 )	{
	        		throw new  UniDirectValidateException(this.getMessage("54440", user));	// 54440:해당 수주건에 대해 강제마감할 자료가 없습니다.(완납)
	        	}
	        }

	        if(sCase > 0)	{
	        	if(!(sCase == 1 || sCase == 3 || ((sCase == 5 || sCase ==6) && (reqIssueQty > 0 ))))	{
	        		Map<String, Object> checkSaleQ = (Map<String, Object>)super.commonDao.select("s_otr100ukrv_shServiceImpl.checkSaleQ", param);
	        		if(!ObjUtils.isEmpty(checkSaleQ))	{
	        			throw new  UniDirectValidateException(this.getMessage("54494", user));
	        		}
	        	}
	        }

	        if(orderP != ObjUtils.parseDouble(param.get("ORDER_P")))	{
	        	if(maxPubNum != null && !"".equals(maxPubNum))	{
	        		throw new  UniDirectValidateException(this.getMessage("54483", user));
	        	}
	        }


	        if(outStockQ > 0)	{
		        List<Map<String, Object>> checkListSSA100 = (List<Map<String, Object>>)super.commonDao.list("s_otr100ukrv_shServiceImpl.checkSSA100", param);
		        if(ObjUtils.isEmpty(checkListSSA100))	{
		        	throw new  UniDirectValidateException(this.getMessage("54400", user));
		        } else 	{

		        	for(Map<String, Object> checkSSA100 : checkListSSA100)	{
		        		int sFlg = 0;
		        		Map mapfCompute = new HashMap();
		        		double saleP = ObjUtils.parseDouble(checkSSA100.get("SALE_P"));
		        		String ssa100_priceYn = ObjUtils.getSafeString(checkSSA100.get("PRICE_YN"));
		        		if("N".equals(accountYnc) && "Y".equals(param.get("ACCOUNT_YNC")) &&  saleP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
		        		   "Y".equals(accountYnc) && "N".equals(param.get("ACCOUNT_YNC")) &&  saleP == ObjUtils.parseDouble(param.get("ORDER_P")) ||
		        		   !ssa100_priceYn.equals(param.get("PRICE_YN")) && "1".equals(ssa100_priceYn)
		        		  )	{
		        			Map ssa100Param = new HashMap();
		        			ssa100Param.put("TAX_TYPE", checkSSA100.get("TAX_TYPE"));
		        			ssa100Param.put("M_TAX_TYPE", checkDetailData.get("M_TAX_TYPE"));
		        			ssa100Param.put("WON_CALC_BAS", checkDetailData.get("WON_CALC_BAS"));
		        			ssa100Param.put("VAT_RATE", checkDetailData.get("VAT_RATE"));
		        			ssa100Param.put("TRANS_RATE", checkSSA100.get("TRANS_RATE"));
		        			ssa100Param.put("SALE_Q", checkSSA100.get("SALE_Q"));

		        			double dParam_Unit_P = 0.0;
		        			if("N".equals(param.get("ACCOUNT_YNC")))	{
		        				dParam_Unit_P = 0;
		        			}else {
		        				dParam_Unit_P = ObjUtils.parseDouble(param.get("ORDER_P"));
		        			}

		        			//mapfCompute = SalesUtil.fnReCompute(ssa100Param, dParam_Unit_P);

		        			sFlg = 1;
		        		}else if( !ssa100_priceYn.equals(param.get("PRICE_YN")))	{
		        			sFlg = 2;
		        		}


		        		if(sFlg != 0)	{
		        			Map<String, Object> paramSRQ100 = new HashMap<String, Object>();
		        			paramSRQ100.put("S_COMP_CODE", param.get("S_COMP_CODE"));
		        			paramSRQ100.put("ACCOUNT_YNC", param.get("ACCOUNT_YNC"));
		        			paramSRQ100.put("OUT_DIV_CODE", param.get("OUT_DIV_CODE"));
		        			paramSRQ100.put("ORDER_NUM", param.get("ORDER_NUM"));
		        			paramSRQ100.put("SER_NO", param.get("SER_NO"));
		        			paramSRQ100.put("INOUT_NUM", checkSSA100.get("INOUT_NUM"));
		        			paramSRQ100.put("INOUT_SEQ", checkSSA100.get("INOUT_SEQ"));

		        			if(sFlg == 1)	{
		        				paramSRQ100.put("INOUT_FOR_P", mapfCompute.get("dParamP"));
		        				paramSRQ100.put("INOUT_FOR_O", mapfCompute.get("dParamI"));
		        				paramSRQ100.put("ORDER_UNIT_P", mapfCompute.get("dParam_Unit_P"));
		        				paramSRQ100.put("ORDER_UNIT_O", mapfCompute.get("dParam_Unit_I"));
		        				paramSRQ100.put("INOUT_TAX_AMT", mapfCompute.get("dParam_Unit_T"));
		        			}


		        			super.commonDao.update("s_otr100ukrv_shServiceImpl.updateBTR100", paramSRQ100);

		        		}
		        	}

	        	}
	        }

	        if(issueReqQ > 0)	{
	        	List<Map<String, Object>> checkListSRQ100 = (List<Map<String, Object>>)super.commonDao.list("s_otr100ukrv_shServiceImpl.checkSRQ100", param);

		        if(ObjUtils.isEmpty(checkListSRQ100))	{
		        	throw new  UniDirectValidateException(this.getMessage("54400", user));
		        }else {
		        	for(Map<String, Object> checkSRQ100 : checkListSRQ100)	{
		        		int sFlg = 0;
		        		Map mapfCompute = new HashMap();


		        		if(ObjUtils.parseDouble(param.get("ORDER_P")) != ObjUtils.parseDouble(checkSRQ100.get("ORDER_P")) )	{
		        			Map ssa100Param = new HashMap();
		        			ssa100Param.put("TAX_TYPE", checkSRQ100.get("TAX_TYPE"));
		        			ssa100Param.put("M_TAX_TYPE", checkDetailData.get("M_TAX_TYPE"));
		        			ssa100Param.put("WON_CALC_BAS", checkDetailData.get("WON_CALC_BAS"));
		        			ssa100Param.put("VAT_RATE", checkDetailData.get("VAT_RATE"));
		        			ssa100Param.put("TRANS_RATE", checkSRQ100.get("TRANS_RATE"));
		        			ssa100Param.put("SALE_Q", checkSRQ100.get("ISSUE_REQ_QTY"));

		        			double dParam_Unit_P = ObjUtils.parseDouble(param.get("ORDER_P"));

		        			//mapfCompute = SalesUtil.fnReCompute(ssa100Param, dParam_Unit_P);

		        			sFlg = 1;
		        		}else if( !priceYn.equals(ObjUtils.getSafeString(checkSRQ100.get("PRICE_YN"))))	{
		        			sFlg = 2;
		        		}else if(!accountYnc.equals(ObjUtils.getSafeString(checkSRQ100.get("ACCOUNT_YNC"))))	{
		        			sFlg = 3;
		        		}


		        		if(sFlg != 0)	{
		        			Map<String, Object> paramSRQ100 = new HashMap<String, Object>();
		        			paramSRQ100.put("S_COMP_CODE", param.get("S_COMP_CODE"));
		        			paramSRQ100.put("ACCOUNT_YNC", param.get("ACCOUNT_YNC"));
		        			paramSRQ100.put("DIV_CODE", param.get("DIV_CODE"));
		        			paramSRQ100.put("ORDER_NUM", param.get("ORDER_NUM"));
		        			paramSRQ100.put("SER_NO", param.get("SER_NO"));
		        			paramSRQ100.put("INOUT_NUM", checkSRQ100.get("INOUT_NUM"));
		        			paramSRQ100.put("INOUT_SEQ", checkSRQ100.get("INOUT_SEQ"));

		        			if(sFlg == 1)	{
		        				paramSRQ100.put("ISSUE_REQ_PRICE", mapfCompute.get("dParam_Unit_P"));
		        				paramSRQ100.put("ISSUE_REQ_AMT", mapfCompute.get("dParam_Unit_I"));
		        				paramSRQ100.put("ISSUE_REQ_TAX_AMT", mapfCompute.get("dParam_Unit_T"));
		        			}

		        			super.commonDao.update("s_otr100ukrv_shServiceImpl.updateSRQ100", paramSRQ100);

		        		}
		        	}
		        }
	        }

		}
	}

}
