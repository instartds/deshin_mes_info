<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc140ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A076" /> <!-- 이익처분구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


var fnGetSession= ${fnGetSession};
var getStDt		= Ext.isEmpty(${getStDt})	? [] : ${getStDt} ;								//당기시작월 관련 전역변수
var gsStDate	= Ext.isEmpty(getStDt)		? '' : getStDt[0].STDT;
//var gsToDate	= Ext.isEmpty(getStDt)		? '' : getStDt[0].TODT;


function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agc140ukrService.selectList',
			update	: 'agc140ukrService.updateList',
			create	: 'agc140ukrService.insertList',
			destroy	: 'agc140ukrService.deleteList',
			syncAll	: 'agc140ukrService.saveAll'
		}
	});
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc140ukrModel', {
	    fields: [
	    	{name: 'ACCNT_NAME'			,text: '과목' 		,type: 'string'},
	    	{name: 'AMT_I1'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'AMT_I2'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'AMT_I3'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'AMT_I4'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'GBN'		      	,text: 'GBN' 		,type: 'string'},
	    	{name: 'UPPER_ACCNT_CD'		,text: '상위 항목코드'	,type: 'string'},
	    	{name: 'ACCNT_CD'		  	,text: '항목코드' 		,type: 'string'},
	    	{name: 'ACCNT'		      	,text: '계정코드 ' 	,type: 'string'},
	    	{name: 'BLANK_FIELD'		,text: 'BLANK_FIELD',type: 'string'},
	    	{name: 'DIS_DIVI'			,text: '출력구분' 		,type: 'string'},			//A050
	    	{name: 'OPT_DIVI'			,text: '집계구분' 		,type: 'string'},			//A052
	    	{name: 'CAL_DIVI'		 	,text: '계산식구분' 	,type: 'string'},			//A073
	    	{name: 'FLAG'				,text: '조회 FLAG'	,type: 'string'}			//신규/참조 구분
		]
	});

	Unilite.defineModel('Agc140ukrModel1', {
	    fields: [
	    	{name: 'ACCNT_NAME'			,text: '과목' 		,type: 'string'},
	    	{name: 'AMT_I1'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'AMT_I2'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'AMT_I3'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'AMT_I4'		      	,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'GBN'		      	,text: 'GBN' 		,type: 'string'},
	    	{name: 'UPPER_ACCNT_CD'		,text: '상위 항목코드'	,type: 'string'},
	    	{name: 'ACCNT_CD'			,text: '항목코드' 		,type: 'string'},
	    	{name: 'ACCNT'		    	,text: '계정코드 ' 	,type: 'string'},
	    	{name: 'BLANK_FIELD'		,text: 'BLANK_FIELD',type: 'string'},
	    	{name: 'DIS_DIVI'			,text: '출력구분' 		,type: 'string'},			//A050
	    	{name: 'OPT_DIVI'			,text: '집계구분' 		,type: 'string'},			//A052
	    	{name: 'CAL_DIVI'		 	,text: '계산식구분' 	,type: 'string'},			//A073
	    	{name: 'FLAG'				,text: '조회 FLAG'	,type: 'string'}			//신규/참조 구분
		]
	});

	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agc140ukrMasterStore',{
		model			: 'Agc140ukrModel',
		uniOpt			: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad		: false,
        proxy			: directProxy,
		loadStoreRecords: function(param)	{
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore		: function(paramMaster)	{	
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;

			paramMaster.CASH_DIVI	= '1';					//간접법일 때 "1"

        	if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
		        		UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners		: {
           	load: function(store, records, successful, eOpts) {
				var recordsFirst = masterStore.data.items[0];	
				if(!Ext.isEmpty(recordsFirst)){
					if(recordsFirst.data.FLAG == 'N'){		//조회된 데이터가 없어서 새로 만든 경우 (참조 또는 재참조일 경우) 신규행 생성해서 조회된 데이터 입력
						masterGrid.reset();
						masterStore.clearData();
						
						Ext.each(records, function(record,i){
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewDataGUBUNTABLE(record.data);	
				    	}); 
				    	
				    	setTimeout(function(){
				    		UniAppManager.setToolbarButtons('save',true);
				    	}, 50)
					}
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	var masterStore1 = Unilite.createStore('agc140ukrMasterStore1',{
		model			: 'Agc140ukrModel1',
		uniOpt			: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad		: false,
        proxy			: directProxy,
		loadStoreRecords: function(param)	{
			this.load({
				params : param
			});
		},
		saveStore		: function(paramMaster)	{	
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
			paramMaster.CASH_DIVI	= '2';

			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
		        		UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners		: {
           	load: function(store, records, successful, eOpts) {
				var recordsFirst = masterStore1.data.items[0];	
				if(!Ext.isEmpty(recordsFirst)){
					if(recordsFirst.data.FLAG == 'N'){		//조회된 데이터가 없어서 새로 만든 경우 (참조 또는 재참조일 경우) 신규행 생성해서 조회된 데이터 입력
						masterGrid1.reset();
						masterStore1.clearData();
						
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid1.setNewDataGUBUNTABLE(record.data);	
				    	}); 
				    	
				    	setTimeout(function(){
				    		UniAppManager.setToolbarButtons('save',true);
				    	}, 50)
					}
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',		
        defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items		: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [{ 
    			fieldLabel		: '전표일',
		        xtype			: 'uniMonthRangefield',
		        startFieldName	: 'FR_DATE',
		        endFieldName	: 'TO_DATE',
		        startDD			: 'first',
		        endDD			: 'last',
		        allowBlank		: false,
		        holdable		: 'hold',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel	: '사업장',
				name		: 'ACCNT_DIV_CODE', 
				xtype		: 'uniCombobox',
		        comboType	: 'BOR120',
		        multiSelect	: true, 
		        typeAhead	: false,
				holdable	: 'hold',
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
	        },{					
    			fieldLabel	: '귀속사업장',
    			name		: 'DIV_CODE',
    			xtype		: 'uniCombobox',
    			comboType	: 'BOR120',
    			allowBlank	: false,
    			listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		}]
		},{
			title		: '추가정보',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
	    	defaultType	: 'uniTextfield',
	    	layout		: {type: 'uniTable', columns: 1},
			items		: [{ 
    			fieldLabel	: '당기시작년월',
    			name		: 'ST_DATE',
				xtype		: 'uniMonthfield',
				allowBlank	: false,
				holdable	: 'hold'
			},{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '과목명',
				items		: [{
					boxLabel	: '과목명1', 
					width		: 80, 
					name		: 'ACCT_NAME', 
					inputValue	: '0',
					checked		: true
				},{
					boxLabel	: '과목명2', 
					width		: 80, 
					name		: 'ACCT_NAME', 
					inputValue	: '1' 
				},{
					boxLabel	: '과목명3', 
					width		: 80, 
					name		: 'ACCT_NAME', 
					inputValue	: '2' 
				}]
			},{
    			fieldLabel	: '금액단위',
    			name		: 'AMT_UNIT', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'B042',
				allowBlank	: false
    		},{
    			fieldLabel	: '재무제표</br>양식차수',
    			name		: 'GUBUN', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'A093',
    			allowBlank	: false
    		}]
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		padding	: '1 1 1 1',
		border	: true,
		layout	: {type : 'uniTable', columns : 3
//			,tableAttrs: {/*style: 'border : 1px solid #ced9e7;', width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/, align : 'left'}
		},
		items	: [{ 
			fieldLabel		: '전표일',
	        xtype			: 'uniMonthRangefield',
	        startFieldName	: 'FR_DATE',
	        endFieldName	: 'TO_DATE',
	        startDD			: 'first',
	        endDD			: 'last',
	        allowBlank		: false,
	        holdable		: 'hold',
	        width			: 380,
	        tdAttrs			: {width: 380}, 
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
					UniAppManager.app.fnSetStDate(newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE',newValue);
		    	}
		    }
        },{
			fieldLabel	: '사업장',
			xtype		: 'uniCombobox',
			name		: 'ACCNT_DIV_CODE', 
	        comboType	: 'BOR120',
	        multiSelect	: true, 
	        typeAhead	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
	    },{
    		xtype	: 'component'
    	},{
    		xtype	: 'component'
    	},{					
			fieldLabel	: '귀속사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			tdAttrs	: {align : 'right', width: '100%'},
			items	: [{
		    	xtype	: 'button',
	    		text	: '재참조',	
	    		name	: '',
	    		width	: 80,	
				handler : function() {
			 		if(!confirm(Msg.sMA0103))	{
			 			return false;
			 		}
			 		//클리어 후, QueryFlag로 조회로직에서 분개 처리 
			 		masterGrid.getStore().loadData({});
					masterGrid1.getStore().loadData({});
					masterStore.clearData();
					masterStore1.clearData();

			 		var QueryFlag = 'RE';
					UniAppManager.app.onQueryButtonDown(QueryFlag);
				}
		    }]
    	}]	
    });
    
    
    
    /** Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agc140ukrGrid', {
    	title		: '간접법',
    	store		: masterStore,
        layout		: 'fit',
        region		: 'center',
        excelTitle	: '간접법',
		uniOpt		: {
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
    		filter: {
				useFilter	: false,
				autoCreate	: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc140rkr('1');
	        	}
        	}
        ],
        columns:  [        
			{ dataIndex	: 'ACCNT_NAME'			, width: 350		/*, renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}*/},
			{ itemId	: 'CHANGE_NAME1',
				columns	: [
					{ dataIndex: 'AMT_I1'		, width: 250},
					{ dataIndex: 'AMT_I2'		, width: 250}
				]
			},
			{ itemId	: 'CHANGE_NAME2',
				columns	: [
					{ dataIndex: 'AMT_I3'		, width: 250},
					{ dataIndex: 'AMT_I4'		, width: 250}
				]
			},
			{ dataIndex	: 'GBN'					, width: 100		, hidden: true},
			{ dataIndex	: 'UPPER_ACCNT_CD'		, width: 100		, hidden: true},
			{ dataIndex	: 'ACCNT_CD'			, width: 100		, hidden: true},
			{ dataIndex	: 'ACCNT'				, width: 100		, hidden: true},
			{ dataIndex	: 'BLANK_FIELD'			, width: 100		, hidden: true},
			{ dataIndex	: 'DIS_DIVI'			, width: 100		, hidden: true},
			{ dataIndex	: 'OPT_DIVI'			, width: 100		, hidden: true},
			{ dataIndex	: 'CAL_DIVI'			, width: 100		, hidden: true}
        ],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//컬럼명이 AMT_I1일 때,
				if (UniUtils.indexOf(e.field, ['AMT_I1'])){	
					if(e.record.data.DIS_DIVI == '1' || e.record.data.OPT_DIVI == '4'){
						return true;
					} else {
						return false;
					}
					
				//컬럼명이 AMT_I2일 때,
				} else if (UniUtils.indexOf(e.field, ['AMT_I2'])){	
					if(e.record.data.DIS_DIVI == '1' || e.record.data.DIS_DIVI == '3' || e.record.data.OPT_DIVI == '4'){
						return false;
						
					} else {
						return true;
					}
					
				//그 외
				} else{
					return false;	
				}
			}
		},
		setNewDataGUBUNTABLE:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('ACCNT_NAME'			,record['ACCNT_NAME']);		
			grdRecord.set('AMT_I1'		   		,record['AMT_I1']);		
			grdRecord.set('AMT_I2'				,record['AMT_I2']);		    
			grdRecord.set('AMT_I3'		 		,record['AMT_I3']);			
			grdRecord.set('AMT_I4'		 		,record['AMT_I4']);				
			grdRecord.set('GBN'		 			,record['GBN']);			
			grdRecord.set('UPPER_ACCNT_CD'		,record['UPPER_ACCNT_CD']);	 
			grdRecord.set('ACCNT_CD'			,record['ACCNT_CD']);			
			grdRecord.set('ACCNT'		    	,record['ACCNT']);			
			grdRecord.set('BLANK_FIELD'			,record['BLANK_FIELD']);			
			grdRecord.set('DIS_DIVI'			,record['DIS_DIVI']);	 
			grdRecord.set('OPT_DIVI'			,record['OPT_DIVI']);	 
			grdRecord.set('CAL_DIVI'		 	,record['CAL_DIVI']);		    
			grdRecord.set('FLAG'				,record['FLAG']);
		}
    });   
	
    var masterGrid1 = Unilite.createGrid('agc140ukrGrid1', {
    	title		: '직접법',
    	store		: masterStore1,
        layout		: 'fit',
        region		: 'center',
        excelTitle	: '직접법',
		uniOpt		: {
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
    		filter: {
				useFilter	: false,
				autoCreate	: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc140rkr('2');
	        	}
        	}
        ],
        columns:  [        
			{ dataIndex	: 'ACCNT_NAME'			, width: 350		/*, renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}*/},
			{ itemId	: 'CHANGE_NAME3',
				columns	: [
					{ dataIndex: 'AMT_I1'		, width: 250},
					{ dataIndex: 'AMT_I2'		, width: 250}
				]
			},
			{ itemId	: 'CHANGE_NAME4',
				columns	: [
					{ dataIndex: 'AMT_I3'		, width: 250},
					{ dataIndex: 'AMT_I4'		, width: 250}
				]
			},
			{ dataIndex	: 'GBN'					, width: 100		, hidden: true},
			{ dataIndex	: 'UPPER_ACCNT_CD'		, width: 100		, hidden: true},
			{ dataIndex	: 'ACCNT_CD'			, width: 100		, hidden: true},
			{ dataIndex	: 'ACCNT'				, width: 100		, hidden: true},
			{ dataIndex	: 'BLANK_FIELD'			, width: 100		, hidden: true},
			{ dataIndex	: 'DIS_DIVI'			, width: 100		, hidden: true},
			{ dataIndex	: 'OPT_DIVI'			, width: 100		, hidden: true},
			{ dataIndex	: 'CAL_DIVI'			, width: 100		, hidden: true}
        ],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//컬럼명이 AMT_I1일 때,
				if (UniUtils.indexOf(e.field, ['AMT_I1'])){	
					if(e.record.data.DIS_DIVI == '1' || e.record.data.OPT_DIVI == '4'){
						return true;
					} else {
						return false;
					}
					
				//컬럼명이 AMT_I2일 때,
				} else if (UniUtils.indexOf(e.field, ['AMT_I2'])){	
					if(e.record.data.DIS_DIVI == '1' || e.record.data.DIS_DIVI == '3' || e.record.data.OPT_DIVI == '4'){
						return false;
						
					} else {
						return true;
					}
					
				//그 외
				} else{
					return false;	
				}
			}
		},
		setNewDataGUBUNTABLE:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('ACCNT_NAME'			,record['ACCNT_NAME']);		
			grdRecord.set('AMT_I1'		   		,record['AMT_I1']);		
			grdRecord.set('AMT_I2'				,record['AMT_I2']);		    
			grdRecord.set('AMT_I3'		 		,record['AMT_I3']);			
			grdRecord.set('AMT_I4'		 		,record['AMT_I4']);				
			grdRecord.set('GBN'		 			,record['GBN']);			
			grdRecord.set('UPPER_ACCNT_CD'		,record['UPPER_ACCNT_CD']);	 
			grdRecord.set('ACCNT_CD'			,record['ACCNT_CD']);			
			grdRecord.set('ACCNT'		    	,record['ACCNT']);			
			grdRecord.set('BLANK_FIELD'			,record['BLANK_FIELD']);			
			grdRecord.set('DIS_DIVI'			,record['DIS_DIVI']);	 
			grdRecord.set('OPT_DIVI'			,record['OPT_DIVI']);	 
			grdRecord.set('CAL_DIVI'		 	,record['CAL_DIVI']);		    
			grdRecord.set('FLAG'				,record['FLAG']);
		}
    });   
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid, masterGrid1
	    ],
	    listeners:{
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				UniAppManager.app.onQueryButtonDown();
    		}
    	}
    });
    
    
    
    Unilite.Main( {
		id			: 'agc140ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		},
		panelSearch  	
		],
		
		fnInitBinding : function() {
			panelSearch.setValue('FR_DATE'	, gsStDate);
			panelSearch.setValue('TO_DATE'	, UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('ST_DATE'	, gsStDate);								//당기시작월 세팅
			panelSearch.setValue('ACCT_NAME', '0');
			panelSearch.setValue('AMT_UNIT'	, '1');
			panelSearch.setValue('GUBUN'	, '01');
			
			panelResult.setValue('FR_DATE'	, gsStDate);
			panelResult.setValue('TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			
			masterGrid.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
			masterGrid.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
			
			UniAppManager.app.fnSetReadOnly(false);
			
			//초기화 시, 포커스 설정
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		
		onQueryButtonDown : function(QueryFlag)	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			var param			= Ext.getCmp('searchForm').getValues();
			//param으로 넘길 변수값 세팅
			var startField		= panelSearch.getField('FR_DATE');
			var startDateValue	= startField.getStartDate();
			param.FR_DATE		= startDateValue;
			
			var endField		= panelSearch.getField('TO_DATE');
			var endDateValue	= endField.getEndDate();
			param.TO_DATE		= endDateValue;
			param.QUERY_FLAG	= QueryFlag;

			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'agc140ukrGrid'){	
				masterGrid.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				param.TAB_SEL = '60';
				masterStore.loadStoreRecords(param);
				
			} else if(activeTabId == 'agc140ukrGrid1'){
				masterGrid1.down('#CHANGE_NAME3').setText('제 ' + UniAppManager.app.fnCalSession('THIS_START_DATE') + ' 당(기)');
				masterGrid1.down('#CHANGE_NAME4').setText('제 ' + UniAppManager.app.fnCalSession('PREV_START_DATE') + ' 전(기)');
				param.TAB_SEL = '70';
				masterStore1.loadStoreRecords(param);				
			}
			UniAppManager.app.fnSetReadOnly(true);
			UniAppManager.setToolbarButtons(['reset'],true);
		},
		
		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
            var r = {
	        };
	        
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'agc140ukrGrid'){	
				masterGrid.createRow(r);
				
			} else if(activeTabId == 'agc140ukrGrid1'){
				masterGrid1.createRow(r);
			}
		},
		
		onResetButtonDown: function() {											
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid1.getStore().loadData({});										
			masterStore.clearData();
			masterStore1.clearData();
			this.fnInitBinding();										
		},
		
		onSaveDataButtonDown: function(config) {
			//paramMaster로 넘길 변수값 세팅
			var paramMaster= panelSearch.getValues();
			
			var startField		= panelSearch.getField('FR_DATE');
			var startDateValue	= startField.getStartDate();
			
			var endField		= panelSearch.getField('TO_DATE');
			var endDateValue	= endField.getEndDate();
			
			paramMaster.FR_AC_DATE		= startDateValue;
			paramMaster.TO_AC_DATE		= endDateValue;
			
			if (gsStDate < startDateValue) {				//당기시작월이 fr전표일 보다 작을 경우,
				alert(Mag.sMA0175);
				return false;
			}
			
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'agc140ukrGrid'){	
				masterStore.saveStore(paramMaster);
				
			} else if(activeTabId == 'agc140ukrGrid1'){
				masterStore1.saveStore(paramMaster);				
			}
		},												
												
/*		//전제삭제 버튼 사용 안 함
		onDeleteAllButtonDown: function() {					
			var records = masterStore.data.items;									
			var isNewData = false;									
			Ext.each(records, function(record,i) {									
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환		
					isNewData = true;							
												
				} else {								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm(Msg.sMB064)) {			//'전체삭제 하시겠습니까?'				
						var deletable = true;						
						if(deletable){						
							masterGrid.reset();					
							UniAppManager.app.onSaveDataButtonDown();					
						}						
						isNewData = false;						
					}							
					return false;							
				}								
			});									
												
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋	
				masterGrid.reset();								
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..							
			}									
												
			UniAppManager.setToolbarButtons('deleteAll', false);									
		},
*/		
		
		//그리드 값 변경 시, 계산 로직
        fnReCalculation: function(record, newValue, oldValue){
        	if(newValue == oldValue){
        		return false;
        		
        	} else {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'agc140ukrGrid'){	
					var thisStore = masterStore
				}
				else if(activeTabId == 'agc140ukrGrid1'){
					var thisStore = masterStore1;	
				}

	        	var sUpperCD;
	        	var sUpperOldAmt = 0;
	        	var sLowerOldAmt = oldValue; 
	        	var sLowerNewAmt = newValue;
	        	var sSign = 0;
	        	
	        	
	        	sUpperCD = record.get('UPPER_ACCNT_CD');
	        	
        		if(Ext.isEmpty(sUpperCD) || sUpperCD == record.get('ACCNT_CD')){
        			return false;
        		}

        		
	        	if(record.get('CAL_DIVI') == '1'){
	        		sSign = 1;	
	        		
	        	} else {
	        		sSign = -1;
	        	}
	        	
	        	var records = thisStore.data.items;
	        	Ext.each(records, function(item, i){
	        		if (sUpperCD == item.get('ACCNT_CD')){
	        			if (item.get('DIS_DIVI') == '1' || item.get('OPT_DIVI') == '4') {
	        				var columnName = 'AMT_I1';
	        				
	        			} else {
	        				var columnName = 'AMT_I2';
	        			}

	        			sUpperOldAmt = item.get(columnName);
	        			
        				if (Ext.isEmpty(sUpperOldAmt)) {
        					sUpperOldAmt = 0;
        				}
        				if (Ext.isEmpty(sLowerOldAmt)) {
        					sLowerOldAmt = 0;
        				}
        				if (Ext.isEmpty(sLowerNewAmt)) {
        					sLowerNewAmt = 0;
        				}

	        			item.set(columnName, sUpperOldAmt - (sSign * sLowerOldAmt) + (sSign * sLowerNewAmt))

	        			//상위레벨 한번 더 확인 (최상위까지 확인해서 set value)
	        			UniAppManager.app.fnReCalculation(item, (sUpperOldAmt - (sSign * oldValue) + (sSign * newValue)), sUpperOldAmt);	
	        		}
	        	});
        	}
        },
        
		
        //그리드 컬럼명 세팅
		fnCalSession: function(value){
			var sThisStDate = ''; var sNextStDate = ''; var sSession ='';
			var sSign ='';
			
			if(value == 'THIS_START_DATE'){
				var sStDate  = UniDate.getDbDateStr(panelSearch.getValue('ST_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */

				var sThisStDate = UniDate.getDbDateStr(gsStDate).substring(0, 6);								
				/* 기본 당기시작년월 */ 
				var sSession	= fnGetSession[0].SESSION;
				
				if(sStDate < sThisStDate){
				
					var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
					var sSession = sSession - sessionCalc; 
				}
				var fanalSession 	= sSession;	
				
				return fanalSession;
				
				
			} else if(value == 'PREV_START_DATE'){
				var prevStDate = UniDate.add(panelSearch.getValue('ST_DATE'), {years: -1});
//				alert (panelSearch.getValue('ST_DATE'));
//				alert (prevStDate);
				var sStDate  = UniDate.getDbDateStr(prevStDate).substring(0, 6);		/* 입력된 당기시작년월 */
				
				var sThisStDate = UniDate.getDbDateStr(gsStDate).substring(0, 6);								
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
        
		
		//당기시작월 세팅
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(gsStDate).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(gsStDate).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(gsStDate).substring(4, 6));
				}
			}
        },
    

		//필드 전체 readOnly설정 (조회 : readOnly(true), 신규 : readOnly(false))
		fnSetReadOnly:function(flag) {
			panelSearch.getForm().getFields().each(function(field) {
				field.setReadOnly(flag);
			});
			panelResult.getForm().getFields().each(function(field) {
				field.setReadOnly(flag);
			});
		},
		fnGotoAgc140rkr: function(type) {
			if(type == '1' && masterGrid.getSelectedRecords().length == 0){
				return false;
			}
			if(type == '2' && masterGrid1.getSelectedRecords().length == 0){
				return false;
			}
			var params = {
				PGM_ID		: 'agc140ukr',
				FR_DATE		: panelSearch.getValue('FR_DATE'),
				TO_DATE		: panelSearch.getValue('TO_DATE'),
				DIV_CODE	: panelSearch.getValue('DIV_CODE'),
				ST_DATE		: panelSearch.getValue('ST_DATE'),
				ACCT_NAME	: panelSearch.getValues().ACCT_NAME,
				AMT_UNIT	: panelSearch.getValue('AMT_UNIT'),
				GUBUN		: panelSearch.getValue('GUBUN'),
				CASH_DIVI	: type
			}
			var rec = {data : {prgID : 'agc140rkr', 'text':''}};
			parent.openTab(rec, '/accnt/agc140rkr.do', params, CHOST+CPATH);
		}
	});
	
	
	
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AMT_I1" : 
				case "AMT_I2" : 
					UniAppManager.app.fnReCalculation(record, newValue,oldValue);
					break;
			}
			return rv;
		}
	});	
	
	Unilite.createValidator('validator02', {
		store	: masterStore1,
		grid	: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AMT_I1" : 
				case "AMT_I2" : 
					UniAppManager.app.fnReCalculation(record, newValue,oldValue);
					break;
			}
			return rv;
		}
	});	
};
</script>
