<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="txt110skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="txt110skrv"/> 						<!-- 사업장 -->  
<t:ExtComboStore comboType="AU" comboCode="YP27" /> <!-- 학기 -->
<t:ExtComboStore comboType="AU" comboCode="YP28" /> <!-- 개설구분 -->
<t:ExtComboStore comboType="AU" comboCode="YP29" /> <!-- 학년 -->
<t:ExtComboStore comboType="AU" comboCode="YP30" /> <!-- 교재구분 -->
<t:ExtComboStore comboType="AU" comboCode="YP31" /> <!-- 자료구분 -->
<t:ExtComboStore comboType="AU" comboCode="YP34" /> <!-- 학과 -->

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
                    read : 'txt110skrvService.searchMenu'
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

	Unilite.defineModel('Txt110skrvModel', {
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
			{name: 'SALE_BASIS_P'		, text: '정가'		, type: 'uniPrice'},
			{name: 'PUB_DATE'			, text: '출판일'		, type: 'uniDate'},
			{name: 'COLLEGE_TYPE'		, text: '개설구분'		, type: 'string',comboType:'AU', comboCode:'YP28'},
			{name: 'TXTBOOK_TYPE'		, text: '교재구분'		, type: 'string',comboType:'AU', comboCode:'YP30'},
			{name: 'PEOPLE_NUM'			, text: '수강인원'		, type: 'uniQty'},
			{name: 'USE_TYPE'			, text: '자료구분'		, type: 'string',comboType:'AU', comboCode:'YP31'},
			{name: 'YN'					, text: '등록여부'		, type: 'string',comboType:'AU', comboCode:'B081'},
			{name: 'STOCK_Q'			, text: '재고수량'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '비고'		, type: 'string'},
			{name: 'COLLEGE_TYPE'		, text: '대학'		, type: 'string'},
			{name: 'SONGDOYN'			, text: '캠퍼스구분'	, type: 'string'}
		]
	});//End of Unilite.defineModel('Txt110skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('txt110skrvMasterStore1', {
		model: 'Txt110skrvModel',
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
				read: 'txt110skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
				this.load({
					params: param
				});
		}
});//End var directMasterStore1 = Unilite.createStore('txt110skrvMasterStore1', {

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
				xtype: 'uniTextfield',
				fieldLabel: '학년도',
				name: 'TXT_YYYY',
				value: new Date().getFullYear(),  
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
				comboType: 'AU', 
				comboCode: 'YP34',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MAJOR_NAME', newValue);
					}
				}
			},{
				fieldLabel: '대학',
				name: 'COLLEGE_TYPE',
				xtype: 'uniTextfield', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COLLEGE_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '학년', 
				name: 'GRADE_CODE', 
				xtype: 'uniTextfield', 
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
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		padding: '0 0 0 0',
	    		fieldLabel: ' ',
	    		id: 'YN_CK',
	    		items: [{
	    			boxLabel: '등록여부',
	    			width: 120,
	    			name: 'YN',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('YN', newValue);
						}
					}
	    		}]
	        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '캠퍼스구분',			
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'SONGDOYN',
					inputValue:'',
					checked: true  
				},{
					boxLabel: '국제', 
					width: 70, 
					name: 'SONGDOYN',
					inputValue: '02'
				},{
					boxLabel : '서울', 
					width: 70,
					name: 'SONGDOYN',
					inputValue: '01'
				},{
					boxLabel : '원주', 
					width: 70,
					name: 'SONGDOYN',
					inputValue: '03'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SONGDOYN').setValue(newValue.SONGDOYN);
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'uniTextfield',
				fieldLabel: '학년도',
				name: 'TXT_YYYY',
				value: new Date().getFullYear(),  
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
				comboType: 'AU', 
				comboCode: 'YP34',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAJOR_NAME', newValue);
					}
				}
			},{
				fieldLabel: '대학',
				name: 'COLLEGE_TYPE',
				xtype: 'uniTextfield', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COLLEGE_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '학년', 
				name: 'GRADE_CODE', 
				xtype: 'uniTextfield', 
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
				colspan: 2,
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
				itemId: 'panelSearch'
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		padding: '0 0 0 0',
	    		fieldLabel: ' ',
	    		id: 'YN_CK2',
	    		items: [{
	    			boxLabel: '등록여부',
	    			width: 120,
	    			name: 'YN',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('YN', newValue);
						}
					}
	    		}]
	        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '캠퍼스구분',			
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'SONGDOYN',
					inputValue:'',
					checked: true  
				},{
					boxLabel: '국제', 
					width: 70, 
					name: 'SONGDOYN',
					inputValue: '02'
				},{
					boxLabel : '서울', 
					width: 80,
					name: 'SONGDOYN',
					inputValue: '01'
				},{
					boxLabel : '원주', 
					width: 80,
					name: 'SONGDOYN',
					inputValue: '03'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('SONGDOYN').setValue(newValue.SONGDOYN);
					}
				}
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('txt110skrvGrid1', {
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
			{dataIndex: 'COLLEGE_TYPE'		, width: 110},  
			{dataIndex: 'SONGDOYN'			, width: 100},
			{dataIndex: 'MAJOR_NAME'		, width: 130}, 
			{dataIndex: 'GRADE_CODE'		, width: 50,align:'center'}, 
			{dataIndex: 'SUBJECT_NAME'		, width: 100}, 
			{dataIndex: 'PROFESSOR_NAME'	, width: 88}, 
			{dataIndex: 'ITEM_CODE'			, width: 110}, 
			{dataIndex: 'ITEM_NAME'			, width: 250}, 
			{dataIndex: 'ISBN_CODE'			, width: 110}, 
			{dataIndex: 'PUBLISHER'			, width: 110}, 
			{dataIndex: 'AUTHOR'			, width: 88}, 
			{dataIndex: 'AUTHOR2'			, width: 88}, 
			{dataIndex: 'TRANSRATOR'		, width: 88}, 
			{dataIndex: 'SALE_BASIS_P'			, width: 88}, 
			{dataIndex: 'PUB_DATE'			, width: 88}, 
			{dataIndex: 'COLLEGE_TYPE'		, width: 88,align:'center'}, 
			{dataIndex: 'TXTBOOK_TYPE'		, width: 88}, 
			{dataIndex: 'PEOPLE_NUM'		, width: 88}, 
			{dataIndex: 'USE_TYPE'			, width: 88}, 
			{dataIndex: 'YN'				, width: 88,align:'center'},
			{dataIndex: 'STOCK_Q'			, width: 88},
			{dataIndex: 'REMARK'			, width: 88}
			
			
		] 
	});//End of var masterGrid = Unilite.createGrid('txt110skrvGrid1', {   
	
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
		id: 'txt110skrvApp',
		fnInitBinding: function() {
        	panelSearch.setValue('TXT_YYYY',new Date().getFullYear());
        	panelResult.setValue('TXT_YYYY',new Date().getFullYear());
        	txt110skrvService.subCode1({}, function(provider, response)	{
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
