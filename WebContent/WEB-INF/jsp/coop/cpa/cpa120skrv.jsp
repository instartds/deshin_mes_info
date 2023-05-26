<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cpa120skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="cpa120skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="YP11"/>	<!-- 조합원구분 	-->
<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 예/아니오 	-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('cpa120skrvModel', {
	    fields: [
	    	{name:'COMP_CODE' 				, text: '법인코드'			, type: 'string'},
	    	{name:'DIV_CODE' 				, text: '사업장'			, type: 'string'}, 
	    	{name:'COOPTOR_NAME' 			, text: '성명'			, type: 'string'},
	    	{name:'INOUT_Q' 				, text: '구좌'			, type: 'uniQty'},
	    	{name:'UNIV_NUMB' 				, text: '학번'			, type: 'string'},
	    	{name:'COOPTOR_TYPE' 			, text: '구분'			, type: 'string', comboType:"AU", comboCode:"YP11"},
	    	{name:'BANK_CODE' 				, text: '은행명'			, type: 'string'},
	    	{name:'BANKBOOK_NUM' 			, text: '계좌번호'			, type: 'string'},
	    	{name:'GRADUATE_YN' 			, text: '졸업여부'			, type: 'string' , comboType:"AU", comboCode:"B010"},
	    	{name:'GRADUATE_DATE' 			, text: '졸업일자'			, type: 'uniDate'},
	    	{name:'REPAYMENT_YN' 			, text: '반환여부'			, type: 'string' , comboType:"AU", comboCode:"B010"},
	    	{name:'REPAYMENT_DATE' 			, text: '반환일자'			, type: 'uniDate'},
	    	/* 2015.12.28 추가*/
	    	{name:'START_DATE' 				, text: '가입일자'			, type: 'uniDate'},
	    	{name:'INVEST_DATE' 			, text: '변동일자'			, type: 'uniDate'}, 
	    	{name:'INOUT_TYPE' 				, text: '변동구분'			, type: 'string'}

	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('cpa120skrvMasterStore',{
			model: 'cpa120skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'cpa120skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			}
	});		// End of var MasterStore 
	
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
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '구분',
				name: 'COOPTOR_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP11',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_TYPE', newValue);
					}
				}
			},{
			    fieldLabel: '조합원명',
				name: 'COOPTOR_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_NAME', newValue);
					}
				}
			},{ 
		        fieldLabel: '가입일자', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'START_DATE_FR',
				endFieldName: 'START_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('START_DATE_FR',newValue);
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('START_DATE_TO',newValue);				  	
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '졸업여부',						            		
				items: [{
					boxLabel: '전체', 
					width: 60, 
					name: 'GRADUATE_YN',
					inputValue: ''
				},{
					boxLabel: '졸업', 
					width: 70, 
					name: 'GRADUATE_YN',
					inputValue: 'Y'
				},{
					boxLabel : '미졸업', 
					width: 70,
					name: 'GRADUATE_YN',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('GRADUATE_YN').setValue(newValue.GRADUATE_YN);
							}
						}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '출자금여부',						            		
				items: [{
					boxLabel: '전체', 
					width: 60, 
					name: 'REPAYMENT_YN',
					inputValue: ''
				},{
					boxLabel: '반환자', 
					width: 70, 
					name: 'REPAYMENT_YN',
					inputValue: 'Y'
				},{
					boxLabel : '미반환자', 
					width: 70,
					name: 'REPAYMENT_YN',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('REPAYMENT_YN').setValue(newValue.REPAYMENT_YN);
							}
						}
			},{ 
		        fieldLabel: '변동일자', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'INVEST_DATE_FR',
				endFieldName: 'INVEST_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('INVEST_DATE_FR',newValue);
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INVEST_DATE_TO',newValue);				  	
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
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
			fieldLabel: '구분',
			name: 'COOPTOR_TYPE' ,
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'YP11',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_TYPE', newValue);
				}
			}
		},{
		    fieldLabel: '조합원명',
			name: 'COOPTOR_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_NAME', newValue);
				}
			}
		},{ 
		        fieldLabel: '가입일자', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'START_DATE_FR',
				endFieldName: 'START_DATE_TO',
				colspan:2,
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('START_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('START_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '졸업여부',						            		
				items: [{
					boxLabel: '전체', 
					width: 60, 
					name: 'GRADUATE_YN',
					inputValue: ''
				},{
					boxLabel: '졸업', 
					width: 70, 
					name: 'GRADUATE_YN',
					inputValue: 'Y'
				},{
					boxLabel : '미졸업', 
					width: 70,
					name: 'GRADUATE_YN',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelSearch.getField('GRADUATE_YN').setValue(newValue.GRADUATE_YN);
							}
						}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '출자금',						            		
				items: [{
					boxLabel: '전체', 
					width: 60, 
					name: 'REPAYMENT_YN',
					inputValue: ''
				},{
					boxLabel: '반환자', 
					width: 70, 
					name: 'REPAYMENT_YN',
					inputValue: 'Y'
				},{
					boxLabel : '미반환자', 
					width: 70,
					name: 'REPAYMENT_YN',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelSearch.getField('REPAYMENT_YN').setValue(newValue.REPAYMENT_YN);
							}
						}
			},{ 
		        fieldLabel: '변동일자', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'INVEST_DATE_FR',
				endFieldName: 'INVEST_DATE_TO',
				colspan:2,
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INVEST_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INVEST_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
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
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('cpa120skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
			{dataIndex:'COMP_CODE' 	  							, width: 100, hidden:true},
			{dataIndex:'DIV_CODE' 	  							, width: 100, hidden:true},
			{dataIndex:'COOPTOR_NAME' 		  					, width: 100 
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
            {dataIndex:'INOUT_Q' 			  					, width: 66  , summaryType: 'sum'},
            {dataIndex:'START_DATE' 			  				, width: 100 },
            {dataIndex:'INVEST_DATE' 			  				, width: 100 },
			{dataIndex:'INOUT_TYPE' 			  				, width: 88  },
			{dataIndex:'UNIV_NUMB' 	  							, width: 120 },
			{dataIndex:'COOPTOR_TYPE' 	  						, width: 88  },
			{dataIndex:'BANK_CODE' 			  					, width: 100 },
			{dataIndex:'BANKBOOK_NUM' 		  					, width: 180 },
			{dataIndex:'GRADUATE_YN'   							, width: 100 },
			{dataIndex:'GRADUATE_DATE' 		  					, width: 100 },
			{dataIndex:'REPAYMENT_YN' 			  				, width: 100 },
			{dataIndex:'REPAYMENT_DATE' 			  			, width: 100 }

		]
    });		//End of var masterGrid 
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'cpa120skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			panelSearch.setValue('START_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('START_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('START_DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('GRADUATE_YN','N');
			panelResult.setValue('GRADUATE_YN','N');
			
			panelSearch.setValue('REPAYMENT_YN','N');
			panelResult.setValue('REPAYMENT_YN','N');
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
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
