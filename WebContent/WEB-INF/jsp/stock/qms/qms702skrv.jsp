<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms702skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="qms702skrv"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Z018" storeId="printDataStore"/>	<!-- 출력 데이터 -->
	<t:ExtComboStore comboType="WU"/> <!-- 작업장 (사용여부)-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr300ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr300ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr300ukrvLevel3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsReportGubun = '${gsReportGubun}'	//레포트 구분
function appMain() {

	 var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'자재발주'  , 'value':'1'},
            {'text':'외주발주'  , 'value':'2'}
        ]
    });

	/**
	 *   Model 정의
	 */
	Unilite.defineModel('qms702skrvModel', {
		fields: [
			{name: 'COMP_CODE'     	, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'     		, text: '사업장'			, type: 'string'},
			{name: 'WKORD_NUM'     	, text: '작업지시번호'	, type: 'string'},
			{name: 'LOT_NO'   			, text: 'LOT_NO'		, type: 'string'},
			{name: 'ITEM_CODE'     	, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '품목명'			, type: 'string'},
			{name: 'SPEC'     				, text: '형명(규격)'		, type: 'string'},
			{name: 'WKORD_Q'  			, text: '생산수량'			, type: 'uniQty'},
			{name: 'NUM'  					, text: '순번'				, type: 'int'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 */
	var masterStore = Unilite.createStore('qms702skrvMasterStore1', {
		model: 'qms702skrvModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'qms702skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						  var recordCount = masterStore.getCount();
						  if(recordCount > 0){
							  masterGrid.getSelectionModel().selectAll();
						  }
					}
				}
			});
		}
	});


	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout: {type : 'uniTable', columns :6},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE', '');
					fn_WorkshopSet('2');
			/* 		if(Ext.getCmp('optRadioBoxIds').getChecked()[0].inputValue == '0'){
						fn_WorkshopSet('0');
					}else{
						fn_WorkshopSet('1');
					} */
				}
			}
		},{
			fieldLabel: '계획일',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_WKORD_DATE_FR',
			endFieldName: 'PRODT_WKORD_DATE_TO',
			startDate: UniDate.get('tomorrow'),
			endDate: UniDate.get('endOfMonth'),
			width: 315,
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {

		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {

		    }

		},{
 		    xtype: 'radiogroup',
		    fieldLabel: '성적서',
		    id: 'optRadioBoxIds',
		    colspan: 4,
		    items : [{
		    	boxLabel: '공정 검사성적서',
		    	name: 'OPT' ,
		    	inputValue: '2',
		    	checked: true,
		    	width:130
		    },{
		    	boxLabel: '코팅 검사성적서',
		    	name: 'OPT' ,
		    	inputValue: '0',
		    	width:130
		    }, {boxLabel: '완제품 검사성적서',
		    	name: 'OPT',
		    	inputValue: '1',
		    	width:130
		    }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

					 if(newValue.OPT == '0'){//코팅성적서
							panelResult.setValue('DOC_NUM1', 'CIR');
							//panelResult.setValue('PRODT_WKORD_DATE_FR', UniDate.get('tomorrow'));
							//panelResult.setValue('PRODT_WKORD_DATE_TO', UniDate.get('endOfMonth'));
				        /* 	masterGrid.reset();
				        	masterStore.clearData(); */
				        	//fn_WorkshopSet('0');
							panelResult.setValue('DOC_NUM3', '');
							panelResult.setValue('INSPEC_COND', '');
							panelResult.setValue('LIMIT_SAMPLE', '');
							panelResult.setValue('INSPEC_METHOD', '');
							fn_DocValSet('0');
					  }else if(newValue.OPT == '1'){//완제품 성적서
							panelResult.setValue('DOC_NUM1', 'FTR');
							//panelResult.setValue('PRODT_WKORD_DATE_FR', UniDate.get('today'));
							//panelResult.setValue('PRODT_WKORD_DATE_TO', UniDate.get('endOfMonth'));
				        	/* masterGrid.reset();
				        	masterStore.clearData(); */
				        	//fn_WorkshopSet('1');
							panelResult.setValue('DOC_NUM3', '');
							panelResult.setValue('INSPEC_COND', '');
							panelResult.setValue('LIMIT_SAMPLE', '');
							panelResult.setValue('INSPEC_METHOD', '');
							fn_DocValSet('1');
					  }else{//공정검사성적서
						  panelResult.setValue('DOC_NUM1', 'PIR');
							//panelResult.setValue('PRODT_WKORD_DATE_FR', UniDate.get('today'));
							//panelResult.setValue('PRODT_WKORD_DATE_TO', UniDate.get('endOfMonth'));
				        	/* masterGrid.reset();
				        	masterStore.clearData(); */
				        	//fn_WorkshopSet('2');
							panelResult.setValue('DOC_NUM3', '');
							panelResult.setValue('INSPEC_COND', '');
							panelResult.setValue('LIMIT_SAMPLE', '');
							panelResult.setValue('INSPEC_METHOD', '');
							fn_DocValSet('2');
					  }
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
			allowBlank: false,
			colspan: 1,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();

					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					} else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan : 5,
			items	: [{
				fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('bpr300ukrvLevel1Store')
			},{
				xtype: 'uniCheckboxgroup',
				fieldLabel: '',
				padding: '0 0 0 0',
				margin: '0 0 0 30',
				items: [{
					boxLabel: '완제품',
					width: 80,
					name: 'ITEM_LEVEL2_1',
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					boxLabel: '시제품',
					width: 80,
					name: 'ITEM_LEVEL2_2',
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					boxLabel: '샘플',
					width: 80,
					name: 'ITEM_LEVEL2_3',
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			}]
		},{
		    xtype: 'box',
		    autoEl: {tag: 'hr'},
		    colspan: 6
		},{
			fieldLabel: '검사일',
			xtype: 'uniDatefield',
			value: new Date(),
			name: 'INSPEC_DATE',
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					//panelResult.setValue('PRINT_Q', newValue);
					if(! Ext.isEmpty(newValue)){
						panelResult.setValue('DOC_NUM2',UniDate.getDbDateStr(newValue).substring(2,8));
					}
				}
			}
		},{
			fieldLabel: '문서번호',
			xtype: 'uniTextfield',
			name: 'DOC_NUM1',
			value: 'CIR',
			readOnly: true,
			width:150,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{ 	 xtype: 'container',
				 colspan: 4,
				 margin : '-5 0 0 -165',
			  	  layout:{type:'uniTable',columns:4},
	   			  items:[{	xtype:'component',
	   				            html:'-',
				   				 style: {
				   					   marginTop: '3px !important',
				   					 	font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				   						}
				   			 },{
				   				fieldLabel: '',
				   				xtype: 'uniTextfield',
				   				name: 'DOC_NUM2',
				   				margin : '0 0 0 0',
				   				readOnly: true,
				   				listeners: {
				   					change: function(field, newValue, oldValue, eOpts) {

				   					}
				   				}
				   			},{ xtype:'component',
				   				 html:'-',
				   				 margin : '0 0 0 0',
				   				 style: {
				   						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				   						}
				   			},{
				   				fieldLabel: '',
				   				xtype: 'uniTextfield',
				   				name: 'DOC_NUM3',
				   				margin : '0 0 0 0',
				   				readOnly: false,
				   				listeners: {
				   					change: function(field, newValue, oldValue, eOpts) {

				   					}
				   				}
	   						}
	   			        ]
   			},{fieldLabel: '검사기준',
				xtype: 'uniTextfield',
				name: 'INSPEC_COND',
				readOnly: false,
				colspan: 6,
				width:800,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{
				fieldLabel: '한도견본',
				xtype: 'uniTextfield',
				name: 'LIMIT_SAMPLE',
				readOnly: false,
				colspan: 6,
				width:800,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{
				fieldLabel: '검사방법',
				xtype: 'uniTextfield',
				name: 'INSPEC_METHOD',
				colspan: 6,
				readOnly: false,
				width:800,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
		}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     */
	var masterGrid = Unilite.createGrid('qms702skrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: true,
				useStateList: true
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
		}],selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	injectCheckbox:1,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){


        		},
				deselect:  function(grid, selectRecord, index, eOpts ){

				}
        	}
        }),
		store: masterStore,
		columns: [
			{dataIndex: 'NUM'				,width: 60, align:'center'},
			{dataIndex: 'WKORD_NUM'		,width: 100},
			{dataIndex: 'LOT_NO'			,width: 100},
			{dataIndex: 'ITEM_CODE'		,width: 150},
			{dataIndex: 'ITEM_NAME'		,width: 250},
			{dataIndex: 'SPEC'     			,width: 150},
			{dataIndex: 'WKORD_Q'    		,width: 100}
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
		}
		],
		id: 'qms702skrvApp',
		fnInitBinding: function() {

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_WKORD_DATE_FR',UniDate.get('today'));
			panelResult.setValue('PRODT_WKORD_DATE_TO',UniDate.get('endOfMonth'));
			panelResult.setValue('INSPEC_DATE',UniDate.get('today'));
			panelResult.setValue('DOC_NUM1', 'PIR');
			panelResult.setValue('ITEM_LEVEL1', '100');
			panelResult.setValue('DOC_NUM3', '01');
			panelResult.setValue('OPT', '2');
			if(! Ext.isEmpty(UniDate.getDbDateStr(panelResult.getValue('INSPEC_DATE')))){
				panelResult.setValue('DOC_NUM2',UniDate.getDbDateStr(panelResult.getValue('INSPEC_DATE')).substring(2,8));
			}

			fn_WorkshopSet('2');
			fn_DocValSet('2');

			UniAppManager.setToolbarButtons(['reset','print'], true);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			masterStore.loadStoreRecords();
		},
        onResetButtonDown:function() {

        	panelResult.clearForm();
        	masterGrid.reset();
        	masterStore.clearData();
        	UniAppManager.app.fnInitBinding();
        },
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크

            var recordCount = masterStore.getCount();
            var selectedRecords = masterGrid.getSelectedRecords();
            var docnum3 =  panelResult.getValue('DOC_NUM3');
            if(Ext.isEmpty(selectedRecords)){
            	alert('출력할 데이터가 없습니다.');
            	return;
            }
			if(Ext.isEmpty(docnum3)){
				alert('문서 번호를 입력해주세요.');
            	return;
			}
			var param = panelResult.getValues();
			var wkordNums = '';
			if(Ext.getCmp('optRadioBoxIds').getChecked()[0].inputValue == '0'){
				param["sTxtValue2_fileTitle"]='코팅검사 성적서';
			}else{
				param["sTxtValue2_fileTitle"]='완제품검사 성적서';
			}

			Ext.each(selectedRecords, function(record, index){
				if(index == 0) {
					wkordNums		= wkordNums + record.get('WKORD_NUM');
				}else{
					wkordNums		= wkordNums + ',' + record.get('WKORD_NUM');
				}
			});

			param["dataCount"] 	 		= selectedRecords.length;
			param["WKORD_NUMS"] 	= wkordNums;
			param["MAIN_CODE"] 		= 'P010';
			param["PGM_ID"]				='qms702skrv';
			param["DOC_NUM"]			= panelResult.getValue('DOC_NUM1') + '-' +  panelResult.getValue('DOC_NUM2') + '-' + panelResult.getValue('DOC_NUM3');
			param["INSPEC_DATE"]	    = UniDate.getDbDateStr( panelResult.getValue('INSPEC_DATE'));
			var win = '';
				  win = Ext.create('widget.ClipReport', {
		                  url: CPATH+'/qms/qms702clskrv.do',
		                  prgID: 'qms702skrv',
		                  extParam: param
		            });
			win.center();
			win.show();
		}
	});

	function fn_DocValSet(opt){

		var printDataStore =  Ext.data.StoreManager.lookup('printDataStore');//출력 데이터 가져오기

		if(opt == '0'){
			Ext.each(printDataStore.data.items, function(record, idx) {
				if(record.get('value') == 'A1'){
					panelResult.setValue('INSPEC_COND', record.get('refCode1'));
				}else if(record.get('value') == 'A2' ){
					panelResult.setValue('LIMIT_SAMPLE', record.get('refCode1'));
				}else if(record.get('value') == 'A3' ){
					panelResult.setValue('INSPEC_METHOD', record.get('refCode1'));
				}
			});
		}else if(opt == '1'){
			Ext.each(printDataStore.data.items, function(record, idx) {
				if(record.get('value') == 'B1'){
					panelResult.setValue('INSPEC_COND', record.get('refCode1'));
				}else if(record.get('value') == 'B2' ){
					panelResult.setValue('LIMIT_SAMPLE', record.get('refCode1'));
				}else if(record.get('value') == 'B3' ){
					panelResult.setValue('INSPEC_METHOD', record.get('refCode1'));
				}
			});
		}else{
			Ext.each(printDataStore.data.items, function(record, idx) {
				if(record.get('value') == 'B1'){
					panelResult.setValue('INSPEC_COND', record.get('refCode1'));
				}else if(record.get('value') == 'B2' ){
					panelResult.setValue('LIMIT_SAMPLE', record.get('refCode1'));
				}else if(record.get('value') == 'B3' ){
					panelResult.setValue('INSPEC_METHOD', record.get('refCode1'));
				}
			});
		}
	}

	function fn_WorkshopSet(opt){
		var workStore = panelResult.getField('WORK_SHOP_CODE').getStore();
		if(opt == '0'){
			Ext.each(workStore.data.items, function(record, index){
				if(record.get('option') == panelResult.getValue('DIV_CODE') && record.get('refCode1') == 'B'){
					 panelResult.setValue('WORK_SHOP_CODE', record.get('value'));
					 return false;
				}
			});
		}else if(opt == '1'){
			Ext.each(workStore.data.items, function(record, index){
				if(record.get('option') == panelResult.getValue('DIV_CODE') && record.get('refCode1') == 'D'){
					 panelResult.setValue('WORK_SHOP_CODE', record.get('value'));
					 return false;
				}
			});
		}else{
			Ext.each(workStore.data.items, function(record, index){
				if(record.get('option') == panelResult.getValue('DIV_CODE') && record.get('refCode1') == 'D'){
					 panelResult.setValue('WORK_SHOP_CODE', record.get('value'));
					 return false;
				}
			});
		}

	}
};
</script>