<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrt111skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="mrt111skrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B019" /> <!-- 국내외구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
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

	Unilite.defineModel('mrt111skrvModel', {
	    fields: [  	
	    	{name: 'COMP_CODE'		    	,text:'<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type:'string'},
	    	{name: 'RETURN_DATE'		    ,text:'반품접수일자'		,type:'uniDate'},
	    	{name: 'RETURN_NUM'		    	,text:'반품접수번호'		,type:'string'},
	    	{name: 'CUSTOM_CODE'			,text:'매입처'			,type:'string'},
	    	{name: 'CUSTOM_NAME'			,text:'매입처명'			,type:'string'},
	    	{name: 'RETURN_NAME'			,text:'반품처명'			,type:'string'},
	    	{name: 'ITEM_COUNT'   			,text:'종수'				,type:'uniQty'},
	    	{name: 'TOTAL_RETURN_Q'			,text:'<t:message code="system.label.purchase.qty" default="수량"/>'				,type:'uniQty'},
	    	{name: 'TOTAL_RETURN_O'			,text:'<t:message code="system.label.purchase.amount" default="금액"/>'				,type:'uniPrice'},
	    	{name: 'REMARK'					,text:'<t:message code="system.label.purchase.remarks" default="비고"/>'				,type:'string'}
		]
	});		// end of Unilite.defineModel('mrt111skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrt111skrvMasterStore1',{
			model: 'mrt111skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mrt111skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					var count = masterGrid.getStore().getCount();
					if(count > 0) {	
						UniAppManager.setToolbarButtons(['print'], true);
					}
				}
		}
	});		// end of var directMasterStore1 = Unilite.createStore('mrt111skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',	
	    items: [{	    
		    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	    	},
	    	Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
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
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
	    		fieldLabel: '반품접수일',
	    		xtype: 'uniDateRangefield',
	    		startFieldName: 'RETURN_DATE_FR',
	    		endFieldName: 'RETURN_DATE_TO',
	    		startDate: UniDate.get('today'),
	    		endDate: UniDate.get('today'),
	    		width:315,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('RETURN_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('RETURN_DATE_TO',newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{	    
		    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	    	},
	    	Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{
	    		fieldLabel: '반품접수일',
	    		xtype: 'uniDateRangefield',
	    		startFieldName: 'RETURN_DATE_FR',
	    		endFieldName: 'RETURN_DATE_TO',
	    		startDate: UniDate.get('today'),
	    		endDate: UniDate.get('today'),
	    		width:315,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('RETURN_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('RETURN_DATE_TO',newValue);
			    	}
			    }
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('mrt111skrvGrid1', {
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
        	{ dataIndex: 'COMP_CODE'		    	,    width: 100 , hidden:true},
        	{ dataIndex: 'RETURN_DATE'		    	,    width: 150},
        	{ dataIndex: 'RETURN_NUM'		    	,    width: 135},
        	{ dataIndex: 'CUSTOM_CODE'				,    width: 100},
        	{ dataIndex: 'CUSTOM_NAME'		   		,    width: 150},
        	{ dataIndex: 'RETURN_NAME'	   			,    width: 150},
        	{ dataIndex: 'ITEM_COUNT'   			,    width: 88},
        	{ dataIndex: 'TOTAL_RETURN_Q'			,    width: 88},
        	{ dataIndex: 'TOTAL_RETURN_O'		   	,    width: 130},
        	{ dataIndex: 'REMARK'		   			,    width: 150}

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
    }); 		// end of var masterGrid = Unilite.createGrid('mrt111skrvGrid1', {  
	
	
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
		id  : 'mrt111skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			//UniAppManager.setToolbarButtons(['print'], true);
//			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('RETURN_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('RETURN_DATE_TO',UniDate.get('today'));
        	panelResult.setValue('RETURN_DATE_FR',UniDate.get('today'));
        	panelResult.setValue('RETURN_DATE_TO',UniDate.get('today'));
			
			/*panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			mrt111skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});*/
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
        onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
		},
        
        onPrintButtonDown: function() {
			//var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
			var param= masterGrid.getSelectedRecords();
			var inout_num_arry = new Array();
			Ext.each(param, 
		   		function(record, i)	{
		   			inout_num_arry[i] = record.get('RETURN_NUM'); 
		   	});
			
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/mrt/mrt200rkrPrint.do',
				prgID: 'mrt200rkr',
					extParam: {
						RETURN_NUM : inout_num_arry,
						DIV_CODE  : panelSearch.getValue('DIV_CODE')
					}
				});
				win.center();
				win.show();
   				
		}
		
	});

};


</script>
