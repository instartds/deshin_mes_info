package foren.unilite.modules.com.combo;

public class ComboItemModel {
	private String value;
	private String text;
	private String option;
	private String search;
	private Boolean includeMainCode=false;
	
	public ComboItemModel() {
		
	}
	
	public ComboItemModel(String value, String text, String option, Boolean includeMainCode) {
		this.value = value;
		this.text = text;
		this.option = option;
		this.search = value+text;
		this.includeMainCode = includeMainCode == null ? false:includeMainCode;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}

	public String getOption() {
		return option;
	}

	public void setOption(String option) {
		this.option = option;
	}
	
	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public Boolean getIncludeMainCode() {
		return includeMainCode;
	}

	public void setIncludeMainCode(Boolean includeMainCode) {
		this.includeMainCode = includeMainCode;
	}
	
}
