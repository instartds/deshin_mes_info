package foren.unilite.modules.base.bdc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.HtmlUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("bdc100ukrvService")
public class Bdc100ukrvServiceImpl extends TlabAbstractServiceImpl implements Bdc100ukrvService {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  파일 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(group = "base")
	public Integer  syncAll(Map param) throws Exception {
		return  0;
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return super.commonDao.list("bdc100ukrvServiceImpl.getDataList", param);
	}
	
	@ExtDirectMethod(group = "base")
	public int updateReadCnt(Map param, LoginVO login) throws Exception {
		int r = 0;
		param.put("S_COMP_CODE", login.getCompCode());
		r = super.commonDao.update("bdc100ukrvServiceImpl.updateReadCnt", param);
		return r;
	}
	/**
	 * 
	 * @param paramList
	 * @return
	 * @throws Exception
	 */

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  insertMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
			Map rs= (Map)super.commonDao.queryForObject("bdc100ukrvServiceImpl.insert", param);	
			if(rs.get("DOC_NO")!=null)	{
				param.put("DOC_NO", rs.get("DOC_NO"));
				param.put("REG_EMP_NAME", rs.get("REG_EMP_NAME"));
				param.put("REG_DEPT_NAME", rs.get("REG_DEPT_NAME"));
				param.put("CUSTOM_NAME", rs.get("CUSTOM_NAME"));
				param.put("PROJECT_NAME", rs.get("PROJECT_NAME"));
				param.put("REG_DATE", rs.get("REG_DATE"));
				this.insertBDC101(param);
				fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("ADD_FID")));
			}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  updateMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
			
			fileMnagerService.deleteFile(login, ObjUtils.getSafeString(param.get("DEL_FID")));
			this.deleteBDC101(param);
			fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("ADD_FID")));
			this.insertBDC101(param);
			
			super.commonDao.update("bdc100ukrvServiceImpl.update", param);
			
		}
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  deleteMulti(List<Map> paramList,  LoginVO login) throws Exception {
		int r = 0;
		
		for(Map param :paramList )	{
			List<Map<String, Object>>  delFileList = getFileList(param,  login);
			for(Map delFile : delFileList)	{
				fileMnagerService.deleteFile(login, ObjUtils.getSafeString(delFile.get("FID")));
			}
			r += super.commonDao.delete("bdc100ukrvServiceImpl.deleteMulti", param);
		}
		return  paramList;
	}


	/**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("bdc100ukrvServiceImpl.getFileList", param);
	}
	
	private void insertBDC101(Map param) throws Exception {
		 String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");
		 
		 for(String fid : fids)	{
			 param.put("FID", fid);
			 super.commonDao.insert("bdc100ukrvServiceImpl.insertBDC101", param);
		 }
	}
	
	private void deleteBDC101(Map param) throws Exception {
		String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
		 for(String fid : fids)	{
			 param.put("FID", fid);
			 super.commonDao.update("bdc100ukrvServiceImpl.deleteBDC101", param);
		 }
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map>  getDocLevel1(Map param) throws Exception {		
		return  super.commonDao.list("bdc100ukrvServiceImpl.getDocLevel1",param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map>  getDocLevel2(Map param) throws Exception {
		return  super.commonDao.list("bdc100ukrvServiceImpl.getDocLevel2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map>  getDocLevel3(Map param) throws Exception {
		return  super.commonDao.list("bdc100ukrvServiceImpl.getDocLevel3", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map>  getCustomList(Map param) throws Exception {
		return  super.commonDao.list("bdc100ukrvServiceImpl.getCustomList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map>  getDeptList(Map param) throws Exception {
		return  super.commonDao.list("bdc100ukrvServiceImpl.getDeptList", param);
	}
	
	/**
	 * 바로가기 Link 생성 
	 * @param param
	 * @return
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
	public Map makeExtLink(Map param, LoginVO user, HttpServletRequest hReq) throws Exception {
		Map<String, Object> rv = new HashMap<String, Object>();
		
		String refId = this.getShortCodeFromURL();
		param.put("REF_ID", refId);
		Integer cnt = 0;
		do {
			cnt = (Integer) super.commonDao.select("bdc100ukrvServiceImpl.checkRefID", param);
		} while (cnt >= 1) ;
		super.commonDao.insert("bdc100ukrvServiceImpl.makeLink", param);
		
		String baseUrl = HtmlUtils.getBaseUrl(hReq);
		baseUrl += BdcController.EXT_DOWNLOAD_SERVLET + "?REF_ID="+refId;
		rv.put("url", baseUrl);
		return rv;
	}
	
	/**
	 * 외부사용자용 파일 목록
	 * 
	 * @param param "REF_ID"
	 * @return
	 */
	public List<Map> getExtFileList(Map param) {
		return super.commonDao.list("bdc100ukrvServiceImpl.getExtFileList", param);
	}
	/**
	 * 하나의 파일 정보 조회
	 */
	public FileDownloadInfo getFileInfo(Map param, String fid) throws Exception {
		String filePath = ConfigUtil.getString("common.upload.temp");
		FileDownloadInfo rv = null;;

		Map rec= (Map)super.commonDao.select("bdc100ukrvServiceImpl.selectFileInfo", param);
		if(rec != null) {
			rv = new FileDownloadInfo(filePath, fid+".bin");
			rv.setOriginalFileName((String) rec.get("ORIGINAL_FILE_NAME"));
			rv.setContentType((String) rec.get("MIME_TYPE"));
		}
		
		return rv;
	}
	 private static String getShortCodeFromURL( ) {

	        //String charSet = "0123456789ABCDEFGHIJKLMNPQRSTUVWXYZ";
	        final String charSet = "0123456789abcdefghijklmnpqrstuvwxyz";
	        
	        StringBuffer t = new StringBuffer();
	        for (int i = 0; i < 10 ; i++) {
	            Double num =  Math.random() * charSet.length();
	            t.append(charSet.charAt( num.intValue() ));
	        }

	        return t.toString();
	    }

}
