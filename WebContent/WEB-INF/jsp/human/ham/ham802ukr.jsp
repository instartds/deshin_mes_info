<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="ham802ukr">
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
	<t:ExtComboStore items="${COMBO_SUPP_TYPE}" storeId="suppType" /><!-- 지급구분 REF_CODE1-->	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
.x-grid-row-readOnly {background-color:#EBEBEB;}
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript">

function appMain() {
	
	var colData = ${colData};
	var gsTaxDate;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read   : 'ham802ukrService.selectDetailList',
			update : 'ham802ukrService.updateDetail',
//			create : 'ham802ukrService.insertDetail',
//			destroy: 'ham802ukrService.deleteDetail',
			syncAll: 'ham802ukrService.saveAll'
		}
	});

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ham802ukrMasterModel', {
		fields: [
			{name: 'COMP_CODE'       	, text: '<t:message code="system.label.human.compcode"				default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'       	, text: '<t:message code="system.label.human.divcode"				default="사업장코드"/>'			, type: 'string'},
			{name: 'PERSON_NUMB'     	, text: '<t:message code="system.label.human.personnumb"			default="사번"/>'				, type: 'string'},
			{name: 'NAME'            	, text: '<t:message code="system.label.human.name"					default="성명"/>'				, type: 'string'},
			{name: 'DEPT_CODE'       	, text: '<t:message code="system.label.human.deptcode"				default="부서코드"/>'			, type: 'string'},
			{name: 'DEPT_NAME'       	, text: '<t:message code="system.label.human.deptname"				default="부서"/>'				, type: 'string'},
			{name: 'DUTY_DATE_FR'	 	, text: '<t:message code="system.label.human.dutyfrom"				default="근태집계기간FROM"/>'		, type: 'string'},	
			{name: 'DUTY_DATE_TO'		, text: '<t:message code="system.label.human.dutyto"				default="근태집계기간TO"/>'		, type: 'string'},
			{name: 'TAX_CODE'		 	, text: '<t:message code="system.label.human.taxcode"				default="연장수당세액"/>'			, type: 'string'},
			{name: 'HIRE_INSUR_TYPE' 	, text: '<t:message code="system.label.human.hireinsurtype2"		default="고용보험계산"/>'			, type: 'string'},
			{name: 'WORK_COMPEN_YN'		, text: '<t:message code="system.label.human.workconpenyn"			default="산재보험계산"/>'			, type: 'string'},
			{name: 'COMP_TAX_I'			, text: '<t:message code="system.label.human.taxcalculationmethod"	default="세액계산대상여부"/>'		, type: 'string'},
			{name: 'TAXRATE_BASE'		, text: '<t:message code="system.label.human.taxratebase"			default="소득세율기준"/>'			, type: 'string'},
			{name: 'PAY_PRESERVE_I'		, text: '<t:message code=""											default="시급"/>'				, type: 'uniPrice'},
			{name: 'MED_INSUR_I'		, text: '<t:message code="system.label.human.medinsuri"				default="건강보험공제대상액"/>'		, type: 'uniPrice'},
			{name: 'OLD_MED_INSUR_I'	, text: '<t:message code="system.label.human.oldmedinsuri"			default="장기요양보험공제대상액"/>'	, type: 'uniPrice'},
			{name: 'HIRE_INSUR_I'		, text: '<t:message code="system.label.human.hirinsuri"				default="고용보험공제대상액"/>'		, type: 'uniPrice'},
			{name: 'ANU_INSUR_I'		, text: '<t:message code="system.label.human.anuinsuriamt"			default="국민연금공제대상액"/>'		, type: 'uniPrice'},
			{name: 'EMPLOY_RATE'		, text: '<t:message code="system.label.human.employrate"			default="고용보험율"/>'			, type: 'uniER'},
			{name: 'BUSI_SHARE_RATE'	, text: '<t:message code="system.label.human.busisharerate"			default="사회보험사업자부담율"/>'	, type: 'uniER'},
			{name: 'WORKER_COMPEN_RATE'	, text: '<t:message code="system.label.human.workercompenrate"		default="산재보험율"/>'			, type: 'uniER'}
		]
	});

	Unilite.defineModel('Ham802ukrDetailModel', {
		fields: [
			{name: 'COMP_CODE'       	, text: '<t:message code="system.label.human.compcode"				default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'       	, text: '<t:message code="system.label.human.divcode"				default="사업장코드"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'     	, text: '<t:message code="system.label.human.personnumb"			default="사번"/>'				, type: 'string'},
			{name: 'NAME'            	, text: '<t:message code="system.label.human.name"					default="성명"/>'				, type: 'string'},
			{name: 'DEPT_CODE'       	, text: '<t:message code="system.label.human.deptcode"				default="부서코드"/>'			, type: 'string'},
			{name: 'DEPT_NAME'       	, text: '<t:message code="system.label.human.deptname"				default="부서"/>'				, type: 'string'},
			{name: 'PAY_YYYY'		 	, text: '<t:message code="system.label.human.payyyyy"				default="귀속년도"/>'			, type: 'string'},	
			{name: 'PAY_YYYYMM'			, text: '<t:message code="system.label.human.payyyyymm"				default="급여년월"/>'			, type: 'string'},
			{name: 'DUTY_YYYYMMDD'	 	, text: '<t:message code="system.label.human.dutyyyymmdd"			default="근무일"/>'			, type: 'string'},
			{name: 'HOLY_TYPE'	 		, text: '<t:message code="system.label.human.holytype"				default="휴무구분"/>'			, type: 'string'},	//	0: 휴일, 1: 반일, 2: 전일, 3: 휴무
			{name: 'SUPP_DATE'			, text: '<t:message code="system.label.human.suppdate"				default="지급일"/>'			, type: 'uniDate'},
			{name: 'QUARTER_TYPE'		, text: '<t:message code="system.label.human.quartertype"			default="귀속분기"/>'			, type: 'string'},
			{name: 'DUTY_TIME'			, text: '<t:message code="system.label.human.worktime1"				default="근무시간"/>'			, type: 'uniFC'},
			{name: 'WAGES_STD_I'		, text: '<t:message code=""											default="지급수당"/>'			, type: 'uniPrice'},
			{name: 'AMOUNT_I_01'		, text: '<t:message code="system.label.human.amounti01"				default="연장수당"/>'			, type: 'uniPrice'},
			{name: 'AMOUNT_I_02'		, text: '<t:message code="system.label.human.amounti02"				default="야간수당"/>'			, type: 'uniPrice'},
			{name: 'SUPP_TOTAL_I'		, text: '<t:message code=""			                                default="과세금액(수당합계)"/>'	, type: 'uniPrice'},
			{name: 'TAX_EXEMPTION_I'	, text: '<t:message code="system.label.human.nontaxi"				default="비과세금액"/>'		    , type: 'uniPrice'},
			{name: 'PAY_TOTAL_I'        , text: '<t:message code=""                                         default="지급총액"/>'          , type: 'uniPrice'},			
            {name: 'DED_TOTAL_I'        , text: '<t:message code="system.label.human.dedtotali"             default="공제총액"/>'           , type: 'uniPrice'},
            {name: 'REAL_AMOUNT_I'      , text: '<t:message code="system.label.human.realamounti"           default="실지급액"/>'           , type: 'uniPrice'},
			{name: 'IN_TAX_I'			, text: '<t:message code="system.label.human.intaxi"				default="소득세"/>'			, type: 'uniPrice'},
			{name: 'LOCAL_TAX_I'		, text: '<t:message code="system.label.human.loctaxi"				default="주민세"/>'			, type: 'uniPrice'},
			{name: 'ANU_INSUR_I'		, text: '<t:message code="system.label.human.anuinsuri"				default="국민연금"/>'			, type: 'uniPrice'},
			{name: 'MED_INSUR_I'		, text: '<t:message code="system.label.human.healthinsur"			default="건강보험"/>'			, type: 'uniPrice'},
			{name: 'OLD_MED_INSUR_I'	, text: '<t:message code=""											default="장기요양보험"/>'		    , type: 'uniPrice'},
			{name: 'HIR_INSUR_I'		, text: '<t:message code="system.label.human.hirinsuri"				default="고용보험"/>'			, type: 'uniPrice'}			
		]
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
			fieldLabel		: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>', 
			xtype			: 'uniMonthfield',
			name 			: 'DUTY_YM',
			allowBlank		: false,
			holdable		: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('DUTY_YM', newValue);
				}
			}
		}, Unilite.popup('DEPT', {
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			autoPopup		: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('DEPT_CODE', newValue);
					
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('DEPT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('DEPT_NAME', newValue);
					
					if(Ext.isEmpty(newValue) && panelSearch.getValue('DEPT_CODE') != '') {
						panelSearch.setValue('DEPT_CODE', '');
					}
				},
				onClear: function(type) {
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
					
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				}
            }
	    }), Unilite.popup('ParttimeEmployee', {
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			autoPopup		: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
						panelResult.setValue('NAME', panelSearch.getValue('NAME'));
					},
					scope: this
				},
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT' : UniDate.get('endOfMonth', panelSearch.getValues().DUTY_YM + "01")}); 
				},
				onClear: function(type) {
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				}
            }
	    })],
		setAllFieldsReadOnly: function(b) { 
			var r = true;
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});                      
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
					
					return r;
				}
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b);
					}
				}
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField') ;       
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(b);
					}
				}
			});
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2,
				   tdAttrds : {style:'vertical-align: top;'}
				  },
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>',
			xtype			: 'uniMonthfield',
			name 			: 'DUTY_YM',
			allowBlank		: false,
			holdable		: 'hold',
			colspan			: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_YM', newValue);
				}
			}
		}, Unilite.popup('DEPT', {
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			autoPopup		: true,
			validateBlank	: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
//						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);
					
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('DEPT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);
					
					if(Ext.isEmpty(newValue) && panelResult.getValue('DEPT_CODE') != '') {
						panelResult.setValue('DEPT_CODE', '');
					}
				},
				onClear: function(type) {
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
					
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				}
            }
	    }), Unilite.popup('ParttimeEmployee', {
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			autoPopup		: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
					},
					scope: this
				},
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT' : UniDate.get('endOfMonth', panelSearch.getValues().DUTY_YM + "01")}); 
				},
				onClear: function(type) {
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				}
            }
	    })],
		setAllFieldsReadOnly: function(b) { 
			var r = true;
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
					
					return r;
				}
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b); 
					}
				} 
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField') ;       
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(b);
					}
				}
			});
			return r;
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('ham802ukrMasterStore',{
		model: 'Ham802ukrMasterModel',
		uniOpt: {
			isMaster : false,			// 상위 버튼 연결 
			editable : false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi  : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 'ham802ukrService.selectMasterList'
			}
		},
		loadStoreRecords : function() {
			var param = panelSearch.getValues();
			console.log( param );
			this.load({ params : param});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				
			}
		}
	});

	var directDetailStore = Unilite.createStore('ham802ukrDetailStore',{
		model: 'Ham802ukrDetailModel',
		uniOpt: {
			isMaster : true,			// 상위 버튼 연결 
			editable : true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi  : false,			// prev | newxt 버튼 사용
			lastRecord : null
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(record) {
			var param = {
				COMP_CODE	: record.get('COMP_CODE'),
				DUTY_YM		: panelSearch.getValues().DUTY_YM,
				PERSON_NUMB	: record.get('PERSON_NUMB')
			};
			this.uniOpt.lastRecord = record;
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = Ext.getCmp('searchForm').getValues();
			var rv = true;
			
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directDetailStore.commitChanges();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var mRecord			= masterGrid.getSelectedRecord();
				var dutyDateFr		= mRecord.get('DUTY_DATE_FR');
				var dutyDateTo		= mRecord.get('DUTY_DATE_TO');
				var maxDutyDate		= dutyDateFr;
				
				Ext.each(records, function(record, index) {
					if(record.get('DUTY_YYYYMMDD') >= dutyDateFr && record.get('DUTY_YYYYMMDD') <= dutyDateTo) {
						if(record.get('HOLY_TYPE') == '2' && record.get('DUTY_YYYYMMDD') > maxDutyDate) {
							maxDutyDate = record.get('DUTY_YYYYMMDD');
						}
					}
				});
				
				gsTaxDate = maxDutyDate;
			}
		}
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('ham802ukrMasterGrid', {
		layout: 'fit',
		region: 'west',
		title : '사원정보',
		store : directMasterStore,
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: true,
			state: {
				useState	: false,
				useStateList: false
			}
		},
		selModel: 'rowmodel',
		columns:[
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DEPT_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DEPT_NAME'				, width: 150},
			{dataIndex: 'PERSON_NUMB'			, width:  80},
			{dataIndex: 'NAME'					, width: 100},
			{dataIndex: 'DUTY_DATE_FR'			, width: 100	, hidden: true},
			{dataIndex: 'DUTY_DATE_TO'			, width: 100	, hidden: true},
			{dataIndex: 'TAX_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'HIRE_INSUR_TYPE'		, width: 100	, hidden: true},
			{dataIndex: 'WORK_COMPEN_YN'		, width: 100	, hidden: true},
			{dataIndex: 'COMP_TAX_I'			, width: 100	, hidden: true},
			{dataIndex: 'TAXRATE_BASE'			, width: 100	, hidden: true},
			{dataIndex: 'MED_INSUR_I'			, width: 100	, hidden: true},
			{dataIndex: 'OLD_MED_INSUR_I'		, width: 100	, hidden: true},
			{dataIndex: 'HIRE_INSUR_I'			, width: 100	, hidden: true},
			{dataIndex: 'ANU_INSUR_I'			, width: 100	, hidden: true},
			{dataIndex: 'EMPLOY_RATE'			, width: 100	, hidden: true},
			{dataIndex: 'BUSI_SHARE_RATE'		, width: 100	, hidden: true},
			{dataIndex: 'WORKER_COMPEN_RATE'	, width: 100	, hidden: true}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					directDetailStore.loadStoreRecords(record);
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('ham802ukrDetailGrid', {
		layout: 'fit',
		region: 'center',
		title : '급여정보',
		flex  : 3.3,
		store : directDetailStore,
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		selModel: 'rowmodel',
		sortableColumns : false,
		features: [{
			id   : 'detailGridTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id   : 'detailGridTotal',
			ftype: 'uniSummary',
			dock : 'top',
			showSummaryRow: true
		}],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				var mRecord = masterGrid.getSelectedRecord();
				
				var basisDutyFr = mRecord.get('DUTY_DATE_FR');
				var basisDutyTo = mRecord.get('DUTY_DATE_TO');
				
				if(record.get('DUTY_YYYYMMDD') < basisDutyFr) {
					cls = 'x-grid-row-readOnly';
				}
				else if(record.get('DUTY_YYYYMMDD') > basisDutyTo) {
					cls = 'x-grid-row-readOnly';
				}
				
				return cls;
			}
		},
		tbar: [{
			xtype:'button',
			text :'공제계산',
			handler:function() {
				if(directMasterStore.getCount() < 1 || directDetailStore.getCount() < 1)
					return;
				
				UniAppManager.app.fnCalcTax();
			}
		}],
		columns:[
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DEPT_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DEPT_NAME'				, width: 100	, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 100	, hidden: true},
			{dataIndex: 'NAME'					, width: 100	, hidden: true},
			{dataIndex: 'PAY_YYYY'				, width: 100	, hidden: true},
			{dataIndex: 'PAY_YYYYMM'			, width: 100	, hidden: true},
			{text:'근태', columns:[
				{dataIndex: 'DUTY_YYYYMMDD'			, width:  100	, editable: false	, align: 'center'	,
					renderer: function(value, meta, record) {
						var holyType = record.get('HOLY_TYPE');
						var date = UniDate.safeFormat(value);
						
						if(holyType == '0' || holyType == '3') {
							return '<font color="red">' + date + '</font>';
						}
						else if(holyType == '1') {
							return '<font color="blue">' + date + '</font>';
						}
						return date;
					},
					summaryRenderer: function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
					}
				},
				{dataIndex: 'HOLY_TYPE'				, width: 100	, hidden: true},
				{dataIndex: 'SUPP_DATE'				, width: 100	, align: 'center'},
				{dataIndex: 'QUARTER_TYPE'			, width: 100	, hidden: true},
				{dataIndex: 'DUTY_TIME'				, width: 70}
			]},
			{text:'수당', columns:[
				{dataIndex: 'WAGES_STD_I'			, width: 100	, summaryType: 'sum'},
				{dataIndex: 'AMOUNT_I_01'			, width: 100	, summaryType: 'sum', hidden: true},
				{dataIndex: 'AMOUNT_I_02'			, width: 100	, summaryType: 'sum', hidden: true},
				{dataIndex: 'SUPP_TOTAL_I'          , width: 120    , summaryType: 'sum', hidden: true, editable: false},
				{dataIndex: 'TAX_EXEMPTION_I'		, width: 100	, summaryType: 'sum'}
				
			]},
			{dataIndex: 'PAY_TOTAL_I'           , width: 100    , summaryType: 'sum'    , editable: false},
			{dataIndex: 'DED_TOTAL_I'			, width: 100	, summaryType: 'sum'	, editable: false},
			{dataIndex: 'REAL_AMOUNT_I'			, width: 100	, summaryType: 'sum'	, editable: false},
			{text:'공제', columns:[
				{dataIndex: 'IN_TAX_I'				, width: 100	, summaryType: 'sum'},
				{dataIndex: 'LOCAL_TAX_I'			, width: 100	, summaryType: 'sum'},
				{dataIndex: 'ANU_INSUR_I'			, width: 100	, summaryType: 'sum'},
				{dataIndex: 'MED_INSUR_I'			, width: 100	, summaryType: 'sum'},
				{dataIndex: 'OLD_MED_INSUR_I'		, width: 100	, summaryType: 'sum'},
				{dataIndex: 'HIR_INSUR_I'			, width: 100	, summaryType: 'sum'}
			]}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				var mRecord = masterGrid.getSelectedRecord();
				var basisDutyFr = mRecord.get('DUTY_DATE_FR');
				var basisDutyTo = mRecord.get('DUTY_DATE_TO');
				var dutyDate = e.record.get('DUTY_YYYYMMDD');
				
				if(dutyDate < basisDutyFr || dutyDate > basisDutyTo) {
					return false;
				}
				
				if(dutyDate != gsTaxDate && UniUtils.indexOf(e.field, ['IN_TAX_I', 'LOCAL_TAX_I', 'ANU_INSUR_I', 'MED_INSUR_I', 'OLD_MED_INSUR_I', 'HIR_INSUR_I'])) {
					return false;
				}
				
				return true;
			},
			edit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['DUTY_TIME'])) {
					var mRecord		= masterGrid.getSelectedRecord();
					
					var payPreserveI	= Number(isNull(mRecord.get('PAY_PRESERVE_I')	, 0));
					var taxExemptionI	= Number(isNull(e.record.get('TAX_EXEMPTION_I')	, 0));
					var amountI01       = Number(isNull(e.record.get('AMOUNT_I_01') , 0));
                    var amountI02       = Number(isNull(e.record.get('AMOUNT_I_02') , 0));
					var dutyTime		= Number(isNull(e.record.get('DUTY_TIME')		, 0));
					
					var wagesStdI		= 0;
					var suppTotalI		= 0;
					var payTotlI        = 0;
					
					wagesStdI	= payPreserveI * dutyTime;
					suppTotalI	= wagesStdI + amountI01 + amountI02;
					payTotalI   = suppTotalI + taxExemptionI
					
					e.record.set('WAGES_STD_I'		, wagesStdI);
					e.record.set('SUPP_TOTAL_I'		, suppTotalI);
					e.record.set('PAY_TOTAL_I'      , payTotalI);
					//UniAppManager.app.fnCalcTax();
					UniAppManager.app.fnCalcAmt();
				}
				else if(UniUtils.indexOf(e.field, ['WAGES_STD_I', 'AMOUNT_I_01', 'AMOUNT_I_02', 'TAX_EXEMPTION_I'])) {
					var mRecord			= masterGrid.getSelectedRecord();
					
					var wagesStdI		= Number(isNull(e.record.get('WAGES_STD_I')	, 0));
					var amountI01       = Number(isNull(e.record.get('AMOUNT_I_01') , 0));
					var amountI02       = Number(isNull(e.record.get('AMOUNT_I_02') , 0));
					var taxExemptionI	= Number(isNull(e.record.get('TAX_EXEMPTION_I')	, 0));
					var suppTotalI		= 0;
					var payTotlI        = 0;
					var dedTotalI       = Number(isNull(e.record.get('DED_TOTAL_I')    , 0));
					var realAmountI     = 0;					
					
					suppTotalI	= wagesStdI + amountI01 + amountI02;
					payTotalI   = suppTotalI + taxExemptionI
//					realAmountI = payTotalI - dedTotalI
					
					e.record.set('SUPP_TOTAL_I'		, suppTotalI);
					e.record.set('PAY_TOTAL_I'      , payTotalI);
					e.record.set('REAL_AMOUNT_I'    , realAmountI);
					
					//UniAppManager.app.fnCalcTax();
					UniAppManager.app.fnCalcAmt();
				}
				else if(UniUtils.indexOf(e.field, ['IN_TAX_I', 'LOCAL_TAX_I', 'ANU_INSUR_I', 'MED_INSUR_I', 'OLD_MED_INSUR_I', 'HIR_INSUR_I'])) {
					var mRecord			= masterGrid.getSelectedRecord();
					
					var inTaxI			= Number(isNull(e.record.get('IN_TAX_I')	, 0));
					var localTaxI		= Number(isNull(e.record.get('LOCAL_TAX_I')	, 0));
					var anuInsurI		= Number(isNull(e.record.get('ANU_INSUR_I')	, 0));
					var medInsurI		= Number(isNull(e.record.get('MED_INSUR_I')	, 0));
					var oldMedInsurI	= Number(isNull(e.record.get('OLD_MED_INSUR_I')	, 0));
					var hirInsurI		= Number(isNull(e.record.get('HIR_INSUR_I')	, 0));
					var payTotalI       = 0;
					var dedTotalI		= 0;
					var realAmountI   	= 0;
					
					
					Ext.each(directDetailStore.data.items, function(record, index){
						payTotalI += Number(isNull(record.get('PAY_TOTAL_I')	, 0));
					});
					
					dedTotalI	= inTaxI + localTaxI + anuInsurI + medInsurI + oldMedInsurI + hirInsurI;
					realAmountI = payTotalI - dedTotalI;
					
					e.record.set('DED_TOTAL_I'			, dedTotalI);
					e.record.set('REAL_AMOUNT_I'		, realAmountI);
				}
			},
			edit_BAK : function( editor, e, eOpts ) {
				var mRecord		= masterGrid.getSelectedRecord();
				var mTaxCode	= mRecord.get('TAX_CODE');	//	1: 과세,	2: 비과세
				
				var wagesStdI	= Number(isNull(e.record.get('WAGES_STD_I')	, 0));
				var amountI01	= Number(isNull(e.record.get('AMOUNT_I_01')	, 0));
				var amountI02	= Number(isNull(e.record.get('AMOUNT_I_02')	, 0));
				var inTaxI		= Number(isNull(e.record.geCt('IN_TAX_I')	, 0));
				var localTaxI	= Number(isNull(e.record.get('LOCAL_TAX_I')	, 0));
				var hirInsurI	= Number(isNull(e.record.get('HIR_INSUR_I')	, 0));
				var suppTotalI	= 0;
				var taxExemptI	= 0;
				var realAmountI	= 0;
				
				if(mTaxCode == '1') {
					taxExemptI	= 0;
					suppTotalI	= wagesStdI + amountI01 + amountI02;
				}
				else {
					taxExemptI	= amountI01 + amountI02;
					suppTotalI	= wagesStdI + taxExemptI;
				}
				realAmountI	= suppTotalI - inTaxI - localTaxI - hirInsurI;
				
				if(realAmountI < 0) {
					realAmountI = 0;
				}
				
				e.record.set('SUPP_TOTAL_I'		, suppTotalI);
				e.record.set('TAX_EXEMPTION_I'	, taxExemptI);
				e.record.set('REAL_AMOUNT_I'	, realAmountI);
				
				UniAppManager.app.fnCalcTax();
			}
		}
	});
	
	function isNull(val, replaceVal) {
		if(Ext.isEmpty(replaceVal)) {
			replaceVal = '';
		}
		
		if(Ext.isEmpty(val)) {
			val = replaceVal;
		}
		
		return val;
	}

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, detailGrid, panelResult
			]
		},
			panelSearch
		],
		id  : 'ham802ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DUTY_YM', UniDate.get('today').substring(0, 6));
			panelResult.setValue('DUTY_YM', UniDate.get('today').substring(0, 6));
			
			UniAppManager.setToolbarButtons(['newData', 'delete', 'save'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			
			panelResult.setAllFieldsReadOnly(true);
			panelSearch.setAllFieldsReadOnly(true);
			
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown : function()	{
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.setAllFieldsReadOnly(false);
			
			panelResult.clearForm();
			panelSearch.clearForm();
			
			Ext.getCmp('ham802ukrMasterGrid').reset();
			
			UniAppManager.app.fnInitBinding();
		},
		onNewDataButtonDown : function() {
		},
		onDeleteDataButtonDown : function()	{
		},
		onSaveDataButtonDown : function() {
			directDetailStore.saveStore();
		},
		fnCalcAmt : function() {
			var suppTotalI      = 0;
			var taxExemptionI   = 0;
			
			var inTaxI			= 0;
			var localTaxI		= 0;
			var anuInsurI		= 0;
			var medInsurI		= 0;
			var oldMedInsurI	= 0;
			var hirInsurI		= 0;
			
			var payTotalI       = 0;
			var dedTotalI		= 0;
			var realAmountI		= 0;
			
			Ext.each(directDetailStore.data.items, function(record, index){
				var mRecord			= masterGrid.getSelectedRecord();
				//var mTaxCode		= mRecord.get('TAX_CODE');	//	1: 과세,	2: 비과세
				var dutyDateFr		= mRecord.get('DUTY_DATE_FR');
				var dutyDateTo		= mRecord.get('DUTY_DATE_TO');
				
				if(record.get('DUTY_YYYYMMDD') >= dutyDateFr && record.get('DUTY_YYYYMMDD') <= dutyDateTo) {
					suppTotalI		+= Number(isNull(record.get('SUPP_TOTAL_I')		, 0));
					taxExemptionI   += Number(isNull(record.get('TAX_EXEMPTION_I')  , 0));
					
					inTaxI			+= Number(isNull(record.get('IN_TAX_I')			, 0));
					localTaxI		+= Number(isNull(record.get('LOCAL_TAX_I')		, 0));
					anuInsurI		+= Number(isNull(record.get('ANU_INSUR_I')		, 0));
					medInsurI		+= Number(isNull(record.get('MED_INSUR_I')		, 0));
					oldMedInsurI	+= Number(isNull(record.get('OLD_MED_INSUR_I')	, 0));
					hirInsurI		+= Number(isNull(record.get('HIR_INSUR_I')		, 0));
				}
				else {
					if(Number(isNull(record.get('SUPP_TOTAL_I')		, 0)) != 0) {
						record.set('SUPP_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('TAX_EXEMPTION_I')	, 0)) != 0) {
						record.set('TAX_EXEMPTION_I', 0)
					}
					if(Number(isNull(record.get('IN_TAX_I')			, 0)) != 0) {
						record.set('IN_TAX_I', 0)
					}
					if(Number(isNull(record.get('LOCAL_TAX_I')		, 0)) != 0) {
						record.set('LOCAL_TAX_I', 0)
					}
					if(Number(isNull(record.get('ANU_INSUR_I')		, 0)) != 0) {
						record.set('ANU_INSUR_I', 0)
					}
					if(Number(isNull(record.get('MED_INSUR_I')		, 0)) != 0) {
						record.set('MED_INSUR_I', 0)
					}
					if(Number(isNull(record.get('OLD_MED_INSUR_I')	, 0)) != 0) {
						record.set('OLD_MED_INSUR_I', 0)
					}
					if(Number(isNull(record.get('HIR_INSUR_I')		, 0)) != 0) {
						record.set('HIR_INSUR_I', 0)
					}
					if(Number(isNull(record.get('PAY_TOTAL_I')		, 0)) != 0) {
						record.set('PAY_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('DED_TOTAL_I')		, 0)) != 0) {
						record.set('DED_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('REAL_AMOUNT_I')	, 0)) != 0) {
						record.set('REAL_AMOUNT_I', 0)
					}
					if(Number(isNull(record.get('DUTY_TIME')		, 0)) != 0) {
						record.set('DUTY_TIME', 0)
					}
					if(Number(isNull(record.get('WAGES_STD_I')		, 0)) != 0) {
						record.set('WAGES_STD_I', 0)
					}
					if(Number(isNull(record.get('SUPP_TOTAL_I')		, 0)) != 0) {
						record.set('SUPP_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('TAX_EXEMPTION_I')	, 0)) != 0) {
						record.set('TAX_EXEMPTION_I', 0)
					}
				}
				
				if(record.get('DUTY_YYYYMMDD') == gsTaxDate) {
					taxRow = record;
				}
			});
			
			payTotalI	= suppTotalI + taxExemptionI
			dedTotalI	= inTaxI + localTaxI + anuInsurI + medInsurI + oldMedInsurI + hirInsurI;
			realAmountI	= payTotalI - dedTotalI;
			
			taxRow.set('DED_TOTAL_I'		, dedTotalI);
			taxRow.set('REAL_AMOUNT_I'		, realAmountI);
		},
		fnCalcTax : function() {
			var mRecord			= masterGrid.getSelectedRecord();
			//var mTaxCode		= mRecord.get('TAX_CODE');	//	1: 과세,	2: 비과세
			var dutyDateFr		= mRecord.get('DUTY_DATE_FR');
			var dutyDateTo		= mRecord.get('DUTY_DATE_TO');
			var hirInsurType	= isNull(mRecord.get('HIRE_INSUR_TYPE')			, 'Y');
			var anuInsurIBase	= Number(isNull(mRecord.get('ANU_INSUR_I')		, 0));
			var medInsurIBase	= Number(isNull(mRecord.get('MED_INSUR_I')		, 0));
			var oldInsurIBase	= Number(isNull(mRecord.get('OLD_MED_INSUR_I')	, 0));
			var hirInsurIBase	= Number(isNull(mRecord.get('HIRE_INSUR_I')		, 0));
			var employRate		= Number(isNull(mRecord.get('EMPLOY_RATE')		, 0));
			var maxDutyDate		= dutyDateFr;
				
			var suppTotalI		= 0;
			var taxExemptionI	= 0;
			var inTaxI			= 0;
			var localTaxI		= 0;
			var taxRow;
			var dedTotalI		= 0;
			
			Ext.each(directDetailStore.data.items, function(record, index) {
				if(record.get('DUTY_YYYYMMDD') >= dutyDateFr && record.get('DUTY_YYYYMMDD') <= dutyDateTo) {
					suppTotalI		+= Number(isNull(record.get('SUPP_TOTAL_I')		, 0));
					taxExemptionI	+= Number(isNull(record.get('TAX_EXEMPTION_I')	, 0));
				}
				else {
					if(Number(isNull(record.get('SUPP_TOTAL_I')		, 0)) != 0) {
						record.set('SUPP_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('TAX_EXEMPTION_I')	, 0)) != 0) {
						record.set('TAX_EXEMPTION_I', 0)
					}
					if(Number(isNull(record.get('IN_TAX_I')			, 0)) != 0) {
						record.set('IN_TAX_I', 0)
					}
					if(Number(isNull(record.get('LOCAL_TAX_I')		, 0)) != 0) {
						record.set('LOCAL_TAX_I', 0)
					}
					if(Number(isNull(record.get('ANU_INSUR_I')		, 0)) != 0) {
						record.set('ANU_INSUR_I', 0)
					}
					if(Number(isNull(record.get('MED_INSUR_I')		, 0)) != 0) {
						record.set('MED_INSUR_I', 0)
					}
					if(Number(isNull(record.get('OLD_MED_INSUR_I')	, 0)) != 0) {
						record.set('OLD_MED_INSUR_I', 0)
					}
					if(Number(isNull(record.get('HIR_INSUR_I')		, 0)) != 0) {
						record.set('HIR_INSUR_I', 0)
					}
					if(Number(isNull(record.get('PAY_TOTAL_I')		, 0)) != 0) {
						record.set('PAY_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('DED_TOTAL_I')		, 0)) != 0) {
						record.set('DED_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('REAL_AMOUNT_I')	, 0)) != 0) {
						record.set('REAL_AMOUNT_I', 0)
					}
					if(Number(isNull(record.get('DUTY_TIME')		, 0)) != 0) {
						record.set('DUTY_TIME', 0)
					}
					if(Number(isNull(record.get('WAGES_STD_I')		, 0)) != 0) {
						record.set('WAGES_STD_I', 0)
					}
					if(Number(isNull(record.get('SUPP_TOTAL_I')		, 0)) != 0) {
						record.set('SUPP_TOTAL_I', 0)
					}
					if(Number(isNull(record.get('TAX_EXEMPTION_I')	, 0)) != 0) {
						record.set('TAX_EXEMPTION_I', 0)
					}
				}
				
				if(record.get('DUTY_YYYYMMDD') == gsTaxDate) {
					taxRow = record;
				}
			});
			
			if(hirInsurIBase == 0 && hirInsurType == 'Y') {
				hirInsurIBase = suppTotalI * employRate / 100;
				hirInsurIBase = Math.floor(hirInsurIBase / 10) * 10;
			}
			else {
				hirInsurIBase = 0;
			}
			
			realAmountI = suppTotalI + taxExemptionI;
			
//			suppTotalI = suppTotalI - 150000;
//			if(suppTotalI < 0) {
//				suppTotalI = 0;
//			}
			
			//inTaxI = Math.floor(suppTotalI * 0.027 / 10) * 10;
			//localTaxI = Math.floor(inTaxI / 100) * 10;
			
			inTaxI = 0;
			localTaxI = 0;
			
			if(realAmountI < inTaxI) {
				inTaxI = realAmountI;
				realAmountI = 0;
			}
			else {
				realAmountI = realAmountI - inTaxI;
			}
			
			if(realAmountI < localTaxI) {
				localTaxI = realAmountI;
				realAmountI = 0;
			}
			else {
				realAmountI = realAmountI - localTaxI;
			}
			
			if(realAmountI >= (anuInsurIBase + medInsurIBase + oldInsurIBase + hirInsurIBase)) {
				realAmountI = realAmountI - (anuInsurIBase + medInsurIBase + oldInsurIBase + hirInsurIBase);
			}
			else {
				anuInsurIBase = 0;
				medInsurIBase = 0;
				oldInsurIBase = 0;
				hirInsurIBase = 0;
			}
			
			dedTotalI = inTaxI + localTaxI + anuInsurIBase + medInsurIBase + oldInsurIBase + hirInsurIBase			
			
			taxRow.set('DED_TOTAL_I'		, dedTotalI);
			taxRow.set('REAL_AMOUNT_I'		, realAmountI);
			taxRow.set('IN_TAX_I'			, inTaxI);
			taxRow.set('LOCAL_TAX_I'		, localTaxI);
			taxRow.set('ANU_INSUR_I'		, anuInsurIBase);
			taxRow.set('MED_INSUR_I'		, medInsurIBase);
			taxRow.set('OLD_MED_INSUR_I'	, oldInsurIBase);
			taxRow.set('HIR_INSUR_I'		, hirInsurIBase);
		}
	})

};	
</script>