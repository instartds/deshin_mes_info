package foren.unilite.modules.crm.cmb.model;


import java.util.Date;

import org.apache.commons.lang.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;



public class EventModel {

	private String id;

	private String cid;

	private String title;

	private String startDate;

	private String endDate;

	private String location;

	private String notes;

	private String url;

	private String recurRule;

	private boolean allDay;

	private String reminder;
	
	private String planClientName;	// 계획고객명
	private String planCustomName;	// 계획거래처
	
	private String content;
	
	private String summary;
	
	private String palnDate; // 계획일자
	private String planTarget; // 계획
	
	private String resultClientName;	// 결과 고객명
	private String resultDate;	// 실행일자
	private String saleType;	// 영업유형
	private String customName;	// 거래처
	
	
	

	public void trimToNull() {
		StringUtils.trimToNull(title);
		StringUtils.trimToNull(location);
		StringUtils.trimToNull(notes);
		StringUtils.trimToNull(url);
		StringUtils.trimToNull(recurRule);
		StringUtils.trimToNull(reminder);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCalendarId() {
		return cid;
	}

	public void setCalendarId(String calendarId) {
		this.cid = calendarId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = cvDate(startDate);
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = cvDate(endDate);
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public boolean isAllDay() {
		return allDay;
	}

	public void setAllDay(boolean allDay) {
		this.allDay = allDay;
	}

	public String getReminder() {
		return reminder;
	}

	public void setReminder(String reminder) {
		this.reminder = reminder;
	}

	public String getRecurRule() {
		return recurRule;
	}

	public void setRecurRule(String recurRule) {
		this.recurRule = recurRule;
	}


	private String cvDate(Date dtj) {
		DateTime dt = new DateTime(dtj);
		 DateTimeFormatter fmt = ISODateTimeFormat.dateTime();
		 return fmt.print(dt);
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	public String getPlanClientName() {
		return planClientName;
	}

	public void setPlanClientName(String planClientName) {
		this.planClientName = planClientName;
	}

	public String getPlanCustomName() {
		return planCustomName;
	}

	public void setPlanCustomName(String planCustomName) {
		this.planCustomName = planCustomName;
	}

	public String getPalnDate() {
		return palnDate;
	}

	public void setPalnDate(String palnDate) {
		this.palnDate = palnDate;
	}

	public String getPlanTarget() {
		return planTarget;
	}

	public void setPlanTarget(String planTarget) {
		this.planTarget = planTarget;
	}

	public String getResultClientName() {
		return resultClientName;
	}

	public void setResultClientName(String resultClientName) {
		this.resultClientName = resultClientName;
	}

	public String getResultDate() {
		return resultDate;
	}

	public void setResultDate(String resultDate) {
		this.resultDate = resultDate;
	}

	public String getSaleType() {
		return saleType;
	}

	public void setSaleType(String saleType) {
		this.saleType = saleType;
	}

	public String getCustomName() {
		return customName;
	}

	public void setCustomName(String customName) {
		this.customName = customName;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}


	
}