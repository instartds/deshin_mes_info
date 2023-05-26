<%@page language="java" contentType="text/html; charset=utf-8"%>

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum100ukrs21Model', {
	    fields: [
	    	{name: 'COMP_CODE'			,text:'법인코드'	,type:'string' },
	    	{name: 'DIV_CODE'			,text:'사업장'		,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'			,text:'부서'		,type:'string' },
	    	{name: 'POST_CODE'			,text:'직위'		,type:'string' ,comboType:'AU' , comboCode:'H005'},
	    	{name: 'NAME'				,text:'성명'		,type:'string' },
	    	{name: 'PERSON_NUMB'		,text:'사번'		,type:'string' ,allowBlank: false},
	    	
	    	{name: 'SCHOOL_NAME'		,text:'학교명'		,type:'string' ,allowBlank: false},
	    	{name: 'ENTR_DATE'			,text:'입학년도'	,type:'uniDate',allowBlank: false},
	    	{name: 'GRAD_DATE'			,text:'졸업년도'	,type:'uniDate'},
	    	{name: 'GRAD_GUBUN'			,text:'졸업구분'	,type:'string' , comboType:'AU' , comboCode:'H010'},
	    	{name: 'ADDRESS'			,text:'소재지'		,type:'string' ,maxLength:40},
	    	{name: 'FIRST_SUBJECT'		,text:'전공과목'	,type:'string' ,maxLength:20},
	    	{name: 'DEGREE'				,text:'학위'		,type:'string' },
	    	{name: 'CREDITS'			,text:'취득학점'	,type:'string' ,maxLength:20},
	    	{name: 'SPECIAL_ITEM'		,text:'특기사항'	,type:'string' ,maxLength:40}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var hum100ukrs21Store = Unilite.createStore('hum100ukrs21Store',{
			model: 'hum100ukrs21Model',
            autoLoad: false,
            uniOpt : {
            	isMaster  : false,		// 상위 버튼 연결
            	editable  : false,		// 수정 모드 사용
            	deletable : false,		// 삭제 가능 여부
	            useNavi   : false		// prev | newxt 버튼 사용
            },
            proxy: {
	           type: 'direct',
	            api: {			
	                read: hum100ukrService.academicBackground              	
	            }
	        }
	});
	
	var academicBackground = {
    	title:'<t:message code="system.label.human.announceInfo" default="학력사항"/>',
		itemId: 'academicBackground',
		layout:{type:'vbox', align:'stretch'},
    	items:[
    		basicInfo,
			{	xtype: 'uniGridPanel',
				itemId:'hum100ukrs21Grid',				
				dockedItems: [{
			        xtype: 'toolbar',
			        dock: 'top',
			        padding:'0px',
			        border:0
			    }],
		        store : hum100ukrs21Store, 
		        padding: '0 10 0 10',
		        uniOpt:{ expandLastColumn : false,
		 				 copiedRow        : true,
		 				 userToolbar      : false
		        },    
		        columns:  [
           		 	{ dataIndex: 'DIV_CODE'				, width: 120},
	        		{ dataIndex: 'DEPT_NAME'			, width: 160},
	        		{ dataIndex: 'POST_CODE'			, width: 88},
	        		{ dataIndex: 'NAME'					, width: 78	},
	        		{ dataIndex: 'PERSON_NUMB'			, width: 78},
	        		{ dataIndex: 'SCHOOL_NAME'			, width: 180},
	        		{ dataIndex: 'ENTR_DATE'			, width: 100},
	        		{ dataIndex: 'GRAD_DATE'			, width: 100},
	        		{ dataIndex: 'GRAD_GUBUN'			, width: 70},
	        		{ dataIndex: 'ADDRESS'				, width: 120},
	        		{ dataIndex: 'FIRST_SUBJECT'		, width: 100},
	        		{ dataIndex: 'DEGREE'				, width: 100},
	        		{ dataIndex: 'CREDITS'				, width: 80},
	        		{ dataIndex: 'SPECIAL_ITEM'			, width: 120}
			  	]
			}
		],
		loadData:function(personNum)	{
			this.down('#hum100ukrs21Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
		}
    }