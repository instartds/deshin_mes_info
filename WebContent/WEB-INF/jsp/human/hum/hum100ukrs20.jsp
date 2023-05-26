<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum100ukrs20Model', {
	    fields: [
			{name: 'ANNOUNCE_DATE'	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>'	, type: 'uniDate'},
			{name: 'ANNOUNCE_CODE'	, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>'	, type: 'string' , comboType: 'AU' ,comboCode: 'H094'},
			{name: 'AF_DIV_NAME'	, text: '<t:message code="system.label.human.afdivname" default="발령후 사업장"/>'	, type: 'string'},
			{name: 'AF_DEPT_NAME'	, text: '<t:message code="system.label.human.afdeptname" default="발령후 부서명"/>'	, type: 'string'},
			{name: 'POST_CODE2'     , text: '<t:message code="system.label.human.postcode" default="직위"/>'      	, type: 'string' , comboType: 'AU' , comboCode: 'H005' },
			{name: 'ABIL_CODE'      , text: '<t:message code="system.label.human.abil" default="직책"/>'      		, type: 'string' , comboType: 'AU' , comboCode: 'H006'},
			{name: 'ANNOUNCE_REASON', text: '<t:message code="system.label.human.announcereason" default="발령사유"/>'	, type: 'string'},    
			{name: 'AFFIL_CODE'		, text: '<t:message code="system.label.human.serial" default="직렬"/>'            , type: 'string', comboType: 'AU' , comboCode: 'H173'},
			{name: 'KNOC'			, text: '<t:message code="system.label.human.ocpt" default="직종"/>'              , type: 'string', comboType: 'AU' , comboCode: 'H072'},
			{name: 'PAY_GRADE_01'	, text: '<t:message code="system.label.human.paygrade01" default="호봉(급)"/>'     , type: 'string'},
			{name: 'PAY_GRADE_02'	, text: '<t:message code="system.label.human.paygrade02" default="호봉(호)"/>'     , type: 'string'}
	    ]
	});


	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var hum100ukr20MasterStore = Unilite.createStore('hum100ukr20MasterStore',{
		model: 'hum100ukrs20Model',
        autoLoad: false,
        uniOpt: {
            isMaster: false,	// 상위 버튼 연결 
            editable: false,	// 수정 모드 사용 
            deletable:false,	// 삭제 가능 여부 
	        useNavi : false		// prev | newxt 버튼 사용
        },
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum100ukrService.announceInfo'                	
            }
        }
	});
	
	var announceInfo = {
    	title:'<t:message code="system.label.human.announceInfo" default="발령사항"/>',
		itemId: 'announceInfo',
		layout:{type:'vbox', align:'stretch'},
    	items:[
    		basicInfo,
			{	xtype: 'uniGridPanel',
				itemId:'hum100ukrs20Grid',				
				dockedItems: [{
			        xtype: 'toolbar',
			        dock: 'top',
			        padding:'0px',
			        border:0
			    }],
		        store : hum100ukr20MasterStore, 
		        padding: '0 10 0 10',
	        	uniOpt:{expandLastColumn   : false,
	        			useRowNumberer     : false,
	                    useMultipleSorting : false,
	                    onLoadSelectFirst  : false,
	                    userToolbar        : false,
	                    state: {
	            			useState       : false,
	            			useStateList   : false
	                    }
		        },
		        columns:  [
           		 	{dataIndex: 'ANNOUNCE_DATE'		, width: 80	 , text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
		            {dataIndex: 'ANNOUNCE_CODE'		, width: 80	 , text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' },
		            {dataIndex: 'AF_DIV_NAME'		, width: 80  , text: '<t:message code="system.label.human.division" default="사업장"/>'},
		            {dataIndex: 'AF_DEPT_NAME'		, width: 80  , text: '<t:message code="system.label.human.department" default="부서"/>'},
		            {dataIndex: 'POST_CODE2'		, width: 80  , text: '<t:message code="system.label.human.postcode" default="직위"/>'},
		            {dataIndex: 'ABIL_CODE'			, width: 80  , text: '<t:message code="system.label.human.abil" default="직책"/>'},
		            {dataIndex: 'AFFIL_CODE'		, width: 80  , text: '<t:message code="system.label.human.serial" default="직렬"/>'},
		            {dataIndex: 'KNOC'				, width: 80  , text: '<t:message code="system.label.human.ocpt" default="직종"/>'},
		            {dataIndex: 'PAY_GRADE_01'		, width: 80  , text: '급호'},
		            {dataIndex: 'PAY_GRADE_02'		, width: 80  , text: '급호'},
		            {dataIndex: 'ANNOUNCE_REASON'	, width: 300 , text: '<t:message code="system.label.human.announcereason" default="발령사유"/>'}
			  	]
			}
		],
		loadData:function(personNum)	{
			this.down('#hum100ukrs20Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
		}
    }
