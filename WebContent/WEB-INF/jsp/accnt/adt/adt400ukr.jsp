<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="adt400ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> 			<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A149" />			<!-- 전자발행여부 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'adt400ukrService.selectDetailList',
			update: 'adt400ukrService.updateDetail',
			create: 'adt400ukrService.insertDetail',
			destroy: 'adt400ukrService.deleteDetail',
			syncAll: 'adt400ukrService.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Adt400Model', {
	   fields: [
			{name: 'CHK'           	, text: '선택'				, type: 'string'},
			{name: 'COMP_CODE'     	, text: 'COMP_CODE'			, type: 'string'},
			{name: 'DSTRB_NO'      	, text: 'DSTRB_NO'			, type: 'string'},
			{name: 'ACCNT'         	, text: '계정코드'				, type: 'string'},
			{name: 'ACCNT_NAME'    	, text: '계정명'				, type: 'string'},
			{name: 'PJT_CODE'      	, text: '프로젝트'				, type: 'string'},
			{name: 'PJT_NAME'      	, text: '프로젝트명'			, type: 'string'},
			{name: 'APPLY_DSTRB'   	, text: '적용배부기준'			, type: 'string'},
			{name: 'DSTRB_AMT_I'   	, text: '배부대상금액'			, type: 'uniPrice'},
			{name: 'UPDATE_DB_USER'	, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'	, text: 'UPDATE_DB_TIME'	, type: 'string'}
	    ]
	});		// End of Ext.define('Adt400ukrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('adt400MasterStore1',{
		model: 'Adt400Model',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
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
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '배부할 데이터', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '전표일',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_AC_DATE',
	            endFieldName: 'TO_AC_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,
        		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_AC_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_AC_DATE',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
	     	},
	     	Unilite.popup('DEPT',{ 
				    fieldLabel: '배부원부서', 
		        	valueFieldName: 'ORG_DEPT_CODE', 
					textFieldName: 'ORG_DEPT_NAME', 
					allowBlank: false, 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ORG_DEPT_CODE', panelSearch.getValue('ORG_DEPT_CODE'));
								panelResult.setValue('ORG_DEPT_NAME', panelSearch.getValue('ORG_DEPT_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ORG_DEPT_CODE', '');
							panelResult.setValue('ORG_DEPT_NAME', '');
						}
					}
			}),{ 
				fieldLabel: '배부율참조사업장',
				name: 'DSTRB_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DSTRB_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{  				///////////////////////////////// 사업장 팝업
				    fieldLabel: '배부원사업장', 
		        	valueFieldName: 'ORG_DEPT_CODE', 
					textFieldName: 'ORG_DEPT_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ORG_DEPT_CODE', panelSearch.getValue('ORG_DEPT_CODE'));
								panelResult.setValue('ORG_DEPT_NAME', panelSearch.getValue('ORG_DEPT_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ORG_DEPT_CODE', '');
							panelResult.setValue('ORG_DEPT_NAME', '');
						}
					}
			})]
		},{
			title: '배부전표 정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '전표일자',
	            xtype: 'uniDatefield',
	            name: 'EX_DATE',
	            endDate: UniDate.get('today'),
	            allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EX_DATE', newValue);
					}
				}
	     	},{ 
				fieldLabel: '귀속사업장',
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
				fieldLabel: '전표번호',
	    		xtype: 'uniTextfield',
	    		name: 'EX_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EX_NUM', newValue);
					}
				}
			},{
				fieldLabel: '배부번호',
	    		xtype: 'uniTextfield',
	    		name: 'DSTRB_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DSTRB_NO', newValue);
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
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype:'container',
				padding: '0 0 5 30',
				html: '<b>[배부할 데이터]</b>',
				style: {
					color: 'blue'				
				},
				colspan: 3
			},{
				fieldLabel: '전표일',
				labelWidth: 110,
	 		    //width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_AC_DATE',
	            endFieldName: 'TO_AC_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,
        		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_AC_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_AC_DATE',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
	     	},
	     	Unilite.popup('DEPT',{ 
				    fieldLabel: '배부원부서', 
					labelWidth: 110,
					colspan: 2,
		        	valueFieldName: 'ORG_DEPT_CODE', 
					textFieldName: 'ORG_DEPT_NAME', 
					allowBlank: false, 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('ORG_DEPT_CODE', panelResult.getValue('ORG_DEPT_CODE'));
								panelSearch.setValue('ORG_DEPT_NAME', panelResult.getValue('ORG_DEPT_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ORG_DEPT_CODE', '');
							panelSearch.setValue('ORG_DEPT_NAME', '');
						}
					}
			}),{ 
				fieldLabel: '배부율참조사업장',
				name: 'DSTRB_DIV_CODE', 
				labelWidth: 110,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DSTRB_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{ 				///////////////////////////////// 사업장 팝업
				    fieldLabel: '배부원사업장', 
					labelWidth: 110,
					colspan: 2,
		        	valueFieldName: 'ORG_DEPT_CODE', 
					textFieldName: 'ORG_DEPT_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('ORG_DEPT_CODE', panelResult.getValue('ORG_DEPT_CODE'));
								panelSearch.setValue('ORG_DEPT_NAME', panelResult.getValue('ORG_DEPT_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ORG_DEPT_CODE', '');
							panelSearch.setValue('ORG_DEPT_NAME', '');
						}
					}
			}),{
				xtype:'container',
				padding: '0 0 5 30',
				html: '<b>[배부전표 정보]</b>',
				style: {
					color: 'blue'				
				},
				colspan: 3
			},{
				fieldLabel: '전표일자',
				labelWidth: 110,
	            xtype: 'uniDatefield',
	            name: 'EX_DATE',
	            endDate: UniDate.get('today'),
	            allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('EX_DATE', newValue);
					}
				}
	     	},{ 
				fieldLabel: '귀속사업장',
				labelWidth: 110,
				colspan: 2,
				name: 'DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '전표번호',
				labelWidth: 110,
	    		xtype: 'uniTextfield',
	    		name: 'EX_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('EX_NUM', newValue);
					}
				}
			},{
				fieldLabel: '배부번호',
				labelWidth: 110,
				colspan: 2,
	    		xtype: 'uniTextfield',
	    		name: 'DSTRB_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DSTRB_NO', newValue);
					}
				}
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
    
    var masterGrid = Unilite.createGrid('adt400Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
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
        	{dataIndex: 'CHK'           	, width: 33}, 		
			{dataIndex: 'COMP_CODE'     	, width: 100, hidden: true}, 		
			{dataIndex: 'DSTRB_NO'      	, width: 100, hidden: true}, 		
			{dataIndex: 'ACCNT'         	, width: 120}, 		
			{dataIndex: 'ACCNT_NAME'    	, width: 166}, 		
			{dataIndex: 'PJT_CODE'      	, width: 120}, 		
			{dataIndex: 'PJT_NAME'      	, width: 166}, 		
			{dataIndex: 'APPLY_DSTRB'   	, width: 133}, 	
			{dataIndex: 'DSTRB_AMT_I'   	, width: 106}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 100, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: true}
		] 
    });    
    
	 Unilite.Main( {
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
		id : 'adt400App',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			UniAppManager.setToolbarButtons('newData', true); 	
			directMasterStore.loadStoreRecords();
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
