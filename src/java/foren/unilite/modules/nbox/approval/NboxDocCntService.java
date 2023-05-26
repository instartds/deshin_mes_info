package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.LoginVO;
import foren.framework.web.view.FileDownloadInfo;

public interface NboxDocCntService {
	
	public String xa003DocCnt(Map param) throws Exception ;
	
	public String getMenuName(Map param) throws Exception ;
	
}