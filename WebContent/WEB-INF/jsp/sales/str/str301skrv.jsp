<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str301skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="str301skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"  comboCode="B001"/>
	<t:ExtComboStore comboType="AU"  comboCode="B024"/>
	<t:ExtComboStore comboType="AU"  comboCode="A"	/>
	<t:ExtComboStore comboType="AU"  comboCode="S006"/>
	<t:ExtComboStore comboType="AU"  comboCode="S007"/>
	<t:ExtComboStore comboType="AU"  comboCode="B020"/>
	<t:ExtComboStore comboType="AU"  comboCode="B021"/>
	<t:ExtComboStore comboType="AU"  comboCode="B036"/>
    <t:ExtComboStore comboType="AU"  comboCode="B001"/>
	<t:ExtComboStore comboType="AU"  comboCode="B116"/>
    <t:ExtComboStore comboType="AU"  comboCode="B013"/>
	<t:ExtComboStore comboType="AU"  comboCode="B010"/>
	<t:ExtComboStore comboType="AU"  comboCode="B039"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="O" /> 		<!--창고-->
</t:appConfig>
<script type="text/javascript" >
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
function appMain() {
	/**
	 * Model 정의
	 *
	 * @type
	 */

	Unilite.defineModel('str301skrvModel', {
	    fields:  [
	    			 {name:  'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
    				 {name:  'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
    				 {name:  'ITEM_NAME1'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'			,type: 'string'},
    				 {name:  'SPEC'                    	,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
    				 {name:  'ORDER_UNIT'              	,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string'},
    				 {name:  'INOUT_Q'                 	,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'		    ,type: 'uniQty'},
    				 {name:  'TRNS_RATE'               	,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'string'},
    				 {name:  'STOCK_UNIT'              	,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type: 'string'},
    				 {name:  'ORDER_UNIT_Q'            	,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'		    ,type: 'uniQty'},
    				 {name:  'WGT_UNIT'		          	,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'		,type: 'string'},
    				 {name:  'UNIT_WGT'		          	,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'		,type: 'float'},
    				 {name:  'INOUT_WGT_Q'		      	,text: '<t:message code="system.label.sales.receiptqtywgt" default="입고량(중량)"/>'	,type: 'float'},
    				 {name:  'INOUT_TYPE_DETAIL'       	,text: '<t:message code="system.label.sales.receiptplannedqty" default="입고유형"/>'		,type: 'string' ,comboType: "AU", comboCode: "S006"},
    				 {name:  'INOUT_CODE_TYPE'         	,text: '<t:message code="system.label.sales.tranplacedivision" default="수불처구분"/>'	    ,type: 'string' },
    				 {name:  'INOUT_CODE'              	,text: '<t:message code="system.label.sales.receiptplace" default="입고처CD"/>'		,type: 'string' },
    				 {name:  'INOUT_NAME'              	,text: '<t:message code="system.label.sales.receiptplaceworkcenter" default="입고처/작업장"/>'	,type: 'string'},
    				 {name:  'INOUT_DATE'              	,text: '<t:message code="system.label.sales.receiptdate" default="입고일"/>'		    ,type: 'uniDate'},
    				 {name:  'ITEM_STATUS'  		    ,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'		,type: 'string' ,comboType: "AU", comboCode: "B021"},
    				 {name:  'WH_CODE'                 	,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			,type: 'string', store:  Ext.data.StoreManager.lookup('whList')},
    				 {name:  'DIV_CODE'    		        ,text: '<t:message code="system.label.sales.division" default="사업장"/>'		    ,type: 'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
    				 {name:  'INOUT_NUM'               	,text: '<t:message code="system.label.sales.receiptno" default="입고번호"/>'		,type: 'string'},
    				 {name:  'INOUT_SEQ'               	,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'string'},
    				 {name:  'LOT_NO'                  	,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'	        ,type: 'string'},
    				 {name:  'PROJECT_NO'               ,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'   ,type: 'string'},
    				 {name:  'REMARK'                  	,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},
    				 {name:  'INOUT_PRSN'              	,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'		,type: 'string',comboType: "AU", comboCode: "B024"},
    				 {name:  'BASIS_NUM'		        ,text: '<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'   ,type: 'string'},
    				 {name:  'INOUT_METH'              	,text: '<t:message code="system.label.sales.receiptmethod" default="입고방법"/>'		,type: 'string' ,comboType: "AU", comboCode: "B036"},
    				 {name:  'EVAL_INOUT_P'            	,text: '<t:message code="system.label.sales.averageprice" default="평균단가"/>'		,type: 'uniUnitPrice'},
    				 {name:  'SORT_KEY'                	,text: 'SORTKEY'	    ,type: 'string' },
	    			 {name:  'UPDATE_DB_TIME'			,text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'		,type: 'string'},
	    			 {name:  'WKORD_NUM'				,text: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'		,type: 'string'}
			]
	});

    var directMasterStore1 = Unilite.createStore('str301skrvMasterStore',{
			model:  'str301skrvModel',
			uniOpt:  {
            	isMaster:  true,			// 상위 버튼 연결
            	editable:  false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi:  false			// prev | next 버튼 사용
            },
            autoLoad:  false,
            proxy:  {
                type:  'direct',
                api:  {
                	   read:  'str301skrvService.selectList1'
                }
            }
			,loadStoreRecords:  function()	{
				var param1 = panelSearch.getValues();
				var param2 = panelResult.getValues();
				var params = Ext.merge(param1 , param2);
				var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	// 부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
					params.DEPT_CODE = deptCode;
				}
				this.load({
					params:  params
				});
			},
			groupField:  'ITEM_CODE'

	});
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
					title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
		   		    itemId: 'search_panel1',
					layout: {type: 'uniTable', columns: 1},
					defaultType: 'uniTextfield',
					items: [{	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				        		name: 'DIV_CODE',
				        		holdable: 'hold',
				        		value : UserInfo.divCode,
				        		child: 'WH_CODE',
				        		xtype: 'uniCombobox',
				        		comboType: 'BOR120',
				        		allowBlank: false,
								listeners: {
									change: function(combo, newValue, oldValue, eOpts) {
										combo.changeDivCode(combo, newValue, oldValue, eOpts);
										var field = panelSearch.getField('INOUT_PRSN');
										field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
										panelResult.setValue('DIV_CODE', newValue);
									}
								}
				        	},

							{
								fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
								xtype: 'uniDateRangefield',
								startFieldName: 'FR_INOUT_DATE',
								endFieldName: 'TO_INOUT_DATE',
								startDate: UniDate.get('startOfMonth'),
								endDate: UniDate.get('today'),
								allowBlank: false,
								width: 315,
								colspan:3,
								onStartDateChange: function(field, newValue, oldValue, eOpts) {
				                	 if(panelResult) {
									 	panelResult.setValue('FR_INOUT_DATE',newValue);
				                	 }
							    },
							    onEndDateChange: function(field, newValue, oldValue, eOpts) {
							    	 if(panelResult) {
							    	 	panelResult.setValue('TO_INOUT_DATE',newValue);
							    	 }
							    }
							},
							{
								fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
								name: 'INOUT_PRSN',
								xtype:'uniCombobox',
								comboType: 'AU',
								comboCode: 'B024',
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {
										 panelResult.setValue('INOUT_PRSN', newValue);
									}
								},
								onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
									if(eOpts){
										combo.filterByRefCode('refCode1', newValue, eOpts.parent);
									}else{
										combo.divFilterByRefCode('refCode1', newValue, divCode);
									}
								}
							},

							Unilite.popup('DIV_PUMOK',{
								fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
								valueFieldName	: 'ITEM_CODE',
								textFieldName	: 'ITEM_NAME',
								validateBlank	: false,
								listeners: {
									onValueFieldChange: function(field, newValue, oldValue){
										panelResult.setValue('ITEM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('ITEM_NAME', '');
											panelResult.setValue('ITEM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){
										panelResult.setValue('ITEM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('ITEM_CODE', '');
											panelResult.setValue('ITEM_CODE', '');
										}
									},
									applyextparam: function(popup){
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
									}
								}
					 		}),
							{
								xtype:'label',
					 	 		colspan:1,
					 	 		hidden:false,
					 	 		itemId:'SEAT1'

							},
					 		{
								fieldLabel:  '<t:message code="system.label.sales.warehouse" default="창고"/>',
								name: 'WH_CODE',
								xtype:'uniCombobox',
								comboType   : 'O',
								listeners: {
										 change: function(field, newValue, oldValue, eOpts) {
										 panelResult.setValue('WH_CODE', newValue);
										 }
									}
							},
							{
								fieldLabel: '<t:message code="system.label.sales.totalrow" default="합계행"/>',
				    		 	xtype: 'radiogroup',
				    		 	itemId:'optSelect',
				    		 	width: 300,
				    		 	items:[{
				    		 		boxLabel:'<t:message code="system.label.sales.print" default="출력"/>',
				    		 		name: 'optSelect',
				    		 		inputValue: 'Y',
				    		 		checked: true
				    		 	},{
				    		 		boxLabel:'<t:message code="system.label.sales.noprint" default="미출력"/>',
				    		 		name:'optSelect',
				    		 		inputValue: 'N'
				    		 	}],
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {
										summaryHandle(newValue.optSelect);
										panelResult.setValue('optSelect',newValue.optSelect);
									}
								}

				    		},
				            {
				                fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				                name:'CREATE_LOC',
				                xtype: 'uniCombobox',
				                comboType:'AU',
				                hidden:true,
				                comboCode:'B031',
				                listeners: {
				                    change: function(field, newValue, oldValue, eOpts) {
				                         panelResult.setValue('CREATE_LOC', newValue);
				                    }
				                }
				            }
					]
				},
				{
				title: '<t:message code="system.label.sales.additionalsearch" default="추가검색"/>',
	   			itemId: 'search_panel2',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',
	    		items:[{
	    				fieldLabel:'<t:message code="system.label.sales.majorgroup" default="대분류"/>',
	    				name:'ITEM_LEVEL1',
	    				xtype:'uniCombobox',
	    				store:  Ext.data.StoreManager.lookup('itemLeve1Store'),
	    				child:  'ITEM_LEVEL2'
	    			},{
	    				fieldLabel:'<t:message code="system.label.sales.middlegroup" default="중분류"/>',
	    				name:'ITEM_LEVEL2',
	    				xtype:'uniCombobox',
	    				store:  Ext.data.StoreManager.lookup('itemLeve2Store'),
	    				child:  'ITEM_LEVEL3'
	    			},{
	    				fieldLabel:'<t:message code="system.label.sales.minorgroup" default="소분류"/>',
	    				name:'ITEM_LEVEL3',
	    				xtype:'uniCombobox',
	    				store:Ext.data.StoreManager.lookup('itemLeve3Store'),
						parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
			            levelType:'ITEM'
	    			},
	    				Unilite.popup('ITEM_GROUP',{
								fieldLabel:'<t:message code="system.label.sales.repmodel" default="대표모델"/>',
								valueFieldName:'ITEM_GROUP',
								textFieldName: 'ITEM_GROUP_NAME',
								validateBlank: false,
								popupWidth:710,
								listeners: {
									onSelected: {
										fn: function(records, type) {
											console.log('records : ', records);
				                    	},
										scope: this
									},
									onClear: function(type)	{

									},
									applyextparam: function(popup){
									}
							}
	    			}),{
			 	 		xtype:  'container',
			 	 		colspan: 2,
	 					layout:  {type:  'hbox', align: 'stretch'},
	 					width: 325,
	 					defaultType:  'uniTextfield',
	 					items: [{
	 						fieldLabel:'<t:message code="system.label.sales.receiptno" default="입고번호"/>',//출고번호
	 						suffixTpl: '&nbsp;~&nbsp;',
	 						name:'FR_INOUT_NO',
	 						width: 218
	 					},{
	 						hideLabel:true,
	 						name:'TO_INOUT_NO',
	 						width: 107
	 					}]
			   		},{
			   			fieldLabel:'Lot No.',
			   			name:'LOT_NO',
			   			width: 325,
			   			xtype:'uniTextfield'
			   		},{
			   			fieldLabel:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
			   			name:'ITEM_ACCOUNT',
			   			xtype:'uniCombobox',
			   			comboType:'AU',
			   			comboCode: 'B020'
			   		},{

			 	 		xtype:  'container',
			 	 		colspan: 2,
	 					layout:  {type:  'hbox', align: 'stretch'},
	 					width: 325,
	 					defaultType:  'uniTextfield',
	 					items: [{
	 						fieldLabel:'<t:message code="system.label.sales.receiptqty" default="입고량"/>',//출고량
	 						suffixTpl:'&nbsp;~&nbsp;',
	 						name:'FR_INOUT_QTY',
	 						width: 218
	 					},{
	 						hideLabel:true,
	 						name:'TO_INOUT_QTY',
	 						width: 107
	 					}]
	 				},{
	 					fieldLabel:'<t:message code="system.label.sales.receiptplannedqty" default="입고유형"/>',//출고유형
	 					name: 'INOUT_TYPE_DETAIL',
	 					xtype:'uniCombobox',
	 					comboType:'AU',
	 					comboCode: 'S006'
	 				},{
	 					fieldLabel:'<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>',
	 					name:'GOOD_BAD',
	 					xtype:'uniCombobox',
	 					comboType: 'AU',
	 					comboCode: 'B021'
	 				},
	 				Unilite.popup('AGENT_CUST', {
						fieldLabel: '<t:message code="system.label.sales.issueplace" default="출고처"/>',
						valueFieldName:'CUSTOM_CODE',
				    	textFieldName:'CUSTOM_NAME',
						valueFieldWidth: 85,
						textFieldWidth: 150,
						holdable: 'hold',
						itemId:'CUSTOM_CODE',
						hidden:true,
						colspan: 2,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
		                    	},
								scope: this
							},
							onClear: function(type)	{
										CustomCodeInfo.gsUnderCalBase = '';
									}
						}
					}),
	 				{
			 	 		xtype:  'container',
			 	 		colspan: 2,
	 					layout:  {type:  'hbox', align: 'stretch'},
	 					width: 325,
	 					itemId:'FR_ORDER_NUM',
	 					defaultType:  'uniTextfield',
	 					items: [{
	 						fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
	 						suffixTpl:'&nbsp;~&nbsp;',
	 						name:'FR_ORDER_NUM',
	 						width: 218
	 					},{
	 						hideLabel:true,
	 						name:'TO_ORDER_NUM',
	 						width: 107
	 					}]
	 				},{
	 					fieldLabel:'PO_NO',
	 					name:'PO_NO',
	 					hidden:true,
	 					width: 300
	 				},{
	 					fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
	        		 	xtype: 'radiogroup',
	        		 	itemId:'TYPE',
	                    id:'TYPE_RDO',
	        		 	hidden:true,
	        		 	width: 300,
	        		 	items:[{
	        		 		boxLabel:'<t:message code="system.label.sales.itemby" default="품목별"/>',
	        		 		name: 'TYPE',
	        		 		inputValue: '1',
	        		 		checked: true
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.byissueplace" default="출고처별"/>',
	        		 		name:'TYPE',
	        		 		inputValue: '2'
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.bydeliveryplacename" default="배송처별"/>',
	        		 		name:'TYPE',
	        		 		inputValue: '3'
	        		 	}]

	        		},{
	        			fieldLabel: '<t:message code="system.label.sales.deliverylapse" default="납기경과"/>',
	        		 	xtype: 'radiogroup',
	        		 	itemId:'DELIVERY',
	        		 	width: 300,
	        		 	hidden:true,
	        		 	items: [{
	        		 		boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>',
	        		 		name:'DELIVERY',
	        		 		inputValue: '0',
	        		 		checked: true
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.deliveryobservance" default="납기준수"/>',
	        		 		name:'DELIVERY',
	        		 		inputValue: '1'
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.deliverylapse" default="납기경과"/>',
	        		 		name:'DELIVERY',
	        		 		inputValue: '2'
	        		 	}]

	        		},{
	        		 	xtype: 'radiogroup',
	        		 	fieldLabel: '<t:message code="system.label.sales.returninclusionyn" default="반품포함여부"/>',
	        		 	itemId:'RETURN',
	        		 	width: 300,
	        		 	hidden:true,
	        		 	items: [{
	        		 		boxLabel:'<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
	        		 		name:'RETURN',
	        		 		inputValue: '1',
	        		 		checked: true
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.inclusion" default="포함"/>',
	        		 		name:'RETURN',
	        		 		inputValue: '2'
	        		 	},{
	        		 		hidden: true
	        		 	}]
	        		},{
	        			fieldLabel: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>',
	        		 	xtype: 'radiogroup',
	        		 	itemId:'ACCOUNT_YNC',
	        		 	width: 300,
	        		 	hidden:true,
	        		 	items: [{
	        		 		boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>',
	        		 		name:'ACCOUNT_YNC',
	        		 		inputValue: '',
	        		 		checked: true
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.yes" default="예"/>',
	        		 		name:'ACCOUNT_YNC',
	        		 		inputValue: 'Y'
	        		 	},{
	        		 		boxLabel:'<t:message code="system.label.sales.no" default="아니오"/>',
	        		 		name:'ACCOUNT_YNC',
	        		 		inputValue: 'N'
	        		 	}]
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}

					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
	});

    var panelResult = Unilite.createSearchForm('panelResultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        defaultType: 'uniSearchSubPanel',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		child: 'WH_CODE',
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},

			{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				colspan:3,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	 if(panelSearch) {
					 	panelSearch.setValue('FR_INOUT_DATE',newValue);
                	 }
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	 if(panelSearch) {
			    	 	panelSearch.setValue('TO_INOUT_DATE',newValue);
			    	 }
			    }
			},
			{
				fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype:'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						 panelSearch.setValue('INOUT_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},

			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			 	validateBlank	: false,
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
	 		}),
			{
				xtype:'label',
	 	 		colspan:1,
	 	 		hidden:false,
	 	 		itemId:'SEAT1'

			},
	 		{
				fieldLabel:  '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype:'uniCombobox',
				comboType   : 'O',
				listeners: {
						 change: function(field, newValue, oldValue, eOpts) {
						 panelSearch.setValue('WH_CODE', newValue);
						 }
					}
			},
			{
				fieldLabel: '<t:message code="system.label.sales.totalrow" default="합계행"/>',
    		 	xtype: 'radiogroup',
    		 	itemId:'optSelect',
    		 	width: 300,
    		 	items:[{
    		 		boxLabel:'<t:message code="system.label.sales.print" default="출력"/>',
    		 		name: 'optSelect',
    		 		inputValue: 'Y',
    		 		checked: true
    		 	},{
    		 		boxLabel:'<t:message code="system.label.sales.noprint" default="미출력"/>',
    		 		name:'optSelect',
    		 		inputValue: 'N'
    		 	}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						summaryHandle(newValue.optSelect);
						panelSearch.setValue('optSelect',newValue.optSelect);
					}
				}

    		},
            {
                fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
                name:'CREATE_LOC',
                xtype: 'uniCombobox',
                comboType:'AU',
                hidden:true,
                comboCode:'B031',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                         panelSearch.setValue('CREATE_LOC', newValue);
                    }
                }
            }
	]



    });

    var masterGrid = Unilite.createGrid('str301skrvGrid1', {
		store	:  directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		title	: '<t:message code="system.label.sales.byreceipt" default="입고별"/>',
		tbar	: [{
			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype		: 'uniNumberfield',
			id			: 'selectionSummary',
//			readOnlfy	: true,
			decimalPrecision: 4,
			format		: '0,000.0000',
			labelWidth	: 110,
			value		: 0
		}],
		uniOpt:{
        		expandLastColumn: false,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
    	           	 {id:  'masterGridTotal'   , ftype:  'uniSummary'        , showSummaryRow:  true} ],
        columns: [   { dataIndex: 'ITEM_CODE'		   	,width: 120 ,locked: false,
                         summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			                 return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.itemtotal" default="품목계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
                         }
                     },
					 { dataIndex: 'ITEM_NAME'		    ,width: 160 ,locked: false},
					 { dataIndex: 'ITEM_NAME1'		    ,width: 160 ,hidden: true},
					 { dataIndex: 'SPEC'				,width: 120 },
					 { dataIndex: 'ORDER_UNIT'		    ,width: 60  , align: 'center' ,hidden:true},
					 { dataIndex: 'TRNS_RATE'		    ,width: 90 },
					 { dataIndex: 'STOCK_UNIT'			,width: 120, align: 'center'  },
					 { dataIndex: 'INOUT_Q'			 	,width: 113 ,summaryType:'sum'},
					 { dataIndex: 'ORDER_UNIT_Q'        ,width: 90 ,hidden:true},
					 { dataIndex: 'WGT_UNIT'		    ,width: 80 },
					 { dataIndex: 'UNIT_WGT'		    ,width: 80 },
					 { dataIndex: 'INOUT_WGT_Q'			,width: 100 },
					 { dataIndex: 'INOUT_TYPE_DETAIL'   ,width: 120 },
					 { dataIndex: 'INOUT_CODE_TYPE'  	,width: 60 ,hidden:true},
					 { dataIndex: 'INOUT_CODE'       	,width: 80, hidden: true   },
					 { dataIndex: 'INOUT_NAME'       	,width: 120 },
					 { dataIndex: 'INOUT_DATE'		  	,width: 80 },
					 { dataIndex: 'ITEM_STATUS'  	    ,width: 120 },
					 { dataIndex: 'WH_CODE'             ,width: 110, align: 'center'   },
					 { dataIndex: 'DIV_CODE'    		,width: 120 },
					 { dataIndex: 'INOUT_NUM'           ,width: 100 },
					 { dataIndex: 'INOUT_SEQ'           ,width: 80   },
					 { dataIndex: 'LOT_NO'              ,width: 100 },
					 { dataIndex: 'PROJECT_NO'          ,width: 100 },
					 { dataIndex: 'REMARK'              ,width: 120 },
					 { dataIndex: 'INOUT_PRSN'          ,width: 100 },
					 { dataIndex: 'BASIS_NUM'		    ,width: 110 },
					 { dataIndex: 'WKORD_NUM'		    ,width: 110 },
					 { dataIndex: 'INOUT_METH'          ,width: 80   },
					 { dataIndex: 'EVAL_INOUT_P'        ,width: 100   },
					 { dataIndex: 'SORT_KEY'            ,width: 120, hidden: true   }
		] ,
		listeners:{
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName	= selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");

					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx	= selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store		= grid.store;
						var sum			= 0;

						for(var i = startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						displayField.setValue(sum);
					} else {
						displayField.setValue(0);
					}
				}
			}
		}
    });


    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid,  panelResult
         	]
      	},panelSearch
      	// panelSearch
      	],
		id: 'str301skrvApp',
		fnInitBinding:  function() {

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_INOUT_DATE')));

			str301skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				 	panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			var activeTabId = tab.getActiveTab().getId();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(!this.isValidSearchForm()){
                return false;
            }
			directMasterStore1.loadStoreRecords();
			summaryHandle(panelResult.down("#optSelect").getValue().optSelect);
            UniAppManager.setToolbarButtons('reset', true)
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
	function summaryHandle(type){
		var viewNormal = masterGrid.getView();
		if(type == 'Y'){
	    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
	    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		}else{
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
	    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
		}
	}

};

</script>