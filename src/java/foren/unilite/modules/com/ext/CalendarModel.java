
package foren.unilite.modules.com.ext;


public class CalendarModel {

	private  String id;

	private  String title;

	private String description;

	private Integer color;

	private Boolean hidden;
	
	public CalendarModel() {
		
	}
	
//	public Calendar(String id, String title, Integer color) {
//		this.id = id;
//		this.title = title;
//		this.color = color;
//	}

	public String getId() {
		return id;
	}

	public String getTitle() {
		return title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getColor() {
		return color;
	}

	public void setColor(Integer color) {
		this.color = color;
	}

	public Boolean isHidden() {
		return hidden;
	}

	public void setHidden(Boolean hidden) {
		this.hidden = hidden;
	}

}
