<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="txt120skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="txt120skrv" /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="YP27" /> <!-- 학기 -->
<t:ExtComboStore comboType="AU" comboCode="YP29" /> <!-- 학년 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	Ext.define("Docs.view.search.Container", {
	extend: "Ext.container.Container",
	alias: "widget.searchcontainer",
	initComponent: function() {
		var me = this;	
    	var searchStore  = Ext.create('Ext.data.Store',{
            fields: [ 
	            {name:'ITEM_NAME', type:'string'}
            ],
            storeId: 'SearchMenuStore',
            autoLoad: false,
            pageSize: 50,
            proxy: {
                type: 'direct',
                api: {
                    read : 'txt120skrvService.searchMenu'
                },
	            reader: {
	                type: 'json',
			<c:choose>
	        	<c:when test="${ext_version == '4.2.2'}">
	        		root: 'records'	//4.2.2
	        	</c:when>		
	        	<c:otherwise>
	        		rootProperty: 'records'	//5.1.0
	        	</c:otherwise>		
	        </c:choose>		                
	            }
            }
        });
		this.items = [{
			fieldLabel:'교재명',
	        xtype: "combobox",
	        autoSelect: false,
  	        store: searchStore,
	        queryMode: 'remote',
//	        pageSize: true, 
	        displayField: 'ITEM_NAME',
	        name: 'ITEM_NAME',
	        minChars: 1,
	        queryParam: 'searchStr',
	        hideTrigger: true,
	        selectOnFocus: false,
	        width: 300,
	        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
			blur: function(){
				var itemID = me.getItemId();
				if(itemID == 'panelSearch'){
					panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
				}else{
					panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
				}
			}
		}];      
    
		this.callParent()
	}
});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Txt120skrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
			{name: 'MAJOR_NAME'			, text: '학과'		, type: 'string'},
			{name: 'GRADE_CODE'			, text: '학년'		, type: 'string'},
			{name: 'SUBJECT_NAME'		, text: '교과목'		, type: 'string'},
			{name: 'PROFESSOR_NAME'		, text: '담당교수'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '교재코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '교재명'		, type: 'string'},
			{name: 'ISBN_CODE'			, text: 'ISBN'		, type: 'string'},
			{name: 'PUBLISHER'			, text: '출판사'		, type: 'string'},
			{name: 'AUTHOR'				, text: '저자1'		, type: 'string'},
			{name: 'AUTHOR2'			, text: '저자2'		, type: 'string'},
			{name: 'TRANSRATOR'			, text: '역자'		, type: 'string'},
			{name: 'SALE_Q'				, text: '매출수량'		, type: 'uniQty'},
			{name: 'SALE_AMT_O'			, text: '매출금액'		, type: 'uniPrice'},
			{name: 'STOCK_Q'			, text: '현재고'		, type: 'uniQty'}
			
		]
	});//End of Unilite.defineModel('Txt120skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('txt120skrvMasterStore1', {
		model: 'Txt120skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'txt120skrvService.selectList'                	
			}
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
});//End var directMasterStore1 = Unilite.createStore('txt120skrvMasterStore1', {

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
			items: [{
			fieldLabel: '사업장', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},
        	Unilite.popup('DEPT', { 
			   		fieldLabel: '부서', 
			   		valueFieldName: 'DEPT_CODE',
			        textFieldName: 'DEPT_NAME',
			    	textFieldWidth: 170,
					allowBlank: false,
			    	listeners: {
			     		onSelected: {
			      			fn: function(records, type) {
			       				panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
			       				panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
			                },
			      			scope: this
			     		},
			     		onClear: function(type) {
			        		panelResult.setValue('DEPT_CODE', '');
			        		panelResult.setValue('DEPT_NAME', '');
			     		}
			    	}
		   }),{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);
			    	}
			    }
			},{
				xtype: 'uniTextfield',
				fieldLabel: '학년도',
				name: 'TXT_YYYY',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXT_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '학기', 
				name: 'TXT_SEQ', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'YP27',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXT_SEQ', newValue);
					}
				}
			},{
				fieldLabel: '학과',
				name: 'MAJOR_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MAJOR_NAME', newValue);
					}
				}
			},{
				fieldLabel: '학년', 
				name: 'GRADE_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'YP29',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GRADE_CODE', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '교과목',
				name: 'SUBJECT_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUBJECT_NAME', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '담당교수',
				name: 'PROFESSOR_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PROFESSOR_NAME', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '교재코드',
				name: 'ITEM_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_CODE', newValue);
					}
				}
			},{
				xtype: 'searchcontainer',
				itemId: 'panelSearch'
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '사업장', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
        	Unilite.popup('DEPT', { 
			   		fieldLabel: '부서', 
			   		valueFieldName: 'DEPT_CODE',
			        textFieldName: 'DEPT_NAME',
			    	textFieldWidth: 170,
					allowBlank: false,
			    	listeners: {
			     		onSelected: {
			      			fn: function(records, type) {
			       				panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
			       				panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
			                },
			      			scope: this
			     		},
			     		onClear: function(type) {
			        		panelSearch.setValue('DEPT_CODE', '');
			        		panelSearch.setValue('DEPT_NAME', '');
			     		}
			    	}
		   }),{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				colspan:2,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);
			    	}
			    }
			},{
				xtype: 'uniTextfield',
				fieldLabel: '학년도',
				name: 'TXT_YYYY',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TXT_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '학기', 
				name: 'TXT_SEQ', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'YP27',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TXT_SEQ', newValue);
					}
				}
			},{
				fieldLabel: '학과',
				name: 'MAJOR_NAME',
				xtype: 'uniTextfield', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAJOR_NAME', newValue);
					}
				}
			},{
				fieldLabel: '학년', 
				name: 'GRADE_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'YP29',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GRADE_CODE', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '교과목',
				name: 'SUBJECT_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SUBJECT_NAME', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '담당교수',
				name: 'PROFESSOR_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PROFESSOR_NAME', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '교재코드',
				name: 'ITEM_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_CODE', newValue);
					}
				}
			},{
				xtype: 'searchcontainer',
				itemId: 'panelResult'
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('txt120skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
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
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: directMasterStore1,
		columns: [  
			{dataIndex: 'COMP_CODE'			, width: 88,hidden:true},  
			{dataIndex: 'MAJOR_NAME'		, width: 130}, 
			{dataIndex: 'GRADE_CODE'		, width: 50,align:'center'}, 
			{dataIndex: 'SUBJECT_NAME'		, width: 100}, 
			{dataIndex: 'PROFESSOR_NAME'	, width: 88,align:'center'}, 
			{dataIndex: 'ITEM_CODE'			, width: 120}, 
			{dataIndex: 'ITEM_NAME'			, width: 250}, 
			{dataIndex: 'ISBN_CODE'			, width: 88}, 
			{dataIndex: 'PUBLISHER'			, width: 110}, 
			{dataIndex: 'AUTHOR'			, width: 88,align:'center'}, 
			{dataIndex: 'AUTHOR2'			, width: 88,align:'center'}, 
			{dataIndex: 'TRANSRATOR'		, width: 88}, 
			{dataIndex: 'SALE_Q'			, width: 88},
			{dataIndex: 'SALE_AMT_O'		, width: 88},
			{dataIndex: 'STOCK_Q'			, width: 88}
		] 
	});//End of var masterGrid = Unilite.createGrid('txt120skrvGrid1', {   
	
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
		id: 'txt120skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
			
			
			panelSearch.setValue('TXT_YYYY',new Date().getFullYear());
        	panelResult.setValue('TXT_YYYY',new Date().getFullYear());
        	txt120skrvService.subCode1({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('TXT_SEQ', provider['SUB_CODE']);
					panelResult.setValue('TXT_SEQ', provider['SUB_CODE']);
				}
			}),
			
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('reset', true);
			
			
		},
		onQueryButtonDown: function() {	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});//End of Unilite.Main( {
};


</script>
