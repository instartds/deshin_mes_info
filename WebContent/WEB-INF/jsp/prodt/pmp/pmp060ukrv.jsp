<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp060ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp060ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
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
	Unilite.defineModel('Pmp060ukrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'       	,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE' 	,text: '주간작업장코드'		,type:'string'},
			{name: 'NIGHT_WORK'     	,text: '야간작업장'			,type:'string'},
			{name: 'WORK_SHOP_NAME'  	,text: '주간작업장명'		,type:'string'},
			{name: 'ITEM_CODE'      	,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'      	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'             	,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},

			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.product.childitemcode" default="자품목코드"/>'			,type:'string'},
			{name: 'ORDER_Q'        	,text: '오더량'			,type:'uniQty'},
			{name: 'PROD_Q'         	,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'},
			{name: 'BAL_Q'          	,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'				,type:'uniQty'},

			{name: 'ORD_STATE01'     	,text: '확정01'			,type:'string'},
			{name: 'ORD_QTY01'      	,text: '오더량01'			,type:'uniQty'},
			{name: 'ORD_NUM01'      	,text: '오더번호01'		,type:'string'},
			{name: 'ORD_STATE02'       	,text: '야간확정02'		,type:'string'},
			{name: 'ORD_QTY02'        	,text: '야간오더02'		,type:'string'},
			{name: 'ORD_NUM02'      	,text: '야간오더번호02'		,type:'string'},

			{name: 'ORD_STATE11'    	,text: '확정11'			,type:'string'},
			{name: 'ORD_QTY11'      	,text: '오더량11'			,type:'uniQty'},
			{name: 'ORD_NUM11'      	,text: '오더번호11'		,type:'string'},
			{name: 'ORD_STATE12'    	,text: '야간번호12'		,type:'string'},
			{name: 'ORD_QTY12'      	,text: '야간오더12'		,type:'string'},
			{name: 'ORD_NUM12'       	,text: '야간오더번호12'		,type:'string'},

			{name: 'ORD_STATE21'    	,text: '확정21'			,type:'string'},
			{name: 'ORD_QTY21'        	,text: '오더량21'			,type:'uniQty'},
			{name: 'ORD_NUM21'      	,text: '오더번호21'		,type:'string'},
			{name: 'ORD_STATE22'    	,text: '야간확정22'		,type:'string'},
			{name: 'ORD_QTY22'      	,text: '야간오더22'		,type:'string'},
			{name: 'ORD_NUM22'      	,text: '야간오더번호22'		,type:'string'},

			{name: 'ORD_STATE31'     	,text: '확정31'			,type:'string'},
			{name: 'ORD_QTY31'       	,text: '오더량31'			,type:'uniQty'},
			{name: 'ORD_NUM31'      	,text: '오더번호31'		,type:'string'},
			{name: 'ORD_STATE32'    	,text: '야간번호32'		,type:'string'},
			{name: 'ORD_QTY32'         	,text: '야간오더32'		,type:'string'},
			{name: 'ORD_NUM32'        	,text: '야간오더번호32'		,type:'string'},

			{name: 'ORD_STATE41'     	,text: '확정41'			,type:'string'},
			{name: 'ORD_QTY41'      	,text: '오더량41'			,type:'uniQty'},
			{name: 'ORD_NUM41'      	,text: '오더번호41'		,type:'string'},
			{name: 'ORD_STATE42'    	,text: '야간번호42'		,type:'string'},
			{name: 'ORD_QTY42'      	,text: '야간오더42'		,type:'string'},
			{name: 'ORD_NUM42'      	,text: '야간오더번호42'		,type:'string'},

			{name: 'ORD_STATE51'   		,text: '확정51'			,type:'string'},
			{name: 'ORD_QTY51'       	,text: '오더량51'			,type:'uniQty'},
			{name: 'ORD_NUM51'      	,text: '오더번호51'		,type:'string'},
			{name: 'ORD_STATE52'    	,text: '야간번호52'		,type:'string'},
			{name: 'ORD_QTY52'      	,text: '야간오더52'		,type:'string'},
			{name: 'ORD_NUM52'      	,text: '야간오더번호52'		,type:'string'},

			{name: 'ORD_STATE61'   		,text: '확정61'			,type:'string'},
			{name: 'ORD_QTY61'      	,text: '오더량61'			,type:'uniQty'},
			{name: 'ORD_NUM61'         	,text: '오더번호61'		,type:'string'},
			{name: 'ORD_STATE62'   		,text: '야간번호62'		,type:'string'},
			{name: 'ORD_QTY62'       	,text: '야간오더62'		,type:'string'},
			{name: 'ORD_NUM62'      	,text: '야간오더번호62'		,type:'string'},

			{name: 'ORD_STATE71'    	,text: '확정71'			,type:'string'},
			{name: 'ORD_QTY71'      	,text: '오더량71'			,type:'uniQty'},
			{name: 'ORD_NUM71'      	,text: '오더번호71'		,type:'string'},
			{name: 'ORD_STATE72'   		,text: '야간번호72'		,type:'string'},
			{name: 'ORD_QTY72'      	,text: '야간오더72'		,type:'string'},
			{name: 'ORD_NUM72'         	,text: '야간오더번호72'		,type:'string'},

			{name: 'ORD_STATE81'     	,text: '확정81'			,type:'string'},
			{name: 'ORD_QTY81'      	,text: '오더량81'			,type:'uniQty'},
			{name: 'ORD_NUM81'      	,text: '오더번호81'		,type:'string'},
			{name: 'ORD_STATE82'    	,text: '야간번호82'		,type:'string'},
			{name: 'ORD_QTY82'      	,text: '야간오더82'		,type:'string'},
			{name: 'ORD_NUM82'      	,text: '야간오더번호82'		,type:'string'},

			{name: 'ORD_STATE91'    	,text: '확정91'			,type:'string'},
			{name: 'ORD_QTY91'         	,text: '오더량91'			,type:'uniQty'},
			{name: 'ORD_NUM91'     		,text: '오더번호91'		,type:'string'},
			{name: 'ORD_STATE92'     	,text: '야간번호92'		,type:'string'},
			{name: 'ORD_QTY92'      	,text: '야간오더92'		,type:'string'},
			{name: 'ORD_NUM92'      	,text: '야간오더번호92'		,type:'string'},

			{name: 'MAX_QTY1'       	,text: '<t:message code="system.label.product.maximumproductqty" default="최대생산량"/>'			,type:'uniQty'},
			{name: 'NIGHT_MAX_QTY2' 	,text: '야간_최대생산량'		,type:'uniQty'},
			{name: 'STN_QTY1'      		,text: '표준생산량'			,type:'uniQty'},
			{name: 'NIGHT_STN_QTY2' 	,text: '야간_표준생산량'		,type:'uniQty'}
		]
	});

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmp060ukrvMasterStore1',{
		model: 'Pmp060ukrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'pms500skrvService.selectList1'
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PLAN_FR_DATE',
				endFieldName: 'PLAN_TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PLAN_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PLAN_TO_DATE',newValue);
			    	}
			    }
			},
			 	Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName: 'ITEM_CODE_FR',
					textFieldName: 'ITEM_NAME_FR',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE_FR', panelSearch.getValue('ITEM_CODE_FR'));
								panelResult.setValue('ITEM_NAME_FR', panelSearch.getValue('ITEM_NAME_FR'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE_FR', '');
							panelResult.setValue('ITEM_NAME_FR', '');
						}
					}
			}),
				Unilite.popup('ITEM',{
					fieldLabel: '~',
					validateBlank:false,
					valueFieldName: 'ITEM_CODE_TO',
					textFieldName: 'ITEM_NAME_TO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					}
			}),{
		        fieldLabel: '<t:message code="system.label.product.confirmperiod" default="확정기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_CONFIRM_DATE',
				endFieldName: 'TO_CONFIRM_DATE',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_CONFIRM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_CONFIRM_DATE',newValue);
			    	}
			    }
			}]
		},{
			title: '<t:message code="system.label.product.additionalinfo" default="추가정보"/>',
   			itemId: 'search_panel2',
   			collapsed: true,
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.date" default="일자"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.qty" default="수량"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.estimateddiliverydate" default="예상납기일"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.soqty" default="수주량"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
			},{
		    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
		    },{
		    	fieldLabel: '<t:message code="system.label.product.productionorderdate" default="생산지시일"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
		    },{
		    	fieldLabel: '<t:message code="system.label.product.productionfinishdate" default="생산완료일"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
		    },{
		    	fieldLabel: '<t:message code="system.label.product.productionqty" default="생산량"/>',
			 	name:'',
			 	xtype: 'uniTextfield',
			 	name: ''
		    }]
	    }]
    });


    var panelResult = Unilite.createSearchForm('panelResultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		colspan:2,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },{
		        fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PLAN_FR_DATE',
				endFieldName: 'PLAN_TO_DATE',
				width: 315,
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('PLAN_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PLAN_TO_DATE',newValue);
			    	}
			    }
			},
			 	Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					textFieldName: 'ITEM_NAME_FR',
					valueFieldName: 'ITEM_CODE_FR',
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('ITEM_CODE_FR', panelResult.getVsalue('ITEM_CODE_FR'));
							panelSearch.setValue('ITEM_NAME_FR', panelResult.getValue('ITEM_NAME_FR'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE_FR', '');
						panelSearch.setValue('ITEM_NAME_FR', '');
					}
			}),
				Unilite.popup('ITEM',{
					fieldLabel: '~',
					validateBlank:false,
					textFieldName: 'ITEM_NAME_TO',
					valueFieldName: 'ITEM_CODE_TO',
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('ITEM_NAME_TO', panelResult.getValue('ITEM_NAME_TO'));
							panelSearch.setValue('ITEM_CODE_TO', panelResult.getValue('ITEM_CODE_TO'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_NAME_TO', '');
						panelSearch.setValue('ITEM_CODE_TO', '');
					}
			}),{
		        fieldLabel: '<t:message code="system.label.product.confirmperiod" default="확정기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_CONFIRM_DATE',
				endFieldName: 'TO_CONFIRM_DATE',
				width: 315,
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_CONFIRM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_CONFIRM_DATE',newValue);
			    	}
			    }
			}
		]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('pmp060ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [

			{dataIndex: 'DIV_CODE'        	, width: 80 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 80 , hidden: true},
			{dataIndex: 'NIGHT_WORK'        , width: 100 , hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'  	, width: 100},
			{dataIndex: 'ITEM_CODE'       	, width: 80},
			{dataIndex: 'ITEM_NAME'       	, width: 133},
			{dataIndex: 'SPEC'            	, width: 100},
			{dataIndex: 'CHILD_ITEM_CODE' 	, width: 80},
			{dataIndex: 'ORDER_Q'         	, width: 66},
			{dataIndex: 'PROD_Q'          	, width: 66},
			{dataIndex: 'BAL_Q'           	, width: 66},
			{text :'2014/07/22' ,
				columns: [
					{dataIndex: 'ORD_STATE01'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY01'       	, width: 66 },
					{dataIndex: 'ORD_NUM01'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE02'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY02'         , width: 66},
					{dataIndex: 'ORD_NUM02'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/23' ,
				columns: [
					{dataIndex: 'ORD_STATE11'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY11'       	, width: 66 },
					{dataIndex: 'ORD_NUM11'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE12'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY12'         , width: 66},
					{dataIndex: 'ORD_NUM12'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/24' ,
				columns: [
					{dataIndex: 'ORD_STATE21'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY21'       	, width: 66 },
					{dataIndex: 'ORD_NUM21'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE22'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY22'         , width: 66},
					{dataIndex: 'ORD_NUM22'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/25' ,
				columns: [
					{dataIndex: 'ORD_STATE31'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY31'       	, width: 66 },
					{dataIndex: 'ORD_NUM31'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE32'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY32'         , width: 66},
					{dataIndex: 'ORD_NUM32'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/26' ,
				columns: [
					{dataIndex: 'ORD_STATE41'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY41'       	, width: 66 },
					{dataIndex: 'ORD_NUM41'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE42'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY42'         , width: 66},
					{dataIndex: 'ORD_NUM42'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/27' ,
				columns: [
					{dataIndex: 'ORD_STATE51'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY51'       	, width: 66 },
					{dataIndex: 'ORD_NUM51'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE52'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY52'         , width: 66},
					{dataIndex: 'ORD_NUM52'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/28' ,
				columns: [
					{dataIndex: 'ORD_STATE61'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY61'       	, width: 66 },
					{dataIndex: 'ORD_NUM61'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE62'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY62'         , width: 66},
					{dataIndex: 'ORD_NUM62'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/29' ,
				columns: [
					{dataIndex: 'ORD_STATE71'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY71'       	, width: 66 },
					{dataIndex: 'ORD_NUM71'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE72'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY72'         , width: 66},
					{dataIndex: 'ORD_NUM72'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/30' ,
				columns: [
					{dataIndex: 'ORD_STATE81'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY81'       	, width: 66 },
					{dataIndex: 'ORD_NUM81'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE82'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY82'         , width: 66},
					{dataIndex: 'ORD_NUM82'       	, width: 66 , hidden: true}
				]
			},
			{text :'2014/07/31' ,
				columns: [
					{dataIndex: 'ORD_STATE91'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY91'       	, width: 66 },
					{dataIndex: 'ORD_NUM91'       	, width: 66 , hidden: true},
					{dataIndex: 'ORD_STATE92'     	, width: 53 , hidden: true},
					{dataIndex: 'ORD_QTY92'         , width: 66},
					{dataIndex: 'ORD_NUM92'       	, width: 66 , hidden: true}
				]
			},
			{text :'<t:message code="system.label.product.maximumproductqty" default="최대생산량"/>' ,
				columns: [
					{dataIndex: 'MAX_QTY1'        	, width: 80},
					{dataIndex: 'NIGHT_MAX_QTY2'  	, width: 80}
				]
			},
			{text :'표준생산량' ,
				columns: [
					{dataIndex: 'STN_QTY1'        	, width: 80},
					{dataIndex: 'NIGHT_STN_QTY2'  	, width: 80}
				]
			}
		]
    });

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
		id: 'pmp060ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'pmp060ukrvGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
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
