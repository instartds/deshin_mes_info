<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa700skrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="ssa700skrv"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="S052" /> <!--문서단계 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Ssa700skrvModel', {
	    fields: [{name: 'EB_TYPE'			,text:'<t:message code="system.label.sales.classfication" default="구분"/>' 				,type:'string'},
	    		 {name: 'EB_STEP'			,text:'문서단계' 			,type:'string'},
	    		 {name: 'BILL_DATE'			,text:'일자' 				,type:'uniDate'},
	    		 {name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.client" default="고객"/>' 			,type:'string'},
	    		 {name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.clientname" default="고객명"/>' 			,type:'string'},
	    		 {name: 'COMPANY_NUM'		,text:'사업자번호' 		,type:'string'},
	    		 {name: 'SUPPLY_AMT_I'		,text:'<t:message code="system.label.sales.supplyamount" default="공급가액"/>' 			,type:'uniPrice'},
	    		 {name: 'TAX_AMT_I'			,text:'<t:message code="system.label.sales.taxamount" default="세액"/>' 				,type:'uniPrice'},
	    		 {name: 'TOT_AMT_I'			,text:'<t:message code="system.label.sales.totalamount" default="합계"/>' 				,type:'uniPrice'},
	    		 {name: 'PUB_NUM'			,text:'<t:message code="system.label.sales.number" default="번호"/>' 				,type:'string'},
	    		 {name: 'SEND_LOG_TIME'		,text:'전송일시' 			,type:'string'},
	    		 {name: 'EB_NUM'	   		,text:'전자문서번호' 		,type:'string'}
	    		
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa700skrvMasterStore1',{
			model: 'Ssa700skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa700skrvService.selectList'  
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log(param);					
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
			layout : {type : 'uniTable', columns : 1},
        	items : [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name:'DIV_CODE',
        		xtype: 'uniCombobox',
        		comboType:'BOR120',
        		allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	}, {
        		fieldLabel: '일자', 
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_DATE',
			    endFieldName: 'TO_DATE',
			    width: 315,
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today'),                	
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
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel		: '고객처', 
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
				fieldLabel: '문서단계'	,
				name:'EB_STEP',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S052',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EB_STEP', newValue);
					}
				}
			}, {
				xtype: 'radiogroup',		            		
        		fieldLabel: '<t:message code="system.label.sales.classfication" default="구분"/>',			            		
        		items : [{
        			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
        			width: 50,
        			name: 'EB_TYPE',
        			inputValue: 'A',
        			checked: true
        		}, {
        			boxLabel: '세금계산서',
        			width: 90,
        			name: 'EB_TYPE',
        			inputValue: '1'
        		}, {
        			boxLabel: '거래명세서',
        			width: 90,
        			name: 'EB_TYPE' ,
        			inputValue: '2'
        		}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('EB_TYPE').setValue(newValue.EB_TYPE);
					}
				}
			}, {
				xtype:'uniTextfield',
				fieldLabel:'<t:message code="system.label.sales.number" default="번호"/>',
				name:'PUB_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PUB_NUM', newValue);
					}
				}
			}]
		}], setAllFieldsReadOnly: function(b) {
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
    		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    		name:'DIV_CODE',
    		xtype: 'uniCombobox',
    		comboType:'BOR120',
    		allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
    	}, {
    		fieldLabel: '일자', 
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
		    width: 315,
		    startDate: UniDate.get('startOfMonth'),
		    endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel		: '고객처', 
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
			fieldLabel: '문서단계'	,
			name:'EB_STEP',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S052',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EB_STEP', newValue);
				}
			}
		}, {
			xtype: 'radiogroup',		            		
    		fieldLabel: '<t:message code="system.label.sales.classfication" default="구분"/>',			            		
    		items : [{
    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
    			width: 50,
    			name: 'EB_TYPE',
    			inputValue: 'A',
    			checked: true
    		}, {
    			boxLabel: '세금계산서',
    			width: 90,
    			name: 'EB_TYPE',
    			inputValue: '1'
    		}, {
    			boxLabel: '거래명세서',
    			width: 90,
    			name: 'EB_TYPE' ,
    			inputValue: '2'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('EB_TYPE').setValue(newValue.EB_TYPE);
				}
			}
		}, {
			xtype:'uniTextfield',
			fieldLabel:'<t:message code="system.label.sales.number" default="번호"/>',
			name:'PUB_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PUB_NUM', newValue);
				}
			}
		}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa700skrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
        columns: [   
        	{dataIndex: 'EB_TYPE'		        , width:100},
        	{dataIndex: 'EB_STEP'		        , width:86},
        	{dataIndex: 'BILL_DATE'		        , width:100},
        	{dataIndex: 'CUSTOM_CODE'	        , width:73},
        	{dataIndex: 'CUSTOM_NAME'	        , width:153},
        	{dataIndex: 'COMPANY_NUM'	        , width:93},
        	{dataIndex: 'SUPPLY_AMT_I'	        , width:93},
        	{dataIndex: 'TAX_AMT_I'		        , width:93},
        	{dataIndex: 'TOT_AMT_I'		        , width:93},
        	{dataIndex: 'PUB_NUM'		        , width:120},
        	{dataIndex: 'SEND_LOG_TIME'         , width:160},
        	{dataIndex: 'EB_NUM'	            , width:120}
        	
               		
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
		id: 'ssa700skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}			
			masterGrid.getStore().loadStoreRecords();
					
				
		},
		onResetButtonDown:function() {
			
			var frm = Ext.getCmp('searchForm');						
			var grid = masterGrid;				
			frm.reset();			
			grid.reset();			
		}
	});

};


</script>
