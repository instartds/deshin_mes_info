package foren.unilite.modules.mobile.android;

import java.util.List;

public class ItemVO {

	private String Barcode;
	private String ItemGrpCd;
	private String ItemGrpNm;
	private String MODELCd;
	private String MODELNm;
	private String SYMBOLCd;
	private String SYMBOLNm;
	private String ItemNo;
	private String ItemNm;
	private String SmallNm;
	private String CountryCd;
	private String Spec;
	private int SeqNo;
	private String Size;
	private String CustLevelCd;
	private String DCRate;
	private double SalePrice;
	private double EPSalePrice;
	private double ItemCost;
	private double LocalCurrCost;
	private String Currency;
	private double GoodStckQnty;
	private String BasUnit;
	private String ItemDec;
	private String UseYN;

	private String WhCode;
	private double StockQnty;


	private List<ItemVO> GroupList;
	private List<ItemVO> ModelList;
	private List<ItemVO> SymbolList;


	// Must have no-argument constructor
	public ItemVO() {

	}

	public ItemVO(
			String Barcode,
			String ItemGrpCd,
			String ItemGrpNm,
			String MODELCd,
			String MODELNm,
			String SYMBOLCd,
			String SYMBOLNm,
			String ItemNo,
			String ItemNm,
			String SmallNm,
			String CountryCd,
			String Spec,
			int SeqNo,
			String Size,
			String CustLevelCd,
			String DCRate,
			double SalePrice,
			double EPSalePrice,
			double ItemCost,
			double LocalCurrCost,
			String Currency,
			double GoodStckQnty,
			String BasUnit,
			String ItemDec,
			String UseYN,
			String WhCode,
			double StockQnty,
			List<ItemVO> GroupList,
			List<ItemVO> ModelList,
			List<ItemVO> SymbolList
			) {
		this.Barcode		= Barcode		;
		this.ItemGrpCd     	= ItemGrpCd     ;
		this.ItemGrpNm     	= ItemGrpNm     ;
		this.MODELCd       	= MODELCd       ;
		this.MODELNm       	= MODELNm       ;
		this.SYMBOLCd      	= SYMBOLCd      ;
		this.SYMBOLNm      	= SYMBOLNm      ;
		this.ItemNo        	= ItemNo        ;
		this.ItemNm        	= ItemNm        ;
		this.SmallNm       	= SmallNm       ;
		this.CountryCd     	= CountryCd     ;
		this.Spec          	= Spec          ;
		this.SeqNo         	= SeqNo         ;
		this.Size          	= Size          ;
		this.CustLevelCd   	= CustLevelCd   ;
		this.DCRate        	= DCRate        ;
		this.SalePrice     	= SalePrice     ;
		this.EPSalePrice   	= EPSalePrice   ;
		this.ItemCost      	= ItemCost      ;
		this.LocalCurrCost 	= LocalCurrCost ;
		this.Currency      	= Currency      ;
		this.GoodStckQnty  	= GoodStckQnty  ;
		this.BasUnit       	= BasUnit       ;
		this.ItemDec       	= ItemDec       ;
		this.UseYN         	= UseYN         ;
		this.WhCode	   	   	= WhCode	   	;
		this.StockQnty	   	= StockQnty	   	;
		this.GroupList	   	= GroupList	   	;
		this.ModelList	   	= ModelList	   	;
		this.SymbolList	   	= SymbolList	;
	}


	public String getBarcode() {
		return Barcode;
	}

	public void setBarcode(String barcode) {
		Barcode = barcode;
	}

	public String getItemGrpCd() {
		return ItemGrpCd;
	}

	public void setItemGrpCd(String itemGrpCd) {
		ItemGrpCd = itemGrpCd;
	}

	public String getItemGrpNm() {
		return ItemGrpNm;
	}

	public void setItemGrpNm(String itemGrpNm) {
		ItemGrpNm = itemGrpNm;
	}

	public String getMODELCd() {
		return MODELCd;
	}

	public void setMODELCd(String mODELCd) {
		MODELCd = mODELCd;
	}

	public String getMODELNm() {
		return MODELNm;
	}

	public void setMODELNm(String mODELNm) {
		MODELNm = mODELNm;
	}

	public String getSYMBOLCd() {
		return SYMBOLCd;
	}

	public void setSYMBOLCd(String sYMBOLCd) {
		SYMBOLCd = sYMBOLCd;
	}

	public String getSYMBOLNm() {
		return SYMBOLNm;
	}

	public void setSYMBOLNm(String sYMBOLNm) {
		SYMBOLNm = sYMBOLNm;
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

	public String getSmallNm() {
		return SmallNm;
	}

	public void setSmallNm(String smallNm) {
		SmallNm = smallNm;
	}

	public String getCountryCd() {
		return CountryCd;
	}

	public void setCountryCd(String countryCd) {
		CountryCd = countryCd;
	}

	public String getSpec() {
		return Spec;
	}

	public void setSpec(String spec) {
		Spec = spec;
	}

	public int getSeqNo() {
		return SeqNo;
	}

	public void setSeqNo(int seqNo) {
		SeqNo = seqNo;
	}

	public String getSize() {
		return Size;
	}

	public void setSize(String size) {
		Size = size;
	}

	public String getCustLevelCd() {
		return CustLevelCd;
	}

	public void setCustLevelCd(String custLevelCd) {
		CustLevelCd = custLevelCd;
	}

	public String getDCRate() {
		return DCRate;
	}

	public void setDCRate(String dCRate) {
		DCRate = dCRate;
	}

	public double getSalePrice() {
		return SalePrice;
	}

	public void setSalePrice(double salePrice) {
		SalePrice = salePrice;
	}

	public double getEPSalePrice() {
		return EPSalePrice;
	}

	public void setEPSalePrice(double ePSalePrice) {
		EPSalePrice = ePSalePrice;
	}

	public double getItemCost() {
		return ItemCost;
	}

	public void setItemCost(double itemCost) {
		ItemCost = itemCost;
	}

	public double getLocalCurrCost() {
		return LocalCurrCost;
	}

	public void setLocalCurrCost(double localCurrCost) {
		LocalCurrCost = localCurrCost;
	}

	public String getCurrency() {
		return Currency;
	}

	public void setCurrency(String currency) {
		Currency = currency;
	}

	public double getGoodStckQnty() {
		return GoodStckQnty;
	}

	public void setGoodStckQnty(double goodStckQnty) {
		GoodStckQnty = goodStckQnty;
	}

	public String getBasUnit() {
		return BasUnit;
	}

	public void setBasUnit(String basUnit) {
		BasUnit = basUnit;
	}

	public String getItemDec() {
		return ItemDec;
	}

	public void setItemDec(String itemDec) {
		ItemDec = itemDec;
	}

	public String getUseYN() {
		return UseYN;
	}

	public void setUseYN(String useYN) {
		UseYN = useYN;
	}

	public String getWhCode() {
		return WhCode;
	}

	public void setWhCode(String whCode) {
		WhCode = whCode;
	}

	public double getStockQnty() {
		return StockQnty;
	}

	public void setStockQnty(double stockQnty) {
		StockQnty = stockQnty;
	}

	public List<ItemVO> getGroupList() {
		return GroupList;
	}

	public void setGroupList(List<ItemVO> groupList) {
		GroupList = groupList;
	}

	public List<ItemVO> getModelList() {
		return ModelList;
	}

	public void setModelList(List<ItemVO> modelList) {
		ModelList = modelList;
	}

	public List<ItemVO> getSymbolList() {
		return SymbolList;
	}

	public void setSymbolList(List<ItemVO> symbolList) {
		SymbolList = symbolList;
	}





}