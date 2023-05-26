<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa710skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa710skrv" /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Ssa710skrvModel', {
	    fields:  [
	    	{name:  'EB_TYPE'	 		,text: '<t:message code="system.label.sales.classfication" default="구분"/>' 			,type: 'string'},
	    	{name:  'BILL_DATE'	 		,text: '일자' 			,type: 'uniDate'},
	    	{name:  'CUSTOM_CODE' 		,text: '<t:message code="system.label.sales.client" default="고객"/>' 			,type: 'string'},
	    	{name:  'CUSTOM_NAME' 		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>' 			,type: 'string'},
	    	{name:  'PUB_NUM'	 		,text: '<t:message code="system.label.sales.number" default="번호"/>' 			,type: 'string'},
	    	{name:  'ERR_STEP'	 		,text: '오류단계' 			,type: 'string'},
	    	{name:  'MSG_DESC'	 		,text: '오류내용' 			,type: 'string'},
	    	{name:  'MSG_DETAIL'	 	,text: '오류대처방안' 		,type: 'string'},
	    	{name:  'ERR_DATE'	 		,text: '오류일시' 			,type: 'string'},
	    	{name:  'EB_NUM'		 	,text: '전자문서번호' 		,type: 'string'}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa710skrvMasterStore1',{
			model:  'Ssa710skrvModel',
			uniOpt:  {
            	isMaster:  true,			// 상위 버튼 연결 
            	editable:  false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi:  false			// prev | next 버튼 사용
            },
            autoLoad:  false,
            proxy:  {
                type:  'direct',
                api:  {			
                	   read:  'ssa710skrvService.selectList'  
                }
            }
			,loadStoreRecords:  function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log(param);					
				this.load({
					params:  param
				});
			}
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout:  {type:  'uniTable', columns:  1},
        	items:  [{
        		fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		xtype:  'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	}, {
        		xtype: 'uniTextfield',
        		fieldLabel: '<t:message code="system.label.sales.number" default="번호"/>',
        		name: 'PUB_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PUB_NUM', newValue);
					}
				}
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel:  '<t:message code="system.label.sales.client" default="고객"/>',
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
				fieldLabel:  '오류일자', 
			    xtype:  'uniDateRangefield',
			    startFieldName:  'ERR_FR_DATE',
			    endFieldName:  'ERR_TO_DATE',
			    width:  315,
			    startDate:  UniDate.get('startOfMonth'),
			    endDate:  UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ERR_FR_DATE', newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ERR_TO_DATE', newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }					    
			}, {
				xtype:  'radiogroup',		            		
        		fieldLabel:  '<t:message code="system.label.sales.classfication" default="구분"/>',			            		
        		items:  [{
        			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
        			width:  50,
        			name: 'EB_TYPE',
        			inputValue:  'A',
        			checked:  true
        		}, {
        			boxLabel: '세금계산서', 
        			width:  90, 
        			name:  'EB_TYPE',
        			inputValue:  '1'
        		}, {
        			boxLabel: '거래명세서',
        			width: 90,
        			name: 'EB_TYPE',
        			inputValue: '2'
        		}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('EB_TYPE').setValue(newValue.GUBUN);
					}
				}
			}, {
				fieldLabel:  '발행/출고일자', 
			    xtype:  'uniDateRangefield',
			    startFieldName:  'FR_DATE',
			    endFieldName:  'TO_DATE',
			    width:  315,
			    startDate:  UniDate.get('startOfMonth'),
			    endDate:  UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE', newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE', newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
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
				}
	  		}
			return r;
  		}
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
    		fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
    		name: 'DIV_CODE',
    		xtype:  'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
    	}, {
    		xtype: 'uniTextfield',
    		fieldLabel: '<t:message code="system.label.sales.number" default="번호"/>',
    		name: 'PUB_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PUB_NUM', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
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
			fieldLabel:  '오류일자', 
		    xtype:  'uniDateRangefield',
		    startFieldName:  'ERR_FR_DATE',
		    endFieldName:  'ERR_TO_DATE',
		    width:  315,
		    startDate:  UniDate.get('startOfMonth'),
		    endDate:  UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ERR_FR_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ERR_TO_DATE', newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }					    
		}, {
			xtype:  'radiogroup',		            		
    		fieldLabel:  '<t:message code="system.label.sales.classfication" default="구분"/>',			            		
    		items:  [{
    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
    			width:  50,
    			name: 'EB_TYPE',
    			inputValue:  'A',
    			checked:  true
    		}, {
    			boxLabel: '세금계산서', 
    			width:  90, 
    			name:  'EB_TYPE',
    			inputValue:  '1'
    		}, {
    			boxLabel: '거래명세서',
    			width: 90,
    			name: 'EB_TYPE',
    			inputValue: '2'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('EB_TYPE').setValue(newValue.GUBUN);
				}
			}
		}, {
			fieldLabel:  '발행/출고일자', 
		    xtype:  'uniDateRangefield',
		    startFieldName:  'FR_DATE',
		    endFieldName:  'TO_DATE',
		    width:  315,
		    startDate:  UniDate.get('startOfMonth'),
		    endDate:  UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('FR_DATE', newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('TO_DATE', newValue);
		    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }						    
		}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa710skrvGrid', {
    	// for tab    
    	region: 'center',
        layout:  'fit', 
        uniOpt: {
         expandLastColumn:  false
        },
    	store:  directMasterStore1,
        columns: [
        	{dataIndex:  'EB_TYPE'	 	, 				width:100},
        	{dataIndex:  'BILL_DATE'	, 				width:86},
        	{dataIndex:  'CUSTOM_CODE' 	, 				width:100},
        	{dataIndex:  'CUSTOM_NAME' 	, 				width:153},
        	{dataIndex:  'PUB_NUM'	 	, 				width:120},
        	{dataIndex:  'ERR_STEP'	 	, 				width:73},
        	{dataIndex:  'MSG_DESC'	 	, 				width:266},
        	{dataIndex:  'MSG_DETAIL'	, 				width:233,hidden:true},
        	{dataIndex:  'ERR_DATE'	 	, 				width:166},
        	{dataIndex:  'EB_NUM'		, 				width:100}
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
		id :  'ssa710skrvApp',
		fnInitBinding:  function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown:  function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}			
			masterGrid.getStore().loadStoreRecords();				
		},
		onResetButtonDown: function() {
			
			var frm = Ext.getCmp('searchForm');						
			var grid = masterGrid;				
			frm.reset();			
			grid.reset();			
		}
	});

};


</script>
