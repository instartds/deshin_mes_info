<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ210skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 --> 	
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


		
	Unilite.defineModel('equ210skrvModel', {
	    fields: [  	  
	    	{name: 'CONTROL_NO'				,text: '관리번호'		,type: 'string'},
	    	{name: 'ASSETS_NO'				,text: '고정자산번호'		,type: 'string'},
	    	{name: 'PRODUCT_NAME'					,text: '품명'			,type: 'string'},
	    	{name: 'SPEC'			,text: '규격'		,type: 'string'},
	    	{name: 'MAKER'			,text: '제작처'		,type: 'string'},
	    	{name: 'MAKER_NAME'				,text: '제작처명'		,type: 'string'},
	    	{name: 'MAKE_DT'	   		,text: '제작년월'		,type: 'uniDate'},
	    	{name: 'MAKE_Q'	   		,text: '수량'		,type: 'uniQty'},
	    	{name: 'MAKE_O'	   		,text: '제작금액'		,type: 'uniPrice'},
	    	{name: 'STATE'			,text: '상태'		,type: 'string'},
	    	{name: 'KEEPER'	   		,text: '보관처'		,type: 'string'},
	    	{name: 'KEEPER_NAME'	   		,text: '보관처명'		,type: 'string'},
	    	{name: 'AMEND_O'	   	,text: '수정금액'		,type: 'uniPrice'},
	    	{name: 'WEIGHT'	   		,text: '중량'		,type: 'string'},
	    	{name: 'PRODT_KIND'	   		,text: '금형종류'		,type: 'string'},
	    	{name: 'MTRL_KIND'	   		,text: '재질'		,type: 'string'},
	    	{name: 'MTRL_TEXT'	   		,text: '기타'		,type: 'string'}
	     
		]
	});		// end of Unilite.defineModel('equ210skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('equ210skrvMasterStore1',{
			model: 'equ210skrvModel',
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
                	   read: 'equ210skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items:[{
		        fieldLabel: '제작년월',
		        xtype: 'uniDateRangefield',  
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('aMonthAgo'),
				endDate: UniDate.get('today'),
				
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
	        	fieldLabel: '품명', 
				xtype: 'uniTextfield',
				name:'PRODUCT_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PRODUCT_NAME', newValue);
					}
				}
		    },	Unilite.popup('CUST', { 
					fieldLabel: '제작처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
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
		        fieldLabel: '보유상태',
		        name:'STATE', 
		        xtype: 'uniCombobox', 
		        comboType:'AU', 
		        comboCode:'I801',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('STATE', newValue);
					}
				}
	        }, {
	        	fieldLabel: '관리번호', 
				xtype: 'uniTextfield',
				name:'CTRL_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CTRL_NO', newValue);
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        fieldLabel: '제작년월',
		        xtype: 'uniDateRangefield',  
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				colspan:2,
				startDate: UniDate.get('aMonthAgo'),
				endDate: UniDate.get('today'),
			
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
	        	fieldLabel: '', 
				xtype: 'uniTextfield',
				hidden:true
				
		    },{
	        	fieldLabel: '품명', 
				xtype: 'uniTextfield',
				name:'PRODUCT_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PRODUCT_NAME', newValue);
					}
				}
		    },Unilite.popup('CUST', { 
					fieldLabel: '제작처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
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
		        fieldLabel: '보유상태',
		        name:'STATE', 
		        xtype: 'uniCombobox', 
		        comboType:'AU', 
		        comboCode:'I801',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('STATE', newValue);
					}
				}
	        }, {
	        	fieldLabel: '관리번호', 
				xtype: 'uniTextfield',
				name:'CTRL_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CTRL_NO', newValue);
					}
				}
		    }]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('equ210skrvGrid1', {
    	// for tab    	
        layout: 'fit',
        region: 'center',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: false 
        },
    	    {id: 'masterGridTotal', 	
    	    ftype: 'uniSummary',
    	    showSummaryRow: false} 
    	],
    	store: directMasterStore1,
        columns:  [  
        	{ dataIndex: 'CONTROL_NO'		     ,   width: 120},
        	{ dataIndex: 'ASSETS_NO'		     ,   width: 146},
        	{ dataIndex: 'PRODUCT_NAME'			     	 ,   width: 133},
        	{ dataIndex: 'SPEC'			 ,   width: 120},
        	{ dataIndex: 'MAKER'		 ,   width: 120},
        	{ dataIndex: 'MAKER_NAME'		 ,   width: 120},
        	{ dataIndex: 'MAKE_DT'		 ,   width: 120},
        	{ dataIndex: 'MAKE_Q'		 ,   width: 120},
        	{ dataIndex: 'MAKE_O'		 ,   width: 120},
        	{ dataIndex: 'STATE'		 ,   width: 120},
        	{ dataIndex: 'KEEPER'		 ,   width: 120,hidden:true},
        	{ dataIndex: 'KEEPER_NAME'		 ,   width: 120},
        	{ dataIndex: 'AMEND_O'		 ,   width: 120},
        	{ dataIndex: 'KEEPER'		 ,   width: 120},
        	{ dataIndex: 'KEEPER_NAME'		 ,   width: 120},
        	{ dataIndex: 'AMEND_O'		 ,   width: 120},
        	{ dataIndex: 'WEIGHT'		 ,   width: 120},
        	{ dataIndex: 'PRODT_KIND'		 ,   width: 120},
        	{ dataIndex: 'MTRL_KIND'		 ,   width: 120},
        	{ dataIndex: 'MTRL_TEXT'		 ,   width: 120}
        	
	    	
       
		] 
    });		// end of var masterGrid = Unilite.createGrid('equ210skrvGrid1', {   
	
	
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
		id  : 'equ210skrvApp',
		fnInitBinding : function() {

			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
			masterGrid.getStore().loadStoreRecords();

		}
	});

};


</script>
