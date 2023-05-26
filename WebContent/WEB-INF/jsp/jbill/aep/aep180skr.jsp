<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep180skr"  >
<style type="text/css">
<t:ExtComboStore comboType="AU" comboCode="J682"/>	<!-- 전표상태	-->
<t:ExtComboStore comboType="AU" comboCode="J604"/>	<!-- 선급금정산상태코드	-->


#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = { 
	paySysGubun: '${paySysGubun}'      // MIS , SAP 구분관련   
	
}

var gsCustomCode   = '${gsCustomCode}';
var gsCustomName   = '${gsCustomName}';
var gsCompanyNum   = '${gsCompanyNum}';

var personName   = '${personName}';

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aep180skrService.selectList'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep180skrModel', {		
	    fields: [	 	
				 {name: 'ELEC_SLIP_NO'   			,text: '전표번호'		,type: 'string'},			 	 	
				 {name: 'GL_DATE'   				,text: '회계일자'		,type: 'uniDate'},			 	 	
				 {name: 'SLIP_DESC'   				,text: '사용내역'		,type: 'string'},			 	 	
				 {name:	'NOT_CMOPLETE_AMT' 			,text: '전표금액'		,type: 'uniPrice'},			 	 	
				 {name:	'COMPLETE_AMT' 				,text: '정산금액'		,type: 'uniPrice'},			 	 	
				 {name:	'NOT_EXCT_AMT'				,text: '미정산금액'		,type: 'uniPrice'},			 	 	
				 {name:	'P_SLIP_STAT' 				,text: '전표상태'		,type: 'string' , comboType:'AU', comboCode:'J682'},		
				 {name: 'ADVM_EXCT_STAT_CD'   		,text: '정산상태'		,type: 'string' , comboType:'AU', comboCode:'J604'},			 	 	
				 {name: 'PROCESS2'   				,text: '정산처리'		,type: 'string'}
		]
	});		
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('aep180skrMasterStore1',{
		model: 'aep180skrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,		// 수정 모드 사용 
        	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
   	 	proxy: directProxy,
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
		    items : [{ 
	    		fieldLabel: '신청일자',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'INSERT_DB_TIME_FR',
			    endFieldName: 'INSERT_DB_TIME_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('INSERT_DB_TIME_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('INSERT_DB_TIME_TO', newValue);				    		
			    	}
			    }
			},{
        		fieldLabel: '정산상태',
        		name: 'ADVM_EXCT_STAT_CD',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'J604',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ADVM_EXCT_STAT_CD', newValue);
					}
				}
        	},		    
            Unilite.popup('CUST',{
                fieldLabel: '지급처', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'VENDOR_ID',
                textFieldName:'VENDOR_NM',
                autoPopup:true,
                listeners: {
                	onValueFieldChange: function(field, newValue){
                        panelResult.setValue('VENDOR_ID', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('VENDOR_NM', newValue);             
                    },
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('VENDOR_SITE_CD', records[0].COMPANY_NUM);
                            panelSearch.setValue('VENDOR_SITE_CD', records[0].COMPANY_NUM);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('VENDOR_SITE_CD', '');
                        panelSearch.setValue('VENDOR_SITE_CD', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'ADD_QUERY': "ISNULL(A.VENDOR_GROUP_CODE,'')!='V090'"});                           
                    }
                }
            }),
            {
                xtype: 'uniTextfield',
                fieldLabel:' ',
                name: 'VENDOR_SITE_CD',
                readOnly:true
            },
		    
		    
		    Unilite.popup('DEPT', {
				fieldLabel: '발생부서',
				valueFieldName: 'DEPT_CODE', 
				textFieldName: 'DEPT_NAME', 
				listeners: {
					onValueFieldChange: function(field, newValue){
	                    panelResult.setValue('DEPT_CODE', newValue);                              
	                },
	                onTextFieldChange: function(field, newValue){
	                    panelResult.setValue('DEPT_NAME', newValue);             
	                }
				}
			}),
			Unilite.popup('Employee',{
                fieldLabel: '신청자', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('PERSON_NUMB', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('NAME', newValue);             
                    },
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('POST_CODE_NAME',  records[0].POST_CODE_NAME);
                            panelSearch.setValue('PERSON_DEPT_NAME',  records[0].DEPT_NAME);
                            panelResult.setValue('POST_CODE_NAME',  records[0].POST_CODE_NAME);
                            panelResult.setValue('PERSON_DEPT_NAME',  records[0].DEPT_NAME);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('POST_CODE_NAME'   ,  '');
                        panelSearch.setValue('PERSON_DEPT_NAME' ,  '');
                        panelResult.setValue('POST_CODE_NAME'   ,  '');
                        panelResult.setValue('PERSON_DEPT_NAME' ,  '');
                    }
                }
            }),
			{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                items :[
                {
                    xtype: 'uniTextfield',
                    fieldLabel:' ',
                    name: 'POST_CODE_NAME',
                    width:200,
                    readOnly:true
                },{
                    xtype: 'uniTextfield',
                    fieldLabel:'',
                    name: 'PERSON_DEPT_NAME',
                    width:140,
                    readOnly:true
                }]
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
		}
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
    		fieldLabel: '신청일자',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'INSERT_DB_TIME_FR',
		    endFieldName: 'INSERT_DB_TIME_TO',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('INSERT_DB_TIME_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('INSERT_DB_TIME_TO', newValue);				    		
		    	}
		    }
		},{
    		fieldLabel: '정산상태',
    		name: 'ADVM_EXCT_STAT_CD',
    		xtype: 'uniCombobox',
    		comboType: 'AU',
    		comboCode: 'J604',
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('VENDOR_GROUP_CODE', newValue);
				}
			}
    	},		    
    	{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:470,
//            padding:'10 10 0 10',
            items :[
            Unilite.popup('CUST',{
                fieldLabel: '지급처', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'VENDOR_ID',
                textFieldName:'VENDOR_NM',
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('VENDOR_ID', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('VENDOR_NM', newValue);             
                    },
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('VENDOR_SITE_CD', records[0].COMPANY_NUM);
                            panelSearch.setValue('VENDOR_SITE_CD', records[0].COMPANY_NUM);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('VENDOR_SITE_CD', '');
                        panelSearch.setValue('VENDOR_SITE_CD', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'ADD_QUERY': "ISNULL(A.VENDOR_GROUP_CODE,'')!='V090'"});                           
                    }
                }
            }),
            {
                xtype: 'uniTextfield',
                fieldLabel:'',
                name: 'VENDOR_SITE_CD',
                width:110,
                readOnly:true
            }]
        },
	    Unilite.popup('DEPT', {
			fieldLabel: '발생부서',
			valueFieldName: 'DEPT_CODE', 
			textFieldName: 'DEPT_NAME', 
			listeners: {
				onValueFieldChange: function(field, newValue){
                    panelResult.setValue('DEPT_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelResult.setValue('DEPT_NAME', newValue);             
                }
			}
		}),
        
        {
            xtype: 'container',
            layout: {type : 'uniTable', columns : 3},
            items :[
            Unilite.popup('Employee',{
                fieldLabel: '신청자', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('PERSON_NUMB', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('NAME', newValue);             
                    },
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('POST_CODE_NAME',  records[0].POST_CODE_NAME);
                            panelSearch.setValue('PERSON_DEPT_NAME',  records[0].DEPT_NAME);
                            panelResult.setValue('POST_CODE_NAME',  records[0].POST_CODE_NAME);
                            panelResult.setValue('PERSON_DEPT_NAME',  records[0].DEPT_NAME);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('POST_CODE_NAME'   ,  '');
                        panelSearch.setValue('PERSON_DEPT_NAME' ,  '');
                        panelResult.setValue('POST_CODE_NAME'   ,  '');
                        panelResult.setValue('PERSON_DEPT_NAME' ,  '');
                    }
                }
            }),
            {
                xtype: 'uniTextfield',
                fieldLabel:'',
                name: 'POST_CODE_NAME',
                width:140,
                readOnly:true
            },{
                xtype: 'uniTextfield',
                fieldLabel:'',
                name: 'PERSON_DEPT_NAME',
                width:140,
                readOnly:true
            }]
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
    
    var masterGrid = Unilite.createGrid('aep180skrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	uniOpt : {
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		    filter: {
				useFilter	: false,		
				autoCreate	: true		
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        		   { dataIndex: 'ELEC_SLIP_NO'   		 	,	width:140},
        		   { dataIndex: 'GL_DATE'   			 	,	width:100},
        		   { dataIndex: 'SLIP_DESC'   				,	width:300},
        		   { dataIndex: 'NOT_CMOPLETE_AMT' 			,	width:100},
        		   { dataIndex: 'COMPLETE_AMT' 			 	,	width:100},
        		   { dataIndex: 'NOT_EXCT_AMT'			 	,	width:100},
        		   { dataIndex: 'P_SLIP_STAT' 			 	,	width:100},
        		   { dataIndex: 'ADVM_EXCT_STAT_CD' 		,	width:88},
        		   { dataIndex: 'PROCESS2'   				,	width:100}
        		  /* { dataIndex: 'TEST9'		,   width: 105,
			          align: 'center',
			          xtype: 'actioncolumn',
			          width:200,
			          items: [{
		                  icon: CPATH+'/resources/css/theme_01/calculate.png',
		                  handler: function(grid, rowIndex, colIndex, item, e, record) {
		                  	
		                  }
			          }]
        		  }*/
        ],
        listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(!Ext.isEmpty(record.get('TEST9'))){ // 정산처리 NAME
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			//if(event.position.column.dataIndex == 'CUSTOM_CODE'){
	        	return true;
	        //}
      	},
		gotoAep140ukr:function(record)	{		// 전자세금계산서 Link
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'aep180skr'
					//'CUSTOM_NAME' : record.data['CUSTOM_FULL_NAME']
				}
		  		var rec1 = {data : {prgID : 'aep140ukr', 'text':''}};							
				parent.openTab(rec1, '/jbill/aep140ukr.do', params);
			}
    	},
    	gotoAep120ukr:function(record)	{		// 세금계산서 Link
			if(record)	{
		    	var params = {
					'PGM_ID' : 'aep180skr'
					//'CUSTOM_NAME' : record.data['CUSTOM_FULL_NAME']
				}
		  		var rec1 = {data : {prgID : 'aep120ukr', 'text':''}};							
				parent.openTab(rec1, '/jbill/aep120ukr.do', params);
			}
    	},
    	gotoAep110ukr:function(record)	{		// 실물증빙 Link
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'aep180skr'
					//'CUSTOM_NAME' : record.data['CUSTOM_FULL_NAME']
				}
		  		var rec1 = {data : {prgID : 'aep110ukr', 'text':''}};							
				parent.openTab(rec1, '/jbill/aep110ukr.do', params);
			}
    	},
    	uniRowContextMenu:{
			items: [
				{	text: '전자세금계산서',   
	            	itemId	: 'linkAep140ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAep140ukr(param.record);
	            	}
	        	},{	text: '세금계산서',  
	            	itemId	: 'linkAep120ukr', 
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAep120ukr(param.record);
	            	}
	        	},{	text: '실물증빙',  
	            	itemId	: 'linkAep110ukr', 
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAep110ukr(param.record);
	            	}
	        	}
	        ]
	    }
    });   	
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid
			]
		},
			panelSearch	
		],
		id  : 'aep180skrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('INSERT_DB_TIME_FR');
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);   
			
			panelSearch.setValue('DEPT_CODE'  , UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME'  , UserInfo.deptName);
			panelResult.setValue('DEPT_CODE'  , UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'  , UserInfo.deptName);
			
			panelSearch.setValue('INSERT_DB_TIME_FR'  , UniDate.get('startOfMonth'));
			panelSearch.setValue('INSERT_DB_TIME_TO'  , UniDate.get('today'));
			panelResult.setValue('INSERT_DB_TIME_FR'  , UniDate.get('startOfMonth'));
			panelResult.setValue('INSERT_DB_TIME_TO'  , UniDate.get('today'));
			
			panelSearch.setValue('ADVM_EXCT_STAT_CD'  , '10');
            panelResult.setValue('ADVM_EXCT_STAT_CD'  , '10');
			

            if(BsaCodeInfo.paySysGubun == '1'){
                panelSearch.setValue('VENDOR_ID',gsCustomCode);
                panelSearch.setValue('VENDOR_NM',gsCustomName);
                panelSearch.setValue('VENDOR_SITE_CD',gsCompanyNum);
                
                panelResult.setValue('VENDOR_ID',gsCustomCode);
                panelResult.setValue('VENDOR_NM',gsCustomName);
                panelResult.setValue('VENDOR_SITE_CD',gsCompanyNum);
            }else if(BsaCodeInfo.paySysGubun == '2'){
                panelSearch.setValue('VENDOR_ID',UserInfo.personNumb);
                panelSearch.setValue('VENDOR_NM',personName);
                panelSearch.setValue('VENDOR_SITE_CD','');
                
                panelResult.setValue('VENDOR_ID',UserInfo.personNumb);
                panelResult.setValue('VENDOR_NM',personName);
                panelResult.setValue('VENDOR_SITE_CD','');
            }
            
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.reset();
			directMasterStore1.clearData();
			
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);	
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
