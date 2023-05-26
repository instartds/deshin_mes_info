package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.validator.UniDirectValidateException;


@SuppressWarnings({"rawtypes", "unchecked"})
@Service("s_ext_combo_mitServiceImpl")
public class S_ext_combo_mitServiceImpl extends TlabAbstractServiceImpl   {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private final static String SQL_BASE_ID = "s_ext_combo_mitServiceImpl.";

	 @Resource( name = "externalDAO_MIT" )
	 protected ExternalDAO_MIT externalDAO;
	 
	private List<Map<String, Object>> getList(String sqlID, Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
		List<Map<String, Object>> r =  externalDAO.list(SQL_BASE_ID+sqlID, param, errorMessage);
		if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
		return r;
	}

	public List<Map<String, Object>> getComboList(String comboType, String comboCode,  LoginVO loginVO, String pgmId, Map param, String[] opts) throws Exception {
		List<Map<String, Object>> rv = null;

		String lang = loginVO.getLanguage();
		if("BOR120".equals( comboType)) {
			//'사업장코드
			param.put("PGM_ID", pgmId);
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("S_USER_ID", loginVO.getUserID());
			param.put("S_DIV_CODE", loginVO.getDivCode());
			
			rv = this.getList("getDivList", param);
		}
		
        return rv;

	}

	public List<Map<String, Object>> getComboList(String comboType, String comboCode,  LoginVO loginVO, Map param, String[] opts, Boolean includeMainCode) throws Exception {
		List<Map<String, Object>> rv = null;

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
		} 
        return rv;

	}

	public List<Map<String, Object>> getComboList(String comboType, String comboCode,  LoginVO loginVO, Map param, String[] opts) throws Exception {
		return this.getComboList(comboType, comboCode,  loginVO, param, opts, false);
	}

	public List<Map<String, Object>> getDeptList(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getDeptList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}


	/**
	 * 품목 대분류
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getItemLevel1(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getItemLevel1", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
	}

	/**
	 * 품목 중분류
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getItemLevel2(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getItemLevel2", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
    	return r ;
	}

	/**
	 * 품목 소분류
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getItemLevel3(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getItemLevel3", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
    	return r ;

	}

	/**
	 * 품목분류 정보 (품목 상위분류 선택 정보 포함)
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base")
	public Object getItemLevelInfo(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> itemLevel = externalDAO.list("s_ext_combo_mitServiceImpl.getItemLevelInfo", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
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
	private List<Map<String, Object>> _getAUlist(Map param, String compCode, String mainCode, boolean includeNotInUsed,String[] opts, String lang) throws Exception   {
		List<Map<String, Object>> rv ;
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
	public List<Map<String, Object>> getWhList(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getWhList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
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
    public List<Map<String, Object>> getWhCellList(Map param) throws Exception {
    	StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getWhCellList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;
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
	public List<Map<String, Object>> getProgWork(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getProgWork", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;

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
	public List<Map<String, Object>> getWhUList(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getWhUList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;

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
	public List<Map<String, Object>> getWsList(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getWsList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;

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
	public List<Map<String, Object>> getWsUList(Map param) throws Exception {
		StringBuilder errorMessage = new StringBuilder("");
    	List<Map<String, Object>> r = externalDAO.list("s_ext_combo_mitServiceImpl.getWsUList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
        return r ;

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
	private List<Map<String, Object>> _getCommonCodelist( String compCode, String mainCode, boolean includeNotInUsed, String[] opts, String lang) throws Exception   {
		boolean hasOpt = opts != null ? true:false;
		
		List<Map<String, Object>> rv = new ArrayList<Map<String, Object>>();
		
		StringBuilder errorMessage = new StringBuilder("");
		Map<String, Object> param = new HashMap();
		param.put("compCode", compCode);
		param.put("mainCode", mainCode);
		
    	List<Map<String, Object>> items = externalDAO.list("s_ext_combo_mitServiceImpl.getCodeDetailList", param, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
    	
		if(items != null) {
			for(Map<String, Object> item : items) {
				if(hasOpt) {
					if(ArrayUtils.contains(opts, item.get("value"))) {
						rv.add(item);
					}
				} else {
					rv.add(item);
				}

			}
		}
		return rv;
	}


}
