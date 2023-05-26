package foren.unilite.modules.accnt.agj;

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

import com.clipsoft.org.apache.sanselan.util.Debug;

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



@Service("agj800ukrService")
public class Agj800ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 
	 * 기초잔액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("agj800ukrService.selectList1", param);
	}	
	
	
	/**
	 * 
	 * 거래합계 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("agj800ukrService.selectList2", param);
	}
	
	public void fnBalanceSet(Map param, LoginVO user) throws Exception {
		
		List<Map<String, Object>> rsTemp = null;
		List<Map<String, Object>> rsAcnt = null;
		String sInputPath, sApArDivi=null;
		String sBankCode, sSaveCode;
		Double dLocAmt , dForAmt;
		Double dOptLocAmt , dOptForAmt;
		Double dTmpLocAmt, dTmpForAmt;
		
		String acDate = ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE"));
		String acDateY = acDate.length()==6 ? acDate.substring(0,3):"";
		String acDateM = acDate.length()==6 ? acDate.substring(4,6):"";
		
		
		//'Step 0. Variable init
		//'==============================================================================================
		if("1".equals("TERM_DIVI"))	{
			sInputPath = "A0";   //'기초잔액
		}else {
			sInputPath = "A1";   //'거래합계
		}
		
		//'Step 1. Balance Check
		//'==============================================================================================
		
		//'Step 1.1 The others balance
		//'----------------------------------------------------------------------------------------------
		rsTemp = (List<Map<String, Object>>) super.commonDao.select("agj800ukrService.chkBalance", param);
		
		if(rsTemp != null  && rsTemp.size() > 0)	{
			
			String errMsg = "기초년월 : "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(0,3)+"년 "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(4,5)+"\n";
			errMsg = errMsg+"잔액반영불가";
			throw new  UniDirectValidateException(this.getMessage("54345;"+errMsg, user));
		}
		
		
		//'Step 1.2 Total balance
		//'----------------------------------------------------------------------------------------------
		rsTemp =  (List<Map<String, Object>>) super.commonDao.select("agj800ukrService.totalBalance", param);
		
		
		if(rsTemp == null  || rsTemp.size() == 0)	{
			String errMsg = "기초년월 : "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(0,3)+"년 "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(4,5)+"\n";
			errMsg = errMsg+"잔액반영불가";
			throw new  UniDirectValidateException(this.getMessage("54346;"+errMsg, user));
		}
		
		Map rsTempMap = rsTemp.get(0);
		if("Y".equals(ObjUtils.getSafeString(rsTempMap.get("PROC_YN"))))	{
			String errMsg = "기초년월 : "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(0,3)+"년 "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(4,5)+"\n";
			errMsg = errMsg+"잔액반영불가";
			throw new  UniDirectValidateException(this.getMessage("54346;"+errMsg, user));
		}
		
		if("1".equals(ObjUtils.getSafeString(param.get("TERM_DIVI"))))	{
			if(ObjUtils.parseDouble(rsTempMap.get("DR_AMT_I")) != ObjUtils.parseDouble(rsTempMap.get("CR_AMT_I")))	{
				String errMsg = "기초년월 : "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(0,3)+"년 "+ObjUtils.getSafeString(rsTemp.get(0).get("AC_DATE")).substring(4,5)+"\n";
				errMsg = errMsg+"잔액반영불가";
				throw new  UniDirectValidateException(this.getMessage("54348;"+errMsg, user));
			}
		}
		
		//'Step 2. G/L (General ledger)
		//'==============================================================================================
		//'Step 2.1 Get Data
		//'----------------------------------------------------------------------------------------------
		rsAcnt = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.getBalanceSet", param);
		
		
		//'Step 2.2 Working AGB100T
		//'----------------------------------------------------------------------------------------------
		if(rsAcnt != null && rsAcnt.size() > 0 )	{
			super.commonDao.delete("agj800ukrService.deleteBalanceSet", param);
		}
		
		for(Map<String, Object> rMap : rsAcnt)	{
			rMap.put("TERM_DIVI", sInputPath);
			rMap.put("S_USER_ID", user.getUserID());
			super.commonDao.queryForObject("agj800ukrService.insertBalanceSet", rMap);
		}
		
		
		//'Step 3. Supplementary account book ( AGB200T )
		//'==============================================================================================
		
		//'Step 3.1 Get Data
		//'----------------------------------------------------------------------------------------------
		rsAcnt = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.getAgb200", param);
		
		//'STEP 3.2 WORKING
		//'----------------------------------------------------------------------------------------------
		if(rsAcnt != null &&  rsAcnt.size() > 0)	{
			super.commonDao.delete("agj800ukrService.deleteAgb200", param);
		}
		
		for(Map<String, Object> rMap : rsAcnt)	{
			rMap.put("TERM_DIVI", sInputPath);
			rMap.put("S_USER_ID", user.getUserID());
			super.commonDao.queryForObject("agj800ukrService.insertAgb200", rMap);
		}
		
		//'STEP 4. DEPOSIT ACCOUNT BOOK ( AGB500T )
		//'==============================================================================================
		
		//'STEP 4.1 GET DATA
		//'----------------------------------------------------------------------------------------------
		rsAcnt = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.getAgb500", param);
		
		//'Step 4.2 Working
		//'----------------------------------------------------------------------------------------------
		if(rsAcnt != null &&  rsAcnt.size() > 0)	{
			for(Map<String, Object> rMap : rsAcnt)	{
				if("O1".equals(ObjUtils.getSafeString(rMap.get("BOOK_CODE1"))))	{
					sSaveCode = ObjUtils.getSafeString(rMap.get("BOOK_DATA1"));
				}else if("O1".equals(ObjUtils.getSafeString(rMap.get("BOOK_CODE2")))){
					sSaveCode = ObjUtils.getSafeString(rMap.get("BOOK_DATA2"));
				}else {
					String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
					errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")";
					throw new  UniDirectValidateException(this.getMessage("54328;"+errMsg, user));
				}
				
				if("A3".equals(ObjUtils.getSafeString(rMap.get("BOOK_CODE1"))))	{
					sBankCode = ObjUtils.getSafeString(rMap.get("BOOK_DATA1"));
				}else if("A3".equals(ObjUtils.getSafeString(rMap.get("BOOK_CODE1"))))	{
					sBankCode = ObjUtils.getSafeString(rMap.get("BOOK_DATA2"));
				}else {
					String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
					errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")";
					throw new  UniDirectValidateException(this.getMessage("54327;"+errMsg, user));
				}
				
				rMap.put("BASE_AC_DATE", param.get("AC_DATE"));
				rMap.put("S_USER_ID", user.getUserID());
				rMap.put("TERM_DIVI", param.get("TERM_DIVI"));
				rMap.put("REMARK", "기초(년)월 잔액");
				rMap.put("BANK_CODE", sBankCode);
				rMap.put("SAVE_CODE", sSaveCode);
				rMap.put("REMARK", "기초(년)월 잔액");
				
				super.commonDao.queryForObject("agj800ukrService.insertAgb500", rMap);
			}
		
		}
		//'Step 5. pending Account
		//'==============================================================================================
	
		//'Step 5.1 Get Data
		//'----------------------------------------------------------------------------------------------
		rsAcnt = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.getPendingAccount", param);
			
		//'Step 5.2 Working
		//'----------------------------------------------------------------------------------------------
		if(rsAcnt != null &&  rsAcnt.size() > 0)	{
			outer:for(Map<String, Object> rMap : rsAcnt)	{
				if("".equals(ObjUtils.getSafeString(rMap.get("JAN_DIVI"))))	{
					String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
					errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")\n";
					errMsg = errMsg+ObjUtils.getSafeString(rMap.get("PEND_NAME"))+" : "+ObjUtils.getSafeString(rMap.get("PEND_DATA_CODE"))+"\n";
					errMsg = errMsg+"차대코드가 존재하지 않습니다.";
					throw new  UniDirectValidateException(this.getMessage("8114;"+errMsg, user));
				}
				
				if("1".equals(ObjUtils.getSafeString(param.get("TERM_DIVI"))))	{
					sApArDivi = "1";
				} else {
					if("1".equals(ObjUtils.getSafeString(rMap.get("JAN_DIVI"))))	{
						if(ObjUtils.parseDouble(rMap.get("DR_AMT_I")) !=  0 && ObjUtils.parseDouble(rMap.get("CR_AMT_I")) == 0 )	{
					         sApArDivi = "1";
						}else if(ObjUtils.parseDouble(rMap.get("DR_AMT_I")) ==  0 && ObjUtils.parseDouble(rMap.get("CR_AMT_I")) != 0 )	{
						    sApArDivi = "2";
						}else {
					        sApArDivi = "3";
						}
					}else if("2".equals(ObjUtils.getSafeString(rMap.get("JAN_DIVI"))))	{
						if(ObjUtils.parseDouble(rMap.get("CR_AMT_I")) != 0 &&  ObjUtils.parseDouble(rMap.get("DR_AMT_I")) == 0 ) {
					          sApArDivi = "1";
						} else if(ObjUtils.parseDouble(rMap.get("DR_AMT_I")) != 0 && ObjUtils.parseDouble(rMap.get("CR_AMT_I")) == 0) {
					          sApArDivi = "2";
						} else {
					          sApArDivi = "3";
						}
					}
				}
				if(!"3".equals(sApArDivi))	{
					if("1".equals(ObjUtils.getSafeString(rMap.get("JAN_DIVI"))))	{
						dLocAmt = ObjUtils.parseDouble(rMap.get("DR_AMT_I")) - ObjUtils.parseDouble(rMap.get("CR_AMT_I"));
						dForAmt = ObjUtils.parseDouble(rMap.get("DR_FOR_AMT_I")) - ObjUtils.parseDouble(rMap.get("CR_FOR_AMT_I"));
					}else {
						dLocAmt = ObjUtils.parseDouble(rMap.get("CR_AMT_I")) - ObjUtils.parseDouble(rMap.get("DR_AMT_I"));
						dForAmt = ObjUtils.parseDouble(rMap.get("CR_FOR_AMT_I")) - ObjUtils.parseDouble(rMap.get("DR_FOR_AMT_I"));
					}
				}else {
					if("1".equals(ObjUtils.getSafeString(rMap.get("JAN_DIVI"))))	{
						 dLocAmt = ObjUtils.parseDouble(rMap.get("CR_AMT_I"));
						 dForAmt = ObjUtils.parseDouble(rMap.get("CR_FOR_AMT_I"));
					}else {
						dLocAmt = ObjUtils.parseDouble(rMap.get("DR_AMT_I"));
						dForAmt = ObjUtils.parseDouble(rMap.get("DR_FOR_AMT_I"));
					}
				}
				
				if("2".equals(sApArDivi))	{
					dLocAmt = dLocAmt * -1;
					dForAmt = dForAmt * -1;
				}

		//'Step 5.2.1 AGB300T ( Create pending )
		//'----------------------------------------------------------------------------------
		if("1".equals(sApArDivi))	{
			//agj800ukrService.createPending
			rMap.put("BASE_AC_DATE", param.get("AC_DATE"));
			rMap.put("S_USER_ID", user.getUserID());
			rMap.put("TERM_DIVI", param.get("TERM_DIVI"));
			rMap.put("D_LOC_AMT", dLocAmt);
			rMap.put("D_FOR_AMT", dForAmt);
			
			super.commonDao.queryForObject("agj800ukrService.createPending", rMap);
			
		//'Step 5.2.2 AGB300T ( Setoff pending )
		//'------------------------------------------------------------------------   ----------
		}else if("2".equals(sApArDivi))	{
			rsTemp = super.commonDao.list("agj800ukrService.setoffPending", rMap);
			if(rsTemp == null || (rsTemp != null && rsTemp.size() == 0))	{
				String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
				errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")\n";
				errMsg = errMsg+ObjUtils.getSafeString(rMap.get("PEND_NAME"))+" : "+ObjUtils.getSafeString(rMap.get("PEND_DATA_CODE"))+"\n";
				errMsg = errMsg+"화폐금액 :"+ObjUtils.getSafeString(rMap.get("MONEY_UNIT"))+" "+dLocAmt.toString();
				throw new  UniDirectValidateException(this.getMessage("8114;"+errMsg, user));

			}
			inner:for(Map<String, Object> rTempMap : rsTemp)	{
		      
		    	dTmpLocAmt = 0.0;
		    	dTmpForAmt = 0.0;
		      
		      //'Step 5.2.2.1 AGB300T ( Setoff pending ) - Local Amount
		      //'--------------------------------------------------------------------------
		      if(dLocAmt != 0)	{
		          if(dLocAmt > ObjUtils.parseDouble(rTempMap.get("BLN_I")))	{
		        	  
		        	  super.commonDao.update("agj800ukrService.updateAmtAgb300", rTempMap);
		          
		          dTmpLocAmt = ObjUtils.parseDouble(rTempMap.get("BLN_I"));
	              dLocAmt = dLocAmt - dTmpLocAmt;
	          
			      } else if(dLocAmt == ObjUtils.parseDouble(rTempMap.get("BLN_I"))) {
			    	  super.commonDao.update("agj800ukrService.updateAmtAgb300", rTempMap);
			              
			          dTmpLocAmt = ObjUtils.parseDouble(rTempMap.get("BLN_I"));
			          dLocAmt = 0.0;
			          
			      }else {
			    	  rTempMap.put("D_LOC_AMT", dLocAmt);
			    	  super.commonDao.update("agj800ukrService.updateAmtAgb300", rTempMap);
			              dTmpLocAmt = dLocAmt;
			              dLocAmt = 0.0;
			      }
		      }
			 
		      //'Step 5.2.2.2 AGB300T ( Setoff pending ) - Foregin Amount
		      //'--------------------------------------------------------------------------
		      
		      if(dForAmt != 0)	{
		          if(dForAmt > ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I")))	{
		        	  
		        	  super.commonDao.update("agj800ukrService.updateForignAmtAgb300", rTempMap);
		          
		        	  dTmpForAmt = ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I"));
		        	  dForAmt = dForAmt - dTmpForAmt;
	          
			      } else if(dForAmt == ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I"))) {
			    	  super.commonDao.update("agj800ukrService.updateForignAmtAgb300", rTempMap);
			              
			          dTmpLocAmt = ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I"));
			          dForAmt = 0.0;
			          
			      }else {
			    	  rTempMap.put("D_FOR_AMT", dForAmt);
			    	  super.commonDao.update("agj800ukrService.updateForignAmtAgb300", rTempMap);
			    	  dTmpForAmt = dForAmt;
			          dForAmt = 0.0;
			      }
		      }
		      
		      //'Step 5.2.2.3 AGB310T ( Create setoff pending )
		      //'--------------------------------------------------------------------------
		      if(dTmpLocAmt != 0 || dTmpForAmt != 0)	{
		    	  rTempMap.put("BASE_AC_DATE", param.get("AC_DATE"));
		    	  rTempMap.put("TERM_DIVI", param.get("TERM_DIVI"));
		    	  rTempMap.put("S_USER_ID", user.getUserID());
		    	  rTempMap.put("D_LOC_AMT", dTmpLocAmt);
		    	  rTempMap.put("D_FOR_AMT", dTmpForAmt);
		    	  super.commonDao.update("agj800ukrService.createSetoffPending", rTempMap);
		      }
		      
		      //'Step 5.2.2.4 Exit setoff pending
		      //'--------------------------------------------------------------------------
		     if(dLocAmt == 0 && dForAmt == 0 ) break inner;	//'<-- Attention
		  }
		  
		  //'Step 5.2.3 Error ( setoff undecided amount > Undecided amount )
		  //'--------------------------------------------------------------------------
		  if(dLocAmt !=0 || dForAmt != 0)	{
				String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
				errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")\n";
				errMsg = errMsg+ObjUtils.getSafeString(rMap.get("PEND_NAME"))+" : "+ObjUtils.getSafeString(rMap.get("PEND_DATA_CODE"))+"\n";
				errMsg = errMsg+"화폐금액 :"+ObjUtils.getSafeString(rMap.get("MONEY_UNIT"))+" "+dLocAmt.toString();
				throw new  UniDirectValidateException(this.getMessage("54351;"+errMsg, user));

		  }
		}else if("3".equals(sApArDivi))	{
		  //1. INSERT AGB300T
		  rMap.put("BASE_AC_DATE", param.get("AC_DATE"));
		  rMap.put("TERM_DIVI", param.get("TERM_DIVI"));
		  rMap.put("S_USER_ID", user.getUserID());
		  super.commonDao.update("agj800ukrService.insertAgb300", rMap);
	      
		  //'2. UPDATE AGB300T, INSERT AGB310T
		  rsTemp = super.commonDao.list("agj800ukrService.setoffPending", rMap);
		  if(rsTemp == null || (rsTemp != null && rsTemp.size() == 0))	{
				String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
				errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")\n";
				errMsg = errMsg+ObjUtils.getSafeString(rMap.get("PEND_NAME"))+" : "+ObjUtils.getSafeString(rMap.get("PEND_DATA_CODE"))+"\n";
				errMsg = errMsg+"화폐금액 :"+ObjUtils.getSafeString(rMap.get("MONEY_UNIT"))+" "+dLocAmt.toString();
				throw new  UniDirectValidateException(this.getMessage("54350;"+errMsg, user));

		  }
		  inner:for(Map<String, Object> rTempMap : rsTemp)	{
		      
		    	dTmpLocAmt = 0.0;
		    	dTmpForAmt = 0.0;
		      
		      //'Step 5.2.2.1 AGB300T ( Setoff pending ) - Local Amount
		      //'--------------------------------------------------------------------------
		      if(dLocAmt != 0)	{
		          if(dLocAmt > ObjUtils.parseDouble(rTempMap.get("BLN_I")))	{
		        	  
		        	  super.commonDao.update("agj800ukrService.updateAmtAgb300", rTempMap);
		          
		          dTmpLocAmt = ObjUtils.parseDouble(rTempMap.get("BLN_I"));
	              dLocAmt = dLocAmt - dTmpLocAmt;
	          
			      } else if(dLocAmt == ObjUtils.parseDouble(rTempMap.get("BLN_I"))) {
			    	  super.commonDao.update("agj800ukrService.updateAmtAgb300", rTempMap);
			              
			          dTmpLocAmt = ObjUtils.parseDouble(rTempMap.get("BLN_I"));
			          dLocAmt = 0.0;
			          
			      }else {
			    	  rTempMap.put("D_LOC_AMT", dLocAmt);
			    	  super.commonDao.update("agj800ukrService.updateAmtAgb300", rTempMap);
			              dTmpLocAmt = dLocAmt;
			              dLocAmt = 0.0;
			      }
		      }
			 
		      //'Step 5.2.2.2 AGB300T ( Setoff pending ) - Foregin Amount
		      //'--------------------------------------------------------------------------
		      
		      if(dForAmt != 0)	{
		          if(dForAmt > ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I")))	{
		        	  
		        	  super.commonDao.update("agj800ukrService.updateForignAmtAgb300", rTempMap);
		          
		        	  dTmpForAmt = ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I"));
		        	  dForAmt = dForAmt - dTmpForAmt;
	          
			      } else if(dForAmt == ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I"))) {
			    	  super.commonDao.update("agj800ukrService.updateForignAmtAgb300", rTempMap);
			              
			          dTmpLocAmt = ObjUtils.parseDouble(rTempMap.get("FOR_BLN_I"));
			          dForAmt = 0.0;
			          
			      }else {
			    	  rTempMap.put("D_FOR_AMT", dForAmt);
			    	  super.commonDao.update("agj800ukrService.updateForignAmtAgb300", rTempMap);
			    	  dTmpForAmt = dForAmt;
			          dForAmt = 0.0;
			      }
		      }
		      
		      
		      //'Step 5.2.2.3 AGB310T ( Create setoff pending )
		      //'--------------------------------------------------------------------------
		      if(dTmpLocAmt != 0 || dTmpForAmt != 0)	{
		    	  rTempMap.put("BASE_AC_DATE", param.get("AC_DATE"));
		    	  rTempMap.put("TERM_DIVI", param.get("TERM_DIVI"));
		    	  rTempMap.put("S_USER_ID", user.getUserID());
		    	  rTempMap.put("D_LOC_AMT", dTmpLocAmt);
		    	  rTempMap.put("D_FOR_AMT", dTmpForAmt);
		    	  super.commonDao.update("agj800ukrService.createSetoffPending", rTempMap);
		      }
		      
		      //'Step 5.2.2.4 Exit setoff pending
		      //'--------------------------------------------------------------------------
		     if(dLocAmt == 0 && dForAmt == 0 ) break inner;	//'<-- Attention
		  }

		  if(dLocAmt !=0 || dForAmt != 0)	{
				String errMsg = "계정과목 : "+ObjUtils.getSafeString(rMap.get("ACCNT"))+"("+ObjUtils.getSafeString(rMap.get("ACCNT_NAME"))+")\n";
				errMsg = errMsg+"부서코드 : "+ObjUtils.getSafeString(rMap.get("DEPT_CODE"))+"("+ObjUtils.getSafeString(rMap.get("DEPT_NAME"))+")\n";
				errMsg = errMsg+ObjUtils.getSafeString(rMap.get("PEND_NAME"))+" : "+ObjUtils.getSafeString(rMap.get("PEND_DATA_CODE"))+"\n";
				errMsg = errMsg+"화폐금액 :"+ObjUtils.getSafeString(rMap.get("MONEY_UNIT"))+" "+dLocAmt.toString();
				throw new  UniDirectValidateException(this.getMessage("54351;"+errMsg, user));

		  }
		  
		
				}
			}
		
		}	
		
		//'Step 6. AGJ800T ( Flag Change )
		//'==============================================================================================
		super.commonDao.update("agj800ukrService.updateFlag", param);
    
		
		//Step 7. Get Return Values
		//==============================================================================================
		this.fnSetReturn(param);        
		//'========================================  E   N   D  =========================================
	}
	
	private void fnBalanceCancel(Map param, LoginVO user) throws Exception {

		List<Map<String, Object>> rsTemp, rsAcnt;
		String sInputPath, sPrevMonth;
		
		Double dDrAmt = 0.0, dCrAmt = 0.0;
		Double dForDrAmt = 0.0, dForCrAmt = 0.0;
		
		String baseAcDate = ObjUtils.getSafeString(param.get("AC_DATE"));
		String baseYear = "", baseMonth="";
		if(baseAcDate!= null && baseAcDate.length() ==6)	{
			baseYear = baseAcDate.substring(0,3);
			baseMonth= baseAcDate.substring(4,5);
		}
		
		//'Step 0. Variable init
		//'==============================================================================================
		if("1".equals(ObjUtils.getSafeString(param.get("TERM_DIVI"))))	{
			sInputPath = "A0";
		} else {
			sInputPath = "A1";
		}
		param.put("INPUT_PATH", sInputPath);
		
		//'Step 1. Data Check
		//'==============================================================================================
		
		//'Step 1.1 Total balance
		//'----------------------------------------------------------------------------------------------

		rsTemp = super.commonDao.list("agj800ukrService.getTotalbalance", param);
		if(rsTemp == null || (rsTemp != null && rsTemp.size() == 0))	{
			String errMsg = "기초년월 : "+baseYear+"년 "+ baseMonth +"월 "+"\n";
			errMsg = errMsg+"잔액취소불가 ";
			throw new  UniDirectValidateException(this.getMessage("54347;"+errMsg, user));
	    }
		Map rsTempMap = rsTemp.get(0);
		if( rsTempMap != null ) {
			if("N".equals(ObjUtils.getSafeString(rsTempMap.get("PROC_YN"))))	{
				String errMsg = "기초년월 : "+baseYear+"년 "+ baseMonth +"월 "+"\n";
				errMsg = errMsg+"잔액취소불가 ";
				throw new  UniDirectValidateException(this.getMessage("54347;"+errMsg, user));
			}
			if("1".equals(ObjUtils.getSafeString(param.get("TERM_DIVI"))) && ObjUtils.parseDouble(rsTempMap.get("DR_AMT_I")) != ObjUtils.parseDouble(rsTempMap.get("CR_AMT_I")))	{
				String errMsg = "기초년월 : "+baseYear+"년 "+ baseMonth +"월 "+"\n";
				errMsg = errMsg+"잔액취소불가 ";
				throw new  UniDirectValidateException(this.getMessage("54348;"+errMsg, user));
			}
				
		}

		//'Step 1.2 Previous year actual
		//'----------------------------------------------------------------------------------------------
		rsTemp = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.prevYearActualBalancing", param); 
	    
		if(ObjUtils.isEmpty(rsTemp) )	{
			return ;
		}
		if("1".equals(ObjUtils.getSafeString(param.get("TERM_DIVI"))))	{
			if(ObjUtils.isNotEmpty(rsTemp) && rsTemp.size() > 0 ){
				String errMsg = "기초년월 : "+baseYear+"년 "+ baseMonth +"월 "+"\n";
				errMsg = errMsg+"잔액취소불가 ";
				throw new  UniDirectValidateException(this.getMessage("54355;"+errMsg, user));
			}
		}
		
		
		//'Step 1.3 Sales balance
		//'----------------------------------------------------------------------------------------------
		rsTemp = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.checkSalesBalancing", param); 
	    
		if(ObjUtils.isEmpty(rsTemp) )	{
			return ;
		}
		if("1".equals(ObjUtils.getSafeString(param.get("TERM_DIVI"))))	{
			if(ObjUtils.isNotEmpty(rsTemp) && rsTemp.size() > 0 ){
				String errMsg = "기초년월 : "+baseYear+"년 "+ baseMonth +"월 "+"\n";
				errMsg = errMsg+"잔액취소불가 ";
				throw new  UniDirectValidateException(this.getMessage("54356;"+errMsg, user));
			}
		}
				
		//'Step 2. pending Account
		//'==============================================================================================
		
		//'Step 2.1 Get Setoff Data
		//'----------------------------------------------------------------------------------------------
		rsAcnt = (List<Map<String, Object>>)super.commonDao.list("agj800ukrService.getSetOffPending", param); 
	    
		if(!ObjUtils.isEmpty(rsAcnt) )	{
			throw new UniDirectValidateException("") ;
		}
		
		//'Step 2.2 Working
		//'----------------------------------------------------------------------------------------------
		Map tParamMap = new HashMap();
		tParamMap.putAll(param);
		for(Map rsAcntMap : rsAcnt)	{
			if(ObjUtils.parseDouble(rsAcntMap.get("J_AMT_I")) > ObjUtils.parseDouble(rsAcntMap.get("BLN_I")) )	{
				String errMsg = "계정과목 : "+rsAcntMap.get("ACCNT") + " (" + rsAcntMap.get("ACCNT_NAME") + ") "+"\n"; 
				errMsg = errMsg+"부서코드 : " + rsAcntMap.get("DEPT_CODE") + " (" + rsAcntMap.get("DEPT_NAME") + ") ]" +"\n"; 
				errMsg = errMsg+rsAcntMap.get("PEND_NAME") + " : " + rsAcntMap.get("PEND_DATA_CODE") + " ]" +"\n"; 
				errMsg = errMsg+"미결잔액 : " + ObjUtils.parseDouble(rsAcntMap.get("BLN_I")) ;
				throw new  UniDirectValidateException(this.getMessage("54351;"+errMsg, user));
			}
			if(ObjUtils.parseDouble(rsAcntMap.get("FOR_J_AMT_I")) > ObjUtils.parseDouble(rsAcntMap.get("FOR_BLN_I")) )	{
				String errMsg = "계정과목 : "+rsAcntMap.get("ACCNT") + " (" + rsAcntMap.get("ACCNT_NAME") + ") "+"\n"; 
				errMsg = errMsg+"부서코드 : " + rsAcntMap.get("DEPT_CODE") + " (" + rsAcntMap.get("DEPT_NAME") + ") ]" +"\n"; 
				errMsg = errMsg+rsAcntMap.get("PEND_NAME") + " : " + rsAcntMap.get("PEND_DATA_CODE") + " ]" +"\n"; 
				errMsg = errMsg+"외화미결잔액 : " + ObjUtils.parseDouble(rsAcntMap.get("BLN_I")) ;
				throw new  UniDirectValidateException(this.getMessage("54351;"+errMsg, user));
			}
			if("1".equals(rsAcntMap.get("JAN_DIVI")))	{
				dDrAmt = 0.0;
				dCrAmt =ObjUtils.parseDouble(rsAcntMap.get("J_AMT_I"));
				dForDrAmt = 0.0;
				dForCrAmt = ObjUtils.parseDouble(rsAcntMap.get("FOR_J_AMT_I"));
			}else {
				dCrAmt = 0.0;
				dDrAmt = ObjUtils.parseDouble(rsAcntMap.get("J_AMT_I"));
				dForCrAmt = 0.0;
				dForDrAmt = ObjUtils.parseDouble(rsAcntMap.get("FOR_J_AMT_I"));
			}
		
		
			//'Step 2.2.1 AGB100T ( Update G/L (General ledger) )
			//'--------------------------------------------------------------------------------------
			rsAcntMap.put("D_DR_AMT"	,dDrAmt);
			rsAcntMap.put("D_CR_AMT"	,dCrAmt);
			rsAcntMap.put("D_FOR_DR_AMT",dForDrAmt);
			rsAcntMap.put("D_FOR_CR_AMT",dForCrAmt);
			rsAcntMap.put("S_COMP_CODE",user.getCompCode());
			rsAcntMap.put("INPUT_PATH",sInputPath);
			rsAcntMap.put("S_COMP_CODE",user.getCompCode());
			rsAcntMap.put("BASE_AC_DATE",param.get("AC_CODE"));
			rsAcntMap.put("S_DIV_CODE",param.get("DIV_CODE"));
			super.commonDao.update("agj800ukrService.updateBalanceSet", rsAcntMap); 
		    
		
			//STEP 2.2.2 AGB200T ( UPDATE SUPPLEMENTARY ACCOUNT BOOK )
			//--------------------------------------------------------------------------------------
			
			super.commonDao.update("agj800ukrService.updateAgb200", rsAcntMap); 
		    
			//'STEP 2.2.3 AGB500T ( UPDATE DEPOSIT ACCOUNT )
			//'--------------------------------------------------------------------------------------
			super.commonDao.update("agj800ukrService.updateAgb500", rsAcntMap); 
		
			//'STEP 2.2.4 AGB300T ( UPDATE PENDING )
			//'--------------------------------------------------------------------------------------
			super.commonDao.update("agj800ukrService.updateCancelAmtAgb300", rsAcntMap); 
			
		
			//'STEP 2.2.5 AGB310T ( DELETE SETOFF PENDING )
			//'--------------------------------------------------------------------------------------
			super.commonDao.delete("agj800ukrService.deleteAgb310", rsAcntMap); 
			
		
			//'STEP 3.2.4 AGJ800T ( FLAG CHANGE )
			//'==============================================================================================
			rsAcntMap.put("TERM_DIVI",param.get("TERM_DIVI"));
			super.commonDao.delete("agj800ukrService.updateCancelFlag", rsAcntMap); 
		
			//'STEP 2.2.6 GET UNDECIDED DATA
			//'--------------------------------------------------------------------------------------
			rsTemp = (List<Map<String, Object>>)super.commonDao.list("agj800ukrService.getUndecidedData", rsAcntMap); 
			if(rsTemp != null && rsTemp.size() == 0 )	{
				String errMsg = "계정과목 : "+rsAcntMap.get("ACCNT") + " (" + rsAcntMap.get("ACCNT_NAME") + ") "+"\n"; 
				errMsg = errMsg+"부서코드 : " + rsAcntMap.get("DEPT_CODE") + " (" + rsAcntMap.get("DEPT_NAME") + ") ]" +"\n"; 
				errMsg = errMsg+rsAcntMap.get("PEND_NAME") + " : " + rsAcntMap.get("PEND_DATA_CODE") + " ]" +"\n"; 
				errMsg = errMsg+"화폐금액 : " +rsAcntMap.get("MONEY_UNIT")+" "+rsAcntMap.get("ORG_AMT_I");
				throw new  UniDirectValidateException(this.getMessage("54350;"+errMsg, user));
			}
			if(ObjUtils.parseDouble(rsAcntMap.get("J_AMT_I")) > ObjUtils.parseDouble(rsAcntMap.get("ORG_AMT_I")) )	{
				String errMsg = "계정과목 : "+rsAcntMap.get("ACCNT") + " (" + rsAcntMap.get("ACCNT_NAME") + ") "+"\n"; 
				errMsg = errMsg+"부서코드 : " + rsAcntMap.get("DEPT_CODE") + " (" + rsAcntMap.get("DEPT_NAME") + ") ]" +"\n"; 
				errMsg = errMsg+rsAcntMap.get("PEND_NAME") + " : " + rsAcntMap.get("PEND_DATA_CODE") + " ]" +"\n"; 
				errMsg = errMsg+"미결발생액 : " +rsAcntMap.get("ORG_AMT_I");
				throw new  UniDirectValidateException(this.getMessage("54352;"+errMsg, user));
			}
			if(ObjUtils.parseDouble(rsAcntMap.get("FOR_J_AMT_I")) > ObjUtils.parseDouble(rsAcntMap.get("FOR_ORG_AMT_I")) )	{
				String errMsg = "계정과목 : "+rsAcntMap.get("ACCNT") + " (" + rsAcntMap.get("ACCNT_NAME") + ") "+"\n"; 
				errMsg = errMsg+"부서코드 : " + rsAcntMap.get("DEPT_CODE") + " (" + rsAcntMap.get("DEPT_NAME") + ") ]" +"\n"; 
				errMsg = errMsg+rsAcntMap.get("PEND_NAME") + " : " + rsAcntMap.get("PEND_DATA_CODE") + " ]" +"\n"; 
				errMsg = errMsg+"외화미결발생액 : " +rsAcntMap.get("MONEY_UNIT")+" "+rsAcntMap.get("FOR_ORG_AMT_I");
				throw new  UniDirectValidateException(this.getMessage("54352;"+errMsg, user));
			}
		
		}
	
		
		//'Step 3. pending Account
		//'==============================================================================================
		
		//'Step 3.1 Get Setoff Data
		//'----------------------------------------------------------------------------------------------
		rsAcnt = (List<Map<String, Object>>)super.commonDao.list("agj800ukrService.getSetOffData", param); 
				
		//'STEP 3.2 WORKING
		//'----------------------------------------------------------------------------------------------
		for(Map rsAcntMap : rsAcnt)	{
			//'STEP 3.2.1 AGB300T ( CANCEL PENDING )
			//'==============================================================================================
			rsAcntMap.put("S_COMP_CODE", user.getCompCode());
			super.commonDao.delete("agj800ukrService.deleteAgb300", rsAcntMap); 

			if("1".equals(rsAcntMap.get("JAN_DIVI")))	{
				dDrAmt = ObjUtils.parseDouble(rsAcntMap.get("ORG_AMT_I"));
				dCrAmt = 0.0;
				dForDrAmt = ObjUtils.parseDouble(rsAcntMap.get("FOR_ORG_AMT_I"));
				dForCrAmt = 0.0;
			} else {
				dDrAmt = 0.0;
				dCrAmt = ObjUtils.parseDouble(rsAcntMap.get("ORG_AMT_I"));
				dForDrAmt = 0.0;
				dForCrAmt = ObjUtils.parseDouble(rsAcntMap.get("FOR_ORG_AMT_I"));
			}
			
			//'STEP 3.2.2 G/L (GENERAL LEDGER)
			//'==============================================================================================
			rsAcntMap.put("AC_DATE", rsAcntMap.get("ORG_AC_DATE"));
			rsAcntMap.put("D_DR_AMT", dDrAmt);
			rsAcntMap.put("D_CR_AMT", dCrAmt);
			rsAcntMap.put("D_FOR_DR_AMT", dForDrAmt);
			rsAcntMap.put("D_FOR_CR_AMT", dForCrAmt);
			
			super.commonDao.update("agj800ukrService.updateBalanceSet", rsAcntMap); 
						
			//'STEP 3.2.3 SUPPLEMENTARY ACCOUNT BOOK
			//'==============================================================================================
			super.commonDao.update("agj800ukrService.updateCancelAgb200", rsAcntMap); 
			
			
			//'STEP 3.2.3.1 AGB200T ( SUPPLEMENTARY ACCOUNT BOOK )
			//'----------------------------------------------------------------------------------------------
			super.commonDao.update("agj800ukrService.updateBalanceSet", rsAcntMap); 
			
			
			
			//'STEP 3.2.3.2 AGB500T ( DEPOSIT ACCOUNT )
			//'----------------------------------------------------------------------------------------------
			rsAcntMap.put("BASE_AC_DATE", rsAcntMap.get("ORG_AC_DATE"));
			super.commonDao.update("agj800ukrService.updateAgb500", rsAcntMap); 
			
			
			//'STEP 3.2.4 AGJ800T ( FLAG CHANGE )
			//'==============================================================================================
			super.commonDao.update("agj800ukrService.updateCancelFlag", rsAcntMap); 
		}
		
		
		//'Step 4. G/L (General ledger)
		//'==============================================================================================
		//'   2005.02.16 jINSOOK
		//'   미결계정은 잔액이 0일때만 삭제하고, 미결계정이 아니면 금액에 상관없이 삭제처리한다.
		//'   잔액입력이 완료되지 않은 상태에서 미결계정을 먼저 입력하고 반제처리할 경우
		//'   반제처리된 데이터를 뺀 나머지만 잔액반영을 취소해야하므로 미결계정여부에 따라 다르게 처리
		//'   agb100t, agb200t, agb500t 적용
		//'----------------------------------------------------------------------------------------------
		super.commonDao.update("agj800ukrService.deleteLedger", param); 
		
		//'STEP 5. SUPPLEMENTARY ACCOUNT BOOK
		//'==============================================================================================
		
		//'STEP 5.1 AGB200T ( SUPPLEMENTARY ACCOUNT BOOK )
		//'----------------------------------------------------------------------------------------------
		super.commonDao.update("agj800ukrService.deleteLedger", param); 
		
		
		//'STEP 5.2 AGB500T ( DEPOSIT ACCOUNT )
		//'----------------------------------------------------------------------------------------------
		super.commonDao.update("agj800ukrService.deleteDepositAccnt", param); 
		
		//'STEP 6 AGJ800T ( FLAG CHANGE )
		//'==============================================================================================
		super.commonDao.update("agj800ukrService.updateFlagChange", param); 
		
		
		//'Setp 7. 잔액취소 프로세스를 돌았으나 처리된 건수가 하나도 없는 것은
		//'        잔액반영 상태의 데이터가 모두 기초일자의 이후일자로 미결반제데이터가 있어서
		//'        취소할 수 없는 경우이다.
		//'==============================================================================================
		
		rsTemp = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.checkCancelComplete", param); 
		
		if(!ObjUtils.isEmpty(rsTemp))	{
			Map<String,Object> rsTempItem = rsTemp.get(0);
		
			String errMsg = "계정과목 : "+rsTempItem.get("ACCNT") + " (" + rsTempItem.get("ACCNT_NAME") + ") "+"\n"; 

			errMsg = errMsg+"부서코드 : " + rsTempItem.get("DEPT_CODE") + " (" + rsTempItem.get("DEPT_NAME") + ") ]" +"\n"; 
			errMsg = errMsg+rsTempItem.get("PEND_NAME") + " : " + rsTempItem.get("PEND_DATA_CODE") + " ]" +"\n"; 
			errMsg = errMsg+"미결금액 : " +rsTempItem.get("MONEY_UNIT")+" "+rsTempItem.get("ORG_AMT_I");
			throw new  UniDirectValidateException(this.getMessage("54353;"+errMsg, user));
	
		}
		
		//'Step 8. Get Return Values
		//'==============================================================================================
		this.fnSetReturn(param);  
		//'========================================  E   N   D  =========================================
		
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map paramMasterData = (Map) paramMaster.get("data");
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail1")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail1")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail1(paramMasterData, deleteList, user);
			if(insertList != null) this.insertDetail1(paramMasterData, insertList, user);
			if(updateList != null) this.updateDetail1(paramMasterData, updateList, user);				
		}
		
		this.fnSetReturn(paramMasterData);
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail1( Map paramMaster, List<Map> paramList, LoginVO user) throws Exception {		
		
			for(Map param : paramList )	{
				logger.debug("@@@@@@@@@@@@@@@@@@@   insertDetail1 :");
				String specdivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));

				logger.debug("@@@@@@@@@@@@@@@@@@@   SPEC_DIVI : " + specdivi);
				Map seqMap = (Map) super.commonDao.select("agj800ukrService.getSeq", param);
				param.put("SEQ", seqMap.get("SEQ"));
				if(ObjUtils.isNotEmpty(specdivi)){
					logger.debug("@@@@@@@@@@@@@@@@@@@   specdivi.substring : " + specdivi.substring(0,1));
					if("D".equals(specdivi.substring(0,1))){
							Map agj800Map = (Map) this.getAgj800(param, user);
							this.getAgj210(param, user);
							this.insertAfn100(param, agj800Map, user, "insertDetail1");
							this.insertAfn200(param, user);
						
		            }
				}
				try {
					super.commonDao.update("agj800ukrService.insertDetail", param);
				}catch(Exception e){
					logger.error(e.getMessage());
					e.printStackTrace();
					throw new  UniDirectValidateException(this.getMessage("2627", user));
				}	
			}
			
		return 0;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail1( Map paramMaster, List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 String specdivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
			if(ObjUtils.isNotEmpty(specdivi)){
		     if("D".equals(specdivi.substring(0,1))){
		    	//Map seqMap = (Map) super.commonDao.select("agj800ukrService.getSeq", param);
			    //param.put("SEQ", seqMap.get("SEQ"));
				Map agj800Map = (Map) this.getAgj800(param, user);
				if(ObjUtils.isNotEmpty(agj800Map)){
					this.getAgj210(param,  user);
					this.deleteAfn100(agj800Map, user);
					this.deleteAfn200(agj800Map, user);
					this.insertAfn100(param, agj800Map,  user, "updateDetail1");
					this.insertAfn200(agj800Map, user);
				}
		     }
			}
		     super.commonDao.update("agj800ukrService.updateDetail", param);
		 }		 
		 return 0;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true, value = ExtDirectMethodType.STORE_MODIFY )
	public Integer deleteDetail1( Map paramMaster, List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 
			String specdivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
			if(ObjUtils.isNotEmpty(specdivi)){
			 if("D".equals(specdivi.substring(0,1))){
				//Map seqMap = (Map) super.commonDao.select("agj800ukrService.getSeq", param);
				//param.put("SEQ", seqMap.get("SEQ"));
				Map agj800Map = (Map) this.getAgj800(param, user);
				if(ObjUtils.isNotEmpty(agj800Map)){
					this.getAgj210(param, user);
					this.deleteAfn100(agj800Map,  user);
					this.deleteAfn200(param, user);
				}
			 }
			}
			try {
				super.commonDao.delete("agj800ukrService.deleteDetail", param);
			}
			catch(Exception e)	{
				logger.error(e.toString());
	    		throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail2(deleteList, user);
			if(insertList != null) this.insertDetail2(insertList, user);
			if(updateList != null) this.updateDetail2(updateList, user);				
		}
		
		this.fnSetReturn(paramMaster);
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		
			for(Map param : paramList )	{
				Map seqMap = (Map) super.commonDao.select("agj800ukrService.getSeq", param);
				param.put("SEQ", seqMap.get("SEQ"));
				String specdivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
				if(ObjUtils.isNotEmpty(specdivi)){
					if("D".equals(specdivi.substring(0,1))){
						Map agj800Map = (Map) this.getAgj800(param, user);
						if(ObjUtils.isNotEmpty(agj800Map)){
							this.getAgj210(param, user);
							this.insertAfn100(param, agj800Map, user, "insertDetail1");
							this.insertAfn200(agj800Map, user);
						}
					}
				}
				try {
					super.commonDao.update("agj800ukrService.insertDetail2", param);
				}catch(Exception e){
					throw new  UniDirectValidateException(this.getMessage("2627", user));
				}	
			}
			
		return 0;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 String specdivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
				if(ObjUtils.isNotEmpty(specdivi)){
					if("D".equals(specdivi.substring(0,1))){
						Map agj800Map = (Map) this.getAgj800(param, user);
						if(ObjUtils.isNotEmpty(agj800Map)){
							this.getAgj210(param, user);
							this.deleteAfn100(agj800Map,  user);
							this.deleteAfn200(agj800Map, user);
							this.insertAfn100(param, agj800Map, user, "insertDetail1");
							this.insertAfn200(agj800Map, user);
						}
				    }
				}
			 super.commonDao.update("agj800ukrService.updateDetail2", param);
		 }		 
		 return 0;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 
				 String specdivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
				if(ObjUtils.isNotEmpty(specdivi)){
					 if("D".equals(specdivi.substring(0,1))){
						Map agj800Map = (Map) this.getAgj800(param, user);
						if(ObjUtils.isNotEmpty(agj800Map)){
							this.getAgj210(param, user);
							this.deleteAfn100(agj800Map,  user);
							this.deleteAfn200(agj800Map, user);
						}
					 }
				}
				try {
					super.commonDao.delete("agj800ukrService.deleteDetail2", param);
				}catch(Exception e)	{
		    		throw new  UniDirectValidateException(this.getMessage("547",user));
				}
		 }
		 return 0;
	}
	@ExtDirectMethod(group = "accnt")
	public void insertAfn100(Map saveParam, Map param, LoginVO user, String dataMethod) throws Exception {   
	    String sNoteSts , sNoteNum , sCustCode, sAcCd;
	    String sSpecDivi = ObjUtils.getSafeString(saveParam.get("SPEC_DIVI")), sDrCr;
	    
	    String sSlipAcDate, sNoteAcDate;
	    Map insertParam = new HashMap();
	    
	    if(!"D".equals(sSpecDivi.substring(0,1)))	{
			return;
		}
	   // '==============================================================================
	   // '   부도어음일 때 관리항목에 어음번호를 설정하지 않았으면 Skip.
	   // '==============================================================================
		if("D4".equals(sSpecDivi) && !"C2".equals(saveParam.get("BOOK_CODE1")) && !"C2".equals(saveParam.get("BOOK_CODE2")))	{
			return;
		}
		//'==============================================================================
	    //'   어음번호, 거래처코드 셋팅
	    //'==============================================================================
		sNoteNum = this.getAcData(saveParam, "C2");
		sCustCode = this.getAcData(saveParam, "A4");
		sDrCr = this.getDrCr(saveParam);
		if("".equals(sNoteNum))	{
			throw new  UniDirectValidateException(this.getMessage("54306;", user));
		}
	    if(ObjUtils.isEmpty(sCustCode)){
			throw new  UniDirectValidateException(this.getMessage("54308;", user));
		}
	    Map tParam = new HashMap();
	    tParam.put("S_COMP_CODE", user.getCompCode());
	    tParam.put("S_USER_ID", user.getUserID());
	    tParam.put("NOTE_NUM", sNoteNum);
	    //==========================================================================
	    //   Get afn100t
	    //==========================================================================
	    Map afn100Map = (Map) super.commonDao.select("agj800ukrService.getAfn100", tParam);
		
	    //'==============================================================================
	    //'   Set 기초년월, 어음사용된 최종 기초년월 및 순번
	    //'==============================================================================
	    if(dataMethod!=null && dataMethod.indexOf("update") >=0)	{
	    	sSlipAcDate = saveParam.get("AC_DATE")+String.format("%05d", Integer.parseInt(ObjUtils.getSafeString(saveParam.get("SEQ")))); ;
	    	tParam.put("AC_DATE", saveParam.get("AC_DATE"));

	    	Map lastNoteDateMap = (Map) super.commonDao.select("agj800ukrService.getLastNote", tParam);
	    	if(lastNoteDateMap != null)	{
		    	sNoteAcDate = ObjUtils.getSafeString(lastNoteDateMap.get("LAST_AC_DATE"));
		    	String[] sNoteDateArr =  {sNoteAcDate.substring(0, 5), sNoteAcDate.substring(6, 10)};
		    	String accnt = "";
		    	String nteStsNm = "";
		    	if(lastNoteDateMap != null)	{
		    		accnt =  ObjUtils.getSafeString(lastNoteDateMap.get("ACCNT"));
		    	}
		    	if(afn100Map != null)	{
		    		nteStsNm = ObjUtils.getSafeString(afn100Map.get("NOTE_STS_NM"));
		    	}
		        this.checkLastData(sNoteNum, nteStsNm, accnt, sSlipAcDate, sNoteAcDate, sNoteDateArr, user);
	    	}
	    }
	    
	    //'==============================================================================
	    //'   차변일 경우
	    //'==============================================================================
	    if("1".equals(sDrCr))	{
	    	if("D1".equals(sSpecDivi))	{
	    		sAcCd = sSpecDivi;
	        
		        //'==========================================================================
		        //'   Get Note Status : unsettled
		        //'==========================================================================
		        sNoteSts = "1";
	        
		        //'==========================================================================
		        //'   Update / Insert afn100
		        //'==========================================================================
		        if(ObjUtils.isEmpty(afn100Map))	{
		        	insertParam.put("S_COMP_CODE", user.getCompCode());
		        	insertParam.put("NOTE_NUM", sNoteNum);
		        	insertParam.put("SPEC_DIVI", sSpecDivi);
		        	insertParam.put("CUST_CODE", sCustCode);
		        	insertParam.put("OC_AMT_I", saveParam.get("DR_AMT_I"));
		        	insertParam.put("ACCNT", saveParam.get("ACCNT") );
		        	insertParam.put("NOTE_STS", sNoteSts);
		        	insertParam.put("S_USER_ID", user.getUserID());
		        	super.commonDao.insert("agj800ukrService.insertAfn100", insertParam);
		        }else {
		        	
		        	if(!"2".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ) && !"3".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ))	{
						String errMsg = "어음번호 : "+sNoteNum+"\n";
						errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";
						logger.error(this.getMessage("54375;"+errMsg, user));
						throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
					}
		        	
		        	if(!sCustCode.equals(ObjUtils.getSafeString(afn100Map.get("CUSTOM_CODE")) ))	{
						String errMsg = "어음번호 : "+sNoteNum+"\n";
						errMsg = errMsg+"거래처 : "+afn100Map.get("CUSTOM_CODE")+"\n";
						logger.error(this.getMessage("54378;"+errMsg, user));
						throw new  UniDirectValidateException(this.getMessage("54378;"+errMsg, user));
					}
		            
		        	if(Double.compare(ObjUtils.parseDouble(saveParam.get("DR_AMT_I")), (ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) )) != 0d)	{
						String errMsg = "어음번호 : "+sNoteNum+"\n";
						errMsg = errMsg+"어음금액 : "+afn100Map.get("OC_AMT_I")+"\n";
						logger.error(this.getMessage("54377;"+errMsg, user));
						
						throw new  UniDirectValidateException(this.getMessage("54377;"+errMsg, user));
					}
		        	
		        	tParam.put("NOTE_STS", sNoteSts);
		        	tParam.put("AC_CD", sAcCd);
		        	super.commonDao.update("agj800ukrService.updateAfn100_N", tParam);
		        }
		        
	    	}else if("D3".equals(sSpecDivi))	{
	    		sAcCd = sSpecDivi;
	    		if(ObjUtils.isEmpty(afn100Map))	{
	    			String errMsg = "어음번호 : "+sNoteNum+"\n";
					logger.error(this.getMessage("54306;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
	    		}
	        
	    		if(!"1".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ) && !"6".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";

					logger.error(this.getMessage("54307;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54307;"+errMsg, user));
				}
	    		
	    		if(!sCustCode.equals(ObjUtils.getSafeString(afn100Map.get("CUSTOM_CODE")) ))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"거래처 : "+afn100Map.get("CUSTOM_CODE")+"\n";
					logger.error(this.getMessage("54378;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54378;"+errMsg, user));
				}
	        
	    		if(ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) < ObjUtils.parseDouble(afn100Map.get("J_AMT_I"))  + (ObjUtils.parseDouble(saveParam.get("DR_AMT_I")) ))	{	
	    			String errMsg = "어음번호 : "+sNoteNum+"\n";
	    			errMsg = errMsg+"어음금액 : "+afn100Map.get("OC_AMT_I")+"\n";
	    			logger.error(this.getMessage("54377;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54377;"+errMsg, user));
				}
	        
	        //'==========================================================================
	        //'   Get Note Status : settled
	        //'==========================================================================
	    		sNoteSts = "2";
	        
	    		if(ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) > ObjUtils.parseDouble(afn100Map.get("J_AMT_I"))  + (ObjUtils.parseDouble(saveParam.get("DR_AMT_I")) ))	{		
		            sNoteSts = "6";
	    		}
	    		tParam.put("NOTE_NUM", sNoteNum);
	    		tParam.put("NOTE_STS", sNoteSts);
	    		tParam.put("AMT_I", saveParam.get("DR_AMT_I"));
	    		tParam.put("AC_CD", sAcCd);
	    		super.commonDao.update("agj800ukrService.updateAfn100_D3", tParam);
	    		
	    	}else if("D4".equals(sSpecDivi))	{
	    
		        //'==========================================================================
		        //'   Get Note Status : dishonor
		        //'==========================================================================
		        sNoteSts = "4";
		        
		        //'==========================================================================
		        //'   Update / Insert afn100t
		        //'==========================================================================
        		if(ObjUtils.isEmpty(afn100Map))	{
		        	insertParam.put("S_COMP_CODE", user.getCompCode());
		        	insertParam.put("NOTE_NUM", sNoteNum);
		        	insertParam.put("SPEC_DIVI", sSpecDivi);
		        	insertParam.put("CUST_CODE", sCustCode);
		        	insertParam.put("OC_AMT_I", saveParam.get("DR_AMT_I"));
		        	insertParam.put("ACCNT", saveParam.get("ACCNT") );
		        	insertParam.put("NOTE_STS", sNoteSts);
		        	insertParam.put("S_USER_ID", user.getUserID());
		        	super.commonDao.insert("agj800ukrService.insertAfn100", insertParam);
		        }else {
		        	
		        	if(!sCustCode.equals(ObjUtils.getSafeString(afn100Map.get("CUSTOM_CODE")) ))	{
						String errMsg = "어음번호 : "+sNoteNum+"\n";
						errMsg = errMsg+"거래처 : "+afn100Map.get("CUSTOM_CODE")+"\n";
						logger.error(this.getMessage("54378;"+errMsg, user));
						throw new  UniDirectValidateException(this.getMessage("54378;"+errMsg, user));
					}
		        	
		        	//=============================================================================
		            logger.debug("################  DR_AMT_I : "+saveParam.get("DR_AMT_I"));
		            logger.debug("################  OC_AMT_I : "+afn100Map.get("OC_AMT_I"));
		            Double a = ObjUtils.parseDouble(saveParam.get("DR_AMT_I"));
		            Double b = ObjUtils.parseDouble(afn100Map.get("OC_AMT_I"));
		            Double c = a-b;
		            
		            if(Double.compare(a, b) == 0 )	{
		            	logger.debug("################  Double.compare(a, b) : "+ String.valueOf(Double.compare(a, b)));
		            }
		            if(Double.compare(ObjUtils.parseDouble(saveParam.get("DR_AMT_I")), ObjUtils.parseDouble(afn100Map.get("OC_AMT_I"))) == 0d )	{
		            	logger.debug("################  Double.compare(a, b) : "+ String.valueOf(Double.compare(a, b)));
		            }
		          //=============================================================================
		        	if(Double.compare(ObjUtils.parseDouble(saveParam.get("DR_AMT_I")), ObjUtils.parseDouble(afn100Map.get("OC_AMT_I"))) != 0d)	{
						String errMsg = "어음번호 : "+sNoteNum+"\n";
						errMsg = errMsg+"어음금액 : "+afn100Map.get("OC_AMT_I")+"\n";
						logger.error(this.getMessage("54377;"+errMsg, user));
						throw new  UniDirectValidateException(this.getMessage("54377;"+errMsg, user));
					}
		        	
		        	tParam.put("NOTE_NUM", sNoteNum);
		        	tParam.put("NOTE_STS", sNoteSts);
		        	tParam.put("AMT_I", param.get("DR_AMT_I"));
		        	super.commonDao.update("agj800ukrService.updateAfn100_D4", tParam);
		        }
		        		
		        		
	    	}
	    }else if( "2".equals(sDrCr))	{
	    //'==============================================================================
	    //'   대변일 경우
	    //'==============================================================================
	    	if("D1".equals(sSpecDivi))	{
		    
		        sAcCd = sSpecDivi;
		        
		        
		        if(ObjUtils.isEmpty(afn100Map))	{
		        	String errMsg = "어음번호 : "+sNoteNum+"\n";
					logger.error(this.getMessage("54306;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
			
		        }
		        	
		        if(!"1".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ) && !"6".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";

					logger.error(this.getMessage("54375;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
				}
	    		
	    		if(!sCustCode.equals(ObjUtils.getSafeString(afn100Map.get("CUSTOM_CODE")) ))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"거래처 : "+afn100Map.get("CUSTOM_CODE")+"\n";
					logger.error(this.getMessage("54378;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54378;"+errMsg, user));
				}
	        
	    		if(ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) < ObjUtils.parseDouble(afn100Map.get("J_AMT_I"))  + (ObjUtils.parseDouble(saveParam.get("CR_AMT_I")) ))	{	
	    			String errMsg = "어음번호 : "+sNoteNum+"\n";
	    			errMsg = errMsg+"어음금액 : "+afn100Map.get("OC_AMT_I")+"\n";
	    			logger.error(this.getMessage("54377;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54377;"+errMsg, user));
				}
	    		
	    		//'==========================================================================
		        //'   Get Note Status : settled
		        //'==========================================================================
	    		sNoteSts = "2";
		        
	    		if(ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) > ObjUtils.parseDouble(afn100Map.get("J_AMT_I"))  + (ObjUtils.parseDouble(saveParam.get("CR_AMT_I")) ))	{		
		            sNoteSts = "6";
	    		}
	    		tParam.put("NOTE_NUM", sNoteNum);
	    		tParam.put("NOTE_STS", sNoteSts);
	    		tParam.put("AMT_I", saveParam.get("CR_AMT_I"));
	    		tParam.put("AC_CD", sAcCd);
	        	super.commonDao.update("agj800ukrService.updateAfn100_D3", tParam);
	    	}else if("D3".equals(sSpecDivi))    	{ 
	    		sAcCd = sSpecDivi;
		        
	    		if(afn100Map != null)	{
	    			String errMsg = "어음번호 : "+sNoteNum+"\n";
	    			if(param != null ) {
	    				errMsg = errMsg+"어음상태 : "+param.get("NOTE_STS_NM")+"\n";
	    			}
	    			logger.error(this.getMessage("54375;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
	    		}
	        
	    		//'==========================================================================
		        //'   Get Note Status : unsettled
		        //'==========================================================================
		        sNoteSts = "1";

		        //'==========================================================================
		        //'   Insert afn100t
		        //'==========================================================================
		        if(ObjUtils.isEmpty(afn100Map))	{
		        	insertParam.put("S_COMP_CODE", user.getCompCode());
		        	insertParam.put("NOTE_NUM", sNoteNum);
		        	insertParam.put("SPEC_DIVI", sSpecDivi);
		        	insertParam.put("CUST_CODE", sCustCode);
		        	insertParam.put("OC_AMT_I", saveParam.get("CR_AMT_I"));
		        	insertParam.put("ACCNT", saveParam.get("ACCNT") );
		        	insertParam.put("NOTE_STS", sNoteSts);
		        	insertParam.put("S_USER_ID", user.getUserID());
		        	super.commonDao.insert("agj800ukrService.insertAfn100", insertParam);
		        }
	    	}else if("D4".equals(sSpecDivi))	{
	    		if(ObjUtils.isEmpty(afn100Map))	{
	    			String errMsg = "어음번호 : "+sNoteNum+"\n";
	    			logger.error(this.getMessage("54306;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
	    		}
	        
	        	if(!"4".equals(ObjUtils.getSafeString(afn100Map.get("NOTE_STS")) ))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";
					logger.error(this.getMessage("54375;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
				}
	        	
	        	if(!sCustCode.equals(ObjUtils.getSafeString(afn100Map.get("CUSTOM_CODE")) ))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"거래처 : "+afn100Map.get("CUSTOM_CODE")+"\n";
					logger.error(this.getMessage("54378;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54378;"+errMsg, user));
				}
	            
	        	if(Double.compare(ObjUtils.parseDouble(saveParam.get("CR_AMT_I")) , (ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) )) !=  0d)	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음금액 : "+afn100Map.get("OC_AMT_I")+"\n";
					logger.error(this.getMessage("54377;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54377;"+errMsg, user));
				}
	        	
	        	//'==========================================================================
		        //'   Get Note Status : settle
		        //'==========================================================================
		        sNoteSts = "2";

	    		tParam.put("NOTE_NUM", sNoteNum);
	        	tParam.put("NOTE_STS", sNoteSts);
	        	tParam.put("AMT_I", saveParam.get("CR_AMT_I"));
	        	
	        	super.commonDao.update("agj800ukrService.updateAfn100_D4", tParam);
	        
		  
	    	}
	    }
	}
	@ExtDirectMethod(group = "accnt")
	public void deleteAfn100(  Map agj800Map,LoginVO user) throws Exception {
		
		
		Map param = new HashMap();
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		param.put("ACCNT", user.getUserID());
		
		long lAffectedCnt;
		
		//Dim rsNote As Object, rsTemp As Object
		
		//Dim sSql As String
		String sNoteSts, sNoteNum, sCustCode;
		String sAcCd , sDrCr;
		String sSpecDivi = ObjUtils.getSafeString(agj800Map.get("SPEC_DIVI"));
		
		String sSlipDate;
		//Dim sPrevAcDate As Variant
		
		if(sSpecDivi.indexOf("D") != 0)	{
			return;
		}
		if("D4".equals(sSpecDivi) && !"C2".equals(agj800Map.get("BOOK_CODE1")) && !"C2".equals(agj800Map.get("BOOK_CODE2")))	{
			logger.error("계정잔액코드가 입력되지 않았습니다.");
			throw new  UniDirectValidateException("계정잔액코드가 입력되지 않았습니다.");
		}
		
		sNoteNum = this.getAcData(agj800Map, "C2");
		sCustCode = this.getAcData(agj800Map, "A4");
		
		sDrCr = this.getDrCr(agj800Map);
		
		if("".equals(sNoteNum))	{
			logger.error(this.getMessage("54306;", user));
			logger.error(this.getMessage("54306;", user));
			throw new  UniDirectValidateException(this.getMessage("54306;", user));
		}
		
		//sSlipDate = Format(Trim("" & rsSlip("AC_DATE")), "000000") + "-" + Format(Trim("" & rsSlip("SEQ")), "00000")
		//sSlipDate = Replace(sSlipDate, "-", "")
		sSlipDate = agj800Map.get("AC_DATE")+String.format("%05d", Integer.parseInt(ObjUtils.getSafeString(agj800Map.get("SEQ")))); ;
		
		param.put("ACCNT", agj800Map.get("ACCNT"));
		param.put("NOTE_NUM", sNoteNum);
		param.put("AC_DATE", sSlipDate);
		
		Map afn100Map = (Map) super.commonDao.select("agj800ukrService.getAfn100WidthAccnt", param);
		
		if(ObjUtils.isEmpty(afn100Map))	{
			String errMsg = "어음번호 :"+sNoteNum+"\n"+"작업위치 : D.1";
			logger.error(this.getMessage("54306;"+errMsg, user));
			throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
		}

		String [] sPrevAcDate = ObjUtils.getSafeString(afn100Map.get("PREV_AC_DATE")).split("|#");
		String    sPrevDate = ObjUtils.getSafeString(afn100Map.get("PREV_AC_DATE")).replace("|#", "");
		
		
		//==============================================================================
	    //   차변일 경우
	    //==============================================================================
		if("1".equals(sDrCr))	{
			if("D1".equals(sSpecDivi)) {
				sAcCd = ObjUtils.getSafeString(agj800Map.get("SPEC_DIVI"));
		
				if( ObjUtils.parseInt(afn100Map.get("NOTE_STS")) > 1)	{
					String errMsg = "어음번호 : "+sNoteNum+"\n"+"어음상태 : "+afn100Map.get("NOTE_STS_NM");
					logger.error(this.getMessage("54375;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
				}
				//----------------------------------------------------------------------
		        //   삭제하고자 하는 데이터가 해당 어음에 대한 최종데이터인지 확인
		        //----------------------------------------------------------------------
				this.checkLastData(sNoteNum, ObjUtils.getSafeString(afn100Map.get("NOTE_STS_NM")), ObjUtils.getSafeString(param.get("ACCNT")),  sPrevDate, sSlipDate, sPrevAcDate, user);
				
				
				if(ObjUtils.isNotEmpty(sPrevDate)) {
					
					//----------------------------------------------------------------------
		            //   차변에 받을어음이 온 최종 전표일 구하기 ①
		            //----------------------------------------------------------------------
					// rsTemp
					
					param.put("SLIP_DATE", sSlipDate);					
					Map slip100Map = (Map) super.commonDao.select("agj800ukrService.getDeleteSlip100", param);
					if(ObjUtils.isEmpty(slip100Map))	{
						logger.error("어음 전표가 존재하지 않습니다.");
						throw new  UniDirectValidateException("어음 전표가 존재하지 않습니다.");
					}
					
					param.put("PREV_AC_DATE", slip100Map.get("PREV_AC_DATE"));
					Map deleteAmt100Map = (Map) super.commonDao.select("agj800ukrService.getDeleteAmt100", param);
					if(ObjUtils.isEmpty(deleteAmt100Map))	{
						logger.error("결제된 금액이 존재하지 않습니다.");
						throw new  UniDirectValidateException("결제된 금액이 존재하지 않습니다.");
					}
					
					//----------------------------------------------------------------------
		            //   Update afn100t
		            //----------------------------------------------------------------------
					sNoteSts = "2";
					
					if( ObjUtils.parseDouble(afn100Map.get("OC_AMT_I")) != ObjUtils.parseDouble(deleteAmt100Map.get("AMT_I"))) {
						sNoteSts = "6";
					}
					
					param.put("NOTE_STS", sNoteSts);
					param.put("AC_CD", sAcCd);
					param.put("AMT_I", deleteAmt100Map.get("AMT_I"));
					
					super.commonDao.update("agj800ukrService.updateAfn100", param);
			
				}else{
					param.put("AC_CD", sAcCd);
					super.commonDao.update("agj800ukrService.deleteAfn100", param);
				}
		
			}else if("D3".equals(sSpecDivi))	{
					sAcCd = ObjUtils.getSafeString(agj800Map.get("SPEC_DIVI"));
			
				//----------------------------------------------------------------------
				//   삭제하고자 하는 데이터가 해당 어음에 대한 최종데이터인지 확인
				//----------------------------------------------------------------------
				this.checkLastData(sNoteNum, ObjUtils.getSafeString(afn100Map.get("NOTE_STS_NM")), ObjUtils.getSafeString(agj800Map.get("ACCNT")),  sPrevDate, sSlipDate, sPrevAcDate, user);
					
				//----------------------------------------------------------------------
				//   Set Note State
				//----------------------------------------------------------------------
				sNoteSts = "1";
				
				if((ObjUtils.parseDouble(afn100Map.get("J_AMT_I")) - ObjUtils.parseDouble(param.get("DR_AMT_I"))) > 0 ) {
					sNoteSts = "6";
				}
				
				//----------------------------------------------------------------------
				//   Update afn100t
				//----------------------------------------------------------------------
				
				param.put("AC_CD", sAcCd);
				param.put("AMT_I",  ObjUtils.parseDouble(param.get("DR_AMT_I")));
				
				super.commonDao.update("agj800ukrService.updateAfn100_D4", param);
				
			}else if("D4".equals(sSpecDivi))	{
				
				//----------------------------------------------------------------------
				//   Check Note State
				//----------------------------------------------------------------------
				if( !"4".equals(afn100Map.get("NOTE_STS")))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";
					logger.error(this.getMessage("54375;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
				}
				
				//----------------------------------------------------------------------
				//   Set Note State
				//----------------------------------------------------------------------
				sNoteSts = "1";
				
				//----------------------------------------------------------------------
				//   Update afn100t
				//----------------------------------------------------------------------
				param.put("NOTE_STS", sNoteSts);
				param.put("AC_CD", null);
				param.put("AMT_I", ObjUtils.parseDouble(param.get("DR_AMT_I")));
				
				super.commonDao.update("agj800ukrService.updateAfn100_D3", param);
			}
			
		//==============================================================================
		//   대변일 경우
		//==============================================================================		
		} else if("2".equals(sDrCr)) {
			
			
			if( "D1".equals(sSpecDivi)) {
				
				sAcCd = ObjUtils.getSafeString(agj800Map.get("SPEC_DIVI"));
				
				//----------------------------------------------------------------------
				//   삭제하고자 하는 데이터가 해당 어음에 대한 최종데이터인지 확인
				//----------------------------------------------------------------------
				this.checkLastData(sNoteNum, ObjUtils.getSafeString(afn100Map.get("NOTE_STS_NM")), ObjUtils.getSafeString(agj800Map.get("ACCNT")),  sPrevDate, sSlipDate, sPrevAcDate, user);
				
				if("4".equals(afn100Map.get("NOTE_STS")))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";
					errMsg = errMsg+"기초년월 : "+(ObjUtils.isNotEmpty(sPrevAcDate) ? sPrevAcDate[0]:"") +"\n";
					errMsg = errMsg+"순번     : "+(ObjUtils.isNotEmpty(sPrevAcDate) ? sPrevAcDate[1]:"0")+"\n";
					errMsg = errMsg+"계정코드 : "+param.get("ACCNT")+"\n";
					logger.error(this.getMessage("55327;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("55327;"+errMsg, user));
				}
				
				//----------------------------------------------------------------------
				//   Set Note Status
				//----------------------------------------------------------------------
				sNoteSts = "1";
				
				if((ObjUtils.parseDouble(afn100Map.get("J_AMT_I")) - ObjUtils.parseDouble(param.get("CR_AMT_I"))) > 0 ) {			
					sNoteSts = "6";
				}
				
				//----------------------------------------------------------------------
				//   Update afn100t
				//----------------------------------------------------------------------
				param.put("NOTE_STS", sNoteSts);
				param.put("AC_CD", sAcCd);
				param.put("AMT_I", ObjUtils.parseDouble(param.get("CR_AMT_I")));
				
				super.commonDao.update("agj800ukrService.updateAfn100_D4", param);
				
			}else if("D3".equals(sSpecDivi))	{
			
				sAcCd = ObjUtils.getSafeString(agj800Map.get("SPEC_DIVI"));
			
				//----------------------------------------------------------------------
				//   Check Note State
				//----------------------------------------------------------------------
				if("1".equals(afn100Map.get("NOTE_STS")))	{
					String errMsg = "어음번호 : "+sNoteNum+"\n";
					errMsg = errMsg+"어음상태 : "+afn100Map.get("NOTE_STS_NM")+"\n";

					logger.error(this.getMessage("54375;"+errMsg, user));
					throw new  UniDirectValidateException(this.getMessage("54375;"+errMsg, user));
				}
				
				//'----------------------------------------------------------------------
				//'   Delete afn100t
				//'----------------------------------------------------------------------
				param.put("AC_CD", sAcCd);
				super.commonDao.update("agj800ukrService.deleteAfn100", param);
				
			}else if("D4".equals(sSpecDivi))	{
				
				//'----------------------------------------------------------------------
				//'   삭제하고자 하는 데이터가 해당 어음에 대한 최종데이터인지 확인
				//'----------------------------------------------------------------------
				this.checkLastData(sNoteNum, ObjUtils.getSafeString(afn100Map.get("NOTE_STS_NM")), ObjUtils.getSafeString(agj800Map.get("ACCNT")),  sPrevDate, sSlipDate, sPrevAcDate, user);
					
				
				//'----------------------------------------------------------------------
				//'   Set Note Status
				//'----------------------------------------------------------------------
				sNoteSts = "4";
				
				//'----------------------------------------------------------------------
				//'   Update afn100t
				//'----------------------------------------------------------------------
				param.put("NOTE_STS", sNoteSts);
				
				super.commonDao.update("agj800ukrService.updateAfn100_N", param);
			}
		}	
	}
	private Object getAgj210(Map param, LoginVO user) throws Exception {
		if("D4".equals(param.get("SPEC_DIVI")) )	{
			if(!"C2".equals(param.get("BOOK_CODE1")) && !"C2".equals(param.get("BOOK_CODE2")))	{
				return null;
			}
		}
		
		String sNoteNum = this.getAcData(param, "C2");
		
		if(sNoteNum == null || ObjUtils.isEmpty(sNoteNum))	{
			logger.error(this.getMessage("54306;", user));
			throw new  UniDirectValidateException(this.getMessage("54306;", user));
		}
		param.put("CHK_NOTE_NUM", sNoteNum);
		Map rtnMap = (Map)super.commonDao.select("agj800ukrService.getAgj210", param);
		if(ObjUtils.isNotEmpty(rtnMap))	{
			if(ObjUtils.parseInt(rtnMap.get("SLIP_CNT")) != 0)	{
				String[] sSlipDate = ObjUtils.getSafeString(rtnMap.get("LAST_SLIP")).split("|#");
				
				String errMsg = "어음번호:"+sNoteNum+"\n"+"전표일자:"+rtnMap.get("AC_DATE");
				if(ObjUtils.isNotEmpty(sSlipDate) && sSlipDate.length == 20)	{
					errMsg = errMsg+"\n"+"전표번호:"+sSlipDate[0]+"\n"+"전표순번:"+sSlipDate[1];
				}
				logger.error(this.getMessage("55325;"+errMsg, user));
				throw new  UniDirectValidateException(this.getMessage("55325;"+errMsg, user));
			}
		}
		return rtnMap;
	}
	private void insertAfn200(Map param, LoginVO user) throws Exception {
		
		String  sNoteSts, sNoteNum, sCustCode;
		String sSpecDivi, sDrCr;
		
		
		if(!"D3".equals(ObjUtils.getSafeString(param.get("SPEC_DIVI"))))	return;
		
		sNoteNum = this.getAcData(param, "C2");
		sCustCode = this.getAcData(param, "A4");
		sSpecDivi = ObjUtils.getSafeString(param.get("SPEC_DIVI"));
		sDrCr = this.getDrCr(param);
		Map tParam = new HashMap();
		tParam.put("S_COMP_CODE", user.getCompCode());
		tParam.put("S_USER_ID", user.getUserID());
		tParam.put("NOTE_NUM", sNoteNum);
		
		if(ObjUtils.isEmpty(sNoteNum))	{
			logger.error(this.getMessage("54306;", user));
			throw new  UniDirectValidateException(this.getMessage("54306;", user));
		}
		
		if(ObjUtils.isEmpty(sCustCode))	{
			logger.error(this.getMessage("54308;", user));
			throw new  UniDirectValidateException(this.getMessage("54308;", user));
		}
		
		//'==============================================================================
		//'   차변일 경우
		//'==============================================================================
		if("1".equals(sDrCr))	{
		
			//'==========================================================================
			//'   Get afn200t
			//'==========================================================================
			
			Map afn200Map =  (Map) super.commonDao.select("agj800ukrService.getAfn200", tParam); 
			
			if(ObjUtils.isEmpty(afn200Map))	{
				String errMsg = "어음번호:"+sNoteNum;
				logger.error(this.getMessage("54306;"+errMsg, user));
				throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
			}
			
			if("3".equals(ObjUtils.getSafeString(afn200Map.get("PROC_SW"))))	{
				String errMsg = "어음번호:"+sNoteNum;

				logger.error(this.getMessage("54307;"+errMsg, user));
				throw new  UniDirectValidateException(this.getMessage("54307;"+errMsg, user));
			}
			
			
			//'==========================================================================
			//'   Get Note Status : settled
			//'==========================================================================
			sNoteSts = "3";
			
			if(ObjUtils.parseDouble(afn200Map.get("OC_AMT_I")) > ObjUtils.parseDouble(afn200Map.get("J_AMT_I")))	{
					sNoteSts = "5";
			}
			
			
			//'==========================================================================
			//'   Update afn200t
			//'==========================================================================
			tParam.put("NOTE_STS", sNoteSts);
			super.commonDao.update("agj800ukrService.updateAfn200", tParam); 
			
			
			
		//'==============================================================================
		//'   대변일 경우
		//'==============================================================================
		}else if("2".equals(sDrCr))	{
			//'==========================================================================
			//'   Get afn200t
			//'==========================================================================
			Map afn200Map =  (Map) super.commonDao.select("agj800ukrService.getAfn200_A", tParam); 
			
			
			if(ObjUtils.isEmpty(afn200Map))	{
				String errMsg = "어음번호:"+sNoteNum;
				logger.error(this.getMessage("54306;"+errMsg, user));
				throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
			}
			
			//'==========================================================================
			//'   Get Note Status : settled
			//'==========================================================================
			sNoteSts = "1";
			
			//'==========================================================================
			//'   Update afn200t
			//'==========================================================================
			
			tParam.put("NOTE_STS", sNoteSts);
			super.commonDao.update("agj800ukrService.updateAfn200", tParam); 
		}
	}
	
	private void deleteAfn200(Map agj800Map, LoginVO user) throws Exception {

		String sNoteSts, sNoteNum, sCustCode;
		String sSpecDivi = ObjUtils.getSafeString(agj800Map.get("SPEC_DIVI")) , sDrCr = this.getDrCr(agj800Map);
		Map param = new HashMap();
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		if( !"D3".equals(sSpecDivi)) return;
		else {
			sNoteNum = this.getAcData(agj800Map, "C2");
			sCustCode = this.getAcData(agj800Map, "A4");

			
			//'==============================================================================
			//'   차변일 경우
			//'==============================================================================
			if("1".equals(sDrCr))	{
			
				//'==============================================================================
				//'   Get afn100t
				//'==============================================================================
				param.put("NOTE_NUM", sNoteNum);
				Map afn100Map = (Map) super.commonDao.select("agj800ukrService.getAfn100", param); 
				
				//'==========================================================================
				//'   Note Sts
				//'==========================================================================
				sNoteSts = "1";
				
				if(ObjUtils.parseDouble(afn100Map.get("J_AMT_I")) > 0) {
					sNoteSts = "5";
				}
				
				//'==========================================================================
				//'   Update afn200t
				//'==========================================================================
				param.put("NOTE_STS", sNoteSts);
				param.put("SET_DATE", "");
				super.commonDao.update("agj800ukrService.updateAfn200", param); 
				
				
				
			//'==============================================================================
			//'   대변일 경우
			//'==============================================================================
			}else if("2".equals(sDrCr)) { 
				
				//'==========================================================================
				//'   Update afn200t
				//'==========================================================================
				param.put("FLOAT_DATE", "");
				param.put("SET_DATE", "");
				
				param.put("NOTE_STS", sDrCr);
				super.commonDao.update("agj800ukrService.updateAfn200", param); 
			}
				
		}
	}
	
	public Object getAgj800(Map param, LoginVO user) throws Exception {
		Object rtnMap = super.commonDao.select("agj800ukrService.getAgj800", param);
		
//		if(ObjUtils.isEmpty(rtnMap))	{
//			String errMsg = "계정과목:"+param.get("ACCNT")+"\n"+"계정과목명:"+param.get("ACCNT_NAME");
//			throw new  UniDirectValidateException(this.getMessage("54306;"+errMsg, user));
//		}
		return rtnMap;
	}
	
	private String getAcData(Map dataMap, String acCode)	throws Exception {
		String rtnData = null;
		if(acCode.equals(dataMap.get("BOOK_CODE1")))	{
			rtnData = ObjUtils.getSafeString(dataMap.get("BOOK_DATA1"));
		} else if(acCode.equals(dataMap.get("BOOK_CODE2")))	{
			rtnData = ObjUtils.getSafeString(dataMap.get("BOOK_DATA2"));
		}
		return rtnData;		
	}
	
	private String getDrCr(Map param) 	throws Exception {
        String r = "1";
		if(ObjUtils.parseDouble(param.get("DR_AMT_I")) > 0 || ObjUtils.parseDouble(param.get("DR_AMT_I")) < 0) {
			r =  "1";
		} else if(ObjUtils.parseDouble(param.get("CR_AMT_I")) > 0 || ObjUtils.parseDouble(param.get("CR_AMT_I")) < 0) {
			r = "2";
		} else if(ObjUtils.parseDouble(param.get("DR_FOR_AMT_I")) > 0 || ObjUtils.parseDouble(param.get("DR_FOR_AMT_I")) < 0) {
			r =  "1";
		} else if(ObjUtils.parseDouble(param.get("CR_FOR_AMT_I")) > 0 || ObjUtils.parseDouble(param.get("CR_FOR_AMT_I")) < 0) {
			r = "2";
		} else {
			r =  ObjUtils.getSafeString(param.get("JAN_DIVI"));
		}
		return r;

	}
	
	/**
	 * 삭제하고자 하는 데이터가 해당 어음에 대한 최종데이터인지 확인
	 * checkLastData(sNoteNum, afn100Map.get("NOTE_STS_NM"), agj800Map.get("ACCNT"),  sPrevDate, sSlipDate, sPrevAcDate) 
	 * @param sNoteNum
	 * @param noteStsNm
	 * @param accnt
	 * @param sPrevDate
	 * @param sSlipDate
	 * @param sPrevAcDate
	 * @throws Exception
	 */
	private void checkLastData(String sNoteNum, String noteStsNm, String accnt,  String sPrevDate, String sSlipDate, String[] sPrevAcDate, LoginVO user) throws Exception {
		if(sPrevDate.compareTo(sSlipDate) > 0) { // sPrevDate > sSlipDate
			String errMsg = "어음번호 : "+sNoteNum+"\n";
			errMsg = errMsg+"어음상태 : "+noteStsNm+"\n";
			errMsg = errMsg+"기초년월 : "+(ObjUtils.isNotEmpty(sPrevAcDate) ? sPrevAcDate[0]:"") +"\n";
			errMsg = errMsg+"순번     : "+(ObjUtils.isNotEmpty(sPrevAcDate) ? sPrevAcDate[1]:"0")+"\n";
			errMsg = errMsg+"계정코드 : "+accnt+"\n";
			logger.error(this.getMessage("55326;"+errMsg, user));
			throw new  UniDirectValidateException(this.getMessage("55326;"+errMsg, user));
		}
	}
	private void fnSetReturn(Map param ) throws Exception {   
	    //'Step 1. Balancing
	    //'----------------------------------------------------------------------------------------------
	    List<Map> rBalancing = (List<Map>)super.commonDao.list("agj800ukrService.returnBalancing", param); 
	    
	    if(ObjUtils.isEmpty(rBalancing) )	{
	    	param.put("BAL_DIVI", "0");
	    }else if(ObjUtils.isNotEmpty(rBalancing) && rBalancing.size() > 1 ){
	    	param.put("BAL_DIVI", "YN");
	    }else {
	    	param.put("BAL_DIVI", ObjUtils.getSafeString(rBalancing.get(0).get("PROC_YN")));
	    }
	        
	    //'Step 2. Previous year actual balancing
	    //'----------------------------------------------------------------------------------------------
	    List<Map> rActualBalancing = (List<Map>)super.commonDao.list("agj800ukrService.prevYearActualBalancing", param); 
	    
	   if(ObjUtils.isEmpty(rActualBalancing) )	{
	    	return ;
	    }else if(ObjUtils.isNotEmpty(rActualBalancing) && rActualBalancing.size() > 1 ){
	    	param.put("ACT_DIVI","Y");
	    }else {
	    	param.put("ACT_DIVI","N");
	    }
	        
	    //'Step 3. Sales 
	    //'----------------------------------------------------------------------------------------------
	    List<Map> rSales = (List<Map>)super.commonDao.list("agj800ukrService.returnSales", param); 
	    
	    if(ObjUtils.isEmpty(rSales) )	{
	    	return ;
	    }else if(ObjUtils.isNotEmpty(rSales) && rSales.size() > 0 ){
	    	param.put("SAL_DIVI",ObjUtils.getSafeString(rSales.get(0).get("REF_CODE")));
	    }else {
	    	param.put("SAL_DIVI", "N");
	    }      
	    
	        
	    //'Step 4. Sales Balancing
	    //'----------------------------------------------------------------------------------------------
	    List<Map> rSalesBalancing = (List<Map>)super.commonDao.list("agj800ukrService.returnSalesBalancing", param); 
	    
	    if(ObjUtils.isEmpty(rSalesBalancing) )	{
	    	return ;
	    }else if(ObjUtils.isNotEmpty(rSalesBalancing) && rSales.size() > 0 ){
	    	param.put("SAL_FLAG","Y");
	    }else {
	    	param.put("SAL_FLAG","N");
	    }      
	    
	}
	//잔액반영
	@SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt" )
    public List<Map<String, Object>> balanceSet( Map param , LoginVO loginVO) throws Exception {
		List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.BalanceSet", param);
        String errorDesc ="";
        if(ObjUtils.isNotEmpty(returnData)){
            errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
	        if(ObjUtils.isNotEmpty(errorDesc)){
	            throw new  UniDirectValidateException(this.getMessage(errorDesc, loginVO));
	        }
        } 
        return returnData;
    }
	//잔액취소
	@SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt" )
    public List<Map<String, Object>> balanceCancel( Map param , LoginVO loginVO) throws Exception {
		List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agj800ukrService.BalanceCancel", param);
        String errorDesc ="";
        if(ObjUtils.isNotEmpty(returnData)){
            errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
	        if(ObjUtils.isNotEmpty(errorDesc)){
	            throw new  UniDirectValidateException(this.getMessage(errorDesc, loginVO));
	        }
        } 
        return returnData;
    }
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> selectStdt(LoginVO loginVO) throws Exception {
		Map<String, Object> param = new HashMap();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (Map<String, Object>) super.commonDao.select("agj800ukrService.selectStdt", param);
	}
	
}
