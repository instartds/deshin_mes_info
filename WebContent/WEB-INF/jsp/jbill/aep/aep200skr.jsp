<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep200skr"  >
<t:ExtComboStore comboType="AU" comboCode="J647"/>	<!-- 전자전표유형코드	-->
<t:ExtComboStore comboType="AU" comboCode="J682"/>	<!-- 전표상태코드	-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep200skrModel', {
	    fields: [
//			{name: 'ICON'				, text: '출력'			, type: 'string'},
	    	{name: 'APPR_MANAGE_NO'		, text: '문서번호'			, type: 'string'},
	    	{name: 'ELEC_SLIP_NO'		, text: '전표번호'			, type: 'string'},
			{name: 'ORA_SLIP_NO'		, text: 'SAP전표번호'		, type: 'string'},
			{name: 'SLIP_STAT_NM'		, text: '진행상태'			, type: 'string' /*,comboType:'AU', comboCode:'J682'*/},
			{name: 'GW_STATUS'			, text: '그룹웨어상태코드'	, type: 'string'},
			{name: 'GW_STATUS_NM'		, text: '그룹웨어상태'		, type: 'string'},
			{name: 'APPR_LINE'			, text: '결재라인'			, type: 'string'},
			{name: 'ELEC_SLIP_TYPE_NM'	, text: '전표유형'			, type: 'string' /*,comboType:'AU', comboCode:'J647'*/},
			{name: 'INVOICE_DATE'		, text: '증빙일자'			, type: 'uniDate'},
			{name: 'GL_DATE'			, text: '회계일자'			, type: 'uniDate'},
			{name: 'INVOICE_AMT'		, text: '총금액'			, type: 'uniPrice'},
			{name: 'VENDOR_NM'			, text: '거래처'			, type: 'string'},
			{name: 'SLIP_DESC'			, text: '사용내역'			, type: 'string'},
			{name: 'REG_DEPT_NM'		, text: '작성부서'			, type: 'string'},
			{name: 'REG_NM'				, text: '작성자'			, type: 'string'},
			{name: 'REG_DT'				, text: '작성일자'			, type: 'uniDate'},
			{name: 'TSS_GUBUN'			, text: '원천세유형'		, type: 'string'		,comboType:'AU', comboCode:'J699'},
			{name: 'ATTRIBUTE3'			, text: 'ATTRIBUTE3'	, type: 'string'}
			
	    ] 
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep200skrMasterStore1',{
		model: 'aep200skrModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'aep200skrService.selectList'                	
            }
        },
        loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = UserInfo.personNumb
			console.log( param );
			this.load({
				params: param
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
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
        		fieldLabel: '전표유형',
        		name: 'ELEC_SLIP_TYPE_CD',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'J647',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_TYPE_CD', newValue);
					}
				}
        	},{
        		fieldLabel: '진행상태',
        		name: 'SLIP_STAT_CD',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'J682',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SLIP_STAT_CD', newValue);
					}
				}
        	},{ 
	    		fieldLabel: '회계일자',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'GL_DATE_FR',
			    endFieldName: 'GL_DATE_TO',
                allowBlank: false,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('GL_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('GL_DATE_TO', newValue);				    		
			    	}
			    }
			},{
		        fieldLabel: '전표번호',
		        name:'ELEC_SLIP_NO',
		        xtype: 'uniTextfield',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_NO', newValue);
					}
				}
		    },{
		       xtype: 'uniTextfield',
		       name: 'DEPTCD',
		       hidden: true,
		       value: UserInfo.deptCode
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
        		fieldLabel: '전표유형',
        		name: 'ELEC_SLIP_TYPE_CD',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'J647',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ELEC_SLIP_TYPE_CD', newValue);
					}
				}
        	},{
        		fieldLabel: '진행상태',
        		name: 'SLIP_STAT_CD',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'J682',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_STAT_CD', newValue);
					}
				}
        	},{ 
	    		fieldLabel: '회계일자',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'GL_DATE_FR',
			    endFieldName: 'GL_DATE_TO',
			    allowBlank: false,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('GL_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('GL_DATE_TO', newValue);				    		
			    	}
			    }
			},{
		        fieldLabel: '전표번호',
		        name:'ELEC_SLIP_NO',
		        xtype: 'uniTextfield',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ELEC_SLIP_NO', newValue);
					}
				}
		    }
		]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aep200skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true/*,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				
				}
			}*/
        }),
        tbar: [{
			itemId: 'silpBtn',
			text: '기안 중 취소',
        	handler: function() {
	     		var records = masterGrid.getSelectedRecords();
	     		var paramArr = new Array();
	     		Ext.each(records, function(item, idx) {
	     			paramArr.push(item.data);
	     		})
	     		aep200skrService.saveAll(paramArr, function(provider, response){
	     			if(provider && provider.resultText !== "undefined" && provider.resultText =="true")	{
	     				UniAppManager.app.onQueryButtonDown();
	     			} else {
	     				alert("기안 중 취소 중 오류가 발생했습니다.");
	     			}
	     		})
	        }
		}/*,{
			itemId: 'silpBtn',
			text: '전표일괄인쇄',
        	handler: function() {
	     
	        }
		},{
			itemId: 'buyBtn',
			text: '품위서일괄인쇄',
        	handler: function() {
	        }
		}*/],
        columns: [{
			    xtype: 'rownumberer',        
			    sortable:false,         
			    width: 35, 
			    align:'center  !important',       
			    resizable: true
			},
//        	{dataIndex: 'ICON'						, width: 100},
			{dataIndex: 'APPR_MANAGE_NO'	   		, width: 120},
			{dataIndex: 'ELEC_SLIP_NO'	   			, width: 120},
        	{dataIndex: 'ORA_SLIP_NO'	   			, width: 120},
        	{dataIndex: 'GW_STATUS_NM'				, width: 100},
        	{dataIndex: 'SLIP_STAT_NM'				, width: 100},
        	{dataIndex: 'APPR_LINE'					, width: 250},
        	{dataIndex: 'ELEC_SLIP_TYPE_NM'			, width: 100},
        	{dataIndex: 'INVOICE_DATE'				, width: 90},
        	{dataIndex: 'GL_DATE'					, width: 90},
        	{dataIndex: 'INVOICE_AMT'				, width: 100},
        	{dataIndex: 'VENDOR_NM'					, width: 150},
        	{dataIndex: 'SLIP_DESC'					, width: 200},
        	{dataIndex: 'REG_DEPT_NM'				, width: 120},
        	{dataIndex: 'REG_NM'					, width: 100},
        	{dataIndex: 'REG_DT'					, minWidth: 70, flex: 1},
        	{dataIndex: 'TSS_GUBUN'					, width: 100		, hidden: true},
        	{dataIndex: 'ATTRIBUTE3'				, minWidth: 70, flex: 1		, hidden: true}
		],
		listeners:{
			beforeselect:function(selModel , record , index , eOpts)	{
				if(record.get("GW_STATUS") != "1")	{
					return false;
				}
			},
		
    		onGridDblClick :function( grid, record, cellIndex, colName ) {
    			//진짜
				var linkFlag	= record.data['ATTRIBUTE3'];
    			//테스트용
//				var linkFlag	= record.data['ELEC_SLIP_TYPE_NM'];

				if (linkFlag == '법인카드'){
           			masterGrid.gotoAep100ukr(record);
					
				} else if (linkFlag == '실물증빙') {
           			masterGrid.gotoAep110ukr(record);

				} else if (linkFlag == '세금계산서') {
           			masterGrid.gotoAep120ukr(record);
				
				} else if (linkFlag == '전자세금계산서업로드') {
           			masterGrid.gotoAep130ukr(record);
				
				} else if (linkFlag == '전자세금계산서') {
           			masterGrid.gotoAep140ukr(record);
           			
				}else if (linkFlag == '원천세') {
           			masterGrid.gotoAep150ukr(record);
				
				} else if (linkFlag == '원천세-원고료') {
           			masterGrid.gotoAep160ukr(record);
           			
				} else if (linkFlag == '원천세-인세') {
           			masterGrid.gotoAep170ukr(record);
				}
			}
		},
		gotoAep100ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO']
    		};
	  		var rec1 = {data : {prgID : 'aep100ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep100ukr.do', param);
    	},
		gotoAep110ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep110ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep110ukr.do', param);
    	},
		gotoAep120ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep120ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep120ukr.do', param);
    	},
		gotoAep130ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep130ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep130ukr.do', param);
    	},
		gotoAep140ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep140ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep140ukr.do', param);
    	},
		gotoAep150ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep150ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep150ukr.do', param);
    	},
		gotoAep160ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep160ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep160ukr.do', param);
    	},
		gotoAep170ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'aep200skr',
				'ELEC_SLIP_NO'		: record.data['ELEC_SLIP_NO'],
				'INVOICE_DATE'		: record.data['INVOICE_DATE']
    		};
	  		var rec1 = {data : {prgID : 'aep170ukr', 'text': ''}};							
			parent.openTab(rec1, '/jbill/aep170ukr.do', param);
    	}
	});                          
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'aep200skrApp',
		fnInitBinding : function() {	
			UniAppManager.setToolbarButtons('reset',true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			panelSearch.setValue('GL_DATE_FR',UniDate.get('twoMonthsAgo'));
            panelSearch.setValue('GL_DATE_TO',UniDate.get('today'));
            panelResult.setValue('GL_DATE_FR',UniDate.get('twoMonthsAgo'));
            panelResult.setValue('GL_DATE_TO',UniDate.get('today'));
			activeSForm.onLoadSelectText('ELEC_SLIP_TYPE_CD');
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
		
			masterGrid.reset();
			directMasterStore.clearData();

			this.fnInitBinding();		
		}
	});
};


</script>
