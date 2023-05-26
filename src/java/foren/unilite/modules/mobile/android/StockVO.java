package foren.unilite.modules.mobile.android;
public class StockVO {

	// 창고
	private String WhCode;
	private String WhName;

	// 재고이동 조회
	private String MoveSpNo;
	private int Seq;
	private String MoveDt;
	private String DeptName;
	private String DeptCd;
	private String EmpName;
	private String EmpNo;
	private String FromWhName;
	private String FromWhCode;
	private String ToWhName;
	private String ToWhCode;
	private String Remark;
	private String ItemNo;
	private String ItemNm;
	private String SizeSeq;
	private String Size;
	private double MoveQnty;
	private String OutSpNo;
	private String InSpNo;

	private String PlantCd;
	private String Barcode;


	// Must have no-argument constructor
	public StockVO() {

	}


	public String getWhCode() {
		return WhCode;
	}


	public void setWhCode(String whCode) {
		WhCode = whCode;
	}


	public String getWhName() {
		return WhName;
	}


	public void setWhName(String whName) {
		WhName = whName;
	}


	public String getMoveSpNo() {
		return MoveSpNo;
	}


	public void setMoveSpNo(String moveSpNo) {
		MoveSpNo = moveSpNo;
	}

	public int getSeq() {
		return Seq;
	}


	public void setSeq(int seq) {
		Seq = seq;
	}

	public String getMoveDt() {
		return MoveDt;
	}


	public void setMoveDt(String moveDt) {
		MoveDt = moveDt;
	}


	public String getDeptName() {
		return DeptName;
	}


	public void setDeptName(String chgDeptName) {
		DeptName = chgDeptName;
	}


	public String getDeptCd() {
		return DeptCd;
	}


	public void setDeptCd(String chgDeptCd) {
		DeptCd = chgDeptCd;
	}


	public String getEmpName() {
		return EmpName;
	}


	public void setEmpName(String chgEmpName) {
		EmpName = chgEmpName;
	}


	public String getEmpNo() {
		return EmpNo;
	}


	public void setEmpNo(String chgEmpNo) {
		EmpNo = chgEmpNo;
	}


	public String getFromWhName() {
		return FromWhName;
	}


	public void setFromWhName(String fromWhName) {
		FromWhName = fromWhName;
	}


	public String getFromWhCode() {
		return FromWhCode;
	}


	public void setFromWhCode(String fromWhCode) {
		FromWhCode = fromWhCode;
	}


	public String getToWhName() {
		return ToWhName;
	}


	public void setToWhName(String toWhName) {
		ToWhName = toWhName;
	}


	public String getToWhCode() {
		return ToWhCode;
	}


	public void setToWhCode(String toWhCode) {
		ToWhCode = toWhCode;
	}


	public String getRemark() {
		return Remark;
	}


	public void setRemark(String remark) {
		Remark = remark;
	}


	public String getItemNo() {
		return ItemNo;
	}


	public void setItemNo(String itemNo) {
		ItemNo = itemNo;
	}


	public String getItemNm() {
		return ItemNm;
	}


	public void setItemNm(String itemNm) {
		ItemNm = itemNm;
	}


	public String getSizeSeq() {
		return SizeSeq;
	}


	public void setSizeSeq(String sizeSeq) {
		SizeSeq = sizeSeq;
	}


	public String getSize() {
		return Size;
	}


	public void setSize(String size) {
		Size = size;
	}


	public double getMoveQnty() {
		return MoveQnty;
	}


	public void setMoveQnty(double moveQnty) {
		MoveQnty = moveQnty;
	}


	public String getOutSpNo() {
		return OutSpNo;
	}


	public void setOutSpNo(String outSpNo) {
		OutSpNo = outSpNo;
	}


	public String getInSpNo() {
		return InSpNo;
	}


	public void setInSpNo(String inSpNo) {
		InSpNo = inSpNo;
	}


	public String getPlantCd() {
		return PlantCd;
	}


	public void setPlantCd(String plantCd) {
		PlantCd = plantCd;
	}


	public String getBarcode() {
		return Barcode;
	}


	public void setBarcode(String barcode) {
		Barcode = barcode;
	}

}