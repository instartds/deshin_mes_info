<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp285skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pmp285skrv"/>	<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="P505" /> <%-- 제조자 --%>
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	Unilite.defineModel('Pmp285skrvModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '<t:message code="system.label.product.entrydate" default="등록일"/>'			, type: 'string'},
			{name: 'WKORD_NUM_SEQ'		, text: '<t:message code="system.label.product.seq" default="순번"/>'					, type: 'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.inventory.wkordnum" default="작업지시번호"/>'		, type: 'string'},
			{name: 'PRODT_DATE'			, text: '제조일자'																		, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'EQU_NAME'			, text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'		, type: 'string'},
			{name: 'WKORD_Q'			, text: '이론량'																		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'		, type: 'uniQty'},
			{name: 'CODE_NAME'			, text: '제조자'																		, type: 'string'},
			{name: 'PROD_PROC'			, text: '제조약어'																		, type: 'string'},
			{name: 'USER_PROD_PROC'		, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'}
		]
	});

	var directMasterStore1 = Unilite.createStore('pmp285skrvMasterStore1',{
		model	: 'Pmp285skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'pmp285skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		}
		/*listeners: {
			load: function(store, records, successful, eOpts) {
           		panelProcDraw.setValue('PROD_PROC', store);
			}
		}*/
	});

	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',  
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '제조일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_DATE_FR',
				endFieldName	: 'PRODT_DATE_TO',
				allowBlank		: false,
				width			: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.wkordnum" default="작업지시번호"/>',
				name		: 'WKORD_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				autoPopup		: true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					}
				}
			}),{
				fieldLabel: '제조자',
				name:'PRODT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P505',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_PRSN', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '제조일자',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO',
			allowBlank		: false,
			width			: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.wkordnum" default="작업지시번호"/>',
			name		: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WKORD_NUM', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
		}),{
			fieldLabel: '제조자',
			name:'PRODT_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'P505',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PRODT_PRSN', newValue);
				}
			}
		}]
	});

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		title	: '제조약어',
    	region	: 'center',
    	flex	: 2,
    	border	: false,
	    width	: 340,
	    padding	: '0 0 0 0',
	    items	: [{	
    	    	xtype:'container',
    	        defaultType: 'uniTextfield',
    	        padding: '10 10 0 10',
    	        layout: {
    	        	type: 'uniTable',
    	        	columns : 1
    	        },
    	        items: [{
    	        	xtype: 'textareafield',
    	        	name: 'PROD_PROC',
    	        	labelAlign: 'top',
    	        	width: '100%',
    	        	height: 700,
    	        	readOnly: true,
    	        	fieldStyle: {
				      'lineHeight' 	 : '30px',
				      'fontSize'     : '20px'
				    }
    	        }
    	    ]}	            			 
		],
        loadForm: function(record)  {
            var count = masterGrid1.getStore().getCount();
            if(count > 0) {
                this.setActiveRecord(record[0]);   
            }
        }
    });
    
	var masterGrid1 = Unilite.createGrid('pmp285skrvGrid1', {
		store	: directMasterStore1,
		flex	: 4,
		region	: 'west',
		uniOpt	: {
			expandLastColumn	: false, // 마지막 열 자동 확장
			useLiveSearch		: true,  // 내용검색 버튼 사용 여부
			useContextMenu		: true,  // Context 메뉴 자동 생성 여부 
			useMultipleSorting	: true,  // 정렬 버튼 사용 여부
			useGroupSummary		: false, // 그룹핑 버튼 사용 여부
			useRowNumberer		: true,  // 번호 컬럼 사용 여부
			filter				: {
				useFilter	: true,		 // 컬럼 filter 사용 여부
				autoCreate	: true		 // 컬럼 필터 자동 생성 여부
			}
		},
		selModel:'rowmodel',
			
		columns	: [
			{dataIndex: 'DIV_CODE'			, width:330 , hidden: true},	 // 사업장
			{dataIndex: 'INSERT_DB_TIME'	, width:330 , hidden: true},	 // 등록일
			{dataIndex: 'WKORD_NUM_SEQ'		, width:50  , hidden: true},	 // 순번
			{dataIndex: 'WKORD_NUM'			, width:110 ,  align: 'center'}, // 작업지시번호
			{dataIndex: 'PRODT_DATE'		, width:80} , 				     // 제조일자
			{dataIndex: 'ITEM_CODE'			, width:70  ,  align: 'center'}, // 제품코드
			{dataIndex: 'ITEM_NAME'			, width:380}, 				     // 설비명
			{dataIndex: 'WKORD_Q'			, width:100} ,				     // 이론량
			{dataIndex: 'PRODT_Q'			, width:100} , 				     // 실적수량
			{dataIndex: 'CODE_NAME'			, width:65  ,  align:'center'},  // 제조자
			{dataIndex: 'PROD_PROC'			, width:350 , hidden: true}, 	 // 제조약어
			{dataIndex: 'USER_PROD_PROC'	, width:330 , hidden: true}  	 // 비고
		],
		listeners : {
            selectionchange : function(grid, selected, eOpts) {
            	panelResult2.loadForm(selected);                    
            }
        }
	});

	Unilite.Main({
		id			: 'pmp285skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid1, panelResult2
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('PRODT_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('PRODT_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
			UniAppManager.setToolbarButtons(['save', 'reset'], false);
		},
		onQueryButtonDown : function() {
			masterGrid1.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			panelResult2.clearForm();
		},
		onResetButtonDown: function() {
			panelSearch.reset();
			masterGrid1.reset();
			panelResult.reset();
			panelResult2.clearForm();
			this.fnInitBinding();
		}
	});
};
</script>