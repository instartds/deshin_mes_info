<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep700skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aep700skrService.selectList'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aep700skrModel', {		
	    fields: [	 	
				 {name: 'CUSTOM_CODE'		    	,text: '파트너유형' 		,type: 'string'},			 	 	
				 {name: 'CUSTOM_FULL_NAME'	    	,text: '생성차수' 			,type: 'string'},			 	 	
				 {name: 'VENDOR_GROUP_CODE'	    	,text: '계정그룹' 			,type: 'string' , comboType: 'AU', comboCode: 'J697'},			 	 	
				 {name: 'COMPANY_NUM'	    	 	,text: '사업자번호' 		,type: 'string'},			 	 	
				 {name: 'VENDOR_CORP_NO'		 	,text: '법인번호' 			,type: 'string'},			 	 	
				 {name: 'TOP_NAME'		 			,text: '대표이사' 			,type: 'string'},			 	 	
				 {name: 'COMP_CLASS'	    	 	,text: '업종' 			,type: 'string'},			 	 	
				 {name: 'COMP_TYPE'			 		,text: '업태' 			,type: 'string'}
		]
	});		
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('aep700skrMasterStore1',{
		model: 'Aep700skrModel',
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
	    		fieldLabel: '등록일자',
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
        		fieldLabel: '계정그룹',
        		name: 'VENDOR_GROUP_CODE',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'J697',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('VENDOR_GROUP_CODE', newValue);
					}
				}
        	},		    
	    	Unilite.popup('CUST',{
	    		extParam : {'CUSTOM_TYPE': ['1','2','3']},
		    	fieldLabel: '거래처명',
				autoPopup   : true ,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
		    }),{
				fieldLabel: '사업자번호',
				name:'COMPANY_NUM', 
				xtype: 'uniTextfield', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COMPANY_NUM', newValue);
					}
				}
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				items :[{
					xtype: 'radiogroup',		            		
					fieldLabel: '등록경로',
					items: [{
						boxLabel: '전체', 
						width: 70,
						name: 'ABC',
						inputValue: '',
						checked: true  
					},{
						boxLabel: 'JBILL', 
						width: 70,
						name: 'ABC',
						inputValue: '1' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('ABC').setValue(newValue.ABC);					
						}
					}
				}
			]}]		
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
    		fieldLabel: '등록일자',
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
    		fieldLabel: '계정그룹',
    		name: 'VENDOR_GROUP_CODE',
    		xtype: 'uniCombobox',
    		comboType: 'AU',
    		comboCode: 'J697',
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('VENDOR_GROUP_CODE', newValue);
				}
			}
    	},		    
    	Unilite.popup('CUST',{
    		extParam : {'CUSTOM_TYPE': ['1','2','3']},
	    	fieldLabel: '거래처명',
			autoPopup   : true ,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
	    }),{
			fieldLabel: '사업자번호',
			name:'COMPANY_NUM', 
			xtype: 'uniTextfield', 
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COMPANY_NUM', newValue);
				}
			}
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '등록경로',
				items: [{
					boxLabel: '전체', 
					width: 70,
					name: 'ABC',
					inputValue: '',
					checked: true  
				},{
					boxLabel: 'JBILL', 
					width: 70,
					name: 'ABC',
					inputValue: '1' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ABC').setValue(newValue.ABC);					
					}
				}
			}
		]}],
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
    
    var masterGrid = Unilite.createGrid('aep700skrGrid', {
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
        		   { dataIndex: 'CUSTOM_CODE'			 	,	width:120},
        		   { dataIndex: 'CUSTOM_FULL_NAME'		 	,	width:200},
        		   { dataIndex: 'VENDOR_GROUP_CODE'			,	width:120},
        		   { dataIndex: 'COMPANY_NUM'	    		,	width:120},
        		   { dataIndex: 'VENDOR_CORP_NO'		 	,	width:120},
        		   { dataIndex: 'TOP_NAME'		 		 	,	width:120},
        		   { dataIndex: 'COMP_CLASS'	    	 	,	width:120},
        		   { dataIndex: 'COMP_TYPE'					,	width:120}
        		   
        ],
        listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(!Ext.isEmpty(record.get('CUSTOM_CODE'))){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			//if(event.position.column.dataIndex == 'CUSTOM_CODE'){
	        	return true;
	        //}
      	},
		gotoAep700ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'aep700skr',
					'CUSTOM_CODE' : record.data['CUSTOM_CODE'],
					'CUSTOM_NAME' : record.data['CUSTOM_FULL_NAME']
				}
		  		var rec1 = {data : {prgID : 'aep700ukr', 'text':''}};							
				parent.openTab(rec1, '/jbill/aep700ukr.do', params);
			}
    	},
    	uniRowContextMenu:{
			items: [
	            {	text: '거래처등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAep700ukr(param.record);
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
		id  : 'aep700skrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('INSERT_DB_TIME_FR');
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);   
			
			panelSearch.setValue('INSERT_DB_TIME_FR'  , UniDate.get('startOfMonth'));
			panelSearch.setValue('INSERT_DB_TIME_TO'  , UniDate.get('today'));
			panelResult.setValue('INSERT_DB_TIME_FR'  , UniDate.get('startOfMonth'));
			panelResult.setValue('INSERT_DB_TIME_TO'  , UniDate.get('today'));

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
			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
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
