<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str400skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="str400skrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 --> 
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B035" /> <!-- 수불유형 -->
	<t:ExtComboStore comboType="OU" /> <!--입고창고-->
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

	Unilite.defineModel('str400skrvModel', {
	    fields: [  	
	    	{name: 'COMP_CODE'  	    	,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'			,type:'string'},
	    	{name: 'DIV_CODE'   			,text:'<t:message code="system.label.sales.division" default="사업장"/>'			,type:'string'},
	    	{name: 'INOUT_DATE' 			,text:'<t:message code="system.label.sales.transdate" default="수불일"/>'			,type:'uniDate'},
	    	{name: 'INOUT_NUM'		    	,text:'<t:message code="system.label.sales.tranno" default="수불번호"/>'			,type:'string'},
	    	{name: 'WH_CODE'				,text:'<t:message code="system.label.sales.issueplace" default="출고처"/>'			,type:'string' , store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'INOUT_PRSN'    			,text:'<t:message code="system.label.sales.trancharge" default="수불담당"/>'			,type:'string' , comboType:"AU", comboCode:"B024"},
	    	{name: 'ORDER_UNIT_O'    		,text:'<t:message code="system.label.sales.supplyamount" default="공급가액"/>'			,type:'uniPrice'},
	    	{name: 'INOUT_TAX_AMT' 			,text:'<t:message code="system.label.sales.taxamount" default="세액"/>'				,type:'uniPrice'},
	    	{name: 'TOTAL_CASH'  	    	,text:'<t:message code="system.label.sales.totalamount" default="합계"/>'				,type:'uniPrice'},
	    	{name: 'AGENT_TYPE' 			,text:'<t:message code="system.label.sales.clienttype" default="고객분류"/>'			,type:'string'},
	    	{name: 'AREA_TYPE'		    	,text:'<t:message code="system.label.sales.areatype" default="지역분류"/>'			,type:'string'},
	    	{name: 'INOUT_TYPE' 			,text:'<t:message code="system.label.sales.trantype" default="수불유형"/>'			,type:'string' , comboType:"AU", comboCode:"B035"}
	    	
		]
	});		// end of Unilite.defineModel('str400skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('str400skrvMasterStore1',{
			model: 'str400skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'str400skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();      
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params: param
				});
			}
	});		// end of var directMasterStore1 = Unilite.createStore('str400skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',	
	    items: [{
			 	fieldLabel: '<t:message code="system.label.sales.tranno" default="수불번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'INOUT_NUM',
//			 	hidden: true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_NUM', newValue);
					}
				}
			},{	    
		    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WH_CODE', '');
					}
				}
	    	},
	    	Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),{
			    fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			    name: 'WH_CODE', 
			    xtype: 'uniCombobox', 
			    comboType:'OU', 
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('WH_CODE', newValue);
			     	},
			     	beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelSearch.getValue('DIV_CODE');
                        })
                        }else{
                           store.filterBy(function(record){
                               return false;   
                        })
                     }
                  }
			    }
			 },{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
//				holdable: 'hold',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('INOUT_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '단가/금액</br>출력여부',
	    	//	id : 'A',
	    		items: [{
	    			boxLabel: '예',
	    			width: 60,
	    			name: 'OUTPUT_CONTROL',
	    			inputValue: 'A',
	    			checked: true
	    		}, {
	    			boxLabel: '아니오',
	    			width: 70,
	    			name: 'OUTPUT_CONTROL',
	    			inputValue: 'B'
	    		}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('OUTPUT_CONTROL').setValue(newValue.OUTPUT_CONTROL);
						
						
					}
				}	
			}]
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			 	fieldLabel: '<t:message code="system.label.sales.tranno" default="수불번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'INOUT_NUM',
//			 	hidden: true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('INOUT_NUM', newValue);
					}
				}
			},{	    
		    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WH_CODE', '');
					}
				}
	    	},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),{
			    fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			    name: 'WH_CODE', 
			    xtype: 'uniCombobox', 
			    comboType:'OU',
//				    allowBlank: false,
			    //holdable: 'hold',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelSearch.setValue('WH_CODE', newValue);
			     	},
			     	beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        })
                        }else{
                           store.filterBy(function(record){
                               return false;   
                        })
                     }
                  }
			    }
		   },{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
//				holdable: 'hold',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('INOUT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('INOUT_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '단가/금액</br>출력여부',
	    	//	id : 'A',
	    		items: [{
	    			boxLabel: '예',
	    			width: 60,
	    			name: 'OUTPUT_CONTROL',
	    			inputValue: 'A',
	    			checked: true
	    		}, {
	    			boxLabel: '아니오',
	    			width: 70,
	    			name: 'OUTPUT_CONTROL',
	    			inputValue: 'B'
	    		}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('OUTPUT_CONTROL').setValue(newValue.OUTPUT_CONTROL);
					}
				}
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('str400skrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region: 'center',
        uniOpt: {
        	onLoadSelectFirst: false, 
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }), 
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore1,
        columns: [
        	{ dataIndex: 'COMP_CODE'		    	,    width: 150 ,hidden:true},
        	{ dataIndex: 'DIV_CODE'		    		,    width: 150 ,hidden:true},
        	{ dataIndex: 'INOUT_DATE'		    	,    width: 150},
        	{ dataIndex: 'INOUT_NUM'		    	,    width: 150},
        	{ dataIndex: 'WH_CODE'		    		,    width: 150},
        	{ dataIndex: 'INOUT_PRSN'		    	,    width: 150},
        	{ dataIndex: 'ORDER_UNIT_O'		    	,    width: 150},
        	{ dataIndex: 'INOUT_TAX_AMT'		    ,    width: 150},
        	{ dataIndex: 'INOUT_TYPE'		    	,    width: 100},
        	{ dataIndex: 'TOTAL_CASH'		    	,    width: 150
        	/*,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			//var rec = masterGrid.getStore().getAt(rowIndex);
					if (panelResult.getValue('a') == ''){//panelResult.getValue('a').inputValue=='1'){//Ext.getCmp('A').getValue() == '1'){
					//	Unilite.messageBox('사슴');
                        return 0;
                    }else{
                    	return val;
                    }
                    
                }*/
        	}
		],
			listeners: {
	        	
	        	select: function(grid, record, index, eOpts ){	
	        			UniAppManager.setToolbarButtons('print',true);
	        			
						
	        			//UniAppManager.app.grid1Select();
					
		          	},
				deselect:  function(grid, record, index, eOpts ){
						//UniAppManager.setToolbarButtons('print',false);

	        		} 
			}
    }); 		// end of var masterGrid = Unilite.createGrid('str400skrvGrid1', {  
	
	
    Unilite.Main({
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
		id  : 'str400skrvApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_FR',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR',UniDate.get('today'));
			//if(location.reload(false)){
			this.processParams(params);
			//}
			UniAppManager.setToolbarButtons(['reset'], true);
			//UniAppManager.setToolbarButtons('reset',false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
        processParams: function(params) {
			this.uniOpt.appParams = params;			
			if(params && params.INOUT_NUM) {
				panelSearch.setValue('DIV_CODE', params.DIV_CODE);
				panelResult.setValue('DIV_CODE', params.DIV_CODE);
				
				panelSearch.setValue('INOUT_DATE_FR', params.INOUT_DATE);
				panelSearch.setValue('INOUT_DATE_TO', params.INOUT_DATE);
				panelResult.setValue('INOUT_DATE_FR', params.INOUT_DATE);
				panelResult.setValue('INOUT_DATE_TO', params.INOUT_DATE);
				
				panelSearch.setValue('INOUT_NUM', params.INOUT_NUM);
				panelResult.setValue('INOUT_NUM', params.INOUT_NUM);
				
				panelSearch.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
				
				panelSearch.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
				panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
				
				panelSearch.setValue('AGENT_TYPE', params.AGENT_TYPE);
				panelResult.setValue('AGENT_TYPE', params.AGENT_TYPE);
				
				directMasterStore1.loadStoreRecords();	
			}

		},
        onPrintButtonDown: function() {
			//var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
        	
        	var params = masterGrid.getSelectedRecords();

        	var inoutType = new Array(); /* 거래 + 반품 */
        	
        	var checkIn = false;
        	var checkOut = false;
        	
        	var in_num_arry = new Array();
        	var out_num_arry = new Array();
        	
			
        	
        	
        	Ext.each(params, function(record, i)	{
	   			if(record.get('INOUT_TYPE') == '2'){
	   				
	   				in_num_arry[i] = record.get('INOUT_NUM');
	   				checkIn  = true;
	   				
	   			}else if (record.get('INOUT_TYPE') == '3'){
	   				
	   				out_num_arry[i] = record.get('INOUT_NUM');
	   				checkOut = true;
	   			}
		   	});
		   	
			if(checkIn && checkOut){
				
				var win = Ext.create('widget.PDFPrintWindow', {  /* 거래명세서 */
					url: CPATH+'/str/str400rkrPrint.do',
					prgID: 'str400rkr',
					extParam: {
						INOUT_NUM : [in_num_arry],
						DIV_CODE  : panelSearch.getValue('DIV_CODE'),
						OUTPUT_CONTROL : panelSearch.getValue('OUTPUT_CONTROL'),
						USER_ID   : UserInfo.userID,
						COMP_CODE : UserInfo.compCode,
						DEPT_CODE : panelSearch.getValue('DEPT_CODE')
					}
				});
				win.center();
				win.show();
				
				var win2 = Ext.create('widget.PDFPrintWindow', {	/* 반품명세서 */
					url: CPATH+'/mrt/mrt100rkrPrint.do',
					prgID: 'mrt100rkr',
						extParam: {
							INOUT_NUM : [out_num_arry],
							DIV_CODE  : panelSearch.getValue('DIV_CODE')
						}
					});
					win2.center();
					win2.show();
				
			}
			else if(checkIn){	
				var win = Ext.create('widget.PDFPrintWindow', {  /* 거래명세서 */
					url: CPATH+'/str/str400rkrPrint.do',
					prgID: 'str400rkr',
					extParam: {
						INOUT_NUM : [in_num_arry],
						DIV_CODE  : panelSearch.getValue('DIV_CODE'),
						OUTPUT_CONTROL : panelSearch.getValue('OUTPUT_CONTROL'),
						USER_ID   : UserInfo.userID,
						COMP_CODE : UserInfo.compCode,
						DEPT_CODE : panelSearch.getValue('DEPT_CODE')
					}
				});
				win.center();
				win.show();
			}
			
			else if(checkOut){
				var win2 = Ext.create('widget.PDFPrintWindow', {	/* 반품명세서 */
					url: CPATH+'/mrt/mrt100rkrPrint.do',
					prgID: 'mrt100rkr',
						extParam: {
							INOUT_NUM : [out_num_arry],
							DIV_CODE  : panelSearch.getValue('DIV_CODE')
						}
					});
					win2.center();
					win2.show();
			}
		}
	});

};


</script>
