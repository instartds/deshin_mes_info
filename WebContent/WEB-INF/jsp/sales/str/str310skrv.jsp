<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str310skrv" >	
	<t:ExtComboStore comboType="BOR120" pgmId="str310skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->      
	<t:ExtComboStore comboType="AU" comboCode="S006" /> <!--입고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B036" /> <!--수불방법-->
	<t:ExtComboStore comboType="AU" comboCode="B116" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="B039" /> <!--출고방법-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts='1;5' /> <!--생성경로-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('str310skrvModel', {
	    fields:  [   {name:  'ITEM_CODE1'              	,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
	    			 {name:  'ITEM_NAME1'              	,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
	    			 {name:  'ITEM_CODE2'              	,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
	    			 {name:  'ITEM_NAME2'              	,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
	    			 {name:  'SPEC'                    	,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
	    			 {name:  'PRICE_TYPE'		      	,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'		,type: 'string'},
	    			 {name:  'ORDER_UNIT'              	,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string'},
	    			 {name:  'ORDER_UNIT_Q'            	,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'			,type: 'uniQty'},
	    			 {name:  'ORDER_UNIT_P'            	,text: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>'		,type: 'uniPrice'},
	    			 {name:  'WGT_UNIT'		          	,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'		,type: 'string'},
	    			 {name:  'UNIT_WGT'		          	,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'		,type: 'float'},
	    			 {name:  'INOUT_WGT_Q'		      	,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	,type: 'float'},
	    			 {name:  'INOUT_FOR_WGT_P'	      	,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'		,type: 'string'},
	    			 {name:  'VOL_UNIT'		          	,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'		,type: 'string'},
	    			 {name:  'UNIT_VOL'		          	,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'		,type: 'string'},
	    			 {name:  'INOUT_VOL_Q'		      	,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'	,type: 'string'},
	    			 {name:  'INOUT_FOR_VOL_P'	      	,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'		,type: 'string'},
	    			 {name:  'TRNS_RATE'               	,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'string'},
	    			 {name:  'STOCK_UNIT'              	,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type: 'string'},
	    			 {name:  'INOUT_Q'                 	,text: '재고단위출고량'	,type: 'uniQty'},
	    			 {name:  'INOUT_P'                 	,text: '재고단가'		,type: 'string'},
	    			 {name:  'MONEY_UNIT'              	,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type: 'string'},
	    			 {name:  'EXCHG_RATE_O'            	,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'			,type: 'uniER'},
	    			 {name:  'INOUT_FOR_O'             	,text: '<t:message code="system.label.sales.foreigncurrencyamount" default="외화금액"/>'		,type: 'uniFC'},
	    			 {name:  'INOUT_I'                 	,text: '원화금액'		,type: 'uniPrice'},
	    			 {name:  'TRANS_COST'              	,text: '<t:message code="system.label.sales.shippingcharge" default="운반비"/>'			,type: 'string'},
	    			 {name:  'INOUT_TYPE_DETAIL'       	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'		,type: 'string' ,comboType: "AU", comboCode: "S007"},
	    			 {name:  'INOUT_CODE_TYPE'         	,text: '<t:message code="system.label.sales.tranplacedivision" default="수불처구분"/>'		,type: 'string'},
	    			 {name:  'INOUT_CODE'              	,text: '출고처CD'		,type: 'string'},
	    			 {name:  'INOUT_NAME'              	,text: '<t:message code="system.label.sales.issueplace" default="출고처"/>'			,type: 'string'},
	    			 {name:  'INOUT_DATE'              	,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			,type: 'uniDate'},
	    			 {name:  'DVRY_CUST_NAME'          	,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			,type: 'string'},
	    			 {name:  'DOM_FORIGN'              	,text: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>'		,type: 'string'},
	    			 {name:  'WH_CODE'                 	,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			,type: 'string', store:  Ext.data.StoreManager.lookup('whList')},
	    			 {name:  'INOUT_PRSN'              	,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'		,type: 'string',comboType: "AU", comboCode: "B024"},
	    			 {name:  'ISSUE_DATE'		      	,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		,type: 'uniDate'},
	    			 {name:  'ISSUE_REQ_NUM'           	,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type: 'string'},
	    			 {name:  'LOT_NO'                  	,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'			,type: 'string'},
	    			 {name:  'REMARK'                  	,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},
	    			 {name:  'ACCOUNT_YNC'             	,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'		,type: 'string' ,comboType: "AU", comboCode: "B010"},
	    			 {name:  'ORDER_NUM'               	,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'		,type: 'string'},
	    			 {name:  'DVRY_DATE'		        ,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
	    			 {name:  'DELIVERY_DATE'	        ,text: '<t:message code="system.label.sales.deliverydate2" default="납품일"/>'			,type: 'uniDate'},
	    			 {name:  'ACCOUNT_Q'               	,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'			,type: 'uniQty'},
	    			 {name:  'LC_NUM'                  	,text: 'L/C번호'		,type: 'string'},
	    			 {name:  'INOUT_NUM'               	,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'		,type: 'string'},
	    			 {name:  'PO_NUM'			      	,text: 'PO_NUM'			,type: 'string'},
	    			 {name:  'PO_SEQ'                  	,text: 'PO_SEQ'			,type: 'string'},
	    			 {name:  'INOUT_SEQ'               	,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'string'},
	    			 {name:  'INOUT_METH'              	,text: '출고방법'		,type: 'string' ,comboType: "AU", comboCode: "B039"},
	    			 {name:  'EVAL_INOUT_P'            	,text: '평균단가'		,type: 'uniUnitPrice'},
	    			 {name:  'SORT_KEY'                	,text: 'SORTKEY'		,type: 'string'},	    			
	    			 {name:  'UPDATE_DB_TIME'          	,text: '등록일시'		,type: 'string'}
	    			
			]
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
		var MasterStore = Unilite.createStore('str310skrvMasterStore',{
			model:  'str310skrvModel',
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
                	   read:  'str310skrvService.selectList'                	
                }
            }
			,loadStoreRecords:  function()	{
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params:  param
				});
				
			},
			groupField:  'ITEM_NAME1'
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

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
		    items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		child: 'WH_CODE',
        		holdable: 'hold',
        		allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('TXT_INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
					
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));		
								panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
								panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel:  '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype:'uniCombobox',  
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WH_CODE', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
			},{
				fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
				name: 'TXT_INOUT_PRSN', 
				xtype:'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXT_INOUT_PRSN', newValue);
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
			        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	
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
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			 }),{
			   fieldLabel:  '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
			   name: 'TXT_CREATE_LOC', 
			   xtype:'uniCombobox', 
			   comboType: 'AU',
			   comboCode: 'B031',
			   listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXT_CREATE_LOC', newValue);
						}
					}
			   }]
		},{
			title: '추가검색', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
    		items:[{ 
    				fieldLabel:'<t:message code="system.label.sales.majorgroup" default="대분류"/>',
    				name:'TXTLV_L1', 
    				xtype:'uniCombobox',  
    				store:  Ext.data.StoreManager.lookup('itemLeve1Store'), 
    				child:  'TXTLV_L2'
    			},{ 
    				fieldLabel:'<t:message code="system.label.sales.middlegroup" default="중분류"/>',
    				name:'TXTLV_L2', 
    				xtype:'uniCombobox',  
    				store:  Ext.data.StoreManager.lookup('itemLeve2Store'), 
    				child:  'TXTLV_L3'
    			},{ 
    				fieldLabel:'<t:message code="system.label.sales.minorgroup" default="소분류"/>',
    				name:'TXTLV_L3',
    				xtype:'uniCombobox',
    				store:Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['TXTLV_L1','TXTLV_L2'],
		            levelType:'ITEM'
    			},
    				Unilite.popup('ITEM_GROUP',{ 
    								fieldLabel:'<t:message code="system.label.sales.repmodel" default="대표모델"/>', 
    								textFieldName:'ITEM_GROUP_CODE',
    								valueFieldName: 'ITEM_GROUP_NAME',
    								
    								validateBlank: false,
    								popupWidth:710
    			}),{ 
		 	 		xtype:  'container',
		 	 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'<t:message code="system.label.sales.issueno" default="출고번호"/>',
 						suffixTpl: '&nbsp;~&nbsp;', 
 						name:'TXT_FR_INOUT_NO', 
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TXT_TO_INOUT_NO', 
 						width: 107
 					}] 
		   		},{
		   			fieldLabel:'Lot No.',
		   			name:'TXT_LOT_NO',
		   			width: 325,
		   			xtype:'uniTextfield'
		   		},{
		   			fieldLabel:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
		   			name:'TXT_ITEM_ACCOUNT',
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
 						fieldLabel:'<t:message code="system.label.sales.issueqty" default="출고량"/>',
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'TXT_FR_INOUT_QTY',
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TXT_TO_INOUT_QTY', 
 						width: 107
 					}]
 				},{ 
 					fieldLabel:'<t:message code="system.label.sales.issuetype" default="출고유형"/>',
 					name: 'TXT_OUT_TYPE',
 					xtype:'uniCombobox',
 					comboType:'AU',
 					comboCode: 'S007'
 				},{ 
 					fieldLabel:'<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>',
 					name:'TXT_GOOD_BAD',
 					xtype:'uniCombobox',
 					comboType: 'AU',
 					comboCode: 'B021' 
 				},
 					Unilite.popup('AGENT_CUST',{ 
 									fieldLabel:'<t:message code="system.label.sales.issueplace" default="출고처"/>', 
 									validateBlank: false, 
 									extParam: {'CUSTOM_TYPE': '3'}, colspan: 2
 				}),{ 
		 	 		xtype:  'container',
		 	 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'TXT_FR_ORDER_NUM',
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TXT_TO_ORDER_NUM',
 						width: 107
 					}]
 				},{ 
 					fieldLabel:'PO_NO',
 					name:'TXT_PONO', 
 					width: 300
 				},{ 
 					fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
        		 	xtype: 'radiogroup',
        		 	width: 300,
        		 	items:[{
        		 		boxLabel:'<t:message code="system.label.sales.itemby" default="품목별"/>',
        		 		name: 'TXT_RDO1',
        		 		inputValue: '1', 
        		 		checked: true
        		 	},{
        		 		boxLabel:'출고처별',
        		 		name:'TXT_RDO1',
        		 		inputValue: '2'
        		 	},{
        		 		boxLabel:'배송처별',
        		 		name:'TXT_RDO1',
        		 		inputValue: '3'
        		 	}]
        		 	
        		},{ 
        			fieldLabel: '납기경과',
        		 	xtype: 'radiogroup',								            		 	
        		 	width: 300,
        		 	items: [{
        		 		boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>', 
        		 		name:'TXT_RDO2',
        		 		inputValue: '0', 
        		 		checked: true
        		 	},{
        		 		boxLabel:'납기준수',
        		 		name:'TXT_RDO2',
        		 		inputValue: '1'
        		 	},{
        		 		boxLabel:'납기경과',
        		 		name:'TXT_RDO2',
        		 		inputValue: '2'
        		 	}]
        		 	
        		},{
        		 	xtype: 'radiogroup',
        		 	fieldLabel: '반품포함여부',
        		 	width: 300,
        		 	items: [{
        		 		boxLabel:'<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
        		 		name:'TXT_RDO3',
        		 		inputValue: '1',
        		 		checked: true
        		 	},{
        		 		boxLabel:'<t:message code="system.label.sales.inclusion" default="포함"/>',
        		 		name:'TXT_RDO3',
        		 		inputValue: '2'
        		 	},{
        		 		hidden: true
        		 	}]
        		 	
        		},{
        			fieldLabel: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>',
        		 	xtype: 'radiogroup',								            		 						            		 	
        		 	width: 300,
        		 	items: [{
        		 		boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>',
        		 		name:'TXT_RDO4',
        		 		inputValue: '',
        		 		checked: true
        		 	},{
        		 		boxLabel:'예',
        		 		name:'TXT_RDO4',
        		 		inputValue: 'Y'
        		 	},{
        		 		boxLabel:'아니오',
        		 		name:'TXT_RDO4',
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
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
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
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				},
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('TXT_INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
					
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
								panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
								panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel:  '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype:'uniCombobox',  
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
			},{
				fieldLabel:'<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name: 'TXT_CREATE_LOC', 
				xtype:'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B031',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXT_CREATE_LOC', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
			},{
				fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
				name: 'TXT_INOUT_PRSN', 
				xtype:'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TXT_INOUT_PRSN', newValue);
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
			        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   })],
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
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
  
    var masterGrid = Unilite.createGrid('str310skrvGrid', {
    	// for tab    	
    	region: 'center' ,
        layout:  'fit',
    	store:  MasterStore, 
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  false },
    	           	{id:  'masterGridTotal', 	ftype:  'uniSummary', 	  showSummaryRow:  false} ],
        columns: [  { dataIndex: 'ITEM_CODE1'              	,      		width: 133, locked: true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '품목계', '<t:message code="system.label.sales.total" default="총계"/>');
            }},				
					 { dataIndex: 'ITEM_NAME1'              	,      		width: 166, locked: true  },				
					 { dataIndex: 'ITEM_CODE2'              	,      		width: 93, hidden: true   },				
					 { dataIndex: 'ITEM_NAME2'              	,      		width: 160, hidden: true   },				
					 { dataIndex: 'SPEC'                    	,      		width: 120   },				
					 { dataIndex: 'PRICE_TYPE'		      	,      		width: 100, hidden: true   },				
					 { dataIndex: 'ORDER_UNIT'              	,      		width: 80, align: 'center'   },			
					 { dataIndex: 'ORDER_UNIT_Q'            	,      		width: 93, summaryType: 'sum'    },				
					 { dataIndex: 'ORDER_UNIT_P'            	,      		width: 66, hidden: true   },				
					 { dataIndex: 'WGT_UNIT'		          	,      		width: 80   },			
					 { dataIndex: 'UNIT_WGT'		          	,      		width: 80   },				
					 { dataIndex: 'INOUT_WGT_Q'		      	,      		width: 113, summaryType: 'sum'    },				
					 { dataIndex: 'INOUT_FOR_WGT_P'	      	,      		width: 113, hidden: true   },				
					 { dataIndex: 'VOL_UNIT'		          	,      		width: 60, hidden: true   },			
					 { dataIndex: 'UNIT_VOL'		          	,      		width: 80, hidden: true   },				
					 { dataIndex: 'INOUT_VOL_Q'		      	,      		width: 113, hidden: true   },				
					 { dataIndex: 'INOUT_FOR_VOL_P'	      	,      		width: 113, hidden: true   },			
					 { dataIndex: 'TRNS_RATE'               	,      		width: 66, align: 'right'   },				
					 { dataIndex: 'STOCK_UNIT'              	,      		width: 60, align: 'center'   },			
					 { dataIndex: 'INOUT_Q'                 	,      		width: 93, summaryType: 'sum'    },				
					 { dataIndex: 'INOUT_P'                 	,      		width: 66, hidden: true   },				
					 { dataIndex: 'MONEY_UNIT'              	,      		width: 93   },			
					 { dataIndex: 'EXCHG_RATE_O'            	,      		width: 66, hidden: true   },				
					 { dataIndex: 'INOUT_FOR_O'             	,      		width: 93, summaryType: 'sum'    },				
					 { dataIndex: 'INOUT_I'                 	,      		width: 93, summaryType: 'sum'    },				
					 { dataIndex: 'TRANS_COST'              	,      		width: 93, hidden: true   },			
					 { dataIndex: 'INOUT_TYPE_DETAIL'       	,      		width: 106   },				
					 { dataIndex: 'INOUT_CODE_TYPE'         	,      		width: 66, hidden: true   },				
					 { dataIndex: 'INOUT_CODE'              	,      		width: 66, hidden: true   },				
					 { dataIndex: 'INOUT_NAME'              	,      		width: 93   },				
					 { dataIndex: 'INOUT_DATE'              	,      		width: 73   },				
					 { dataIndex: 'DVRY_CUST_NAME'          	,      		width: 93   },				
					 { dataIndex: 'DOM_FORIGN'              	,      		width: 106   },				
					 { dataIndex: 'WH_CODE'                 	,      		width: 106   },				
					 { dataIndex: 'INOUT_PRSN'              	,      		width: 106   },				
					 { dataIndex: 'ISSUE_DATE'		      	,      		width: 140   },				
					 { dataIndex: 'ISSUE_REQ_NUM'           	,      		width: 100   },				
					 { dataIndex: 'LOT_NO'                  	,      		width: 100   },				
					 { dataIndex: 'REMARK'                  	,      		width: 100   },				
					 { dataIndex: 'ACCOUNT_YNC'             	,      		width: 100   },			
					 { dataIndex: 'ORDER_NUM'               	,      		width: 100   },				
					 { dataIndex: 'DVRY_DATE'		       ,      		width: 140   },				
					 { dataIndex: 'DELIVERY_DATE'	       ,      		width: 140   },				
					 { dataIndex: 'ACCOUNT_Q'               	,      		width: 113, summaryType: 'sum'    },				
					 { dataIndex: 'LC_NUM'                  	,      		width: 106   },				
					 { dataIndex: 'INOUT_NUM'               	,      		width: 100   },				
					 { dataIndex: 'PO_NUM'			      	,      		width: 100, hidden: true   },				
					 { dataIndex: 'PO_SEQ'                  	,      		width: 66, hidden: true   },				
					 { dataIndex: 'INOUT_SEQ'               	,      		width: 66, align: 'center'   },				
					 { dataIndex: 'INOUT_METH'              	,      		width: 106   },				
					 { dataIndex: 'EVAL_INOUT_P'            	,      		width: 106   },				
					 { dataIndex: 'SORT_KEY'                	,      		width: 106, hidden: true   },				
					 { dataIndex: 'UPDATE_DB_TIME'          	,      		width: 130   }				
					
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
		id: 'str310skrvApp',
		fnInitBinding:  function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_INOUT_DATE')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_INOUT_DATE')));
			
			str310skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var field = panelSearch.getField('TXT_INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('TXT_INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});

};


</script>
