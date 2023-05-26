<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc130skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var fnSetFormTitle = ${fnSetFormTitle};

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}',
	gsAssets : '${gsAssets}',//자산 //1999
	gsDebt   : '${gsDebt}'	//부채  // 5000
};

var referCommentWindow;		/* 주석 */

function appMain() {
	
	var len = fnSetFormTitle.length; 
	var tabTitle1 ='대차대조표';
	var tabTitle2 ='손익계산서';
	var tabTitle3 ='제조원가명세서';
	var tabTitle4 ='용역원가명세서';
	var tabTitle5 ='용역원가명세서2';
	var tabTitle6 ='이익잉여금처분계산서';
	var tabTitle7 ='자본변동표';
	var tabTitle8 ='결손금처분계산서';
	
	var hideTab1 = true;
	var hideTab2 = true;
	var hideTab3 = true;
	var hideTab4 = true;
	var hideTab5 = true;
	var hideTab6 = true;
	var hideTab7 = true;
	var hideTab8 = true;
	
	for(var i = 0; i < len; i++) {
		if(fnSetFormTitle[i].SUB_CODE == '10'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab2 = false;
			}
			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '30'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab3 = false;
			}
			tabTitle3 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '31'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab4 = false;
			}
			tabTitle4 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '32'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab5 = false;
			}
			tabTitle5 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '40'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab6 = false;
			}
			tabTitle6 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '35'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab7 = false;
			}
			tabTitle7 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '45'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab8 = false;
			}
			tabTitle8 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	/* 
	 * 대차대조표 				agc130skrs1
	 * 손익계산서				agc130skrs1
	 * 제조원가명세서			agc130skrs1
	 * 용역원가명세서			agc130skrs1
	 * 용역원가명세서2			agc130skrs1
	 * 이익잉여금처분계산서		agc130skrs2
	 * 자본변동표				agc130skrs3
	 * */
	var getStDt = ${getStDt};
	
	var fnGetSession = ${fnGetSession};
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc130skrModel', {
		fields: [
			{name: 'ACCNT_CD'		, text: '계정코드'			,type: 'string'},
			{name: 'ACCNT_NAME'		, text: '과목'			,type: 'string'},
			{name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
			{name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
			{name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
			{name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
			
			{name: 'GBN'			, text: 'GBN' 			,type: 'string'},
			{name: 'SEQ'			, text: '순번'			,type: 'string'},
			{name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
			{name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
			{name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'},
			{name: 'OPT_DIVI'		, text: 'OPT_DIVI'		,type: 'string'}
		]
	});
	
	Unilite.defineModel('Agc130skrModel2', {
	    fields: [  	  
	    	{name: 'ACCNT_CD'		, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '과목'			,type: 'string'},
		    {name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'},
		    {name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
		    {name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'		,type: 'string'}  	
		]          
	});
	
	Unilite.defineModel('Agc130skrModel3', {
	    fields: [  	  
	    	{name: 'ACCNT_CD'		, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '과목'			,type: 'string'},
		    {name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'},
		    {name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
		    {name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'		,type: 'string'}  	
		]          
	});
	
	Unilite.defineModel('Agc130skrModel4', {
	    fields: [  	  
	    	{name: 'ACCNT_CD'		, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '과목'			,type: 'string'},
		    {name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'},
		    {name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
		    {name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'		,type: 'string'} 	
		]          
	});
	
	Unilite.defineModel('Agc130skrModel5', {
	    fields: [  	  
	    	{name: 'ACCNT_CD'		, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '과목'			,type: 'string'},
		    {name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'},
		    {name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
		    {name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'		,type: 'string'}  	
		]          
	});
	
	Unilite.defineModel('Agc130skrModel6', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'		, text: '과목' 			,type: 'string'},
		    {name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'},
		    {name: 'ACCNT_CD'		, text: '계정코드'			,type: 'string'},
		    {name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
		    {name: 'DEAL_DATE1'		, text: 'DEAL_DATE1'	,type: 'string'},
		    {name: 'DEAL_DATE2'		, text: 'DEAL_DATE2'	,type: 'string'},  	
		    {name: 'TITLE'			, text: 'TITLE'			,type: 'string'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'}  	
		]          
	});
	
	Unilite.defineModel('Agc130skrModel7', {
	    fields: [  	  
	    	{name: 'GUBUN'			, text: '구분코드' 		,type: 'string'},
		    {name: 'GUBUN_NAME'		, text: '회기구분'			,type: 'string'},
	    	{name: 'ACCNT_CD'		, text: '항목코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '구분'			,type: 'string'},
		    {name: 'AMT_I1'			, text: '자본금' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '자본잉여금'		,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '자본조정'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '기타포괄손익누계액'	,type: 'uniPrice'},
		    {name: 'AMT_I5'			, text: '이익잉여금'		,type: 'uniPrice'},
		    {name: 'AMT_I6'			, text: '총계'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'}
		]          
	});
	
	Unilite.defineModel('Agc130skrModel8', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'		, text: '과목' 			,type: 'string'},
		    {name: 'AMT_I1'			, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I2'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I3'			, text: '금액'			,type: 'uniPrice'},
		    {name: 'AMT_I4'			, text: '금액'			,type: 'uniPrice'},
		    
		    {name: 'GBN'			, text: 'GBN' 			,type: 'string'},
		    {name: 'SEQ'			, text: '순번'			,type: 'string'},
		    {name: 'ACCNT_CD'		, text: '계정코드'			,type: 'string'},
		    {name: 'BLANK_FIELD'	, text: 'BLANK_FIELD'	,type: 'string'},
		    {name: 'DEAL_DATE1'		, text: 'DEAL_DATE1'	,type: 'string'},
		    {name: 'DEAL_DATE2'		, text: 'DEAL_DATE2'	,type: 'string'},  	
		    {name: 'TITLE'			, text: 'TITLE'			,type: 'string'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'		,type: 'string'}  	
		]          
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc130skrMasterStore1',{
		model: 'Agc130skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {		
				var dDrAmt   = '';
				var dCrAmt     = '';
				var dBalance = '';
				if(successful){
					Ext.each(records, function(record, rowIndex){
						if(record.get('ACCNT_CD') == BsaCodeInfo.gsAssets){
							dDrAmt = record.get('AMT_I2');
						}
						else if(record.get('ACCNT_CD') == BsaCodeInfo.gsDebt){
							dCrAmt = record.get('AMT_I2');
						}
					});	
					dBalance = dDrAmt - dCrAmt;			
					if(dBalance != 0){
						var fainalValue = Ext.util.Format.number(dBalance,'0,000' );
						var innerText = " ※ " + Msg.sMAW516 + " (" + fainalValue + ") ";
						
						panelResult.setValue('INNER_TEXT' , innerText);
						panelResult.down('#innerText').show();
					}else{
						panelResult.setValue('INNER_TEXT' , '');
						panelResult.down('#innerText').hide();
					}
				}
			}			
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agc130skrMasterStore2',{
		model: 'Agc130skrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('agc130skrMasterStore3',{
		model: 'Agc130skrModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList3'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore4 = Unilite.createStore('agc130skrMasterStore4',{
		model: 'Agc130skrModel4',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList4'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore5 = Unilite.createStore('agc130skrMasterStore5',{
		model: 'Agc130skrModel5',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList5'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore6 = Unilite.createStore('agc130skrMasterStore6',{
		model: 'Agc130skrModel6',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList6'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore7 = Unilite.createStore('agc130skrMasterStore7',{
		model: 'Agc130skrModel7',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList7'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore8 = Unilite.createStore('agc130skrMasterStore8',{
		model: 'Agc130skrModel8',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc130skrService.selectList8'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
	        	fieldLabel: '당기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'THIS_DATE_FR',
				endFieldName: 'THIS_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('THIS_DATE_FR',newValue);	
						UniAppManager.app.fnSetStDate(newValue, 'THIS_START_DATE', getStDt[0].STDT);
						UniAppManager.app.fnCalPrevDate(newValue, panelSearch.getValue('PREV_DATE_FR'), 'PREV_START_DATE' , "PREV_DATE_FR");
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('THIS_DATE_TO',newValue);
			    		//UniAppManager.app.fnSetStDate(newValue, 'THIS_START_DATE', getStDt[0].STDT);
			    		UniAppManager.app.fnCalPrevDate(newValue, panelSearch.getValue('PREV_DATE_FR'), '' , "PREV_DATE_TO");
			    	}   	
			    }
			},{ 
	        	fieldLabel: '전기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'PREV_DATE_FR',
				endFieldName: 'PREV_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PREV_DATE_FR',newValue);
						UniAppManager.app.fnSetStDate(newValue, 'PREV_START_DATE', getStDt[0].STDT);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PREV_DATE_TO',newValue);
			    		//UniAppManager.app.fnSetStDate(newValue, 'PREV_START_DATE', getStDt[0].STDT);
			    	}   	
			    }
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}
        ]},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
    		defaultType: 'uniTextfield',
    		layout : {type : 'uniTable', columns : 1},
    		defaultType: 'uniTextfield',
    		items:[{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'THIS_START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '전기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'PREV_START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '금액단위',
		 		name:'AMT_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B042',
		 		allowBlank:false
	 		},{
		 		fieldLabel: '재무제표양식차수',
		 		name:'GUBUN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A093',
		 		value: BsaCodeInfo.gsFinancialY,
		 		allowBlank:false
	 		},{
				xtype: 'radiogroup',	
				id: 'rdo1',
				fieldLabel: '과목출력',
				items: [{
					boxLabel: '한다', 
					width: 70, 
					name: 'PRINT',
					inputValue: '1'
				},{
					boxLabel : '안한다', 
					width: 70,
					name: 'PRINT',
					inputValue: '2',
					checked: true 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(newValue){
							setTimeout(function(){UniAppManager.app.onQueryButtonDown()}, 500);
						}
					}
				}
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목명',	
				id: 'rdo2',
				items: [{
					boxLabel: '과목명1', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '0'
				},{
					boxLabel : '과목명2', 
					width: 70,
					name: 'ACCOUNT_NAME',
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '2' 
				}]
			}]				
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
	        	fieldLabel: '당기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'THIS_DATE_FR',
				endFieldName: 'THIS_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('THIS_DATE_FR',newValue);
						UniAppManager.app.fnSetStDate(newValue, 'THIS_START_DATE', getStDt[0].STDT);
						UniAppManager.app.fnCalPrevDate(newValue, panelSearch.getValue('PREV_DATE_FR'), 'PREV_START_DATE' , "PREV_DATE_FR");
						
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('THIS_DATE_TO',newValue);
			    		//UniAppManager.app.fnSetStDate(newValue, 'THIS_START_DATE', getStDt[0].STDT);
			    		UniAppManager.app.fnCalPrevDate(newValue, panelSearch.getValue('PREV_DATE_FR'), '' , "PREV_DATE_TO");
			    	}   	
			    }
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
	        	fieldLabel: '전기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'PREV_DATE_FR',
				endFieldName: 'PREV_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('PREV_DATE_FR',newValue);
						UniAppManager.app.fnSetStDate(newValue, 'PREV_START_DATE', getStDt[0].STDT);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {		
			    		panelSearch.setValue('PREV_DATE_TO',newValue);
			    		//UniAppManager.app.fnSetStDate(newValue, 'PREV_START_DATE', getStDt[0].STDT);
			    	}   	
			    }
			},{
	    		xtype:'container',
	    		colspan:1,
	    		layout: {type:'vbox', align:'stretch'},
	  			width: 500,
	    		items:[{ 
					fieldLabel: ' ',
					name: 'INNER_TEXT', 
					itemId:'innerText',
					xtype: 'uniTextfield',
					readOnly: true,
					width: 500,
					fieldCls: 'x-change-celltext_red'
				}]	
			}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('agc130skrGrid1', {
    	title  : tabTitle1,
    	hidden : hideTab1,
    	excelTitle: '재무제표' + '   (' + tabTitle1 + ')',
    	layout : 'fit',
        store  : directMasterStore, 
		uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
				
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		if(masterGrid1.getSelectedRecords().length == 0){
		    			return false;
	        		}
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '10'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
	        		
	        	}
        	}
        ],
        columns: [
        	{dataIndex: 'ACCNT'			, width: 66},
        	{dataIndex: 'ACCNT_CD'		, width: 66, hidden: true},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME1',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME2',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid1.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }
	     /*gotoAgc130skr:function(grid, record, cellIndex, colName)	{  // 로직 수정필요
			if(record)	{	
				switch(colName)	{
					case 'ACCNT_CD':
					case 'ACCNT_NAME':
					case 'AMT_I1':
					case 'AMT_I2':
						var params = {
				    		action:'select',
					    	'PGM_ID' 			: 'agc130skr',   	
					    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
					    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
					    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
					    	'ACCNT'				: record.data['ACCNT_CD'],
					    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
					    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
					    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
					    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
			    		}
			    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/agb110skr.do', params);	
						break;
					
					case 'AMT_I3':
					case 'AMT_I4':
			    	var params = {
			    		action:'select',
				    	'PGM_ID' 			: 'agc130skr',
				    	'ST_DATE'		: panelSearch.getValue('PREV_START_DATE'),
				    	'FR_DATE'	    : panelSearch.getValue('PREV_DATE_FR'),
				    	'TO_DATE'		: panelSearch.getValue('PREV_DATE_TO'),
				    	'ACCNT'				: record.data['ACCNT_CD'],
				    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
				    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
				    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
				    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	
			    	}
			    	var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agb110skr.do', params);	
					break;
				}
			}
    	}*/
    });
    
      var masterGrid2 = Unilite.createGrid('agc130skrGrid2', {
    	title  : tabTitle2,
    	hidden : hideTab2,
    	excelTitle: '재무제표' + '   (' + tabTitle2 + ')',
    	layout : 'fit',
        store : directMasterStore2, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid2.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '20'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            }
        ],
        columns: [        
        	{dataIndex: 'ACCNT'			, width: 66},
        	{dataIndex: 'ACCNT_CD'		, width: 66, hidden: true},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME3',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME4',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid2.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }              	        
    });
    
      var masterGrid3 = Unilite.createGrid('agc130skrGrid3', {
    	title  : tabTitle3,
    	hidden : hideTab3,
    	excelTitle: '재무제표' + '   (' + tabTitle3 + ')',
    	layout : 'fit',
        store : directMasterStore3, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid3.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '30'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            }
        ],
        columns: [        
        	{dataIndex: 'ACCNT'			, width: 66},
        	{dataIndex: 'ACCNT_CD'		, width: 66, hidden: true},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME5',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME6',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid3.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }              	        
    });
    
      var masterGrid4 = Unilite.createGrid('agc130skrGrid4', {
    	title  : tabTitle4,
    	hidden : hideTab4,
    	excelTitle: '재무제표' + '   (' + tabTitle4 + ')',
    	layout : 'fit',
        store : directMasterStore4, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid4.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '31'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            }
        ],
        columns: [        
        	{dataIndex: 'ACCNT'			, width: 66},
        	{dataIndex: 'ACCNT_CD'		, width: 66, hidden: true},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME7',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME8',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid4.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }              	        
    });
    
      var masterGrid5 = Unilite.createGrid('agc130skrGrid5', {
    	title  : tabTitle5,
    	hidden : hideTab5,
    	excelTitle: '재무제표' + '   (' + tabTitle5 + ')',
    	layout : 'fit',
        store : directMasterStore5, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid5.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '32'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            }
        ],
        columns: [        
        	{dataIndex: 'ACCNT'			, width: 66},
        	{dataIndex: 'ACCNT_CD'		, width: 66, hidden: true},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME9',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME10',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid5.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }              	        
    });
    
      var masterGrid6 = Unilite.createGrid('agc130skrGrid6', {
    	title  : tabTitle6,
    	hidden : hideTab6,
    	excelTitle: '재무제표' + '   (' + tabTitle6 + ')',
    	layout : 'fit',
        store : directMasterStore6, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid6.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '40'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            },{
	        	xtype:'button',
	        	text:'이익잉여금처분',
	        	handler:function()	{
			  		var rec1 = {data : {prgID : 'agc120ukr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agc120ukr.do', null);
	        	}
        	}
        ],
        columns: [        	
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME11',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME12',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid6.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT_CD'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }              	        
    });
    
      var masterGrid7 = Unilite.createGrid('agc130skrGrid7', {
    	title  : tabTitle7,
    	hidden : hideTab7,
    	excelTitle: '재무제표' + '   (' + tabTitle7 + ')',
    	layout : 'fit',
        store : directMasterStore7, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('SEQ') == '90') {
	          		cls = 'x-change-cell_light';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid7.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '35'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            }
        ],
        columns: [        
        	{dataIndex: 'GUBUN'			, width: 66, hidden: true},
        	{dataIndex: 'GUBUN_NAME'	, width: 66},
        	{dataIndex: 'ACCNT_CD'		, width: 66},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{dataIndex: 'AMT_I1'		, width: 150},
			{dataIndex: 'AMT_I2'		, width: 150},
			{dataIndex: 'AMT_I3'		, width: 150},
			{dataIndex: 'AMT_I4'		, width: 150},
			{dataIndex: 'AMT_I5'		, width: 150},
			{dataIndex: 'AMT_I6'		, width: 150}
			

		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid7.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc130skr:function(record)	{
	    	if(record)	{	
	    		var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agc130skr',   	
			    	'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
			    	'FR_DATE'	    	: panelSearch.getValue('THIS_DATE_FR'),
			    	'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
			    	'ACCNT'				: record.data['ACCNT_CD'],
			    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
			    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
			    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
			    	'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
	    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }              	        
    });
    
    var masterGrid8 = Unilite.createGrid('agc130skrGrid8', {
    	title  : tabTitle8,
    	hidden : hideTab8,
    	excelTitle: '재무제표' + '   (' + tabTitle8 + ')',
    	layout : 'fit',
        store : directMasterStore8,
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				if(record.get('DIS_DIVI') == '2' && record.get('ACCNT') != record.get('ACCNT_CD')) {
					cls = 'x-change-celltext_darkred';
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'주석',
	        	handler:function()	{
	        		if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					else{
						openCommentWindow();
					}
	        	}
        	},
        	{
                xtype:'button',
                text:'출력',
                handler:function()  {
                    if(masterGrid8.getSelectedRecords().length == 0){
                        return false;
                    }
                    var params = {
                          action: 'new',
                          IS_LINK: true,
                          THIS_DATE_FR: panelSearch.getValue('THIS_DATE_FR'),
                          THIS_DATE_TO: panelSearch.getValue('THIS_DATE_TO'),
                          PREV_DATE_FR: panelSearch.getValue('PREV_DATE_FR'),
                          PREV_DATE_TO: panelSearch.getValue('PREV_DATE_TO'),
                          DIV_CODE: panelSearch.getValue('DIV_CODE'),
                          THIS_START_DATE: panelSearch.getValue('THIS_START_DATE'),
                          PREV_START_DATE: panelSearch.getValue('PREV_START_DATE'),
                          AMT_UNIT: panelSearch.getValue('AMT_UNIT'),
                          ACCOUNT_NAME: Ext.getCmp('rdo2').getChecked()[0].inputValue,
                          PRINT: Ext.getCmp('rdo1').getChecked()[0].inputValue,
                          GUBUN: panelSearch.getValue('GUBUN'),
                          TYPE: '45'
                    }
                    var rec = {data : {prgID : 'agc130rkr', 'text':''}};
                    parent.openTab(rec, '/accnt/agc130rkr.do', params, CHOST+CPATH); 
                    
                }
            },{
	        	xtype:'button',
	        	text:'결손금처분',
	        	handler:function()	{
			  		var rec1 = {data : {prgID : 'agc120ukr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agc120ukr.do', null);
	        	}
        	}
        ],
        columns: [        	
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{itemId:'CHANGE_NAME11',
					columns:[{ dataIndex: 'AMT_I1'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I2'		, width: 176,	summaryType: 'sum'}
					]	
			},
			{itemId:'CHANGE_NAME12',
					columns:[{ dataIndex: 'AMT_I3'		, width: 176,	summaryType: 'sum'},
							 { dataIndex: 'AMT_I4'		, width: 176,	summaryType: 'sum'}
					]	
			}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
				if(column, ['ACCNT_CD','ACCNT_NAME','AMT_I1','AMT_I2','AMT_I3','AMT_I4']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
	          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
					masterGrid1.gotoAgc130skr(record);
	        	}
            }
        },  
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
          	if(record.get('ACCNT') != record.get('ACCNT_CD')){
        		return true;
        	}else{	
      			return false;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid8.gotoAgc130skr(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAgc130skr:function(record) {
			if(record) {
				var params = {
					action:'select',
					'PGM_ID' 			: 'agc130skr',
					'ST_DATE'			: panelSearch.getValue('THIS_START_DATE'),
					'FR_DATE'			: panelSearch.getValue('THIS_DATE_FR'),
					'TO_DATE'			: panelSearch.getValue('THIS_DATE_TO'),
					'ACCNT'				: record.data['ACCNT_CD'],
					'ACCNT_NAME'		: record.data['ACCNT_NAME'],
					'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
					'DIV_NAME'			: panelSearch.getValue('DIV_NAME'),
					'INNER_TEXT'		: panelSearch.getValue('INNER_TEXT')
				}
				var rec1 = {data : {prgID : 'agb110skr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb110skr.do', params);
			}
		}
	});
	
	var commentSearch = Unilite.createSearchForm('CommentSearch', { //주석
		layout: {type : 'uniTable', columns : 1},
		items :[{
				fieldLabel: '전표일',
				width: 315,
				xtype: 'uniMonthRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false
			},{
				fieldLabel: '대차대조표 주석', 
				name: 'REMARK1',
				xtype:'textarea',
				width:350,
				height:100
			},{
				fieldLabel: '손익계산서 주석', 
				name: 'REMARK2',
				xtype:'textarea',
				width:350,
				height:100
			}],
			api: {
				load : 'agc130skrService.selectForm',
            	submit: 'agc130skrService.syncForm'	
            },
			setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
    });
    
    
    function openCommentWindow() {    		// 주석
		if(!referCommentWindow) {
			referCommentWindow = Ext.create('widget.uniDetailWindow', {
                title: '주석',
                width: 380,			                
                height: 308,
                resizable:false,
                layout: {type:'vbox', align:'stretch'},
                items: [commentSearch],
                tbar: [
                	'->',
					{	
						itemId : 'openBtn',
						text: '확인',
						handler: function() {
							UniAppManager.app.onSaveButtonDown();
						},
						disabled: false	
					},{	
						itemId : 'colseBtn',
						text: '닫기',
						handler: function() {
							referCommentWindow.hide();
						},
						disabled: false
					}
				],
                listeners: {
					beforehide: function(me, eOpt)	{

	    			},
	    			beforeclose: function( panel, eOpts )	{

	    			},
	    			beforeshow: function ( me, eOpts )	{			
	    				commentSearch.setValue('FR_DATE' , panelSearch.getValue('THIS_DATE_FR'));
	    				commentSearch.setValue('TO_DATE' , panelSearch.getValue('THIS_DATE_TO'));
	    				
	    				commentSearch.getField('FR_DATE').setReadOnly(true);
	    				commentSearch.getField('TO_DATE').setReadOnly(true);	
	    				
	    				UniAppManager.app.onQueryButtonDown();
	    			}
                }
			})
		}
		referCommentWindow.center();
		referCommentWindow.show();
	}
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid1,
	         masterGrid2,
	         masterGrid3,
	         masterGrid4,
	         masterGrid5,
	         masterGrid6,
	         masterGrid7,
	         masterGrid8
	    ],
	    listeners:{
    		beforetabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				panelResult.down('#innerText').hide();
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			panelResult.down('#innerText').hide();
    			
    			if(newCard.getItemId() == 'agc130skrGrid1')	{
    				//masterGrid1.down('#CHANGE_NAME1').setText('제 ' + Session + ' 당(기)');
					//masterGrid1.down('#CHANGE_NAME2').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid2') {
    				//masterGrid2.down('#CHANGE_NAME3').setText('제 ' + Session + ' 당(기)');
					//masterGrid2.down('#CHANGE_NAME4').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid3') {
    				//down('#CHANGE_NAME5').setText('제 ' + Session + ' 당(기)');
					//masterGrid3.down('#CHANGE_NAME6').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid4') {
    				//masterGrid4.down('#CHANGE_NAME7').setText('제 ' + Session + ' 당(기)');
					//masterGrid4.down('#CHANGE_NAME8').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid5') {
    				//masterGrid5.down('#CHANGE_NAME9').setText('제 ' + Session + ' 당(기)');
					//masterGrid5.down('#CHANGE_NAME10').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid6') {
    				//masterGrid6.down('#CHANGE_NAME11').setText('제 ' + Session + ' 당(기)');
					//masterGrid6.down('#CHANGE_NAME12').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid7') {
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc130skrGrid8') {
    				//masterGrid6.down('#CHANGE_NAME11').setText('제 ' + Session + ' 당(기)');
					//masterGrid6.down('#CHANGE_NAME12').setText('제 ' + beforeSession + ' 전(기)');
    				UniAppManager.app.onQueryButtonDown();
    			}
    		}
    	}
    });
    
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		],
		id : 'agc130skrApp',
		fnInitBinding : function(params) {
			panelResult.down('#innerText').hide(); // 재무상태표  자산 - 부채 Field hide
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('THIS_DATE_FR');	// 당기전표일 기본 Focus
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('AMT_UNIT'  ,Ext.data.StoreManager.lookup( 'CBS_AU_B042' ).getAt(0).get ('value'));
			
			var gsThisStDate = getStDt[0].STDT;
			var gsPrevStDate = UniDate.getDbDateStr(gsThisStDate).substring(0, 4)-1 + UniDate.getDbDateStr(gsThisStDate).substring(4, 8);
			var thisDate = UniDate.get('today');
			var PrevDate = UniDate.getDbDateStr(thisDate).substring(0, 4)-1 + UniDate.getDbDateStr(thisDate).substring(4, 8);
			
			panelSearch.setValue('THIS_DATE_FR', gsThisStDate);    // 당기시작일 FR
			panelSearch.setValue('THIS_DATE_TO', thisDate);		   // 당기시작일 TO
			panelSearch.setValue('PREV_DATE_FR', gsPrevStDate);    // 전기시작일 FR
			panelSearch.setValue('PREV_DATE_TO', PrevDate);        // 전기시작일 TO
			panelSearch.setValue('THIS_START_DATE', gsThisStDate); // 당기시작년월
			panelSearch.setValue('PREV_START_DATE', gsPrevStDate); // 전기시작년월
			
			panelResult.setValue('THIS_DATE_FR', gsThisStDate);    // 당기시작일 FR
			panelResult.setValue('THIS_DATE_TO', thisDate);		   // 당기시작일 TO
			panelResult.setValue('PREV_DATE_FR', gsPrevStDate);    // 전기시작일 FR
			panelResult.setValue('PREV_DATE_TO', PrevDate);        // 전기시작일 TO
			panelResult.setValue('THIS_START_DATE', gsThisStDate); // 당기시작년월
			panelResult.setValue('PREV_START_DATE', gsPrevStDate); // 전기시작년월
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			
			//UniAppManager.app.fnCalSession("THIS_START_DATE");
			//UniAppManager.app.fnCalSession("PREV_START_DATE");
			
			masterGrid1.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
			masterGrid1.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');

			//20210521 추가: 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 's_ssa700skrv_wm') {
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown : function()	{
			
			if(!this.isValidSearchForm()){
				return false;
			}
			
			if(!this.fnCheckData()) {
				return false;
			}
			
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'agc130skrGrid1'){	
				masterGrid1.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid1.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore.loadStoreRecords();
			}
			else if(activeTabId == 'agc130skrGrid2'){
				masterGrid2.down('#CHANGE_NAME3').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid2.down('#CHANGE_NAME4').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore2.loadStoreRecords();				
			}
			else if(activeTabId == 'agc130skrGrid3'){
				masterGrid3.down('#CHANGE_NAME5').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid3.down('#CHANGE_NAME6').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore3.loadStoreRecords();	
			}
			else if(activeTabId == 'agc130skrGrid4'){
				masterGrid4.down('#CHANGE_NAME7').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid4.down('#CHANGE_NAME8').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore4.loadStoreRecords();
			}
			else if(activeTabId == 'agc130skrGrid5'){
				masterGrid5.down('#CHANGE_NAME9').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid5.down('#CHANGE_NAME10').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore5.loadStoreRecords();
			}
			else if(activeTabId == 'agc130skrGrid6'){
				masterGrid6.down('#CHANGE_NAME11').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid6.down('#CHANGE_NAME12').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore6.loadStoreRecords();
			}
			else if(activeTabId == 'agc130skrGrid7'){						
				directMasterStore7.loadStoreRecords();
			}
			else if(activeTabId == 'agc130skrGrid8'){
				masterGrid8.down('#CHANGE_NAME11').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid8.down('#CHANGE_NAME12').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				directMasterStore8.loadStoreRecords();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnCheckData:function(newValue){
			var prevDateFr = panelSearch.getField('PREV_DATE_FR').getSubmitValue();  // 전기전표일 FR
			var prevDateTo = panelSearch.getField('PREV_DATE_TO').getSubmitValue();  // 전기전표일 TO
			
			var thisDateFr = panelSearch.getField('THIS_DATE_FR').getSubmitValue();  // 당기전표일 FR
			var thisDataTo = panelSearch.getField('THIS_DATE_TO').getSubmitValue();  // 당기전표일 TO
			
			
			var thisStartDate = panelSearch.getField('THIS_START_DATE').getSubmitValue();  // 당기시작년월
			var prevStartDate = panelSearch.getField('PREV_START_DATE').getSubmitValue();  // 전기시작년월

			var r= true
			
			if(thisDateFr > thisDataTo) {
				alert('당기전표일: 시작일이 종료일보다 클수는 없습니다.');
				//당기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW036"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('THIS_DATE_FR',thisDateFr);
				panelResult.setValue('THIS_DATE_FR',thisDateFr);						
				panelSearch.getField('THIS_DATE_FR').focus();
				r = false;
				return false;
			}

			if(prevDateFr > prevDateTo) {
				alert('전기전표일: 시작일이 종료일보다 클수는 없습니다.');
				//전기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW037"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('PREV_DATE_FR',prevDateFr);
				panelResult.setValue('PREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PREV_DATE_FR').focus();
				r = false;
				return false;
			}
			
			if(thisDateFr < prevDateTo) {
				alert('전기전표일이 당기전표일보다 클 수 없습니다.');
				//전기전표일이 당기전표일보다 클 수 없습니다.
				//alert('<t:message code="unilite.msg.sMA0324"/>');
				panelSearch.setValue('PREV_DATE_FR',prevDateFr);
				panelResult.setValue('PREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PREV_DATE_FR').focus();
				r = false;
				return false;
			}
			return r;
		},

		fnSetStDate: function(dateObj, targetObj, sStDt){
			if(dateObj == null){
				return false;
			}
			var sTempDate = ''; var sStDate   = '';	
			var fn = false;
			
			sTempDate = UniDate.getDbDateStr(dateObj).substring(0, 6);
			sStDate   = UniDate.getDbDateStr(sTempDate).substring(0, 4) + UniDate.getDbDateStr(sStDt).substring(4, 6);
			
			if(sTempDate < sStDate){
				sStDate = (UniDate.getDbDateStr(sStDate).substring(0, 4) - 1) + (UniDate.getDbDateStr(sStDate).substring(4, 6));
			}
			
			if(targetObj == 'THIS_START_DATE'){
				panelSearch.setValue('THIS_START_DATE', sStDate);
				fn = true;
			}
			if(targetObj == 'PREV_START_DATE'){
				panelSearch.setValue('PREV_START_DATE', sStDate);
				fn = true;
			}
			if(targetObj == ''){
				fn = true;
			}
			return fn;
		},
		
		// 당기전표일 변경시 전기전표일 자동계산
		fnCalPrevDate: function(sDate, oPrevDate, oPrevStDate, chageValue){
			if(sDate == null){
				return false;
			}
			else{
				oPrevDate = (UniDate.getDbDateStr(sDate).substring(0, 4) - 1) + (UniDate.getDbDateStr(sDate).substring(4, 8));
				if(chageValue == 'PREV_DATE_FR' ){
					panelSearch.setValue('PREV_DATE_FR', oPrevDate);
					panelResult.setValue('PREV_DATE_FR', oPrevDate);
				}
				if(chageValue == 'PREV_DATE_TO' ){
					panelSearch.setValue('PREV_DATE_TO', oPrevDate);
					panelResult.setValue('PREV_DATE_TO', oPrevDate);
				}
				if(oPrevStDate){
					UniAppManager.app.fnSetStDate(oPrevDate, oPrevStDate, getStDt[0].STDT);	
				}
			}
		},
		
		fnCalSession: function(value){
			var sThisStDate = ''; var sNextStDate = ''; var sSession ='';
			var sSign ='';
			
			
			if(value == 'THIS_START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('THIS_START_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */
				
				var sThisStDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);								
				/* 기본 당기시작년월 */ 
				var sSession	= fnGetSession[0].SESSION;
				
				if(sStDate < sThisStDate){
				
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					var sSession = sSession - sessionCalc; 
				}
				var fanalSession 	= sSession;	
				
				return fanalSession;
			}
			else if(value == 'PREV_START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('PREV_START_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */
				
				var sThisStDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);								
				/* 기본 당기시작년월 */ 
				var sSession	= fnGetSession[0].SESSION;
				
				if(sStDate < sThisStDate){
				
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					var sSession = sSession - sessionCalc; 
				}
				var fanalSession 	= sSession;	
				
				return fanalSession;
			}
		},
		
		
        onSaveButtonDown: function (config) {			
			var param= commentSearch.getValues();
			commentSearch.getForm().submit({
				params : param,
				success : function(form, action) {
		 			commentSearch.getForm().wasDirty = false;
					commentSearch.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
		            UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
		            referCommentWindow.hide();
				}	
			});
		}
	});
};


</script>
