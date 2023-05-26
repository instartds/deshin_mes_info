package foren.unilite.modules.nbox.approval;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.nbox.approval.model.NboxDocModel;
import foren.unilite.modules.nbox.link.NboxLinkDataCodeByApprovalService;
import foren.unilite.multidb.cubrid.sp.USP_GWAPP;


@Service("nboxDocListService")
public class NboxDocListServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "nboxDocFileService")
	private NboxDocFileService nboxDocFileService;
	
	@Resource(name = "nboxDocLineService")
	private NboxDocLineService nboxDocLineService;
	
	@Resource(name = "nboxDocRcvUserService")
	private NboxDocRcvUserService nboxDocRcvUserService;
	
	@Resource(name = "nboxDocBasisService")
	private NboxDocBasisService nboxDocBasisService;
	
	@Resource(name = "nboxLinkDataCodeByApprovalService")
	private NboxLinkDataCodeByApprovalService nboxLinkDataCodeByApprovalService;
	
	@Resource(name = "nboxDocExpenseDetailService")
	private NboxDocExpenseDetailService nboxDocExpenseDetailService;
	
	
	/**
	 * 상세 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map select(Map param, HttpServletRequest request) throws Exception {
		logger.debug("\n select: {}", param );
		
		/* Main Info */
		Map rv = new HashMap();
		Map details = (Map)super.commonDao.select("nboxDocListService.select", param);

		rv.put("records", details);
		return rv;
	}
	
	/**
	 * 저장(추가,수정)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "nbox")
	public ExtDirectFormPostResult save(
			@RequestParam("ADDFID") String[] ADDFID,
			@RequestParam("DELFID") String[] DELFID,
			@RequestParam("DOCLINES") String[] DOCLINES,
			@RequestParam("RCVUSERS") String[] RCVUSERS, 
			@RequestParam("REFUSERS") String[] REFUSERS, 
			@RequestParam("DOCBASISS") String[] DOCBASIS,
			@RequestParam("LINKDATA") String[] LINKDATA,
			@RequestParam("EXPENSEADD") String[] EXPENSEADD,
			@RequestParam("EXPENSEUPD") String[] EXPENSEUPD,
			@RequestParam("EXPENSEDEL") String[] EXPENSEDEL,
			NboxDocModel _doc, 
			LoginVO user) throws Exception {
		
		
		logger.debug("\n save NboxDocModel : {}", _doc );
		logger.debug("\n save ADDFID.length: {}", ADDFID.length);
		logger.debug("\n save DELFID.length: {}", DELFID.length);
		logger.debug("\n save DOCLINE.length: {}", DOCLINES.length);
		logger.debug("\n save RCVUSERS.length: {}", RCVUSERS.length);
		logger.debug("\n save REFUSERS.length: {}", REFUSERS.length);
		logger.debug("\n save DOCBASIS.length: {}", DOCBASIS.length);
		logger.debug("\n save EXPENSEADD.length: {}", EXPENSEADD.length);
		logger.debug("\n save EXPENSEUPD.length: {}", EXPENSEUPD.length);
		logger.debug("\n save EXPENSEDEL.length: {}", EXPENSEDEL.length);
				
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		_doc.setS_USER_ID(user.getUserID());
		_doc.setS_COMP_CODE(user.getCompCode());
		_doc.setS_DIV_CODE(user.getDivCode());
		_doc.setS_LANG_CODE(user.getLanguage());

		if (_doc.getContents() == null || _doc.getContents().isEmpty())
		{
			_doc.setContents(_doc.getEditorContents());
		}
		
		List<Map<String, Object>> DocLineList = stringArrayToListMap(DOCLINES);
		List<Map<String, Object>> RcvUserList = stringArrayToListMap(RCVUSERS);
		List<Map<String, Object>> RefUserList = stringArrayToListMap(REFUSERS);
		List<Map<String, Object>> DocBasisList = stringArrayToListMap(DOCBASIS);
		List<Map<String, Object>> LinkDataList = stringArrayToListMap(LINKDATA);
		List<Map<String, Object>> ExpenseAddList = stringArrayToListMap(EXPENSEADD);
		List<Map<String, Object>> ExpenseUpdList = stringArrayToListMap(EXPENSEUPD);
		List<Map<String, Object>> ExpenseDelList = stringArrayToListMap(EXPENSEDEL);
		
		logger.debug("\n save ExpenseAddList.size()  : {}", ExpenseAddList.size()  );

		if (ExpenseAddList.size() > 0)
		{
			StringBuilder buf = new StringBuilder();
			String sep = "";
			for (Map<String, Object> eachMap : ExpenseAddList) {
				logger.debug("\n save eachMap : {}", eachMap);
			    buf.append(sep).append(eachMap.get("CODE"));
			    sep = ";";
			    logger.debug("\n save buf : {}", buf.toString());
			}
			
			_doc.setInputRcvUser(buf.toString());
		}
		
		logger.debug("\n save _doc.getInputRcvUser() : {}", _doc.getInputRcvUser());
		
		if(_doc.getDocumentID() == null || _doc.getDocumentID().isEmpty()){
			Map Object = (Map)super.commonDao.select("nboxDocListService.createDocumentID",_doc);
			_doc.setDocumentID((String)Object.get("DocumentID"));
			
			super.commonDao.insert("nboxDocListService.insert", _doc);
		}else{
			super.commonDao.update("nboxDocListService.update", _doc);
		}
		
		if (ADDFID.length > 0)
			nboxDocFileService.confirmFile(user, _doc.getDocumentID(), ADDFID);
		
		logger.debug("\n nboxDocFileService.confirmFile : {}", ADDFID.length );
		
		if (DELFID.length > 0)
			nboxDocFileService.deleteFile(user, DELFID);
		
		logger.debug("\n nboxDocFileService.deleteFile : {}", DELFID.length );
		
		
		//if (DocLineList.size() > 0)
		nboxDocLineService.save(user, _doc.getDocumentID(), DocLineList);
		
		logger.debug("\n nboxDocLineService.save : {}", DocLineList );
		
		//if (RcvUserList.size() > 0)
		nboxDocRcvUserService.save(user, _doc.getDocumentID(), "C", RcvUserList);
		
		logger.debug("\n nboxDocRcvUserService.save RcvUserList : {}", RcvUserList );
		
		//if (RefUserList.size() > 0)
		nboxDocRcvUserService.save(user, _doc.getDocumentID(), "R", RefUserList);
		
		logger.debug("\n nboxDocRcvUserService.save RefUserList : {}", RefUserList );
		
		//if (DocBasisList.size() > 0)
		nboxDocBasisService.save(user, _doc.getDocumentID(), DocBasisList);
		
		logger.debug("\n nboxDocBasisService.save : {}", DocBasisList );
				
		//if (LinkDataList.size() > 0)
		nboxLinkDataCodeByApprovalService.save(user, _doc.getDocumentID(), LinkDataList);
		
		logger.debug("\n nboxLinkDataCodeByApprovalService.save : {}", LinkDataList );
		
		//if (ExpenseAddList.size() > 0)
			//nboxDocExpenseDetailService.insert(user, _doc.getDocumentID(), ExpenseAddList);
		
		if (ExpenseUpdList.size() > 0)
			nboxDocExpenseDetailService.update(user, ExpenseUpdList);
		
		if (ExpenseDelList.size() > 0)
			nboxDocExpenseDetailService.delete(user, ExpenseDelList);
		
		logger.debug("\n save _doc.getStatus() : {}", _doc.getStatus()  );
		
		// 상신
		if(_doc.getStatus().equals("B") ){
			logger.debug("\n save _doc.getStatus() : {}", _doc.getStatus()  );
			
			Map param = new HashMap();
			param.put("DocumentID", _doc.getDocumentID());
			
			param.put("S_COMP_CODE", user.getCompCode());
			param.put("S_USER_ID", user.getUserID());
			param.put("S_LANG_CODE", user.getLanguage());
			param.put("EXEC_TYPE", "DRAFT");
			
			logger.debug("\n nboxDocListService.save.exec: {}", param );
			
	        super.commonDao.update("nboxDocListService.exec", param);
	        
		}
				
		Map param1 = new HashMap();
		
		param1.put("DOCUMENTID", _doc.getDocumentID());
		param1.put("GUBUN", _doc.getGubun());
		param1.put("INTERFACEKEY",_doc.getInterfaceKey());
		param1.put("STATUS",_doc.getStatus());
		param1.put("S_USER_ID", user.getUserID());
		
		if(checkInterface(param1).equals(Boolean.FALSE )){
			if (_doc.getInterfaceKey() != null && !_doc.getInterfaceKey().isEmpty())
			{
				insertInterfaceInfo(param1);
				insertInterfaceHistory(param1);
				
				Map param2 = getDocInfo(param1);
				param2.put("S_COMP_CODE", user.getCompCode());
				param2.put("USER_ID", user.getUserID());
				setInterfaceERP(param2);
			}
		}
		else
		{
			updateInterfaceInfo(param1);
			insertInterfaceHistory(param1);
			
			Map param3 = getDocInfo(param1);
			param3.put("S_COMP_CODE", user.getCompCode());
			param3.put("USER_ID", user.getUserID());
			setInterfaceERP(param3);
		}	
				
		resp.addResultProperty("DocumentID", _doc.getDocumentID());
		
		return resp; 
	}
	
	private Boolean checkInterface(Map param) throws Exception {
		Boolean flag = Boolean.FALSE;
		logger.debug("\n nboxDocListService.checkInterface1: {}", param);
		int cnt = (int)super.commonDao.select("nboxDocListService.checkInterface", param);
		
		if (cnt > 0)
			flag = Boolean.TRUE;
		else
			flag = Boolean.FALSE;
		
		return flag;
	}
	
	private String insertInterfaceInfo(Map param) throws Exception {
		String ret = "";
		logger.debug("\n nboxDocListService.insertInterfaceInfo: {}", param);
		super.commonDao.insert("nboxDocListService.insertInterfaceInfo", param);
		
		return ret;
	}
	
	private String insertInterfaceHistory(Map param) throws Exception {
		String ret = "";
		logger.debug("\n nboxDocListService.insertInterfaceHistory: {}", param);
		super.commonDao.insert("nboxDocListService.insertInterfaceHistory", param);
		
		return ret;
	}
	
	private String updateInterfaceInfo(Map param) throws Exception {
		String ret = "";
		logger.debug("\n nboxDocListService.updateInterfaceInfo: {}", param);
		super.commonDao.insert("nboxDocListService.updateInterfaceInfo", param);
		
		return ret;
	}
	
	private String deleteInterfaceInfo(Map param) throws Exception {
		String ret = "";
		logger.debug("\n nboxDocListService.deleteInterfaceInfo: {}", param);
		super.commonDao.insert("nboxDocListService.deleteInterfaceInfo", param);
		
		return ret;
	}
	
	private List<Map<String, Object>> stringArrayToListMap(String[] stringArray) throws Exception {
		logger.debug("\n nboxDocListService.strArrToListMap: {}", stringArray);
		
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
	
		for(String strTemp :stringArray )	{
			listMap.add(stringToMap(strTemp.replace((char)11, ',')));
		}
		
		return listMap;
	}
	
	private Map<String, Object> stringToMap(String strTemp) throws Exception {
		logger.debug("\n nboxDocListService.strToMap: {}", strTemp);
		
		if (strTemp == null) return null;
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> mapObj = mapper.readValue(strTemp, new TypeReference<Map<String, Object>>() {});
		
		return mapObj;
	}
	
	/**
	 * 리스트 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		logger.debug("\n selects: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocListService.selects", param);
		
		int totalCount = 0;
		if(list.size() > 0 ) {
			Map rec = (Map) list.get(0);
			totalCount = (Integer)rec.get("TOTALCOUNT");
		}
		
		rv.put("records", list);
		rv.put("total", totalCount);
		
		return rv;
	}
	
	/**
	 *  첨부파일리스트
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selectFiles(Map param, HttpServletRequest request) throws Exception {
		logger.debug("\n selectFiles: {}", param );
		Map rv = new HashMap();
		
		String configPath = ConfigUtil.getString("nbox.image.ext");
		String iconPath = request.getServletContext().getRealPath(configPath) + '/';
		
		List<Map<String, Object>> list = nboxDocFileService.getByDocumentID(param);
		
		BigDecimal mbSize = new BigDecimal((1024 * 1024));
			
		for(Map fileMap : list) {
			String ext = fileMap.get("UploadFileExtension").toString().toLowerCase();
			ext = ext.substring(0, (ext.length() > 3 ? 3 : ext.length())) + ".gif";
			
			logger.debug("\n selectFiles.ext: {}", ext );
			
			String extPath = iconPath + ext;
			File f = new File(extPath);
			if (f.isFile()){
				fileMap.put("UploadFileIcon", ext);
			}
			else{
				fileMap.put("UploadFileIcon", "none.gif");
			}
			BigDecimal FILESIZE;
			BigDecimal kbSize = new BigDecimal(fileMap.get("FileSize").toString());
			
			FILESIZE = kbSize.divide(mbSize, 2, BigDecimal.ROUND_UP);
			fileMap.put("FileSize", FILESIZE);
		}
		
		rv.put("records", list);
		return rv;
	}
	
	@SuppressWarnings("unchecked")
	@ExtDirectMethod(group = "nbox")
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		logger.debug("\n getFileList: {}", param );
		return nboxDocFileService.getByDocumentID(param);
	}
	
	/**
	 * 문서 실행 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "nbox")
	public ExtDirectFormPostResult exec(NboxDocModel _doc, LoginVO user) throws Exception {
		logger.debug("\n nboxDocFileService.exec: {}", _doc );
		
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		Map param = new HashMap();
		param.put("DocumentID", _doc.getDocumentID());
		
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		param.put("S_LANG_CODE", user.getLanguage());
		
		
		switch (_doc.getActionType()){
			case "D":  // 삭제
				// 파일
				List<Map<String, Object>> fileList = super.commonDao.list("nboxDocFileService.getByDocumentID", param);
				if (fileList.size() > 0 ){
					String[] DELFID = new String[fileList.size()];
					int idx = 0 ;
					
					for(Map<String, Object>file : fileList ){
						DELFID[idx] = file.get("fid").toString();
						idx++;
					}
					
					nboxDocFileService.deleteFile(user, DELFID);
				}
				
				Map param1 = new HashMap();
				
				param1.put("DOCUMENTID", _doc.getDocumentID());
				param1.put("GUBUN", _doc.getGubun());
				param1.put("INTERFACEKEY",_doc.getInterfaceKey());
				param1.put("STATUS",_doc.getStatus());
				param1.put("S_USER_ID", user.getUserID());
				
				if(checkInterface(param1).equals(Boolean.TRUE)){
					deleteInterfaceInfo(param1);
				}
				
				// 결재라인
				super.commonDao.delete("nboxDocLineService.deletes", param);
				// 수신/참조 라인
				param.put("RcvType", "C");
				super.commonDao.delete("nboxDocRcvUserService.deletes", param);
				param.put("RcvType", "R");
				super.commonDao.delete("nboxDocRcvUserService.deletes", param);
				// 근거문서
				super.commonDao.delete("nboxDocBasisService.deletes", param);
				// 댓글
				super.commonDao.delete("nboxDocCommentService.deletes", param);
				// 결재연동
				super.commonDao.delete("nboxLinkDataCodeByApprovalService.deletes", param);
				// 결재문서
				super.commonDao.delete("nboxDocListService.delete", param);
				
				break;
				
			case "U":
				param.put("EXEC_TYPE", _doc.getExecType());
				
				logger.debug("\n nboxDocListService.exec: {}", param );
				
		    	super.commonDao.update("nboxDocListService.exec", param);
		        
				Map param2 = new HashMap();
				
				param2.put("DOCUMENTID", _doc.getDocumentID());
				param2.put("GUBUN", _doc.getGubun());
				param2.put("INTERFACEKEY",_doc.getInterfaceKey());
				param2.put("STATUS",_doc.getStatus());
				param2.put("S_USER_ID", user.getUserID());
				
				if(checkInterface(param2).equals(Boolean.FALSE )){
					if (_doc.getInterfaceKey() != null && !_doc.getInterfaceKey().isEmpty())
					{     
						insertInterfaceInfo(param2);
						insertInterfaceHistory(param2);
						
						Map param3 = getDocInfo(param2);
						param3.put("S_COMP_CODE", user.getCompCode());
						param3.put("USER_ID", user.getUserID());
						setInterfaceERP(param3);
					}
				}
				else
				{
					Map param4 = getDocInfo(param2);
					param4.put("S_COMP_CODE", user.getCompCode());
					param4.put("S_USER_ID", user.getUserID());
					
					updateInterfaceInfo(param4);
					insertInterfaceHistory(param4);
					setInterfaceERP(param4);
				}
				
				
				break;
			default:
				break;
		}
		
		return resp; 
	}
	
	
	
	private Map getDocInfo(Map param) throws Exception {
		logger.debug("\n nboxDocListService.getDocInfo: {}", param );
		Map rv = new HashMap();
		Map details = (Map)super.commonDao.select("nboxDocListService.getDocInfo", param);

		return details;
	}
	
	private String setInterfaceERP(Map param) throws Exception {
		String ret = "";
		logger.debug("\n nboxDocListService.setInterfaceERP: {}", param);
		
		String dbms = ConfigUtil.getString("common.dbms", "");
		
		Map param1 = new HashMap();
		param1.put("GWIF_ID", param.get("INTERFACEKEY"));
		param1.put("SP_CALL", param.get("S_COMP_CODE"));
		param1.put("USER_ID", param.get("USER_ID"));
		param1.put("DOC_NO", param.get("DOCUMENTNO"));
		param1.put("GUBUN", param.get("GUBUN"));
				
		switch(param.get("STATUS").toString().toUpperCase())
		{
			case "A":
				param1.put("STATUS", "1");
				break;
				
			case "B":
				param1.put("STATUS", "3");
				break;
				
			case "C":
				param1.put("STATUS", "9");
				break;
			
			case "R":
				param1.put("STATUS", "5");
				break;
				
			default:
				param1.put("STATUS", "0");
				break;
		}
		 
		if (dbms.equals("")) {
			super.commonDao.update("nboxDocListService.setInterfaceERP", param1);
		} else if (dbms.equals("CUBRID")) {
			USP_GWAPP.SP_GWAPP(param1);
		}
		
		return ret;
	}
	
	/**
	 * 메뉴이동
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "nbox")
	public Map moveMenu(Map param, LoginVO user) throws Exception {	
		logger.debug("\n moveMenu: {}", param );
		super.commonDao.update("nboxDocListService.moveMenu", param);		
		return  param;
	}
	
	@ExtDirectMethod(group = "nbox")
	public int checkDoc(Map param) throws Exception {
		logger.debug("\n checkDoc: {}", param );
		
		int rv = 0;
		rv =(int)super.commonDao.select("nboxDocListService.checkDoc", param);
		
		return rv;
	}
	
	@ExtDirectMethod(group = "nbox")
	public Map isInterface(Map param) throws Exception {
		logger.debug("\n checkDoc: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocListService.isInterface", param);
		
		rv.put("records", list);
		return rv;
	}
	
	
	@ExtDirectMethod(group = "nbox")
	public Map nfnTest(Map param) throws Exception{
		logger.debug("\n nfnTest: {}", param );
		
		String sValue = "";
		int iSeq = 500;
		
		//sValue = NboxFunction_final.nfnGetInterfaceForm("MASTER", "1", "01A2014071016125");
		//sValue = NboxFunction_final.nfnMenuListByUser("MASTER", "14", "unilite5");
				
		Map rv = new HashMap();
		
		rv.put("sValue", sValue);
				
		return rv;
	}



}
