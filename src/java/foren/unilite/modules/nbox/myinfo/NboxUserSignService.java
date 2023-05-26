package foren.unilite.modules.nbox.myinfo;

import java.io.File;
import java.util.List;
import java.util.Map;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.LoginVO;
import foren.framework.web.view.FileDownloadInfo;

public interface NboxUserSignService {
	
	public File getUserSignImage(String fid) throws Exception;
	
}