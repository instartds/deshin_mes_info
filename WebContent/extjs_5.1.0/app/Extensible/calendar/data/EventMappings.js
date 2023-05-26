
/*!
 * Extensible 1.5.2
 * Copyright(c) 2010-2013 Extensible, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
 
/**
 * @class Extensible.calendar.data.EventMappings
 * @extends Object
 * <p>A simple object that provides the field definitions for 
 * {@link Extensible.calendar.EventRecord EventRecord}s so that they can be easily overridden.</p>
 * 
 * <p>There are several ways of overriding the default Event record mappings to customize how 
 * Ext records are mapped to your back-end data model. If you only need to change a handful 
 * of field properties you can directly modify the EventMappings object as needed and then 
 * reconfigure it. The simplest approach is to only override specific field attributes:</p>
 * <pre><code>
var M = Extensible.calendar.data.EventMappings;
M.Title.mapping = 'evt_title';
M.Title.name = 'EventTitle';
Extensible.calendar.EventRecord.reconfigure();
</code></pre>
 * 
 * <p>You can alternately override an entire field definition using object-literal syntax, or 
 * provide your own custom field definitions (as in the following example). Note that if you do 
 * this, you <b>MUST</b> include a complete field definition, including the <tt>type</tt> attribute
 * if the field is not the default type of <tt>string</tt>.</p>
 * <pre><code>
// Add a new field that does not exist in the default EventMappings:
Extensible.calendar.data.EventMappings.Timestamp = {
    name: 'Timestamp',
    mapping: 'timestamp',
    type: 'date'
};
Extensible.calendar.EventRecord.reconfigure();
</code></pre>
 * 
 * <p>If you are overriding a significant number of field definitions it may be more convenient 
 * to simply redefine the entire EventMappings object from scratch. The following example
 * redefines the same fields that exist in the standard EventRecord object but the names and 
 * mappings have all been customized. Note that the name of each field definition object 
 * (e.g., 'EventId') should <b>NOT</b> be changed for the default EventMappings fields as it 
 * is the key used to access the field data programmatically.</p>
 * <pre><code>
Extensible.calendar.data.EventMappings = {
    EventId:     {name: 'ID', mapping:'evt_id', type:'int'},
    CalendarId:  {name: 'CalID', mapping: 'cal_id', type: 'int'},
    Title:       {name: 'EvtTitle', mapping: 'evt_title'},
    StartDate:   {name: 'StartDt', mapping: 'start_dt', type: 'date', dateFormat: 'c'},
    EndDate:     {name: 'EndDt', mapping: 'end_dt', type: 'date', dateFormat: 'c'},
    RRule:       {name: 'RecurRule', mapping: 'recur_rule'},
    Location:    {name: 'Location', mapping: 'location'},
    Notes:       {name: 'Desc', mapping: 'full_desc'},
    Url:         {name: 'LinkUrl', mapping: 'link_url'},
    IsAllDay:    {name: 'AllDay', mapping: 'all_day', type: 'boolean'},
    Reminder:    {name: 'Reminder', mapping: 'reminder'},
    
    // We can also add some new fields that do not exist in the standard EventRecord:
    CreatedBy:   {name: 'CreatedBy', mapping: 'created_by'},
    IsPrivate:   {name: 'Private', mapping:'private', type:'boolean'}
};
// Don't forget to reconfigure!
Extensible.calendar.EventRecord.reconfigure();
</code></pre>
 * 
 * <p><b>NOTE:</b> Any record reconfiguration you want to perform must be done <b>PRIOR to</b> 
 * initializing your data store, otherwise the changes will not be reflected in the store's records.</p>
 * 
 * <p>Another important note is that if you alter the default mapping for <tt>EventId</tt>, make sure to add
 * that mapping as the <tt>idProperty</tt> of your data reader, otherwise it won't recognize how to
 * access the data correctly and will treat existing records as phantoms. Here's an easy way to make sure
 * your mapping is always valid:</p>
 * <pre><code>
var reader = new Ext.data.JsonReader({
    totalProperty: 'total',
    successProperty: 'success',
    root: 'data',
    messageProperty: 'message',
    
    // read the id property generically, regardless of the mapping:
    idProperty: Extensible.calendar.data.EventMappings.EventId.mapping  || 'id',
    
    // this is also a handy way to configure your reader's fields generically:
    fields: Extensible.calendar.EventRecord.prototype.fields.getRange()
});
</code></pre>
 */
Ext.ns('Extensible.calendar.data');
// @define Extensible.calendar.data.EventMappings
Extensible.calendar.data.EventMappings = {	
    EventId: {
        name:    'id',
        mapping: 'id',
        type:    'String'
    },
    CalendarId: {
        name:    'calendarId',
        mapping: 'calendarId',
        type:    'String'
    },
    Title: {
        name:    'title',
        mapping: 'title',
        type:    'string'
    },
    StartDate: {
        name:       'startDate',
        mapping:    'startDate',
        type:       'date',
        dateFormat: 'Ymd' // c
    },
    EndDate: {
        name:       'endDate',
        mapping:    'endDate',
        type:       'date',
        dateFormat: 'Ymd' // c'c'
    },
    RRule: { // not currently used
        name:    'recurRule', 
        mapping: 'recurRule', 
        type:    'string' 
    },
    Location: {
        name:    'location',
        mapping: 'location',
        type:    'string'
    },
    Notes: {
        name:    'notes',
        mapping: 'notes',
        type:    'string'
    },
    Url: {
        name:    'url',
        mapping: 'url',
        type:    'string'
    },
    IsAllDay: {
        name:    'allDay',
        mapping: 'allDay',
        type:    'boolean'
    },
    Reminder: {
        name:    'reminder',
        mapping: 'reminder',
        type:    'string'
    },
    DOC_NO: {
    	name:    'DOC_NO',
        mapping: 'DOC_NO',
        type:    'string'
    },
    RESULT_DATE: {
    	name:    'RESULT_DATE',
        mapping: 'RESULT_DATE',
        type:    'string'
    },
    TOPTIONSTR: {
    	name:    'TOPTIONSTR',
        mapping: 'TOPTIONSTR',
        type:    'string'
    }
   /* 
    Content: {
        name:    'CONTENT_STR',
        mapping: 'CONTENT_STR',
        type:    'string'
    },
    Summary: {
        name:    'SUMMARY_STR',
        mapping: 'SUMMARY_STR',
        type:    'string'
    },
    
    /////
    
    
    PlanClientCode: {    	
        name:    'PLAN_CLIENT_ID', 		// 고객코드
		mapping: 'PLAN_CLIENT_ID',
        type:    'string'
    },
   PlanClientName: {    	
        name:    'PLAN_CLIENT_NAME', 		// 고객명
		mapping: 'PLAN_CLIENT_NAME',
        type:    'string'
    },
    PlanCustomCode: {    	
        name:    'PLAN_CUSTOM_CODE', 		// 거래처코드
		mapping: 'PLAN_CUSTOM_CODE',
        type:    'string'
    },
    PlanCustomName: {    	
        name:    'PLAN_CUSTOM_NAME', 		// 거래처명
		mapping: 'PLAN_CUSTOM_NAME',
        type:    'string'
    },   
    PlanDvryCustSeq: {    	
        name:    'PLAN_DVRY_CUST_SEQ', 		// 배송처
		mapping: 'PLAN_DVRY_CUST_SEQ',
        type:    'string'
    },
    PlanDvryCustNm: {    	
        name:    'PLAN_DVRY_CUST_NM', 		// 배송처
		mapping: 'PLAN_DVRY_CUST_NM',
        type:    'string'
    },
    PlanDate: {    	
        name:    'PLAN_DATE', 		// 계획일자
		mapping: 'PLAN_DATE',
        type:    'string'
    }, 
    PlanTarget: {    	
        name:    'PLAN_TARGET', 		// 계획
		mapping: 'PLAN_TARGET',
        type:    'string'
    },     
     
    
    ResultClientCd: {
        name:    'RESULT_CLIENT', 		// 고객명
		mapping: 'RESULT_CLIENT',
        type:    'string'
    },        
	ResultClientNm: {
        name:    'RESULT_CLIENT_NAME',			// 고객명
		mapping: 'RESULT_CLIENT_NAME',
        type:    'string'
    },      
	EtcClientNm : {
        name:    'ETC_CLIENT',			// 고객명
		mapping: 'ETC_CLIENT',
        type:    'string'
    },      
	ResultDate: {
        name:    'RESULT_DATE',	  		// 실행일자
		mapping: 'RESULT_DATE',
        type:    'string'
    },     
  ResultTime: {
        name:    'RESULT_TIME',	  		// 실행시간
		mapping: 'RESULT_TIME',
        type:    'string'
    },   
	            
	SaleType: {
        name:    'SALE_TYPE',			// 영업유형
		mapping: 'SALE_TYPE',
        type:    'string'
    },        

	CustomCode: {
        name:    'CUSTOM_CODE', 			// 거래처
		mapping: 'CUSTOM_CODE',
        type:    'string'
    },        
	CustomNm: {
        name:    'CUSTOM_NAME',
		mapping: 'CUSTOM_NAME',
        type:    'string'
    },        
   DvryCustSeq: {
        name:    'DVRY_CUST_SEQ',  // 배송처
		mapping: 'DVRY_CUST_SEQ',
        type:    'string'
    },     
   DvryCustNm: {
        name:    'DVRY_CUST_NM',
		mapping: 'DVRY_CUST_NM',
        type:    'string'
    },    
	ProcessTypeCd: {									//상태
        name:    'PROCESS_TYPE',		
		mapping: 'PROCESS_TYPE',
        type:    'string'
    },            
	ProcessTypeNm: {
        name:    'PROCESS_TYPE_NM', 		// 상태
		mapping: 'PROCESS_TYPE_NM',
        type:    'string'
    },        
	ProjectCode: {
        name:    'PROJECT_NO',			// 영업기회
		mapping: 'PROJECT_NO',
        type:    'string'
    },        
	ProjectNm: {
        name:    'PROJECT_NO_NM',	
		mapping: 'PROJECT_NO_NM',
        type:    'string'
    },        

	CurrentItemNm: {
        name:    'ITEM_NAME', 		// 현사용제품
		mapping: 'ITEM_NAME',
        type:    'string'
    },        
	ImportanceState: {
        name:    'IMPORTANCE_STATUS', 			// 중요도	      
		mapping: 'IMPORTANCE_STATUS',
        type:    'string'
    },                

	SaleEmp: {
        name:    'SALE_EMP', 			// 영업담당자
		mapping: 'SALE_EMP',
        type:    'string'
    },        
	SaleAttend: {
        name:    'SALE_ATTEND',			// 영업참석자
		mapping: 'SALE_ATTEND',
        type:    'string'
    },        
	SummaryStr: {
        name:    'SUMMARY_STR',			//현황요약
		mapping: 'SUMMARY_STR',
        type:    'string'
    },        
	ContentStr: {
        name:    'CONTENT_STR', 			// 내용
		mapping: 'CONTENT_STR',
        type:    'string'
    },        
	ReqStr: {
        name:    'REQ_STR',				//요청사항
		mapping: 'REQ_STR',
        type:    'string'
    },        
	OptionStr: {
        name:    'OPINION_STR', 			//소견/작성자
		mapping: 'OPINION_STR',
        type:    'string'
    },        
	Remark: {
        name:    'REMARK', 				//비고
		mapping: 'REMARK',
        type:    'string'
    },        
	KeyWord: {
        name:    'KEYWORD' ,				//'Keyword'
		mapping: 'KEYWORD',
        type:    'string'
    }       
	    */         
};