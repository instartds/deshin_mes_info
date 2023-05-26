package foren.unilite.modules.omegaplus.bug;

import java.io.File;
import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.z_wm.S_Bsa315ukrv_wmModel;
import foren.unilite.utils.ExtFileUtils;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service( "bug100ukrvService" )
@SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
public class Bug100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "base";

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;


	/**
	 * 프로그램 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bug" )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
		return super.commonDao.list("bug100ukrvServiceImpl.selectList", param);
	}



	/**
	 * 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bug" )
	public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if (insertList != null) this.updateList(insertList, user, dataMaster);
			if (updateList != null) this.updateList(updateList, user, dataMaster);
			if (deleteList != null) this.deleteList(deleteList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bug" )
	public void insertList( List<Map> paramList, LoginVO user ) throws Exception {
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bug" )
	public Integer updateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for(Map param : paramList) {
			param.put("PGM_SEQ", paramMaster.get("PGM_SEQ"));
			super.commonDao.update("bug100ukrvServiceImpl.updateList", param);
			if(ObjUtils.isNotEmpty(param.get("FILE_NO")) || ObjUtils.isNotEmpty(param.get("DEL_FIDS"))) {
				this.syncFileList(param, user, "N");
			}
		}
		return 0;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bug" )
	public Integer deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		 for(Map param : paramList) {
			try {
				param.put("PGM_SEQ", paramMaster.get("PGM_SEQ"));
				super.commonDao.delete("bug100ukrvServiceImpl.deleteList", param);
				if(ObjUtils.isNotEmpty(param.get("FILE_NO"))) {
					this.syncFileList(param, user, "D");
				}
			} catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}



	/**
	 * 파일업로드 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	private Map syncFileList(Map param, LoginVO login, String saveFlag) throws Exception {
		List<Map> rList	= null;
		Map rtn			= null;
		if(!ObjUtils.isEmpty(param.get("FILE_NO")) || !ObjUtils.isEmpty(param.get("DEL_FIDS"))) {
			List<Map> paramList	= new ArrayList<Map>();
			Map fParam			= new HashMap();
			fParam.put("DOC_NO"		, param.get("FILE_NO"));
			fParam.put("ADD_FIDS"	, param.get("FILE_NO"));
			fParam.put("DEL_FIDS"	, param.get("DEL_FIDS"));
			fParam.put("S_COMP_CODE", login.getCompCode());
			fParam.put("S_USER_ID"	, login.getUserID());
			fParam.put("S_DEPT_CODE", login.getDeptCode());
			fParam.put("AUTH_LEVEL"	, login.getAuthorityLevel());
			paramList.add(fParam);
			if("N".equals(saveFlag) && !ObjUtils.isEmpty(param.get("FILE_NO"))) {
				rList = this.updateMulti(paramList, login);
			} else {
				rList = this.deleteMulti(paramList, login);
			}
		}
		if (!ObjUtils.isEmpty(rList)) rtn = rList.get(0);
		return rtn;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map> updateMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r = 0;
		for(Map param : paramList) {
			fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("ADD_FIDS")));
			this.insertBDC101(param);
			super.commonDao.update("bug100ukrvServiceImpl.insert", param);
		}
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map> deleteMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r			= 0;
		Object file_no	= new HashMap();

		for(Map param : paramList) {
			if(ObjUtils.isNotEmpty(param.get("DEL_FID"))) {
				file_no = param.get("DEL_FID");
			} else {
				file_no = param.get("ADD_FIDS");
			}
			fileMnagerService.deleteFile(login, ObjUtils.getSafeString(file_no));
			param.put("FILE_NO", file_no);
			this.deleteBDC101(param);
		}
		return  paramList;
	}

	private void insertBDC101(Map param) throws Exception {
		String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");

		for(String fid : fids) {
			param.put("FID", fid);
			super.commonDao.update("bug100ukrvServiceImpl.insertBDC101", param);
		}
	}

	private void deleteBDC101(Map param) throws Exception {
		String[] fids =  ObjUtils.getSafeString(param.get("FILE_NO")).split(",");
		for(String fid : fids) {
			param.put("FID", fid);
			super.commonDao.update("bug100ukrvServiceImpl.deleteBDC101", param);
		}
	}



	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bug" )
	public Map getManualInfo( Map param ) throws Exception {
		return (Map) super.commonDao.select("bug100ukrvServiceImpl.getManualInfo", param);
	}




	/**
	 * 출력기능 추가: 20210622 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bug" )
	public List<Map<String, Object>> selectPrintList( Map param ) throws Exception {
		return super.commonDao.list("bug100ukrvServiceImpl.selectPrintList", param);
	}
}