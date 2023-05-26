package foren.unilite.modules.nbox.approval.model;

import java.math.BigDecimal;

import foren.framework.model.BaseVO;

public class NboxDocFileModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String FID ;
    
    private String DocumentID;
    private String UploadFileName;
    private String UploadFileExtension;
    private String UploadFileIcon;
	private BigDecimal FileSize;
    private String UploadContentType;
    private String UploadPath;
    private String CompanyID;
    
    private String InsertUserID;
    private String InsertDate;
    private String UpdateUserID;
    private String UpdateDate;
    
    public String getFID() {
		return this.FID;
	}
	
	public void setFID(String FID) {
		this.FID = FID;
	}

	public String getDocumentID() {
		return DocumentID;
	}

	public void setDocumentID(String documentID) {
		DocumentID = documentID;
	}

	public String getUploadFileName() {
		return UploadFileName;
	}

	public void setUploadFileName(String uploadFileName) {
		UploadFileName = uploadFileName;
	}

	public String getUploadFileExtension() {
		return UploadFileExtension;
	}

	public void setUploadFileExtension(String uploadFileExtension) {
		UploadFileExtension = uploadFileExtension;
	}

	public String getUploadFileIcon() {
		return UploadFileIcon;
	}

	public void setUploadFileIcon(String uploadFileIcon) {
		UploadFileIcon = uploadFileIcon;
	}

	public BigDecimal getFileSize() {
		return FileSize;
	}

	public void setFileSize(BigDecimal fileSize) {
		FileSize = fileSize;
	}

	public String getUploadContentType() {
		return UploadContentType;
	}

	public void setUploadContentType(String uploadContentType) {
		UploadContentType = uploadContentType;
	}

	public String getUploadPath() {
		return UploadPath;
	}

	public void setUploadPath(String uploadPath) {
		UploadPath = uploadPath;
	}

	public String getCompanyID() {
		return CompanyID;
	}

	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}

	public String getInsertUserID() {
		return InsertUserID;
	}

	public void setInsertUserID(String insertUserID) {
		InsertUserID = insertUserID;
	}

	public String getInsertDate() {
		return InsertDate;
	}

	public void setInsertDate(String insertDate) {
		InsertDate = insertDate;
	}

	public String getUpdateUserID() {
		return UpdateUserID;
	}

	public void setUpdateUserID(String updateUserID) {
		UpdateUserID = updateUserID;
	}

	public String getUpdateDate() {
		return UpdateDate;
	}

	public void setUpdateDate(String updateDate) {
		UpdateDate = updateDate;
	}

	
}
