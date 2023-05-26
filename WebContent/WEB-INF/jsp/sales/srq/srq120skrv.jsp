<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="srq120skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="BOR120" /> <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--품목상태-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!--매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="T016" /> <!--대금결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B116" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!--판매형태-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' /> <!--생성경로-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>
<script type="text/javascript">

var getSelectedRecords;

function appMain() {
	
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('srq120skrvModel', {
		fields: [{name: 'CUSTOM_NAME'		    	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
				 {name: 'ITEM_CODE'		        		,text: '<t:message code="system.label.sales.item" default="품목"/>'				        , type: 'string'},
				 {name: 'ITEM_NAME'		        		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
				 {name: 'SPEC'		            				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					    , type: 'string'},
				 {name: 'ORDER_UNIT'		    			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string', displayField: 'value'},
				 {name: 'TRANS_RATE'		    		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'string'},
				 {name: 'ISSUE_REQ_DATE'	    	,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'		, type: 'uniDate'},
				 {name: 'ISSUE_DATE'	   	    		,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				, type: 'uniDate'},
				 {name: 'NOT_REQ_Q'		       		,text: '<t:message code="system.label.sales.unissuedqty" default="미출고량"/>'				, type: 'uniQty'},
				 {name: 'ISSUE_REQ_QTY'	        	,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty'},
				 {name: 'ISSUE_REQ_STOCK_QTY'	        	,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.inventory" default="재고"/>)'		, type: 'uniQty'},				 
				 {name: 'ISSUE_WGT_Q'	        		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'		, type: 'string'},
				 {name: 'ISSUE_VOL_Q'	        		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'		, type: 'string'},
				 {name: 'STOCK_Q'	            			,text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'			, type: 'uniQty'},
				 {name: 'WH_CODE'             		  	,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string', comboType   : 'OU'},
				 {name: 'ORDER_NUM'             	,text: '<t:message code="system.label.sales.soofferno" default="수주(오퍼)번호"/>'		    , type: 'string'},
				 {name: 'ISSUE_REQ_NUM'	       	,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		, type: 'string'},
				 {name: 'ISSUE_REQ_SEQ'	        	,text: '<t:message code="system.label.sales.seq" default="순번"/>'					    , type: 'string'},
				 {name: 'PROJECT_NO'		    		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
				 {name: 'PAY_METHODE1'		   	,text: '<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'		, type: 'string'},
				 {name: 'LC_SER_NO'		        		,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'					, type: 'string'},
				 {name: 'LOT_NO'			    			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					, type: 'string'},
				 {name: 'RECEIVER_ID'           		,text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>'				, type: 'string'},
				 {name: 'RECEIVER_NAME'         	,text: '<t:message code="system.label.sales.receivername" default="수신자명"/>'			, type: 'string'},
				 {name: 'TELEPHONE_NUM1'        	,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},
				 {name: 'TELEPHONE_NUM2'        	,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},
				 {name: 'ADDRESS'               			,text: '<t:message code="system.label.sales.address" default="주소"/>'					, type: 'string'},
				 {name: 'ORDER_CUST_CD'	        	,text: '<t:message code="system.label.sales.soplace" default="수주처"/>'					, type: 'string'},
				 {name: 'DIV_CODE'            		  	,text: 'DIV_CODE'          		, type: 'string'},
				 {name: 'CUSTOM_CODE'           	,text: 'CUSTOM_CODE'       		, type: 'string'},
				 {name: 'INOUT_TYPE_DETAIL'     	,text: 'INOUT_TYPE_DETAIL' 		, type: 'string'},
				 {name: 'WH_CELL_CODE'          	,text: 'WH_CELL_CODE'      		, type: 'string'},
				 {name: 'WH_CELL_NAME'          	,text: 'WH_CELL_NAME'      		, type: 'string'},
				 {name: 'ISSUE_REQ_PRICE'       	,text: 'ISSUE_REQ_PRICE'   		, type: 'uniPrice'},
				 {name: 'ISSUE_REQ_AMT'         	,text: 'ISSUE_REQ_AMT'     		, type: 'uniPrice'},
				 {name: 'ISSUE_REQ_TAX_AMT'     	,text: 'ISSUE_REQ_TAX_AMT' 		, type: 'uniPrice'},
				 {name: 'TAX_TYPE'              			,text: 'TAX_TYPE'          		, type: 'string'},
				 {name: 'MONEY_UNIT'           	 	,text: 'MONEY_UNIT'        		, type: 'string'},
				 {name: 'EXCHANGE_RATE'         	,text: 'EXCHANGE_RATE'     		, type: 'string'},
				 {name: 'ACCOUNT_YNC'           	,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string'},
				 {name: 'DISCOUNT_RATE'         	,text: 'DISCOUNT_RATE'   		, type: 'string'},
				 {name: 'ISSUE_REQ_PRSN'        	,text: 'ISSUE_REQ_PRSN'  		, type: 'string'},
				 {name: 'DVRY_CUST_CD'          	,text: 'DVRY_CUST_CD'    		, type: 'string'},
				 {name: 'REMARK'               		 	,text: '<t:message code="system.label.sales.remarks" default="비고"/>'          		, type: 'string'},
				 {name: 'SER_NO'                			,text: 'SER_NO'          		, type: 'string'},
				 {name: 'SALE_CUSTOM_CODE'      	,text: 'SALE_CUSTOM_CODE'		, type: 'string'},
				 {name: 'SALE_CUST_CD'         	 	,text: 'SALE_CUST_CD'    		, type: 'string'},
				 {name: 'ISSUE_DIV_CODE'        	,text: 'ISSUE_DIV_CODE'  		, type: 'string'},
				 {name: 'BILL_TYPE'             			,text: 'BILL_TYPE'       		, type: 'string'},
				 {name: 'ORDER_TYPE'            		,text: 'ORDER_TYPE'      		, type: 'string'},
				 {name: 'PRICE_YN'              			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003'},
				 {name: 'PO_NUM'              		  	,text: 'PO_NUM'       			, type: 'string'},
				 {name: 'PO_SEQ'                			,text: 'PO_SEQ'       			, type: 'string'},
				 {name: 'CREDIT_YN'             		,text: 'CREDIT_YN'    			, type: 'string'},
				 {name: 'WON_CALC_BAS'          	,text: 'WON_CALC_BAS' 			, type: 'string'},
				 {name: 'TAX_INOUT'             		,text: 'TAX_INOUT'    			, type: 'string'},
				 {name: 'AGENT_TYPE'            		,text: 'AGENT_TYPE'   			, type: 'string'},
				 {name: 'STOCK_CARE_YN'         	,text: 'STOCK_CARE_YN'			, type: 'string'},
				 {name: 'STOCK_UNIT'            		,text: 'STOCK_UNIT'   			, type: 'string'},
				 {name: 'DVRY_CUST_NAME'        	,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'					, type: 'string'},
				 {name: 'SOF100_TAX_INOUT'      	,text: 'SOF100_TAX_INOUT'		, type: 'string'},
				 {name: 'RETURN_Q_YN'           ,text: 'RETURN_Q_YN'     		, type: 'string'},
				 {name: 'ORDER_Q'              		,text: 'ORDER_Q'         		, type: 'string'},
				 {name: 'REF_CODE2'             	,text: 'REF_CODE2'       		, type: 'string'},
				 {name: 'EXCESS_RATE'           	,text: 'EXCESS_RATE'     		, type: 'string'},
				 {name: 'DEPT_CODE'             	,text: 'DEPT_CODE'       		, type: 'string'},
				 {name: 'ITEM_ACCOUNT'          	,text: 'ITEM_ACCOUNT'    		, type: 'string'},
				 {name: 'PRICE_TYPE'            			,text: 'PRICE_TYPE'      		, type: 'string'},
				 {name: 'ISSUE_FOR_WGT_P'       	,text: 'ISSUE_FOR_WGT_P' 		, type: 'string'},
				 {name: 'ISSUE_WGT_P'           		,text: 'ISSUE_WGT_P'     		, type: 'string'},
				 {name: 'ISSUE_FOR_VOL_P'       	,text: 'ISSUE_FOR_VOL_P' 		, type: 'string'},
				 {name: 'ISSUE_VOL_P'           		,text: 'ISSUE_VOL_P'     		, type: 'string'},
				 {name: 'WGT_UNIT'              		,text: 'WGT_UNIT'        		, type: 'string'},
				 {name: 'UNIT_WGT'              		,text: 'UNIT_WGT'        		, type: 'string'},
				 {name: 'VOL_UNIT'              			,text: 'VOL_UNIT'        		, type: 'string'},
				 {name: 'UNIT_VOL'              			,text: 'UNIT_VOL'        		, type: 'string'},
				 {name: 'LOT_YN'              				,text: 'LOT_YN'        		, type: 'string'},
				 {name: 'REMARK_INTER'             	,text: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'        		, type: 'string'},
				 {name: 'STOCK_SHORY_YN'             ,text: 'STOCK_SHORY_YN'        		, type: 'string'}
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	   read : 'srq120skrvService.selectList'
        }
	});
	
	/*
	 store 정의
	*/
	var directMasterStore = Unilite.createStore('srq120skrvMasterStore',{
		model: 'srq120skrvModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy
		// Store 관련 BL 로직
        // 검색 조건을 통해 DB에서 데이타 읽어 오기 
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('srq120skrvPanelResult').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		,saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				//this.syncAll({});
				this.syncAllDirect();
			}else {
				var grid = Ext.getCmp('srq120skrvMasterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	
	var panelResult = Unilite.createSearchForm('srq120skrvPanelResult',{
        layout : {type : 'uniTable' , columns: 3 },
        	 items :[{
	        	xtype: 'uniCombobox',
	       		name:'DIV_CODE',
	       		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	       		child: 'WH_CODE',
	       		comboType:'BOR120',
	       		comboCode:'AU',
	       		value: '01',
	       		allowBlank: false
	       		//readOnly: true
	        },{
            	fieldLabel: '납기일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'ISSUE_DATE_FR',
			    endFieldName: 'ISSUE_DATE_TO',
			    width: 350,
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('tomorrow')
	       }, 
	       {
	        	fieldLabel: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
	        	name: 'WH_CODE',
	        	xtype:'uniCombobox',
	        	comboType   : 'OU',
	        	comboCode:''
	        	//store: Ext.data.StoreManager.lookup('whList')
	        }, 
           Unilite.popup('AGENT_CUST',{
				fieldLabel		:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
				valueFieldName	:'CUSTOM_CODE',
				textFieldName	:'CUSTOM_NAME',
				validateBlank	:false,
				listeners : {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
				xtype: 'uniTextfield',
				name:'ISSUE_REQ_NUM'
			}, {
				fieldLabel: 'LOT_NO',
				xtype: 'uniTextfield',
				name:'LOT_NO'
			}, Unilite.popup('DIV_PUMOK',{
				fieldLabel : '품목',
				valueFieldName:'ITEM_CODE',
 				textFieldName:'ITEM_NAME',
 				/* DBvalueFieldName: 'ITEM_CODE',
 				DBtextFieldName: 'ITEM_NAME', */
 				validateBlank:false,
 				listeners: {
 					onValueFieldChange: function(field, newValue, oldValue){
 						if(!Ext.isObject(oldValue)) {
 							panelResult.setValue('ITEM_NAME', '');
 						}
 					},
 					onTextFieldChange: function(field, newValue, oldValue){
 						if(!Ext.isObject(oldValue)) {
 							panelResult.setValue('ITEM_CODE', '');
 						}
 					},
 					applyextparam: function(popup){
 						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
 					}
 				}
          }), {
                fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
                xtype:'uniTextfield',
                name: 'REMARK'
            },{
                fieldLabel: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>',
                xtype:'uniTextfield',
                name: 'REMARK_INTER'
            }
		]		            
    });
	
	/**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('srq120skrvMasterGrid', {
    	region: 'center',
    	store: directMasterStore,
    	tbar: [{
            xtype: 'button',
            text: '<div style="color: blue">출고등록</div>',
            id: 'SUJU',
            tooltip : '거래처 같은 경우만 이용 가능합니다.', 
            handler: function() {
					if(directMasterStore.getCount() != 0){
						   
						  var panelValues = panelResult.getValues();
						  panelValues.CUSTOM_CODE = getSelectedRecords[0].getData().CUSTOM_CODE;
						  panelValues.CUSTOM_NAME = getSelectedRecords[0].getData().CUSTOM_NAME;
						  var params = {
							   action		:	'select',
							   'PGM_ID'		:	'srq120skrv',
							   'record'		:	getSelectedRecords,
							   'formPram'	:	panelValues
						   }

							var rec = {data : {prgID : 'str103ukrv', 'text':''}};
							parent.openTab(rec, '/sales/str103ukrv.do', params, CHOST+CPATH);
						}
            }
        }],  
    	uniOpt: {
    		expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: false,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
    	},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                	getSelectedRecords = masterGrid.getSelectionModel().getSelection();
                	var sameFlag = false;
                	var customCodeTemp = null;
                	Ext.each(masterGrid.getSelectionModel().getSelection(), function(record, idx) {
        				if(idx == 0){
        					customCodeTemp = record.data.CUSTOM_CODE;
        				}
        				if(customCodeTemp != record.data.CUSTOM_CODE){
        					sameFlag = true;
        				}
        			});
                	Ext.getCmp('SUJU').setDisabled(sameFlag);
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	getSelectedRecords = masterGrid.getSelectionModel().getSelection();
                	var sameFlag = false;
                	var customCodeTemp = null;
                	Ext.each(masterGrid.getSelectionModel().getSelection(), function(record, idx) {
        				if(idx == 0){
        					customCodeTemp = record.data.CUSTOM_CODE;
        				}
        				if(customCodeTemp != record.data.CUSTOM_CODE){
        					sameFlag = true;
        				}
        			});
                	Ext.getCmp('SUJU').setDisabled(sameFlag);
                	if(masterGrid.getSelectionModel().getSelection().length == 0){
                		Ext.getCmp('SUJU').setDisabled(true);
                	}
                }
            }
        }),
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){          //오류 row 빨간색 표시     
                var cls = '';

                if(record.get('STOCK_SHORY_YN') == 'Y'){
                    cls = 'x-change-celltext_red';
                }
                return cls;
            }
        },
    	features: [ 
    	    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	    	],
		columns:[{ dataIndex: 'CUSTOM_NAME'		    	,  width: 150 },//거래처
      		   { dataIndex: 'ITEM_CODE'		        	,  width: 150 },//품목
    		   { dataIndex: 'ITEM_NAME'		        	,  width: 150 },//품목명
    		   { dataIndex: 'SPEC'		            	,  width: 150 },//규격
    		   { dataIndex: 'LOT_NO'			    	,  width: 100 },//LOT번호
    		   { dataIndex: 'ORDER_UNIT'		    	,  width: 80, align: 'center' },//판매단위
    		   { dataIndex: 'TRANS_RATE'		    	,  width: 40 },//입수
    		   { dataIndex: 'ISSUE_REQ_DATE'	    	,  width: 80 },//출하지시일
    		   { dataIndex: 'ISSUE_DATE'	   	    	,  width: 80 },//납기일
    		   { dataIndex: 'NOT_REQ_Q'		       		,  width: 80 },//미출고량
    		   { dataIndex: 'ISSUE_REQ_QTY'	        	,  width: 100 },//출하지시량
     		   { dataIndex: 'ISSUE_REQ_STOCK_QTY'	        	,  width: 120 },  //출하지시량(재고단위)
    		   { dataIndex: 'ISSUE_WGT_Q'	        	,  width: 80, hidden: true },
    		   { dataIndex: 'ISSUE_VOL_Q'	        	,  width: 80, hidden: true },
    		   { dataIndex: 'STOCK_Q'	            	,  width: 100 },//재고수량
    		   { dataIndex: 'WH_CODE'               	,  width: 120},//출고창고
    		   { dataIndex: 'ORDER_NUM'             	,  width: 120 },//수주(오퍼)번호
    		   { dataIndex: 'ISSUE_REQ_NUM'	        	,  width: 120 },//출하지시번호
    		   { dataIndex: 'ISSUE_REQ_SEQ'	        	,  width: 40 },//순번
    		   { dataIndex: 'PROJECT_NO'		    	,  width: 86 },//프로젝트번호
    		   { dataIndex: 'PAY_METHODE1'		    	,  width: 100 },//대금결제방법
    		   { dataIndex: 'LC_SER_NO'		        	,  width: 100 },//L/C번호
    		   
    		   { dataIndex: 'RECEIVER_ID'           	,  width: 86, hidden: true },
    		   { dataIndex: 'RECEIVER_NAME'         	,  width: 86, hidden: true },
    		   { dataIndex: 'TELEPHONE_NUM1'        	,  width: 80, hidden: true },
    		   { dataIndex: 'TELEPHONE_NUM2'        	,  width: 80, hidden: true },
    		   { dataIndex: 'ADDRESS'               	,  width: 133, hidden: true },
    		   { dataIndex: 'ORDER_CUST_CD'	        	,  width: 150 },//수주처
    		   { dataIndex: 'DIV_CODE'              	,  width: 66, hidden: true },
    		   { dataIndex: 'CUSTOM_CODE'           	,  width: 66, hidden: true },
    		   { dataIndex: 'INOUT_TYPE_DETAIL'     	,  width: 66, hidden: true },
    		   { dataIndex: 'WH_CELL_CODE'          	,  width: 66, hidden: true },
    		   { dataIndex: 'WH_CELL_NAME'          	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_REQ_PRICE'       	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_REQ_AMT'         	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_REQ_TAX_AMT'     	,  width: 66, hidden: true },
    		   { dataIndex: 'TAX_TYPE'              	,  width: 66, hidden: true },
    		   { dataIndex: 'MONEY_UNIT'            	,  width: 66, hidden: true },
    		   { dataIndex: 'EXCHANGE_RATE'         	,  width: 66, hidden: true },
    		   { dataIndex: 'ACCOUNT_YNC'           	,  width: 66 },//매출대상
    		   { dataIndex: 'DISCOUNT_RATE'         	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_REQ_PRSN'        	,  width: 66, hidden: true },
    		   { dataIndex: 'DVRY_CUST_CD'          	,  width: 66, hidden: true },
    		   { dataIndex: 'SER_NO'                	,  width: 66, hidden: true },
    		   { dataIndex: 'SALE_CUSTOM_CODE'      	,  width: 66, hidden: true },
    		   { dataIndex: 'SALE_CUST_CD'          	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_DIV_CODE'        	,  width: 66, hidden: true },
    		   { dataIndex: 'BILL_TYPE'             	,  width: 66, hidden: true },
    		   { dataIndex: 'ORDER_TYPE'            	,  width: 66, hidden: true },
    		   { dataIndex: 'PRICE_YN'              	,  width: 80 },//단가구분
    		   { dataIndex: 'PO_NUM'                	,  width: 66, hidden: true },
    		   { dataIndex: 'PO_SEQ'                	,  width: 66, hidden: true },
    		   { dataIndex: 'CREDIT_YN'             	,  width: 66, hidden: true },
    		   { dataIndex: 'WON_CALC_BAS'          	,  width: 66, hidden: true },
    		   { dataIndex: 'TAX_INOUT'             	,  width: 66, hidden: true },
    		   { dataIndex: 'AGENT_TYPE'            	,  width: 66, hidden: true },
    		   { dataIndex: 'STOCK_CARE_YN'         	,  width: 66, hidden: true },
    		   { dataIndex: 'STOCK_UNIT'            	,  width: 66, hidden: true },
    		   { dataIndex: 'DVRY_CUST_NAME'        	,  width: 113 },//배송처
    		   { dataIndex: 'SOF100_TAX_INOUT'      	,  width: 66, hidden: true },
    		   { dataIndex: 'RETURN_Q_YN'           	,  width: 66, hidden: true },
    		   { dataIndex: 'ORDER_Q'               	,  width: 66, hidden: true },
    		   { dataIndex: 'REF_CODE2'             	,  width: 66, hidden: true },
    		   { dataIndex: 'EXCESS_RATE'           	,  width: 66, hidden: true },
    		   { dataIndex: 'DEPT_CODE'             	,  width: 66, hidden: true },
    		   { dataIndex: 'ITEM_ACCOUNT'          	,  width: 66, hidden: true },
    		   { dataIndex: 'PRICE_TYPE'            	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_FOR_WGT_P'       	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_WGT_P'           	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_FOR_VOL_P'       	,  width: 66, hidden: true },
    		   { dataIndex: 'ISSUE_VOL_P'           	,  width: 66, hidden: true },
    		   { dataIndex: 'WGT_UNIT'              	,  width: 66, hidden: true },
    		   { dataIndex: 'UNIT_WGT'              	,  width: 66, hidden: true },
    		   { dataIndex: 'VOL_UNIT'              	,  width: 66, hidden: true },
    		   { dataIndex: 'UNIT_VOL'              	,  width: 66, hidden: true },
    		   { dataIndex: 'REMARK'                	,  width: 120},//비고
    		   { dataIndex: 'REMARK_INTER'              ,  width: 120},//내부기록사항
    		   { dataIndex: 'LOT_YN'                 	,  width: 66, hidden: true },
    		   { dataIndex: 'STOCK_SHORY_YN'                 	,  width: 66, hidden: true }    		   
      ]
    });
	
	/*
	* Main
	*/
    Unilite.Main({
		items : [panelResult, 	masterGrid],
		fnInitBinding : function() {
			getSelectedRecords = null;
			Ext.getCmp('SUJU').setDisabled(true);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ISSUE_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ISSUE_DATE_TO',UniDate.get('tomorrow'));
			UniAppManager.setToolbarButtons(['newData'],false);
		},
		onQueryButtonDown : function() {	
			directMasterStore.loadStoreRecords();			
		},
		onResetButtonDown:function() {
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
			this.fnInitBinding();
		}
	});
};
</script>