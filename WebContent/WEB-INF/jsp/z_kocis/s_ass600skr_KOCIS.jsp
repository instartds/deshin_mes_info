<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="s_ass600skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 					<!--상각완료여부--> 
	<t:ExtComboStore comboType="AU" comboCode="ZA14" /> 					<!--10품종-->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> 	<!--기관-->
	<t:ExtComboStore comboType="AU" comboCode="A393" /> 					<!-- 물품상태-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

//var getChargeCode = ${getChargeCode};
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('s_ass600skr_KOCISModel', {
	    fields: [
			{name: 'ITEM_CD'			 			,text: '10품종' 			,type: 'string'		, comboType: "AU"	, comboCode: "ZA14"},
	    	{name: 'PROCESS_GUBUN'		 			,text: '처분구분' 			,type: 'string'		,  editable: false		, comboType: "AU"	, comboCode: "A392"},
	    	{name: 'ASST'  				 			,text: '자산코드' 			,type: 'string'},
	    	{name: 'REMARK'  				 		,text: '디브레인 자산코드'	,type: 'string'},
	    	{name: 'ASST_NAME' 			 			,text: '자산명' 			,type: 'string'},
	   		{name: 'ITEM_NM'		 				,text: '품명' 			,type: 'string'},
	    	{name: 'SPEC' 				 			,text: '규격' 			,type: 'string'},
	    	{name: 'DEPT_CODE'  			 		,text: '기관' 			,type: 'string'},
	    	{name: 'DEPT_NAME'  		 			,text: '기관' 			,type: 'string'},
	    	{name: 'PLACE_INFO'			 			,text: '사용위치' 			,type: 'string'},
	    	{name: 'ACQ_DATE'  			 			,text: '취득일자' 			,type: 'uniDate'},
	    	{name: 'ACQ_AMT_I'  		 			,text: '취득가격' 			,type: 'uniPrice'},
	    	{name: 'ITEM_USE'  		 				,text: '물품용도' 			,type: 'string'},
	    	{name: 'ASS_STATE'  	 				,text: '물품상태' 			,type: 'string'		, comboType: "AU"	, comboCode: "A393"},
	    	{name: 'DRB_YEAR' 			 			,text: '내용년수' 			,type: 'int'},
	    	{name: 'REASON_NM'				 		,text: '관련근거' 			,type: 'string'}
/*	추가필드 : 필요시 사용
 	    	{name: 'PJT_NAME' 			 			,text: '프로젝트' 			,type: 'string'},
	    	{name: 'ACQ_Q'  			 			,text: '취득수량' 			,type: 'uniQty'},
	    	{name: 'STOCK_Q'  			 			,text: '재고수량' 			,type: 'uniQty'},
	    	{name: 'FOR_ACQ_AMT_I'		 			,text: '외화취득가액' 		,type: 'uniPrice'},
	    	{name: 'DPR_STS2'  			 			,text: '상각여부' 			,type: 'string'},
	    	{name: 'DPR_YYYYMM'  		 			,text: '상각년월' 			,type: 'uniDate'},
	    	{name: 'WASTE_SW'  			 			,text: '매각폐기여부' 		,type: 'string'},
	    	{name: 'WASTE_YYYYMM'		 			,text: '매각폐기년월' 		,type: 'uniDate'},
	    	{name: 'SALE_MANAGE_COST'	 			,text: '판매비용' 			,type: 'uniPrice'},
	    	{name: 'PRODUCE_COST'		 			,text: '제조원가' 			,type: 'uniPrice'},
	    	{name: 'SALE_COST'			 			,text: '영업외비용' 		,type: 'uniPrice'},
	    	{name: 'COST_POOL_NAME'		 			,text: 'Cost Pool' 		,type: 'string'},
	    	{name: 'COST_DIRECT'		 			,text: 'Cost Pool 직과' 	,type: 'string'},
	    	{name: 'ITEMLEVEL1_NAME'	 			,text: '대분류' 			,type: 'string'},
	    	{name: 'ITEMLEVEL2_NAME'	 			,text: '중분류' 			,type: 'string'},
	    	{name: 'ITEMLEVEL3_NAME'	 			,text: '소분류' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'		 			,text: '구입처' 			,type: 'string'},
	    	{name: 'PERSON_NAME'		 			,text: '사용자' 			,type: 'string'},
	    	{name: 'SERIAL_NO'			 			,text: '일련번호' 			,type: 'string'},
	    	{name: 'BAR_CODE'			 			,text: 'Bar Code' 		,type: 'string'},
*/		]
	});

	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_ass600skr_KOCISMasterStore1',{
		model	: 's_ass600skr_KOCISModel',
		uniOpt	: {
        	isMaster	: true,				// 상위 버튼 연결 
        	editable	: false,			// 수정 모드 사용 
        	deletable	: false,			// 삭제 가능 여부 
            useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
            type	: 'direct',
            api		: {			
        	   read: 's_ass600skrService_KOCIS.selectList'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField	: 'ITEM_CD',
		listeners	: {
           	load: function(store, records, successful, eOpts) {
//           		var viewNormal = masterGrid.normalGrid.getView();
//				var viewLocked = masterGrid.lockedGrid.getView();
//           		if(store.getCount() > 0){
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				}else{
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        defaults	: {enforceMaxLength: true},
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [
		    	Unilite.popup('ASSET', {
					fieldLabel		: '자산코드', 
					valueFieldName	: 'ASSET_CODE', 
					textFieldName	: 'ASSET_NAME', 
					validateBlank	: false, 
					popupWidth		: 710,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ASSET_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ASSET_NAME', newValue);				
						}
					}
			}),
				Unilite.popup('ASSET',{ 
					fieldLabel		: '~', 
					valueFieldName	: 'ASSET_CODE2', 
					textFieldName	: 'ASSET_NAME2', 
					popupWidth		: 710,
					validateBlank	: false, 
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ASSET_CODE2', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ASSET_NAME2', newValue);				
						}
					}
			}),{
    			fieldLabel	: '10품종'	,
    			name		: 'ITEM_CD', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'ZA14',
    			listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('ITEM_CD', newValue);
					}
				} 
    		},{
				fieldLabel	: '기관',
				name		: 'DEPT_CODE', 
				xtype		: 'uniCombobox',
                store		: Ext.data.StoreManager.lookup('deptKocis'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DEPT_CODE', newValue);
					}
				}
			}]
    	}/*,{
    		title: '추가정보',
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [
    			Unilite.popup('ACCNT', {
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE', 
				textFieldName: 'ACCNT_NAME',
//					textFieldWidth:170, 
				validateBlank:false, 
                listeners: {
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
                }
			}),
			Unilite.popup('ACCNT',{ 
				fieldLabel: '~', 
				valueFieldName: 'ACCNT_CODE2', 
				textFieldName: 'ACCNT_NAME2', 
//					textFieldWidth: 170, 
				validateBlank: false, 
//				popupWidth: 710,
				listeners: {
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
                }
			}),
			{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				defaults : {enforceMaxLength: true},
				width:600,
				items :[{
				    fieldLabel:'내용년수', 
				    xtype: 'uniNumberfield',
				    name: 'DRB_YEAR_FR',
				    maxLength:3,
				    width:195
			   },{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'DRB_YEAR_TO', 
					maxLength:3,
					width:110
				}]
			},
			Unilite.popup('AC_PROJECT', {
				fieldLabel: '프로젝트', 
				valueFieldName: 'AC_PROJECT_CODE', 
				textFieldName: 'AC_PROJECT_NAME', 
//					textFieldWidth:170, 
				validateBlank:false, 
				popupWidth: 710
			}),
			Unilite.popup('AC_PROJECT',{ 
				fieldLabel: '~', 
				valueFieldName: 'AC_PROJECT_CODE2', 
				textFieldName: 'AC_PROJECT_NAME2', 
//					textFieldWidth: 170, 
				validateBlank: false, 
				popupWidth: 710
			}),
			{
				fieldLabel: '취득일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ACQ_DATE_FR',
				endFieldName: 'ACQ_DATE_TO',
				width: 315
			},{
				fieldLabel:'취득가액', 
				xtype: 'uniNumberfield',
				name: 'ACQ_AMT_I_FR'
			},{
				fieldLabel:'~', 
				xtype: 'uniNumberfield',
				name: 'ACQ_AMT_I_TO'
			},{
				fieldLabel: '사용일',
				xtype: 'uniDateRangefield',
				startFieldName: 'USE_DATE_FR',
				endFieldName: 'USE_DATE_TO',
				width: 315
			},{
				fieldLabel:'외화취득가액', 
				xtype: 'uniNumberfield',
				name: 'FOR_ACQ_AMT_I_FR'
			},{
				fieldLabel:'~', 
				xtype: 'uniNumberfield',
				name: 'FOR_ACQ_AMT_I_TO'
			},{
				fieldLabel: '상각년월',
				xtype: 'uniDateRangefield',
				startFieldName: 'DPR_YYYYMM_FR',
				endFieldName: 'DPR_YYYYMM_TO',
				width: 315
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '매각/폐기여부',
			    id: 'rdoSelect',
			    items : [{
			    	boxLabel: '전체',
			    	name: 'WASTE_SW',
			    	inputValue: 'A',
			    	checked: true,
			    	width:50
			    },{
			    	boxLabel: '예',
			    	name: 'WASTE_SW' ,
			    	inputValue: 'Y',
			    	width:40
			    },{
			    	boxLabel: '아니오',
			    	name: 'WASTE_SW',
			    	inputValue: 'N',
			    	width:60
			    }]
			},{
				fieldLabel: '매각/폐기년월',
				xtype: 'uniDateRangefield',
				startFieldName: 'WASTE_YYYYMM_FR',
				endFieldName: 'WASTE_YYYYMM_TO',
				width: 315
			}]
		}*/]		
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
//			width	: 500,
			colspan	: 2,
			items	: [
				Unilite.popup('ASSET', {
					fieldLabel		: '자산코드', 
					valueFieldName	: 'ASSET_CODE', 
					textFieldName	: 'ASSET_NAME', 
					popupWidth		: 710,
					validateBlank	: false, 
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_NAME', newValue);				
						}
					}
				}),
				Unilite.popup('ASSET',{ 
					fieldLabel		: '~', 
					valueFieldName	: 'ASSET_CODE2', 
					textFieldName	: 'ASSET_NAME2', 
					labelWidth		: 20,
					popupWidth		: 710,
					validateBlank	: false, 
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_CODE2', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_NAME2', newValue);				
						}
					}
				})]
	    	},{
    			fieldLabel	: '10품종'	,
    			name		: 'ITEM_CD', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'ZA14',
    			listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelSearch.setValue('ITEM_CD', newValue);
					}
				} 
	    	},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				colspan	: 2,
				items	:[{
					fieldLabel	: '기관',
					name		: 'DEPT_CODE', 
					xtype		: 'uniCombobox',
	                store		: Ext.data.StoreManager.lookup('deptKocis'),
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DEPT_CODE', newValue);
						}
					}
				}
			]}
		]
	});	

	
	
	/** Master Grid1 정의(Grid Panel)
     * @type 
     */
      var masterGrid = Unilite.createGrid('agb240skrGrid1', {
        store		: directMasterStore, 
        region		: 'center',
        excelTitle	: '고정자산대장조회',
        uniOpt		: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        tbar		: [{
        	id		: 'printBtn',
        	itemId	: 'printBtn',
    		text	:'라벨출력',
    		width	: 100,
    		handler	: function() {
    			var selectedRecodes = 
    			alert('라벨출력');
			}
   		}],
    	selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			if (this.selected.getCount() > 0) {
						Ext.getCmp('printBtn').enable();
	    			}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('printBtn').disable();
	    			}
	    		}
    		}
        }),
    	features	: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           		{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
        columns		: [        
        	{														
				xtype		: 'rownumberer',									
				align		:'center  !important', 					
				width		: 35,														
				sortable	: false,													
				resizable	: true											
			},												
        	{dataIndex: 'ITEM_CD'			 				,  width: 100},
	    	{dataIndex: 'PROCESS_GUBUN'			  			,  width: 80}, 
			{dataIndex: 'ASST'  				 			,  width: 100},
			{dataIndex: 'REMARK'  				 			,  width: 100},
			{dataIndex: 'ASST_NAME' 			 			,  width: 120},
			{dataIndex: 'ITEM_NM' 			 				,  width: 120},
			{dataIndex: 'SPEC' 				 				,  width: 120},
			{dataIndex: 'DEPT_CODE'  			 			,  width: 100	, hidden: true},
			{dataIndex: 'DEPT_NAME'  		 				,  width: 100},
			{dataIndex: 'PLACE_INFO'			 			,  width: 120},
			{dataIndex: 'ACQ_DATE'  			 			,  width: 100},
			{dataIndex: 'ACQ_AMT_I'  		 				,  width: 100},
			{dataIndex: 'ITEM_USE'		 					,  width: 100},
			{dataIndex: 'ASS_STATE'			 				,  width: 100},
			{dataIndex: 'DRB_YEAR' 			 				,  width: 100	, align: 'center'},
			{dataIndex: 'REASON_NM'				 			,  flex: 1		, minWidth: 166}
/*			{dataIndex: 'PJT_NAME' 			 				,  width: 100},
			{dataIndex: 'ACQ_Q'  			 				,  width: 88,summaryType: 'sum'},
			{dataIndex: 'STOCK_Q'  			 				,  width: 88,summaryType: 'sum'},
			{dataIndex: 'DRB_YEAR' 			 				,  width: 88,align:'center'},
			{dataIndex: 'FOR_ACQ_AMT_I'		 				,  width: 100,summaryType: 'sum'},
			{dataIndex: 'DPR_STS2'  			 			,  width: 86,align:'center'},
			{dataIndex: 'DPR_YYYYMM'  		 				,  width: 86},
			{dataIndex: 'WASTE_SW'  			 			,  width: 86,align:'center'},
			{dataIndex: 'WASTE_YYYYMM'		 				,  width: 86},
			{dataIndex: 'SALE_MANAGE_COST'	 				,  width: 73},
			{dataIndex: 'PRODUCE_COST'		 				,  width: 73},
			{dataIndex: 'SALE_COST'			 				,  width: 73},
			{dataIndex: 'COST_POOL_NAME'		 			,  width: 100},
			{dataIndex: 'COST_DIRECT'		 				,  width: 100},
			{dataIndex: 'ITEMLEVEL1_NAME'	 				,  width: 100},
			{dataIndex: 'ITEMLEVEL2_NAME'	 				,  width: 100},
			{dataIndex: 'ITEMLEVEL3_NAME'	 				,  width: 100},
			{dataIndex: 'CUSTOM_NAME'		 				,  width: 120},
			{dataIndex: 'PERSON_NAME'		 				,  width: 66},
			{dataIndex: 'SERIAL_NO'			 				,  width: 133},
			{dataIndex: 'BAR_CODE'			 				,  width: 166}*/
		],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '고정자산 등록',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAss300skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAss300skr:function(record)	{
			if(record)	{
		    	var params = record;
		    	params.PGM_ID 			= 's_ass600skr_KOCIS';
		    	params.ASST 			=	record.get('ASST');
		    	params.ASST_NAME 		=	record.get('ASST_NAME');
			}
	  		var rec1 = {data : {prgID : 'ass300ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/ass300ukr.do', params);
    	}     
    });   
	
    Unilite.Main( {
		id  : 's_ass600skr_KOCISApp',
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
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('reset'	, false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');	
			
			
			this.setDefault();
		},
		
		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){
				return false;
				
			}else{
				masterGrid.getStore().loadStoreRecords();
//				var viewLocked = masterGrid.lockedGrid.getView();
//				var viewNormal = masterGrid.normalGrid.getView();
//				console.log("viewLocked: ", viewLocked);
//				console.log("viewNormal: ", viewNormal);
//			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			    UniAppManager.setToolbarButtons('reset',true);
			}
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});

			this.fnInitBinding();
		},
		
		setDefault: function() {
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			
            if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01') {
					panelSearch.getField('DEPT_CODE').setReadOnly(false);
					panelResult.getField('DEPT_CODE').setReadOnly(false);
					
				} else {
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
					panelResult.getField('DEPT_CODE').setReadOnly(true);
				}
				
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
                //부서정보가 없을 경우, 조회버튼 비활성화
			    UniAppManager.setToolbarButtons('query',false);
            }
			
			Ext.getCmp('printBtn').disable();
		}
	});
};
</script>
