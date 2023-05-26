<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq200rkrv"  >
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
   	
   	<t:ExtComboStore comboType="OU" /> <!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var searchInfoWindow; //searchInfoWindow : 조회창

var BsaCodeInfo = {
	    gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
	};

function appMain() {
	//조회창 모델 정의
	Unilite.defineModel('requestNoMasterModel', {
	    fields: [{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.client" default="고객"/>'    			, type: 'string'},
				 {name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.client" default="고객"/>'    			, type: 'string'},
				 {name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'    		, type: 'string'},
				 {name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'    		, type: 'string'},
				 {name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'    			, type: 'string'},
				 {name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'    	, type: 'uniQty'},
				 {name: 'ISSUE_REQ_DATE'	, text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'    	, type: 'uniDate'},
				 {name: 'ISSUE_DATE'		, text: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>'    	, type: 'uniDate'},
				 {name: 'ISSUE_DIV_CODE'	, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'    	, type: 'string'},
				 {name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'    		, type: 'string', comboType:'OU'},
				 {name: 'ORDER_TYPE'		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'    		, type: 'string', comboType:'AU', comboCode:'S002'},
				 {name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'    		, type: 'string', comboType:'AU', comboCode:'S007'},
				 {name: 'PROJECT_NO'		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'    	, type: 'string'},
				 {name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'    	, type: 'string'},
				 {name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'    		, type: 'string'},
				 {name: 'SORT_KEY'			, text: 'SORT_KEY'    		, type: 'string'},
				 {name: 'ISSUE_REQ_SEQ'		, text: '<t:message code="system.label.sales.seq" default="순번"/>'    		, type: 'string'},
				 {name: 'ISSUE_REQ_PRSN'	, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	, type: 'string', comboType:'0', comboCode:'S010'},
				 {name: 'AGENT_TYPE'		, text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'	, type: 'string', comboType:'0', comboCode:'B055'},
				 {name: 'AREA_TYPE'			, text: '<t:message code="system.label.sales.area" default="지역"/>'			, type: 'string', comboType:'0', comboCode:'B056'}
		]
	});		
	//조회창 스토어 정의
	var requestNoMasterStore = Unilite.createStore('requestNoMasterStore', {
			model: 'requestNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'srq200rkrvService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= requestNoSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	var panelSearch = Unilite.createSearchForm('searchForm',{
    	region: 'center',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{	    
	    	fieldLabel: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120',
            comboCode:'B001',
	    	allowBlank:false,
	    	value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', '');
				}
			}
    	},{	    
	    	fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
	    	name:'ISSUE_REQ_PRSN',
	    	xtype: 'uniCombobox', 
	    	comboType:'0', 
	    	comboCode:'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
				}
			}
    	},{	    
	    	fieldLabel: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
	    	name:'WH_CODE',
	    	xtype: 'uniCombobox', 
			comboType   : 'OU',   	
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
				},
                beforequery:function( queryPlan, eOpts )   {
                     var store = queryPlan.combo.store;
                         store.clearFilter();
                         if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                              store.filterBy(function(record){
                              return record.get('option') == panelSearch.getValue('DIV_CODE');
                          })
                        }else{
                        store.filterBy(function(record){
                             return false;   
                        })
                    }
                }
			}
    	},{
    		fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
	    	name:'ISSUE_REQ_NUM',
	    	xtype: 'uniTextfield', 
	    	allowBlank:false,
			listeners: {
				render: function(p) { 
					     p.getEl().on('dblclick', function(p){ 
					     	openSearchInfoWindow();
					     })
				}
			}
		},{
    		fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
	    	name:'AGENT_TYPE',
	    	xtype: 'uniCombobox', 
			comboType:'0', 
	    	comboCode:'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
				}
			}
		},{
    		fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
	    	name:'AREA_TYPE',
	    	xtype: 'uniCombobox', 
			comboType:'0', 
	    	comboCode:'B056',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE', 
			textFieldName	: 'CUSTOM_NAME', 
			textFieldWidth	: 170,
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
			
		}),{
    		fieldLabel: '<t:message code="system.label.sales.deliverydetail" default="검사항목"/>',
	    	xtype: 'textareafield', 
	    	name:'Instructions',
	    	width:400,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
				}
			}
		}]
    });		
	 /**
	 * 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	 //조회창 폼 정의
	var requestNoSearch = Unilite.createSearchForm('requestNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestNoSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestNoSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_REQ_DATE_FR',
			endFieldName: 'ISSUE_REQ_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    labelWidth: 100
		}, {
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		,
			name: 'ISSUE_REQ_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S010'
		}, {
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items: [{
		    	fieldLabel: '<t:message code="system.label.sales.issuedivisionwh" default="출고사업장/창고"/>'  ,
		    	name: 'ISSUE_DIV_CODE',
		    	xtype:'uniCombobox',
		    	comboType:'BOR120',
		    	comboCode:'B001',
		    	value:UserInfo.divCode,
		    	allowBlank:false,
		    	child: 'WH_CODE',
		    	
		    	labelWidth: 100
	    	}, {
	    		margin:  '0 0 0 10',
	    		hideLabel: true,
	        	name: 'WH_CODE',
	        	xtype:'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('whList'), 
	        	comboType:'OU'
	        }]
		}, {
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name: 'ORDER_TYPE',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S002',
			value: '10'
		},
			Unilite.popup('DIV_PUMOK',{
			labelWidth		: 100,
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestNoSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestNoSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
			name: 'INOUT_TYPE_DETAIL',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S007'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO',
			width:315,
		    labelWidth: 100
		}]
    }); // createSearchForm
	//조회창 그리드 정의
    var requestNoMasterGrid = Unilite.createGrid('srq100ukrvOrderNoMasterGrid', {
        // title: '기본',
        layout : 'fit',       
		store: requestNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:[
				{ dataIndex: 'ISSUE_REQ_NUM'					,	 width: 90  },
				{ dataIndex: 'ISSUE_REQ_SEQ'					,	 width: 50  },
				{ dataIndex: 'CUSTOM_CODE'					,	 width: 66, hidden: true  },
				{ dataIndex: 'CUSTOM_NAME'					,	 width: 100 },
				{ dataIndex: 'ITEM_CODE'						,	 width: 80  },
				{ dataIndex: 'ITEM_NAME'         			,	 width: 166 },
				{ dataIndex: 'SPEC'			    			,	 width: 100 },
				{ dataIndex: 'ISSUE_REQ_QTY'					,	 width: 100  },
				{ dataIndex: 'ISSUE_REQ_DATE'    			,	 width: 80  },
				{ dataIndex: 'ISSUE_DATE'					,	 width: 80  },
				{ dataIndex: 'ISSUE_DIV_CODE'    			,	 width: 80, hidden: true  },
				{ dataIndex: 'WH_CODE'						,	 width: 80  },
				{ dataIndex: 'ORDER_TYPE'        			,	 width: 86  },
				{ dataIndex: 'INOUT_TYPE_DETAIL'				,	 width: 86  },
				{ dataIndex: 'PROJECT_NO'        			,	 width: 86  },
				{ dataIndex: 'DIV_CODE'		    			,	 width: 73, hidden: true  },
				{ dataIndex: 'SORT_KEY'		    			,	 width: 73, hidden: true  }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				requestNoMasterGrid.returnData(record);
				searchInfoWindow.hide();
			}
		} // listeners
		,returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			// 초기화
			panelSearch.clearForm();
			
			panelSearch.setValues({
						  'DIV_CODE'		: record.get('DIV_CODE')
						, 'ISSUE_REQ_NUM'	: record.get('ISSUE_REQ_NUM')
						, 'WH_CODE'			: record.get('WH_CODE')
						, 'ISSUE_REQ_PRSN'	: record.get('ISSUE_REQ_PRSN')
						, 'AGENT_TYPE'		: record.get('AGENT_TYPE')
						, 'AREA_TYPE'		: record.get('AREA_TYPE')
			});
			// 한꺼번에 세팅시 둘다 세팅 안돼는 오류로 인해 거래처코드와 명은 따로 세팅
			panelSearch.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
			panelSearch.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
			
			if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			}
			panelSearch.uniOpt.inLoading=false;
		}
	});
	
	//조회창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.sales.shipmentordernosearch" default="출하지시번호검색"/>',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [requestNoSearch, requestNoMasterGrid],
                tbar:  ['->',
				        {	itemId : 'searchBtn',
							text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
							handler: function() {
								requestNoMasterStore.loadStoreRecords();												
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '<t:message code="system.label.sales.close" default="닫기"/>',
							handler: function() {
								searchInfoWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											requestNoSearch.clearForm();
											requestNoMasterGrid.reset();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											requestNoSearch.clearForm();
											requestNoMasterGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	requestNoSearch.setValue('ISSUE_DIV_CODE',panelSearch.getValue('DIV_CODE'));
					    		requestNoSearch.setValue('ISSUE_REQ_DATE_FR', UniDate.get('startOfMonth'));
					    		requestNoSearch.setValue('ISSUE_REQ_DATE_TO',UniDate.get('today'));
                			 }
                }		
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
    }
	
    
    
    Unilite.Main({
    	borderItems:[
				panelSearch     
		],	
		id  : 'srq200rkrvApp',
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset','print'], true);
            UniAppManager.setToolbarButtons(['query'], false);
			this.setDefault();
            this.processParams(params);
		},
		setDefault: function() {		// 기본값
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
         	panelSearch.resetDirtyStatus();                            
		},
		processParams: function(params) {
            if(!Ext.isEmpty(params)){
                this.uniOpt.appParams = params;
                if(params.PGM_ID == 'srq100ukrv') {
                    
                    panelSearch.setValue('ISSUE_REQ_NUM',params.ISSUE_REQ_NUM);
                }
            }
        },
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			this.fnInitBinding();
			panelSearch.getField('ISSUE_REQ_PRSN').focus();
		},
		onPrintButtonDown: function() {
			/* if(!panelSearch.getInvalidMessage()) return;   //필수체크
			var param = panelSearch.getValues();
			param["PGM_ID"]=PGM_ID;
			param["MAIN_CODE"] = 'S036';		//영업용 공통 코드
			param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.shipmentorderpaperprintcustomer" default="출하지시서출력(고객별)"/>';
			param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
			param["USER_LANG"] = UserInfo.userLang;
			win.center();
			win.show(); */
				
				 if(!panelSearch.getInvalidMessage()) return;   //필수체크
					var param = panelSearch.getValues();
					param["PGM_ID"]=PGM_ID;
					param["MAIN_CODE"] = 'S036';		//영업용 공통 코드
					param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.shipmentorderpaperprintcustomer" default="출하지시서출력(고객별)"/>';
					param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
					param["USER_LANG"] = UserInfo.userLang;
					var reportGubun = BsaCodeInfo.gsReportGubun;//BsaCodeInfo.gsReportGubun
		            /* if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
		            	var win = Ext.create('widget.CrystalReport', {
			             	url: CPATH+'/sales/srq200crkrv.do',
			                prgID: 'srq200rkrv',
			                extParam: param
			            });
		            }else{ */
		            	var win = Ext.create('widget.ClipReport', {
		    				url: CPATH+'/sales/srq200clrkrv.do',
		    				prgID: 'srq200rkrv',
		    				extParam: param
		    				});
		            //}
					win.center();
					win.show();
		}
	});
};

</script>
