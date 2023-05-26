package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.LoginVO;
import foren.framework.web.view.FileDownloadInfo;

public interface NboxDocFileService {

	/**
	 * 하나의 임시 파일 등록
	 */
	public String insertFile( LoginVO user, FileUploadModel file) throws Exception;

	/**
	 * 하나의 파일 정보 조회
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid) throws Exception;
	
	public List<Map<String, Object>> getByDocumentID(Map param) throws Exception;
	
	/**
	 * 하나 또는 여러개의 파일 정보 등록 확인 처리(템프->정규)	 
	 * @param user
	 * @param fids : 하나의 fid 또는 ","으로 구분 되는 fid 목록 문자열
	 * @return
	 * @throws Exception
	 */
	public boolean confirmFile( LoginVO user, String DocumentID, String[] ADDFID) throws Exception;
	
	/**
	 * /**
	 * 하나 또는 여러개의 파일 정보 삭제
	 * @param user
	 * @param fids : 하나의 fid 또는 ","으로 구분 되는 fid 목록 문자열
	 * @return
	 * @throws Exception
	 */
	public boolean deleteFile( LoginVO user, String[] DELFID) throws Exception;
}