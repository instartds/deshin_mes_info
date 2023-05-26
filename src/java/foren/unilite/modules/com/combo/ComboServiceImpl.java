package foren.unilite.modules.com.combo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ArrayUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboService;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.utils.CodeUtil;


@SuppressWarnings({"rawtypes", "unchecked"})
@Service("UniliteComboServiceImpl")
public class ComboServiceImpl extends TlabAbstractServiceImpl implements ComboService  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private final static String SQL_BASE_ID = "ComboServiceImpl.";
	public final static String BEAN_ID = "UniliteComboServiceImpl";

	/* (non-Javadoc)
	 * @see foren.unilite.modules.com.combo.ComboService#getList(java.lang.String, java.util.Map)
	 */
	private List<ComboItemModel> getList(String sqlID, Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list(SQL_BASE_ID+sqlID, param);
	}

	public List<ComboItemModel> getComboList(String comboType, String comboCode,  LoginVO loginVO, String pgmId, Map param, String[] opts) throws Exception {
		List<ComboItemModel> rv = null;

		String lang = loginVO.getLanguage();
		if("BOR120".equals( comboType)) {
			//'사업장코드
			param.put("PGM_ID", pgmId);
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("S_USER_ID", loginVO.getUserID());
			param.put("S_DIV_CODE", loginVO.getDivCode());
			/*Map<String, Object> chkMap =  (Map<String, Object>)super.commonDao.select("ComboServiceImpl.chkDivList", param);
			if(chkMap != null){
				param.put("DIV_CODE", loginVO.getDivCode());
				param.put("AUTHO", chkMap.get("AUTHO"));
			}*/

			rv = this.getList("getDivList", param);
		}
		// FIXME 공통 코드 기타 정의 추가
		// S: 시스템정의코드
		// H: 사용자정의코드 / 중복 !!!
		// H3 : 끝전처리에서 비시스템과 고용보험만 가져오는 루틴
		// Y/Z :
		// K
		// C :

		// CBM600 : Cost Pool 정보
		// BILL_DIV
		// PROFIT_FLAG
		// PROOF_TYPE
		// INPUT_TYPE


        return rv;

	}

	public List<ComboItemModel> getComboList(String comboType, String comboCode,  LoginVO loginVO, Map param, String[] opts, Boolean includeMainCode) throws Exception {
		List<ComboItemModel> rv = null;

		String lang = loginVO.getLanguage();
		if(ArrayUtils.contains(new String[]{"0", "A", "B", "D", "O", "W"}, comboType)) {
			//공통코드(미사용 포함)
			if("O".equals(comboType))	{
				rv = this.getWhList(param);
			}else if("W".equals(comboType))	{
				rv = this.getWsList(param);
			}else {
				rv = this._getAUlist(param, loginVO.getCompCode(), comboCode, true , opts, lang);
			}
		} else if(ArrayUtils.contains(new String[]{"0U", "AU", "BU", "DU", "OU", "WU"}, comboType)) {
			//공통코드(사용만포함)
			if("OU".equals(comboType))	{
				rv = this.getWhUList(param);
			}else if("WU".equals(comboType))	{
				rv = this.getWsUList(param);
			}else {
				rv = this._getAUlist(param, loginVO.getCompCode(), comboCode, false, opts, lang );
			}
		} else if("P".equals( comboType)) {
			rv = this._getCommonCodelist(loginVO.getCompCode(), comboCode, true, new String[]{"1","L"}, lang) ;
		} else if("Q".equals( comboType)) {
			// FIXME !!UBsaExKrv.CBsaExSKr[fnRecordList] Query07
			rv = this._getCommonCodelist(loginVO.getCompCode(), comboCode, true, new String[]{"1","L"}, lang) ;
		} else if("R".equals( comboType)) {
			rv = this._getCommonCodelist(loginVO.getCompCode(), comboCode, true, new String[]{"E","F","G","N"}, lang) ;
		} else if("BOR120".equals( comboType)) {
			if("BILL".equals(comboCode))	{
				rv = this.getList("getBillDivList", param);
			}else {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("S_USER_ID", loginVO.getUserID());
				param.put("S_DIV_ID", loginVO.getDivCode());
				rv = this.getList("getDivList", param);
			}
		} else if("BOR110".equals( comboType)) {
			//'사업부코드
			rv = this.getList("getSectionList", param);
		} else if("BOR100".equals( comboType)) {
			//'회사코드
			rv = this.getList("getCompList", param);
		}else if("BSA421".equals( comboType)) {
			//'Grid 설정
			String[] code = comboCode.split("__");
			param.put("COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());
			param.put("PGM_ID", code[0]);
			param.put("SHT_ID", code[1]);
			rv = this.getList("getStateList", param);
		}else if("CBM600".equals( comboType) || "CBM700".equals( comboType)) {
			//'Grid 설정
			String[] code = comboCode.split("__");
			param.put("COMP_CODE", loginVO.getCompCode());
			rv = this.getHumanCostPool(param);
		}

		// FIXME 공통 코드 기타 정의 추가
		// S: 시스템정의코드
		// H: 사용자정의코드 / 중복 !!!
		// H3 : 끝전처리에서 비시스템과 고용보험만 가져오는 루틴
		// Y/Z :
		// K
		// C :

		// CBM600 : Cost Pool 정보
		// BILL_DIV
		// PROFIT_FLAG
		// PROOF_TYPE
		// INPUT_TYPE
		if(includeMainCode && ObjUtils.isNotEmpty(comboCode) )	{
			for(ComboItemModel comboData : rv)	{
				comboData.setValue(comboCode + "_" +comboData.getValue());
				comboData.setSearch(comboCode + "_" +comboData.getValue()+comboData.getText());
				comboData.setIncludeMainCode(true);
			}
		}

        return rv;

	}

	public List<ComboItemModel> getComboList(String comboType, String comboCode,  LoginVO loginVO, Map param, String[] opts) throws Exception {
		return this.getComboList(comboType, comboCode,  loginVO, param, opts, false);
	}

	public List<ComboItemModel> getDeptList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getDeptList", param);

	}

	/**
	 * POS_NO
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getPosNo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getPosNo", param);

	}
	/**
	 * 자판기_번호
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getVendingNo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getVendingNo", param);

	}

	/**
	 * 자판기_번호 ( TYPE 4 )
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getMachineNo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getMachineNo", param);

	}

	/**
	 * 품목 대분류
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getItemLevel1(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getItemLevel1", param);

	}

	/**
	 * 품목 중분류
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getItemLevel2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getItemLevel2", param);

	}

	/**
	 * 품목 소분류
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getItemLevel3(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getItemLevel3", param);

	}

	/**
	 * 품목 팝업 사업장 리스트(B266)
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */

	public List<ComboItemModel> getDivCode(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.selectDivCode", param);

	}

	/**
	 * 품목분류 정보 (품목 상위분류 선택 정보 포함)
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base")
	public Object getItemLevelInfo(Map param) throws Exception {
		List itemLevel = (List) super.commonDao.list("ComboServiceImpl.getItemLevelInfo", param);
		if (itemLevel.size() != 1) {
			return 0;
		} else {
			return itemLevel;
		}

	}

	/**
	 * 공통 코드 및 사업장
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	private List<ComboItemModel> _getAUlist(Map param, String compCode, String mainCode, boolean includeNotInUsed,String[] opts, String lang) throws Exception   {
		List<ComboItemModel> rv ;
		if ("B001".equals(mainCode)) {
			rv = this.getList("getDivList", param);
		} else {
			rv = _getCommonCodelist(compCode, mainCode, includeNotInUsed, opts, lang);
		}
		return rv;
	}

	/**
	 * 창고리스트
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getWhList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getWhList", param);

	}

	/**
     * 창고Cell리스트
     * @param param
     * @param compCode
     * @param mainCode
     * @param includeNotInUsed
     * @return
     * @throws Exception
     */
    public List<ComboItemModel> getWhCellList(Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getWhCellList", param);

    }

	/**
	 * 공정리스트
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getProgWork(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getProgWork", param);

	}

	/**
	 * 창고리스트 (USE_YN != 'N')
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getWhUList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getWhUList", param);

	}

	/**
	 * 작업장리스트
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getWsList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getWsList", param);

	}
	/**
	 * 작업장리스트 (USE_YN != 'N')
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getWsUList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getWsUList", param);

	}
	/**
	 * 지불예정명세서등록 차수관련
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getCollectDay(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getCollectDay", param);

	}

	/**
	 * 회계 - 관리항목
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getAcItemList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getAcItemList", param);

	}

	/**
	 * 회계 - B020 품목계정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getAcItemCombo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getAcItemCombo", param);

	}

	/**
	 *
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @param opts	opts의 값들로 code의 value를 필터링하여 출력.
	 * @param lang
	 * @return
	 * @throws Exception
	 */
	private List<ComboItemModel> _getCommonCodelist( String compCode, String mainCode, boolean includeNotInUsed, String[] opts, String lang) throws Exception   {
		boolean hasOpt = opts != null ? true:false;
		List<ComboItemModel> rv = new ArrayList<ComboItemModel>();
		List<CodeDetailVO> codeList = CodeUtil.getCompCodeList(compCode, mainCode, includeNotInUsed);
		if(codeList != null) {
			for(CodeDetailVO code : codeList) {
				ComboItemModel item = null;
				 item = new ComboItemModel(code.getCodeNo(), code.getCodeName(lang), null);
//				if("en".equals(lang)) {
//					 item = new ComboItemModel(code.getCodeNo(), code.getCodeNameEn(), null);
//				}else if("zh".equals(lang)) {
//					 item = new ComboItemModel(code.getCodeNo(), code.getCodeNameCn(), null);
//				}else if("ja".equals(lang)) {
//					 item = new ComboItemModel(code.getCodeNo(), code.getCodeNameJp(), null);
//				}else  {
//					 item = new ComboItemModel(code.getCodeNo(), code.getCodeName(), null);
//				}
				item.setRefCode1(code.getRefCode1());
				item.setRefCode2(code.getRefCode2());
				item.setRefCode3(code.getRefCode3());
				item.setRefCode4(code.getRefCode4());
				item.setRefCode5(code.getRefCode5());
				item.setRefCode6(code.getRefCode6());
				item.setRefCode7(code.getRefCode7());
				item.setRefCode8(code.getRefCode8());
				item.setRefCode9(code.getRefCode9());
				item.setRefCode10(code.getRefCode10());
				item.setRefCode11(code.getRefCode11());
				item.setRefCode12(code.getRefCode12());
				item.setRefCode13(code.getRefCode13());
				item.setRefCode14(code.getRefCode14());
				item.setRefCode15(code.getRefCode15());
				if(hasOpt) {
					if(ArrayUtils.contains(opts, item.getValue())) {
						rv.add(item);
					}
				} else {
					rv.add(item);
				}

			}
		}
		return rv;
	}

	/**
	 * 인사 - COST_POOL
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getHumanCostPool(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getHumanCostPool", param);

	}

	/**
	 * 인사 - PAY_LIST(HBS300T)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getPayList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getPayList", param);

	}

	/**
	 * 인사 - H032(급여지급방식 REF_CODE 1일 경우)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getPayment(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getPayment", param);

	}

	/**
	 * 어플리케이션 정보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<ComboItemModel> getApplication(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getApplication", param);

	}
	/**
	 * 구분1 정보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<ComboItemModel> getGubun1(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getGubun1", param);

	}

	/**
	 * 구분2 정보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<ComboItemModel> getGubun2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getGubun2", param);

	}

	/**
	 * 구분3 정보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<ComboItemModel> getGubun3(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getGubun3", param);

	}

	/**
	 * 구분4 정보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<ComboItemModel> getGubun4(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getGubun4", param);

	}

	/**
	 * 구분5 정보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<ComboItemModel> getGubun5(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getGubun5", param);

	}

	/**
	 * 주차 콤보
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base")
	public List<ComboItemModel> getCalNo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getCalNo", param);

	}


	/**
     * 인사/급여업무설정 > 수당기준설정 > 근속수당기준등록 > 근속구분 콤보관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetCnwkDsnc (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetCnwkDsnc", param);
    }

    /**
     * 인사 부서 권한 관련
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetauthDepts (LoginVO loginVO, Map param) throws Exception {
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetauthDepts", param);
    }

	// KOCIS
    /**
     * KOCIS 기관 코드
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetDeptKocis (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetDeptKocis", param);
    }



    /**
     * KOCIS 예산코드 1 level   (부문 콤보코드 관련)
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetBudgCodeLevel1 (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetBudgCodeLevel1", param);
    }

    /**
     * KOCIS 예산코드 3 level   (세부사업 콤보코드 관련)
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetBudgCodeLevel3 (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetBudgCodeLevel3", param);
    }

    /**
     * KOCIS 예산코드 6 level  (목/세목 콤보코드 관련)
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetBudgCodeLevel6 (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetBudgCodeLevel6", param);
    }

    /**
     * KOCIS 예산코드  (예산항목 콤보코드 관련)
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetBudgCode (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetBudgCode", param);
    }

    /**
     * KOCIS 계좌코드   (계좌코드 콤보코드 관련)
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetSaveCode (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetSaveCode", param);
    }

    /**
     * KOCIS 계좌코드   (계좌코드 콤보코드 관련)
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetGwStatus (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.fnGetGwStatus", param);
    }

	/**
	 * 창고리스트
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getAnList2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getAnList2", param);

	}

    /**
	 * 작업지시 공정 가져오기
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getPmp100tProgWorkCode(Map param) throws Exception {
		return  (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getPmp100tProgWorkCode", param);

	}

    /**
   	 * 품목검사항목 가져오기
   	 */
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
   	public List<ComboItemModel> getQbaListCombo(Map param) throws Exception {
   		return  (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getQbaListCombo", param);

   	}

     /**
   	 * 작업지시 공정 가져오기
   	 */
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
   	public List<ComboItemModel> getProgWorkCode(Map param) throws Exception {
   		return  (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getProgWorkCode", param);

   	}
}
