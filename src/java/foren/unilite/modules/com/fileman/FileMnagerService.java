package foren.unilite.modules.com.fileman;

import java.util.Map;

import foren.framework.lib.fileupload.FileUploadModel;
import foren.framework.model.LoginVO;
import foren.framework.web.view.FileDownloadInfo;

public interface FileMnagerService {

	/**
	 * 하나의 임시 파일 등록
	 */
	public String insertFile( LoginVO user, FileUploadModel file) throws Exception;

    /**
     * <pre>
     * 파일을 업로드 합니다.
     * 파일을 BFL200T 테이블에 저장하지 않습니다.
     * </pre>
     * 
     * @param filePath 업로드될 파일 경로
     * @param file 파일
     * @return
     * @throws Exception
     */
    public String saveFile( String filePath, FileUploadModel file ) throws Exception;
	
	/**
	 * 하나의 파일 정보 조회
	 */
	public FileDownloadInfo getFileInfo( LoginVO user, String fid) throws Exception;
	
	   /**
     * 하나의 파일 정보 조회
     */
    public FileDownloadInfo getExcelFileInfo( LoginVO user, String fid,  String type) throws Exception;
	
	/**
	 * 하나 또는 여러개의 파일 정보 등록 확인 처리(템프->정규)	 
	 * @param user
	 * @param fids : 하나의 fid 또는 ","으로 구분 되는 fid 목록 문자열
	 * @return
	 * @throws Exception
	 */
	public boolean confirmFile( LoginVO user, String fids) throws Exception;
	
	/**
	 * /**
	 * 하나 또는 여러개의 파일 정보 삭제
	 * @param user
	 * @param fids : 하나의 fid 또는 ","으로 구분 되는 fid 목록 문자열
	 * @return
	 * @throws Exception
	 */
	public boolean deleteFile( LoginVO user, String fids) throws Exception;
	
	/**
	 * 도움말 파일 정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Object getManualInfo( Map param) throws Exception;

	public FileDownloadInfo getApkInfo( LoginVO user ) throws Exception;
	
}