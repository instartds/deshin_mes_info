<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc110skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt	= ${getStDt};			//당기시작월 관련 전역변수

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc110skrModel', {
	    fields: [  	  
	    	{name: 'DIVI'   			, text: 'DIVI' 		,type: 'string'},
		    {name: 'ACCNT'   			, text: '계정코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정과목명' 	,type: 'string'},
		    {name: 'AMT_01'   			, text: '1월' 		,type: 'uniPrice'},
		    {name: 'AMT_02'   			, text: '2월'		,type: 'uniPrice'},
		    {name: 'AMT_03'   			, text: '3월'		,type: 'uniPrice'},
		    {name: 'AMT_04'   			, text: '4월'		,type: 'uniPrice'},
		    {name: 'AMT_05'   			, text: '5월'		,type: 'uniPrice'},
		    {name: 'AMT_06'   			, text: '6월'		,type: 'uniPrice'},
		    {name: 'AMT_07'   			, text: '7월'		,type: 'uniPrice'},
		    {name: 'AMT_08'   			, text: '8월'		,type: 'uniPrice'},
		    {name: 'AMT_09'   			, text: '9월'		,type: 'uniPrice'},
		    {name: 'AMT_10'   			, text: '10월'		,type: 'uniPrice'},
		    {name: 'AMT_11'   			, text: '11월'		,type: 'uniPrice'},
		    {name: 'AMT_12'   			, text: '12월'		,type: 'uniPrice'},
		    {name: 'AMT_TOT'  			, text: '합계'		,type: 'uniPrice'},
		    {name: 'REMARK'  			, text: '비고'		,type: 'string'}
		]          	
	});
	
	Unilite.defineModel('Agc110skrModel2', {
	    fields: [  	  
	    	{name: 'DIVI'   			, text: 'DIVI' 		,type: 'string'},
		    {name: 'ACCNT'   			, text: '계정코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정과목명' 	,type: 'string'},
		    {name: 'AMT_01'   			, text: '1월' 		,type: 'uniPrice'},
		    {name: 'AMT_02'   			, text: '2월'		,type: 'uniPrice'},
		    {name: 'AMT_03'   			, text: '3월'		,type: 'uniPrice'},
		    {name: 'AMT_04'   			, text: '4월'		,type: 'uniPrice'},
		    {name: 'AMT_05'   			, text: '5월'		,type: 'uniPrice'},
		    {name: 'AMT_06'   			, text: '6월'		,type: 'uniPrice'},
		    {name: 'AMT_07'   			, text: '7월'		,type: 'uniPrice'},
		    {name: 'AMT_08'   			, text: '8월'		,type: 'uniPrice'},
		    {name: 'AMT_09'   			, text: '9월'		,type: 'uniPrice'},
		    {name: 'AMT_10'   			, text: '10월'		,type: 'uniPrice'},
		    {name: 'AMT_11'   			, text: '11월'		,type: 'uniPrice'},
		    {name: 'AMT_12'   			, text: '12월'		,type: 'uniPrice'},
		    {name: 'AMT_TOT'  			, text: '합계'		,type: 'uniPrice'},
		    {name: 'REMARK'  			, text: '비고'		,type: 'string'}
		]          	
	});
	
	Unilite.defineModel('Agc110skrModel3', {
	    fields: [  	  
	    	{name: 'DIVI'   			, text: 'DIVI' 		,type: 'string'},
		    {name: 'ACCNT'   			, text: '계정코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정과목명' 	,type: 'string'},
		    {name: 'AMT_01'   			, text: '1월' 		,type: 'string'},
		    {name: 'AMT_02'   			, text: '2월'		,type: 'string'},
		    {name: 'AMT_03'   			, text: '3월'		,type: 'string'},
		    {name: 'AMT_04'   			, text: '4월'		,type: 'string'},
		    {name: 'AMT_05'   			, text: '5월'		,type: 'string'},
		    {name: 'AMT_06'   			, text: '6월'		,type: 'string'},
		    {name: 'AMT_07'   			, text: '7월'		,type: 'string'},
		    {name: 'AMT_08'   			, text: '8월'		,type: 'string'},
		    {name: 'AMT_09'   			, text: '9월'		,type: 'string'},
		    {name: 'AMT_10'   			, text: '10월'		,type: 'string'},
		    {name: 'AMT_11'   			, text: '11월'		,type: 'string'},
		    {name: 'AMT_12'   			, text: '12월'		,type: 'string'},
		    {name: 'AMT_TOT'  			, text: '합계'		,type: 'uniPrice'},
		    {name: 'REMARK'  			, text: '비고'		,type: 'string'}
		]          	
	});
	
	Unilite.defineModel('Agc110skrModel4', {
	    fields: [  	  
	    	{name: 'DIVI'   			, text: 'DIVI' 		,type: 'string'},
		    {name: 'ACCNT'   			, text: '계정코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정과목명' 	,type: 'string'},
		    {name: 'AMT_01'   			, text: '1월' 		,type: 'string'},
		    {name: 'AMT_02'   			, text: '2월'		,type: 'string'},
		    {name: 'AMT_03'   			, text: '3월'		,type: 'string'},
		    {name: 'AMT_04'   			, text: '4월'		,type: 'string'},
		    {name: 'AMT_05'   			, text: '5월'		,type: 'string'},
		    {name: 'AMT_06'   			, text: '6월'		,type: 'string'},
		    {name: 'AMT_07'   			, text: '7월'		,type: 'string'},
		    {name: 'AMT_08'   			, text: '8월'		,type: 'string'},
		    {name: 'AMT_09'   			, text: '9월'		,type: 'string'},
		    {name: 'AMT_10'   			, text: '10월'		,type: 'string'},
		    {name: 'AMT_11'   			, text: '11월'		,type: 'string'},
		    {name: 'AMT_12'   			, text: '12월'		,type: 'string'},
		    {name: 'AMT_TOT'  			, text: '합계'		,type: 'uniPrice'},
		    {name: 'REMARK'  			, text: '비고'		,type: 'string'}
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
	var directMasterStore = Unilite.createStore('agc110skrMasterStore1',{
		model: 'Agc110skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc110skrService.selectList'                	
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
	
	var directMasterStore2 = Unilite.createStore('agc110skrMasterStore2',{
		model: 'Agc110skrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc110skrService.selectList2'                	
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
	
	var directMasterStore3 = Unilite.createStore('agc110skrMasterStore3',{
		model: 'Agc110skrModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc110skrService.selectList3'                	
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
	
	var directMasterStore4 = Unilite.createStore('agc110skrMasterStore4',{
		model: 'Agc110skrModel4',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc110skrService.selectList4'                	
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
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '기준년도',
		 		xtype: 'uniYearField',
		 		name: 'START_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('START_DATE', newValue);
						panelSearch.setValue('ST_DATE', newValue + '0101');
					}
				}
			},{
		 		fieldLabel: 'ST_DATE',
		 		xtype: 'uniTextfield',
		 		name: 'ST_DATE',
		 		hidden: true
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
			Unilite.popup('DEPT',{ 
		    	fieldLabel: '부서',   
		    	popupWidth: 710,
		    	valueFieldName: 'DEPT_CODE_FR',
				textFieldName: 'DEPT_NAME_FR',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
							panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE_FR', '');
						panelResult.setValue('DEPT_NAME_FR', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),   	
			Unilite.popup('DEPT',{ 
				fieldLabel: '~',
				popupWidth: 710,
				valueFieldName: 'DEPT_CODE_TO',
				textFieldName: 'DEPT_NAME_TO',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
							panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE_TO', '');
						panelResult.setValue('DEPT_NAME_TO', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				id:'rdoAccountDiviS',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCOUNT_DIVI',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCOUNT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('ACCOUNT_DIVI').setValue(newValue.ACCOUNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
		 		fieldLabel: 'QUERY_TYPE',
		 		xtype: 'uniTextfield',
		 		name: 'QUERY_TYPE',
		 		hidden: true
			},{
		 		fieldLabel: 'MSG_NO',
		 		xtype: 'uniTextfield',
		 		name: 'MSG_NO',
		 		hidden: true
			},{
		 		fieldLabel: 'MSG_DESC',
		 		xtype: 'uniTextfield',
		 		name: 'MSG_DESC',
		 		hidden: true
			}]},{
				title:'추가정보',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		items:[
        			Unilite.popup('PJT',{ 
			    	fieldLabel: '프로젝트',  
			    	popupWidth: 710,
			    	valueFieldName: 'PJT_CODE',
					textFieldName: 'PJT_NAME'
				}),{
					xtype: 'radiogroup',		            		
					fieldLabel: '과목명',	
					id:'rdoRefItemS',
					items: [{
						boxLabel: '과목명1', 
						width: 70, 
						name: 'REF_ITEM',
						inputValue: '0',
						checked: true  
					},{
						boxLabel : '과목명2', 
						width: 70,
						name: 'REF_ITEM',
						inputValue: '1'
					},{
						boxLabel: '과목명3', 
						width: 70, 
						name: 'REF_ITEM',
						inputValue: '2' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {					
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			]				
		}],
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		api: {
	 		load: 'agc110skrService.selectMsg'	
		}		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
		 		fieldLabel: '기준년도',
		 		xtype: 'uniYearField',
		 		name: 'START_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('START_DATE', newValue);
						panelSearch.setValue('ST_DATE', newValue + '0101');
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
				Unilite.popup('DEPT',{ 
			    	fieldLabel: '부서',  
			    	popupWidth: 710,
			    	valueFieldName: 'DEPT_CODE_FR',
					textFieldName: 'DEPT_NAME_FR',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE_FR', panelResult.getValue('DEPT_CODE_FR'));
								panelSearch.setValue('DEPT_NAME_FR', panelResult.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE_FR', '');
							panelSearch.setValue('DEPT_NAME_FR', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),   	
				Unilite.popup('DEPT',{ 
					fieldLabel: '~',
					popupWidth: 710,
					valueFieldName: 'DEPT_CODE_TO',
					textFieldName: 'DEPT_NAME_TO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
								panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE_TO', '');
							panelSearch.setValue('DEPT_NAME_TO', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCOUNT_DIVI',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCOUNT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ACCOUNT_DIVI').setValue(newValue.ACCOUNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
		],
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}	
    });
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agc110skrGrid1', {
    	layout : 'fit',
    	title : '판매비와관리비',
        store : directMasterStore, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        selModel: 'cellmodel',
        tbar: [{
        	text:'출력',
        	handler: function() {
				UniAppManager.app.fnGotoPrintPage('1');
        	}
        }],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
			{dataIndex: 'ACCNT'   			, width: 73	,locked:true}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 133,locked:true},
			{dataIndex: 'AMT_01'   			, width: 100},
			{dataIndex: 'AMT_02'   			, width: 100},
			{dataIndex: 'AMT_03'   			, width: 100},
			{dataIndex: 'AMT_04'   			, width: 100},
			{dataIndex: 'AMT_05'   			, width: 100},
			{dataIndex: 'AMT_06'   			, width: 100},
			{dataIndex: 'AMT_07'   			, width: 100},
			{dataIndex: 'AMT_08'   			, width: 100},
			{dataIndex: 'AMT_09'   			, width: 100},
			{dataIndex: 'AMT_10'   			, width: 100},
			{dataIndex: 'AMT_11'   			, width: 100},
			{dataIndex: 'AMT_12'   			, width: 100},
			{dataIndex: 'AMT_TOT'  			, width: 120},
        	{dataIndex: 'DIVI'   			, width: 73, hidden:true},
			{dataIndex: 'REMARK'  			, width: 66, flex: 1}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			var selModel = masterGrid.getSelectionModel();
			var currentPosition = selModel.getPosition();
			var colName = currentPosition.column.dataIndex;
			
			if (!UniUtils.indexOf(colName,	['AMT_01','AMT_02','AMT_03','AMT_04','AMT_05','AMT_06',
                                             'AMT_07','AMT_08','AMT_09','AMT_10','AMT_11','AMT_12']))
				return false;
			
			return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '보조부',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		var selModel = masterGrid.getSelectionModel();
	            		var currentPosition = selModel.getPosition();
	            		var column = currentPosition.column;
	            		
	            		masterGrid.gotoAgb110(masterGrid, param.record, column.fullColumnIndex, column.dataIndex);
	            		//masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
	    getLastDate:function(date) {
	    	date = date.substring(0, 6);
	    	
	    	var yy = date.substring(0, 4);
	    	var mm = date.substring(4, 6);
	    	var dd = "31";
	    	
	    	if(mm == "02") {
		    	if(yy % 400 == 0)
		    		dd = "29";
		    	else if (yy % 100 == 0)
		    		dd = "28";
		    	else if (yy % 4 == 0)
		    		dd = "29";
		    	else
		    		dd = "28";
	    	}
	    	else if (mm == "04" || mm == "06" || mm == "09" || mm == "11")
	    		dd = "30";
	    	
	    	return yy + mm + dd;
	    },
		gotoAgb110:function(grid, record, cellIndex, colName)	{
			if(record)	{
		    	
				switch(colName)	{
					case 'AMT_01' :
					case 'AMT_02' :
					case 'AMT_03' :
					case 'AMT_04' :
					case 'AMT_05' :
					case 'AMT_06' :
					case 'AMT_07' :
					case 'AMT_08' :
					case 'AMT_09' :
					case 'AMT_10' :
					case 'AMT_11' :
					case 'AMT_12' :
						var month = colName.substring(4, 6);
						var params = {
							action:'select',
							'PGM_ID'			: 'agc110skr',
							'FR_DATE' 			: panelSearch.getValue('START_DATE') + month + '01',
							'TO_DATE' 			: masterGrid.getLastDate(panelSearch.getValue('START_DATE') + month),
							'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
							'ACCNT' 			: record.data['ACCNT'],	
							'ACCNT_NAME' 		: record.data['ACCNT_NAME'],
							'START_DATE'		: panelSearch.getValue('ST_DATE')
						}
		          		//if (record.data['DIVI'] != '3'){
			          		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
							parent.openTab(rec1, '/accnt/agb110skr.do', params);	
		          		//}
	          		break;
	          		
	  			}
			}
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				} else if(record.get('DIVI') == '3') { 
					cls = 'x-change-cell_dark';
				} 
				return cls;
	        }
	    }              	        
    });       
    
    var masterGrid2 = Unilite.createGrid('agc110skrGrid2', {
    	layout : 'fit',
    	title : '제조경비',
        store : directMasterStore2, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        selModel: 'cellmodel',
        tbar: [{
        	text:'출력',
        	handler: function() {
				UniAppManager.app.fnGotoPrintPage('2');
        	}
        }],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
			{dataIndex: 'ACCNT'   			, width: 73	,locked:true}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 133,locked:true},
			{dataIndex: 'AMT_01'   			, width: 100},
			{dataIndex: 'AMT_02'   			, width: 100},
			{dataIndex: 'AMT_03'   			, width: 100},
			{dataIndex: 'AMT_04'   			, width: 100},
			{dataIndex: 'AMT_05'   			, width: 100},
			{dataIndex: 'AMT_06'   			, width: 100},
			{dataIndex: 'AMT_07'   			, width: 100},
			{dataIndex: 'AMT_08'   			, width: 100},
			{dataIndex: 'AMT_09'   			, width: 100},
			{dataIndex: 'AMT_10'   			, width: 100},
			{dataIndex: 'AMT_11'   			, width: 100},
			{dataIndex: 'AMT_12'   			, width: 100},
			{dataIndex: 'AMT_TOT'  			, width: 120},
        	{dataIndex: 'DIVI'   			, width: 73, hidden:true},
			{dataIndex: 'REMARK'  			, width: 66, flex: 1}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			var selModel = masterGrid2.getSelectionModel();
			var currentPosition = selModel.getPosition();
			var colName = currentPosition.column.dataIndex;
			
			if (!UniUtils.indexOf(colName,	['AMT_01','AMT_02','AMT_03','AMT_04','AMT_05','AMT_06',
                                             'AMT_07','AMT_08','AMT_09','AMT_10','AMT_11','AMT_12']))
				return false;
			
			return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '보조부',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		var selModel = masterGrid2.getSelectionModel();
	            		var currentPosition = selModel.getPosition();
	            		var column = currentPosition.column;
	            		
	            		masterGrid.gotoAgb110(masterGrid2, param.record, column.fullColumnIndex, column.dataIndex);
	            		//masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				} else if(record.get('DIVI') == '3') { 
					cls = 'x-change-cell_dark';
				} 
				return cls;
	        }
	    }              	        
    });                       
    
    var masterGrid3 = Unilite.createGrid('agc110skrGrid3', {
    	layout : 'fit',
    	title : '용역경비',
        store : directMasterStore3, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        tbar: [{
        	text:'출력',
        	handler: function() {
				UniAppManager.app.fnGotoPrintPage('3');
        	}
        }],
        selModel: 'cellmodel',
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
			{dataIndex: 'ACCNT'   			, width: 73	,locked:true}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 133,locked:true},
			{dataIndex: 'AMT_01'   			, width: 100},
			{dataIndex: 'AMT_02'   			, width: 100},
			{dataIndex: 'AMT_03'   			, width: 100},
			{dataIndex: 'AMT_04'   			, width: 100},
			{dataIndex: 'AMT_05'   			, width: 100},
			{dataIndex: 'AMT_06'   			, width: 100},
			{dataIndex: 'AMT_07'   			, width: 100},
			{dataIndex: 'AMT_08'   			, width: 100},
			{dataIndex: 'AMT_09'   			, width: 100},
			{dataIndex: 'AMT_10'   			, width: 100},
			{dataIndex: 'AMT_11'   			, width: 100},
			{dataIndex: 'AMT_12'   			, width: 100},
			{dataIndex: 'AMT_TOT'  			, width: 120},
        	{dataIndex: 'DIVI'   			, width: 73, hidden:true},
			{dataIndex: 'REMARK'  			, width: 66, flex: 1}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			var selModel = masterGrid3.getSelectionModel();
			var currentPosition = selModel.getPosition();
			var colName = currentPosition.column.dataIndex;
			
			if (!UniUtils.indexOf(colName,	['AMT_01','AMT_02','AMT_03','AMT_04','AMT_05','AMT_06',
                                             'AMT_07','AMT_08','AMT_09','AMT_10','AMT_11','AMT_12']))
				return false;
			
			return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '보조부',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		var selModel = masterGrid3.getSelectionModel();
	            		var currentPosition = selModel.getPosition();
	            		var column = currentPosition.column;
	            		
	            		masterGrid.gotoAgb110(masterGrid3, param.record, column.fullColumnIndex, column.dataIndex);
	            		//masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				} else if(record.get('DIVI') == '3') { 
					cls = 'x-change-cell_dark';
				} 
				return cls;
	        }
	    }              	        
    });                       
    
    var masterGrid4 = Unilite.createGrid('agc110skrGrid4', {
    	layout : 'fit',
    	title : '용역경비2',
        store : directMasterStore4, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        tbar: [{
        	text:'출력',
        	handler: function() {
				UniAppManager.app.fnGotoPrintPage('4');
        	}
        }],
        selModel: 'cellmodel',
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
			{dataIndex: 'ACCNT'   			, width: 73	,locked:true}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 133,locked:true},
			{dataIndex: 'AMT_01'   			, width: 100},
			{dataIndex: 'AMT_02'   			, width: 100},
			{dataIndex: 'AMT_03'   			, width: 100},
			{dataIndex: 'AMT_04'   			, width: 100},
			{dataIndex: 'AMT_05'   			, width: 100},
			{dataIndex: 'AMT_06'   			, width: 100},
			{dataIndex: 'AMT_07'   			, width: 100},
			{dataIndex: 'AMT_08'   			, width: 100},
			{dataIndex: 'AMT_09'   			, width: 100},
			{dataIndex: 'AMT_10'   			, width: 100},
			{dataIndex: 'AMT_11'   			, width: 100},
			{dataIndex: 'AMT_12'   			, width: 100},
			{dataIndex: 'AMT_TOT'  			, width: 120},
        	{dataIndex: 'DIVI'   			, width: 73, hidden:true},
			{dataIndex: 'REMARK'  			, width: 66, flex: 1}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			var selModel = masterGrid4.getSelectionModel();
			var currentPosition = selModel.getPosition();
			var colName = currentPosition.column.dataIndex;
			
			if (!UniUtils.indexOf(colName,	['AMT_01','AMT_02','AMT_03','AMT_04','AMT_05','AMT_06',
                                             'AMT_07','AMT_08','AMT_09','AMT_10','AMT_11','AMT_12']))
				return false;
			
			return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '보조부',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		var selModel = masterGrid4.getSelectionModel();
	            		var currentPosition = selModel.getPosition();
	            		var column = currentPosition.column;
	            		
	            		masterGrid.gotoAgb110(masterGrid4, param.record, column.fullColumnIndex, column.dataIndex);
	            		//masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				} else if(record.get('DIVI') == '3') { 
					cls = 'x-change-cell_dark';
				} 
				return cls;
	        }
	    }              	        
    });       
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2,
	         masterGrid3,
	         masterGrid4
	    ],
	     listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'agc110skrGrid1':
						panelSearch.setValue('QUERY_TYPE', '1');
						directMasterStore.loadStoreRecords();
						break;
						
					case 'agc110skrGrid2':
						panelSearch.setValue('QUERY_TYPE', '2');
						directMasterStore2.loadStoreRecords();
						break;
						
					case 'agc110skrGrid3':
						panelSearch.setValue('QUERY_TYPE', '3');
						directMasterStore3.loadStoreRecords();
						break;
						
					case 'agc110skrGrid4':
						panelSearch.setValue('QUERY_TYPE', '4');
						directMasterStore4.loadStoreRecords();
						break;
						
					default:
						break;
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
		id : 'agc110skrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('START_DATE');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('QUERY_TYPE', '1');
			panelSearch.setValue('ST_DATE', getStDt[0].STDT);
			panelSearch.setValue('START_DATE', new Date().getFullYear());
			panelResult.setValue('START_DATE', new Date().getFullYear());
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'agc110skrGrid1'){
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore.loadStoreRecords();
					}
				});					
			} else if(activeTabId == 'agc110skrGrid2'){	
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore2.loadStoreRecords();
					}
				});									
			} else if(activeTabId == 'agc110skrGrid3'){	
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore3.loadStoreRecords();
					}
				});					
			} else if(activeTabId == 'agc110skrGrid4'){	
				var param= Ext.getCmp('searchForm').getValues();
				panelSearch.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore4.loadStoreRecords();
					}
				});					
			}
		},
        fnGotoPrintPage:function(type) {
			var params = {
					'PGM_ID'		: 'agc110skr',
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'ST_DATE'		: panelSearch.getValue('ST_DATE'),
					'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE'),
					'DEPT_CODE_FR'	: panelSearch.getValue('DEPT_CODE_FR'),
					'DEPT_NAME_FR'	: panelSearch.getValue('DEPT_NAME_FR'),
					'DEPT_CODE_TO'	: panelSearch.getValue('DEPT_CODE_TO'),
					'DEPT_NAME_TO'	: panelSearch.getValue('DEPT_NAME_TO'),
					'ACCOUNT_DIVI'	: Ext.getCmp('rdoAccountDiviS').getValue(),
					'PJT_CODE'		: panelSearch.getValue('PJT_CODE'),
					'PJT_NAME'		: panelSearch.getValue('PJT_NAME'),
					'REF_ITEM'		: Ext.getCmp('rdoRefItemS').getValue(),
					'PAGE_TYPE'		: type
					
					
			}
			//전송
			var rec1 = {data : {prgID : 'agc110rkr', 'text':''}};
			parent.openTab(rec1, '/accnt/agc110rkr.do', params);
        }
	});
};


</script>
