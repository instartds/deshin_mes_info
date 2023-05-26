<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="adt100ukr"  >

	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="A121" /> <!-- 배부기준 -->
	<t:ExtComboStore comboType="AU" comboCode="A008" /> <!-- 계정과목유형 -->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'adt100ukrService.selectDetailList',
			update: 'adt100ukrService.updateDetail',
			create: 'adt100ukrService.insertDetail',
			destroy: 'adt100ukrService.deleteDetail',
			syncAll: 'adt100ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'adt100ukrService.selectDetailList2'/*,
			update: 'adt100ukrService.updateDetail2',
			create: 'adt100ukrService.insertDetail2',
			destroy: 'adt100ukrService.deleteDetail2',
			syncAll: 'adt100ukrService.saveAll2'*/
		}
	});
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'adt100ukrService.selectDetailList3'/*,
			update: 'adt100ukrService.updateDetail2',
			create: 'adt100ukrService.insertDetail2',
			destroy: 'adt100ukrService.deleteDetail2',
			syncAll: 'adt100ukrService.saveAll2'*/
		}
	});
	
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'adt100ukrService.selectDetailList4'/*,
			update: 'adt100ukrService.updateDetail2',
			create: 'adt100ukrService.insertDetail2',
			destroy: 'adt100ukrService.deleteDetail2',
			syncAll: 'adt100ukrService.saveAll2'*/
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Adt100ukrModel1', {
		
	    fields: [{name: 'COMP_CODE'				,text: '법인코드' 				,type: 'string'},
			     {name: 'DEPT_CODE'				,text: '부서코드' 				,type: 'string', allowBlank: false},
			     {name: 'DEPT_NAME'				,text: '부서명' 				,type: 'string'},
			     {name: 'FR_YYYYMM'				,text: '기준시작일' 			,type: 'uniDate'},
			     {name: 'TO_YYYYMM'				,text: '기준종료일' 			,type: 'uniDate'},
			     {name: 'BASE_DSTRB'			,text: '배부기준' 				,type: 'string'},
			     {name: 'BASE_DIV_CODE'			,text: 'BASE_DIV_CODE' 		,type: 'string'},
			     {name: 'DIV_CODE'				,text: '사업장' 				,type: 'string'},
			     {name: 'DSTRB_RATE'			,text: '배부율' 				,type: 'string', allowBlank: false},
			     {name: 'SAVE_TYPE'				,text: 'SAVE_TYPE' 			,type: 'string'},
			     {name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 	,type: 'string'}
		]
	});
	
	Unilite.defineModel('Adt100ukrModel2', {
		
	    fields: [{name: 'COMP_CODE'				,text: '법인코드' 					,type: 'string'},
			     {name: 'FR_YYYYMM'				,text: '기준시작일' 				,type: 'uniDate'},
			     {name: 'TO_YYYYMM'				,text: '기준종료일' 				,type: 'uniDate'},
			     {name: 'BASE_DIV_CODE'			,text: '사업장' 					,type: 'string'},
			     {name: 'ACCNT'					,text: '계정코드' 					,type: 'string', allowBlank: false},
			     {name: 'ACCNT_NAME'			,text: '계정명' 					,type: 'string'},
			     {name: 'APPLY_DSTRB'			,text: '적용배부기준' 				,type: 'string', allowBlank: false},
			     {name: 'SAVE_TYPE'				,text: 'SAVE_TYPE' 				,type: 'string'},
			     {name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 		,type: 'string'}
				 
		]
	});	
	
	Unilite.defineModel('Adt100ukrModel3', {
		
	    fields: [{name: 'COMP_CODE'				,text: '법인코드' 					,type: 'string'},
			     {name: 'FR_YYYYMM'				,text: '기준시작일' 				,type: 'uniDate'},
			     {name: 'TO_YYYYMM'				,text: '기준종료일' 				,type: 'uniDate'},
			     {name: 'BASE_DIV_CODE'			,text: '사업장' 					,type: 'string'},
			     {name: 'ACCNT_DIVI'			,text: '계정유형' 					,type: 'string', allowBlank: false},
			     {name: 'BASE_DSTRB'			,text: '배부기준' 					,type: 'string'},
			     {name: 'DSTRB_RATE'			,text: '배부율' 					,type: 'string', allowBlank: false},
			     {name: 'SAVE_TYPE'				,text: 'SAVE_TYPE' 				,type: 'string'},
			     {name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 		,type: 'string'}
				 
		]
	});	
	
	Unilite.defineModel('Adt100ukrModel4', {
		
	    fields: [{name: 'COMP_CODE'				,text: '법인코드' 					,type: 'string'},
	    		 {name: 'FR_YYYYMM'				,text: '기준시작일' 				,type: 'uniDate'},
	    		 {name: 'TO_YYYYMM'				,text: '기준종료일' 				,type: 'uniDate'},
	    		 {name: 'BASE_DIV_CODE'			,text: '사업장' 					,type: 'string'},
	    		 {name: 'BASE_ACCNT'			,text: '기준' 					,type: 'string', allowBlank: false},
	    		 {name: 'BASE_ACCNT_NAM'		,text: '계정명' 					,type: 'string'},
	    		 {name: 'ACCNT_1'				,text: '배부1' 					,type: 'string', allowBlank: false},
	    		 {name: 'ACCNT_1_NAME'			,text: '계정명' 					,type: 'string'},
	    		 {name: 'ACCNT_2'				,text: '배부2' 					,type: 'string', allowBlank: false},
	    		 {name: 'ACCNT_2_NAME'			,text: '계정명' 					,type: 'string'},
	    		 {name: 'ACCNT_3'				,text: '배부3' 					,type: 'string', allowBlank: false},
	    		 {name: 'ACCNT_3_NAME'			,text: '계정명' 					,type: 'string'},
	    		 {name: 'APPLY_DSTRB'			,text: '적용배부기준' 				,type: 'string', allowBlank: false},
	    		 {name: 'SAVE_TYPE'				,text: 'SAVE_TYPE' 				,type: 'string'},
	    		 {name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 		,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('adt100ukrMasterStore1',{
			model: 'Adt100ukrModel1',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME'
			
	});
	
	var directMasterStore2 = Unilite.createStore('adt100ukrMasterStore2',{
			model: 'Adt100ukrModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy2,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			
	});	
	
	var directMasterStore3 = Unilite.createStore('adt100ukrMasterStore3',{
			model: 'Adt100ukrModel3',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy3,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			
	});
	
	var directMasterStore4 = Unilite.createStore('adt100ukrMasterStore4',{
			model: 'Adt100ukrModel4',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy4,
			loadStoreRecords : function()	{
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
		    items : [{
				fieldLabel: '기준월',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'SALE_FR_DATE',
	            endFieldName: 'SALE_TO_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,
        		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_FR_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_TO_DATE',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
	     	},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '배부기준',
				name: '', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A121',
				allowBlank: false
			},{ 
				fieldLabel: '계정과목유형',
				name: '', 
            	hidden: true,
            	id:  'adt100ukrPOSearch',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A008'
			},{ 
				fieldLabel: '적용배부기준',
				name: '', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A121'
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
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '기준월',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'SALE_FR_DATE',
	            endFieldName: 'SALE_TO_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false
	     	},{ 
				fieldLabel: '사업장',
				name: '', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				width: 270,
				allowBlank: false
			},{ 
				fieldLabel: '배부기준',
				name: '', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A121',
				allowBlank: false
			},{ 
				fieldLabel: '계정과목유형',
				name: '', 
            	hidden: true,
            	id:  'adt100ukrPOSearch2',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A008'
			},{ 
				fieldLabel: '적용배부기준',
				name: '', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A121'
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
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('adt100ukrGrid1', {
    	// for tab 
    	title: '부서별배부',
    	layout : 'fit',
        region: 'center',
    	store: directMasterStore1,
    	uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'COMP_CODE'						 	,		width: 100, hidden: true }, 
        		   { dataIndex: 'DEPT_CODE'						 	,		width: 93 }, 
        		   { dataIndex: 'DEPT_NAME'						 	,		width: 160 }, 
        		   { dataIndex: 'FR_YYYYMM'						 	,		width: 100, hidden: true }, 
        		   { dataIndex: 'TO_YYYYMM'						 	,		width: 100, hidden: true }, 
        		   { dataIndex: 'BASE_DSTRB'					 	,		width: 100, hidden: true }, 
        		   { dataIndex: 'BASE_DIV_CODE'					 	,		width: 93, hidden: true }, 
        		   { dataIndex: 'DIV_CODE'						 	,		width: 93 }, 
        		   { dataIndex: 'DSTRB_RATE'					 	,		width: 66 }, 
        		   { dataIndex: 'SAVE_TYPE'						 	,		width: 120, hidden: true }, 
        		   { dataIndex: 'UPDATE_DB_USER'				 	,		width: 100, hidden: true }
        ] 
    });
    
    var masterGrid2 = Unilite.createGrid('adt100ukrGrid2', {
    	// for tab 
    	//title: '부서별배부',
    	layout : 'fit',
        region: 'east',
    	store: directMasterStore2,
    	uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'COMP_CODE'					,		width: 100, hidden: true}, 
        		   { dataIndex: 'FR_YYYYMM'					,		width: 120, hidden: true}, 
        		   { dataIndex: 'TO_YYYYMM'					,		width: 120, hidden: true}, 
        		   { dataIndex: 'BASE_DIV_CODE'				,		width: 100, hidden: true}, 
        		   { dataIndex: 'ACCNT'						,		width: 93}, 
        		   { dataIndex: 'ACCNT_NAME'				,		width: 186}, 
        		   { dataIndex: 'APPLY_DSTRB'				,		width: 106}, 
        		   { dataIndex: 'SAVE_TYPE'					,		width: 120, hidden: true}, 
        		   { dataIndex: 'UPDATE_DB_USER'			,		width: 120, hidden: true}
        ] 
    });
    
    var masterGrid3 = Unilite.createGrid('adt100ukrGrid3', {
    	// for tab 
    	title: '원가계정별배부',
        layout : 'fit',
        region: 'center',
    	store: directMasterStore3,
    	uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'COMP_CODE'				, 		width: 100, hidden: true },  
        		   { dataIndex: 'FR_YYYYMM'				, 		width: 120, hidden: true },  
        		   { dataIndex: 'TO_YYYYMM'				, 		width: 120, hidden: true },  
        		   { dataIndex: 'BASE_DIV_CODE'			, 		width: 100, hidden: true },  
        		   { dataIndex: 'ACCNT_DIVI'			, 		width: 133 },  
        		   { dataIndex: 'BASE_DSTRB'			, 		width: 100, hidden: true },  
        		   { dataIndex: 'DSTRB_RATE'			, 		width: 66 },  
        		   { dataIndex: 'SAVE_TYPE'				, 		width: 120, hidden: true },  
        		   { dataIndex: 'UPDATE_DB_USER'		, 		width: 120, hidden: true }
        ] 
    }); 
    
    var masterGrid4 = Unilite.createGrid('adt100ukrGrid4', {
    	// for tab 
    	//title: '원가계정별배부',
        layout : 'fit',
        region: 'east',
    	store: directMasterStore4,
    	uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'COMP_CODE'						, 		width: 100, hidden: true},  
        		   { dataIndex: 'FR_YYYYMM'						, 		width: 120, hidden: true},  
        		   { dataIndex: 'TO_YYYYMM'						, 		width: 120, hidden: true},  
        		   { dataIndex: 'BASE_DIV_CODE'					, 		width: 100, hidden: true},  
        		   { dataIndex: 'BASE_ACCNT'					, 		width: 50},  
        		   { dataIndex: 'BASE_ACCNT_NAM'				, 		width: 120},  
        		   { dataIndex: 'ACCNT_1'						, 		width: 50},  
        		   { dataIndex: 'ACCNT_1_NAME'					, 		width: 120},  
        		   { dataIndex: 'ACCNT_2'						, 		width: 50},  
        		   { dataIndex: 'ACCNT_2_NAME'					, 		width: 120},  
        		   { dataIndex: 'ACCNT_3'						, 		width: 50},  
        		   { dataIndex: 'ACCNT_3_NAME'					, 		width: 120},  
        		   { dataIndex: 'APPLY_DSTRB'					, 		width: 66},  
        		   { dataIndex: 'SAVE_TYPE'						, 		width: 93, hidden: true},  
        		   { dataIndex: 'UPDATE_DB_USER'				, 		width: 120, hidden: true}
        ] 
    }); 
     
     var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [
	    	/*[{
				region : 'west',
				xtype : 'container',
				layout : 'fit',
				width : 700,
				items : [ masterGrid1 ]
			},{
				region : 'center',
				xtype : 'container',
				layout : 'fit',
				flex : 1,
				items : [ masterGrid2 ]
			}],[{
				region : 'west',
				xtype : 'container',
				layout : 'fit',
				width : 500,
				items : [ masterGrid3 ]
			},{
				region : 'center',
				xtype : 'container',
				layout : 'fit',
				flex : 1,
				items : [ masterGrid4 ]
			}]*/
	    	{
	    		//xtype: 'container',
	    		items: [masterGrid1, masterGrid2]
	    	},{
	    		//xtype: 'container',
	    		items: [masterGrid3, masterGrid4]
	    	}
	    ],
	     listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'adt100ukrGrid1':
						var poSearch = Ext.getCmp('adt100ukrPOSearch');
					    poSearch.setVisible(false);
					    var poSearch2 = Ext.getCmp('adt100ukrPOSearch2');
					    poSearch2.setVisible(false);
						break;
						
					case 'adt100ukrGrid3':
						var poSearch = Ext.getCmp('adt100ukrPOSearch');
					    poSearch.setVisible(true);
					    var poSearch2 = Ext.getCmp('adt100ukrPOSearch2');
					    poSearch2.setVisible(true);
						break;
						
						default:
						break;
				}
	     	}
	     }
     });
	
    Unilite.Main( {
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
		id  : 'adt100ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
				masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
