<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms100skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mms100skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />			<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q031" />			<!-- 조회구분(접수구분) -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" />			<!-- 최종판정 -->
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

	Unilite.defineModel('Mms100skrvModel1', {
		fields: [
			{name: 'DIV_CODE'    	        , text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'   	       	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'	, type: 'string'},
	    	{name: 'CUSTOM_NAME'   	       	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},

//	    	{name: 'DEPT_CODE'   	       	, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'		, type: 'string'},
//	    	{name: 'DEPT_NAME'   	       	, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'		, type: 'string'},

	    	{name: 'ORDER_TYPE'    	       	, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'		, type: 'string',comboType:'AU', comboCode:'M001'},
	    	{name: 'ORDER_DATE'    	       	, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		, type: 'uniDate'},
	    	{name: 'ITEM_CODE'    	        , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'    	        , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'    	            , text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
	    	{name: 'DVRY_DATE'    	        , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
	    	{name: 'ORDER_UNIT'		       	, text: '<t:message code="system.label.purchase.unit" default="단위"/>'		, type: 'string'},
	    	{name: 'ORDER_Q'		        , text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
	    	{name: 'RECEIPT_DATE'		    , text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
	    	{name: 'RECEIPT_PRSN'    	    , text: '<t:message code="system.label.purchase.receptionist" default="접수자"/>'		, type: 'string',comboType:'AU', comboCode:'Q021'},
	    	{name: 'RECEIPT_Q'		        , text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
	    	{name: 'NOTRECEIPT_Q'    	    , text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'		, type: 'uniQty'},
	    	{name: 'ORDER_NUM'    	        , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'},
	    	{name: 'ORDER_SEQ'              , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'		, type: 'int'},
	    	{name: 'RECEIPT_NUM'            , text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
	    	{name: 'RECEIPT_SEQ'     	    , text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
	    	{name: 'ORDER_REMARK'     	    , text: '<t:message code="system.label.purchase.poremark" default="발주비고"/>'		, type: 'string'},
	    	{name: 'ORDER_PROJECT_NO'       , text: '<t:message code="system.label.purchase.poprojectnum" default="발주관리번호"/>'	, type: 'string'},
	    	{name: 'RECEIPT_REMARK'         , text: '<t:message code="system.label.purchase.receiptremark" default="접수비고"/>'		, type: 'string'},
	    	{name: 'RECEIPT_PROJECT_NO'		, text: '<t:message code="system.label.purchase.receiptprojectno" default="접수관리번호"/>'	, type: 'string'}
		]
	});//Unilite.defineModel('Mms100skrvModel1', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mms100skrvMasterStore1', {
		model: 'Mms100skrvModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mms100skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			/*var param= panelSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});*/


			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});


		}

	});//End of var directMasterStore1 = Unilite.createStore('mms100skrvMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME',
//				textFieldWidth:170,
//				validateBlank:false,
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUST_CODE', newValue);
								panelResult.setValue('CUST_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUST_NAME', '');
									panelResult.setValue('CUST_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUST_NAME', newValue);
								panelResult.setValue('CUST_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUST_CODE', '');
									panelResult.setValue('CUST_CODE', '');
								}
							}
					}
			}),/*
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장

							if(authoInfo == "A"){	//자기사업장
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});

							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});

							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),*/
			{
				fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
//				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
/*     				startDate: UniDate.get('startOfMonth'),
    				endDate: UniDate.get('today'), */
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                    	panelSearch.setValue('ORDER_DATE_FR',newValue);
                        //panelResult.getField('ISSUE_REQ_DATE_FR').validate();

                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                    	panelSearch.setValue('ORDER_DATE_TO',newValue);
                        //panelResult.getField('ISSUE_REQ_DATE_TO').validate();
                    }
                }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
				endFieldName: 'RECEIPT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('RECEIPT_DATE_FR',newValue);
                        //panelResult.getField('ISSUE_REQ_DATE_FR').validate();

                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('RECEIPT_DATE_TO',newValue);
                        //panelResult.getField('ISSUE_REQ_DATE_TO').validate();
                    }
                }
			},{
				fieldLabel: '<t:message code="system.label.purchase.inquiryclass" default="조회구분"/>',
				name: 'TOT_RECEIPT_Q',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'Q031',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('TOT_RECEIPT_Q', newValue);
                    }
                }
			},{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}

					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
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
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUST_CODE',
			textFieldName: 'CUST_NAME',
//			textFieldWidth:170,
//			validateBlank:false,
			popupWidth: 710,
			extParam: {'CUSTOM_TYPE': ['1','2']},
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUST_CODE', newValue);
							panelResult.setValue('CUST_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUST_NAME', '');
								panelResult.setValue('CUST_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUST_NAME', newValue);
							panelResult.setValue('CUST_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUST_CODE', '');
								panelResult.setValue('CUST_CODE', '');
							}
						}
				}
		}),{
            fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'ORDER_DATE_FR',
            endFieldName: 'ORDER_DATE_TO',
          /*   startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'), */
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('ORDER_DATE_FR',newValue);
                    //panelResult.getField('ISSUE_REQ_DATE_FR').validate();

                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('ORDER_DATE_TO',newValue);
                    //panelResult.getField('ISSUE_REQ_DATE_TO').validate();
                }
            }
        },/*
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장

							if(authoInfo == "A"){	//자기사업장
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});

							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});

							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),*/
		{
			fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
//			textFieldWidth: 170,
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
				}
		}),{
            fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'RECEIPT_DATE_FR',
            endFieldName: 'RECEIPT_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('RECEIPT_DATE_FR',newValue);
                    //panelResult.getField('ISSUE_REQ_DATE_FR').validate();

                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('RECEIPT_DATE_TO',newValue);
                    //panelResult.getField('ISSUE_REQ_DATE_TO').validate();
                }
            }
        },{
            fieldLabel: '<t:message code="system.label.purchase.inquiryclass" default="조회구분"/>',
            name: 'TOT_RECEIPT_Q',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'Q031',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('TOT_RECEIPT_Q', newValue);
                }
            }
        },{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('mms100skrvGrid1', {
    	// for tab
		layout: 'fit',
		region:'center',
		excelTitle: '<t:message code="system.label.purchase.receiptstatusinquiry" default="접수현황조회"/>',
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
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 80,locked:true,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			{dataIndex: 'CUSTOM_NAME'			, width: 150,locked:true},

//			{dataIndex: 'DEPT_CODE'			, width: 80},
//			{dataIndex: 'DEPT_NAME'			, width: 120},
			{dataIndex: 'ORDER_TYPE'			, width: 80, align:'center'},
			{dataIndex: 'ORDER_DATE'			, width: 80},
			{dataIndex: 'ITEM_CODE'				, width: 100},
			{dataIndex: 'ITEM_NAME'				, width: 200},
			{dataIndex: 'SPEC'					, width: 80},
			{dataIndex: 'DVRY_DATE'				, width: 80},
			{dataIndex: 'ORDER_UNIT'			, width: 53, align:'center'},
			{dataIndex: 'ORDER_Q'				, width: 80,summaryType: 'sum'},
			{dataIndex: 'RECEIPT_DATE'			, width: 80},
			{dataIndex: 'RECEIPT_PRSN'			, width: 66, align:'center'},
			{dataIndex: 'RECEIPT_Q'				, width: 80,summaryType: 'sum'},
			{dataIndex: 'NOTRECEIPT_Q'			, width: 80,summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'				, width: 133},
			{dataIndex: 'ORDER_SEQ'				, width: 66},
			{dataIndex: 'RECEIPT_NUM'			, width: 133},
			{dataIndex: 'RECEIPT_SEQ'			, width: 66},
			{dataIndex: 'ORDER_REMARK'			, width: 133},
			{dataIndex: 'ORDER_PROJECT_NO'		, width: 133},
			{dataIndex: 'RECEIPT_REMARK'		, width: 133},
			{dataIndex: 'RECEIPT_PROJECT_NO'	, width: 133}
		]
	});//End of var masterGrid = Unilite.createGrid('mms100skrvGrid1', {

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
		id: 'mms100skrvApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			/* panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today')); */
			panelSearch.setValue('RECEIPT_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('RECEIPT_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('TOT_RECEIPT_Q', 'Y');
            panelResult.setValue('TOT_RECEIPT_Q', 'Y');
			panelSearch.setValue('ORDER_TYPE', '1');
			panelResult.setValue('ORDER_TYPE', '1');


			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
};//End of Unilite.Main({

</script>
