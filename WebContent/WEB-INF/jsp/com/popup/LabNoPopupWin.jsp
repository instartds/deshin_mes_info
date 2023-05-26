<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// LAP NO 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.LabNoPopup");
%>


	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.LabNoPopupModel', {  
	fields: [ 	 
		{name: 'COMPANY_NM'		,text:'거래처'				,type:'string'},
		{name: 'LAB_NO'			,text:'LAB_NO'			,type:'string'},
		{name: 'REQST_ID'		,text:'샘플 ID'			,type:'string'},
		{name: 'SAMPLE_NAME'	,text:'샘플명'				,type:'string'},
		{name: 'CUSTOMER_NM'	,text:'담당자'				,type:'string'},
		//20190607 추가
		{name: 'SAMPLE_KEY'		,text:'SAMPLE_KEY'		,type:'string'}
	]
	});

/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config) {
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		/**
		 * 검색조건 (Search Panel)
		 * @type 
		 */
//		var wParam = this.param;
//		var t1= false, t2 = false;
//		if( Ext.isDefined(wParam)) {
//			if(wParam['TYPE'] == 'VALUE') {
//				t1 = true;
//				t2 = false;
//				
//			} else {
//				t1 = false;
//				t2 = true;
//				
//			}
//		}


		me.panelSearch =  Unilite.createSearchForm('',{
			layout	: {type : 'uniTable', columns : 2},
			items	: [
				{ fieldLabel: '거래처'		, name:'COMPANY_NM'	, xtype:'uniTextfield'},
				{ fieldLabel: 'LAB NO'	, name:'TXT_SEARCH'	, xtype:'uniTextfield'},
				{ fieldLabel: 'MAX_YN'	, name:'MAX_YN'		, xtype:'uniTextfield'	, hidden: true}	//20210818 추가: 동일 거래처/lab no 일 때, 최근 데이터만 보여주기 위해 추가
			]
		});
		me.masterStore = Unilite.createStoreSimple('${PKGNAME}.labNoPopupMasterStore',{
			model: '${PKGNAME}.LabNoPopupModel',
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'popupService.labNoPopup'
				}
			}
		})
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: me.masterStore,
			uniOpt:{
				 expandLastColumn: false
				,useRowNumberer: false,
				state: {
					useState: false,
					useStateList: false	
				},
				pivot : {
					use : false
				}
			},
			selModel: 'rowmodel',
			columns	: [
				{dataIndex: 'COMPANY_NM'	,width:150	},
				{dataIndex: 'LAB_NO'		,width:150	},
				{dataIndex: 'REQST_ID'		,width:100	},
				{dataIndex: 'SAMPLE_NAME'	,width:150	},
				{dataIndex: 'CUSTOMER_NM'	,width:100	},
				//20190607 추가
				{dataIndex: 'SAMPLE_KEY'	,width:100	}
					
			] ,
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var rv = {
						status	: "OK",
						data	: [record.data]
					};
					me.returnData(rv);
					me.masterStore.commitChanges();
				},
				beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {
				},
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();
						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		});
		config.items = [me.panelSearch,	me.masterGrid];
		me.callParent(arguments);
	},
	initComponent : function(){
		var me  = this;
		me.masterGrid.focus();
		this.callParent();
	},
	fnInitBinding : function(param) {
		var me = this;
		
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
			if(!Ext.isEmpty(param['LAB_NO'])){
				fieldTxt.setValue(param['LAB_NO']);
			}
		}else{
			if(!Ext.isEmpty(param['LAB_NO'])){
				fieldTxt.setValue(param['LAB_NO']);
			}
			if(!Ext.isEmpty(param['REQST_ID'])){
				fieldTxt.setValue(param['REQST_ID']);
			}
		}
		this._dataLoad();
	},
	 onQueryButtonDown : function() {
		this._dataLoad();
	},
	onSubmitButtonDown : function() {
		var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		var rv ;
		if(selectRecord) {
			rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function() {
				me.isLoading = false;
			}
		});
	}
});

