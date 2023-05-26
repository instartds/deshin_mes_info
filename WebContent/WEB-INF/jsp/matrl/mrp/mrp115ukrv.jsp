<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="mrp115ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
<t:ExtComboStore comboType="AU" comboCode="M201" />		 <!-- 수급계획 담당자 -->
<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >
var chkinterval ;
function appMain() {
	var baseDate = ${baseDate};
	var baseYN = ${baseYN};
	var dataCnt = ${dataCnt};

	var fnCommon =  {

		checkMrpData : function(){
			//alert("checkMrpData" + param);
			var param= Ext.getCmp('searchForm').getValues();
			mrp110ukrvService.checkMrpData(param,
                function(provider, response) {
					panelSearch.setValue('DATA_CNT', provider.DATA_CNT);
                    //alert(provider[0].DATA_CNT);
                }
            )
		}

	 };

	var mrpBatchView =  {
		xtype:'panel',
		id:"progressView",
		flex:1,
		border : 0,
		itemId:'BatchStatus',
		hidden:false,
		layout:{type:'uniTable', columns:'2', tableAttrs:{border : 0, style:"padding : 10px"}},
		defaults:{
			tdAttrs:{style:"padding : 5px"}
		},
		items:[{
			xtype:'component',
			width:300,
			colspan:2,
			tdAttrs:{align:'center',style:"padding : 5px"},
			html :'<b>[ MRP Batch Status ]</b>'
		},{
			xtype:'component',
			width:150,
			tdAttrs:{align:'right',style:"padding : 5px"},
			html :'Status : '
		},{
			xtype:'component',
			width:150,
			itemId:'batchStatus',
			tdAttrs:{style:"padding : 5px"},
			html :''
		},{
			xtype:'component',
			tdAttrs:{align:'right',style:"padding : 5px"},
			html :'Start Time : '
		},{
			xtype:'component',
			tdAttrs:{style:"padding : 5px"},
			itemId:'StartTime',
			html :''
		},{
			xtype:'component',
			tdAttrs:{align:'right',style:"padding : 5px"},
			html :'Running Time : '
		},{
			xtype:'component',
			itemId:'ProgressTime',
			tdAttrs:{style:"padding : 5px"},
			html :'<div></div>'
		},{
			xtype:'component',
			tdAttrs:{align:'right',style:"padding : 5px"},
			html :'Complete Time : '
		},{
			xtype:'component',
			itemId:'EndTime',
			tdAttrs:{style:"padding : 5px"},
			html :'<div></div>'
		},{
			xtype:'component',
			colspan:2,
			tdAttrs:{style:"padding : 5px",align:'center'},
			html :'(Auto refresh every 10 minutes.)'
		},{
			xtype:'button',
			itemId:'Refresh',
			tdAttrs:{style:"padding : 10px"},
			text :'Refresh',
			colspan:2,
			tdAttrs:{align:'center'},
			handler:function()	{
				mrpBatchView.loadData();
				clearInterval(chkinterval);
				chkinterval = setInterval(function(){ mrpBatchView.loadData(); }, 600000);
			}
		}],
		loadData:function()	{
			var me = this;
			var param = {};
			var progressView = Ext.getCmp("progressView");
			progressView.mask("Refresh...");
			Mrp115ukrvService.selectLog(param, function(provider, response){
				var status = "";
				var me = Ext.getCmp("progressView");
				if(provider)	{
					if(provider.OPR_FLAG == "S") {
						status = "Running";
					}else if(provider.OPR_FLAG == "E") {
						status = "Complete";
						clearInterval(chkinterval);
					}else if(provider.OPR_FLAG == "F") {
						status = "Failure";
						if(provider.ERROR_MSG)	{
							status = status + "("+provider.ERROR_MSG+")"
						}
						clearInterval(chkinterval);
					}
					me.down('#batchStatus').setHtml("<div>"+status+"</div>");
					me.down('#StartTime').setHtml("<div>"+provider.S_DATETIME+"</div>");
					me.down('#EndTime').setHtml("<div>"+provider.E_DATETIME+"</div>");
					me.down('#ProgressTime').setHtml("<div>"+provider.E_HOUR+" hour(s) " + provider.E_MIN +" minute(s)</div>");
				}
				me.unmask();
			});
		}
	};
	var panelSearch = Unilite.createForm('searchForm', {
		disabled :false,
        
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
		items:	[{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
                    labelWidth: 120,
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					value: UserInfo.divCode,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							fnCommon.checkMrpData();
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
				},{
	    			fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
                    labelWidth: 120,
	    			name: 'WORK_SHOP_CODE',
	    			xtype: 'uniCombobox',
	    			comboType: 'WU',
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WORK_SHOP_CODE', newValue);
						},
	                    beforequery:function( queryPlan, eOpts )   {
	                        var store = queryPlan.combo.store;
	                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
	                        store.clearFilter();
	                        prStore.clearFilter();
	                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
	                            store.filterBy(function(record){
	                                return record.get('option') == panelSearch.getValue('DIV_CODE');
	                            });
	                            prStore.filterBy(function(record){
	                                return record.get('option') == panelSearch.getValue('DIV_CODE');
	                            });
	                        }else{
	                            store.filterBy(function(record){
	                                return false;
	                            });
	                            prStore.filterBy(function(record){
	                                return false;
	                            });
	                        }
	                    }
					}
	    			//comboType:'AU',
	    			//comboCode:'B001'
	    		},{
	    			fieldLabel: 'MRP <t:message code="system.label.purchase.charger" default="담당자"/>',
                    labelWidth: 120,
	    			name:'PLAN_PRSN',
	    			xtype: 'uniCombobox',
	    			comboType:'AU',
	    			comboCode:'M201'
	    		},{
					fieldLabel: '<t:message code="system.label.purchase.predeploydate" default="이전 전개일"/>',
                    labelWidth: 120,
					name:'MRP_DATE',
					xtype: 'uniDatefield',
					readOnly:true
				},{
					fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
                    labelWidth: 120,
					name:'BASE_DATE',
					xtype: 'uniDatefield',
//					value: UniDate.get('yesterday'),
                    value: UniDate.get('today'),
					allowBlank:false
				},{
					fieldLabel: '<t:message code="system.label.purchase.confirmdate" default="확정일"/>',
                    labelWidth: 120,
					name:'FIRM_DATE',
					xtype: 'uniDatefield',
					allowBlank:false
				},{
					fieldLabel: '<t:message code="system.label.purchase.forecastdate" default="예시일"/>',
                    labelWidth: 120,
					name:'PLAN_DATE',
					xtype: 'uniDatefield'
					//value: UniDate.get('today')
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect1',
				    fieldLabel: '<t:message code="system.label.purchase.availableinventoryapply" default="가용재고 반영"/>',
                    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'PAB_STOCK_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'PAB_STOCK_YN' ,
				    	inputValue: 'N',
				    	width:80,
				    	checked: true
				    }],
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {
				    		if (Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Y'){
				    			panelSearch.setValue('WH_STOCK_YN','N');
				    			panelSearch.setValue('SAFETY_STOCK_YN','N');
				    			panelSearch.setValue('INSTOCK_PLAN_YN','N');
				    			panelSearch.setValue('OUTSTOCK_PLAN_YN','N');
				    			panelSearch.setValue('SUB_STOCK_YN','N');
				    			panelSearch.getField('WH_STOCK_YN').setReadOnly(true);
                                panelSearch.getField('SAFETY_STOCK_YN').setReadOnly(true);
                                panelSearch.getField('INSTOCK_PLAN_YN').setReadOnly(true);
                                panelSearch.getField('OUTSTOCK_PLAN_YN').setReadOnly(true);
                                panelSearch.getField('SUB_STOCK_YN').setReadOnly(true);
				    		} else
				    		{
				    			panelSearch.setValue('WH_STOCK_YN','Y');
				    			panelSearch.setValue('SAFETY_STOCK_YN','Y');
				    			panelSearch.setValue('INSTOCK_PLAN_YN','Y');
				    			panelSearch.setValue('OUTSTOCK_PLAN_YN','Y');
				    			panelSearch.setValue('SUB_STOCK_YN','Y');
                                panelSearch.getField('WH_STOCK_YN').setReadOnly(false);
                                panelSearch.getField('SAFETY_STOCK_YN').setReadOnly(false);
                                panelSearch.getField('INSTOCK_PLAN_YN').setReadOnly(false);
                                panelSearch.getField('OUTSTOCK_PLAN_YN').setReadOnly(false);
                                panelSearch.getField('SUB_STOCK_YN').setReadOnly(false);
				    		}
				    	}
				    }
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect2',
				    fieldLabel: '<t:message code="system.label.purchase.onhandstockapply" default="현재고 반영"/>',
                    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'WH_STOCK_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'WH_STOCK_YN' ,
				    	inputValue: 'N',
				    	width:80
				    }]
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect3',
				    fieldLabel: '<t:message code="system.label.purchase.safetystockapply" default="안전재고 반영"/>',
                    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'SAFETY_STOCK_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'SAFETY_STOCK_YN' ,
				    	inputValue: 'N',
				    	width:80
				    }]
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect4',
				    fieldLabel: '<t:message code="system.label.purchase.receiptplannedapply" default="입고예정 반영"/>',
                    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'INSTOCK_PLAN_YN',
				    	inputValue: 'Y',
				    	width:80
				    	//checked: true
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'INSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	width:80
				    }]
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect5',
				    fieldLabel: '<t:message code="system.label.purchase.issueresevationapply" default="출고예정 반영"/>',
                    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'OUTSTOCK_PLAN_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'OUTSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	width:80
				    }]
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect6',
				    fieldLabel: '<t:message code="system.label.purchase.substockapply" default="외주재고 반영"/>',
                    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'SUB_STOCK_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'SUB_STOCK_YN' ,
				    	inputValue: 'N',
				    	width:80
				    }]
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect7',
				    fieldLabel: '<t:message code="system.label.purchase.uncertaintransformorderapply" default="미확정 전환오더 반영"/>',
				    labelWidth: 120,
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'REL_PLAN_YN',
				    	inputValue: 'Y',
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'REL_PLAN_YN' ,
				    	inputValue: 'N',
				    	width:110
				    }]
				},{
	    			fieldLabel: '<t:message code="system.label.purchase.nontransitionplanorder" default="미전환 계획오더"/>',
	    			name:'DATA_CNT',
	    			value:dataCnt,
	    			hidden: true
	    		},{
	    			fieldLabel: '<t:message code="system.label.purchase.nontransitionplanorderdeleteyn" default="미전환 계획오더 삭제여부"/>',
	    			name:'OPEN_DEL_YN',
	    			hidden: true
	    		},{
			     	xtype: 'container',
			     	tdAttrs: {align: 'center'},
			     	layout: {type: 'uniTable', columns: 3},
			     	items: [{
				        	margin: '0 6 0 0',
							xtype: 'button',
							id: 'startButton',
							text: '<t:message code="system.label.purchase.execute" default="실행"/>',
							width: 60,
							handler : function() {
								var rv = true;
								if(confirm(Msg.sMB063)) {
									if(panelSearch.getValue('DATA_CNT') == '0'){
										panelSearch.setValue('OPEN_DEL_YN', 'N');
									}else{
										if(confirm('<t:message code="system.message.purchase.message053" default="이미 MRP전개한 미전환 계획오더가 존재합니다. 삭제하고 진행하시겠습니까?"/>')) {
											panelSearch.setValue('OPEN_DEL_YN', 'Y');
										}else{
											panelSearch.setValue('OPEN_DEL_YN', 'N');
										}
									}

									var param= panelSearch.getValues();
									var me = this;
									panelSearch.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
									Mrp115ukrvService.spCall(param, function(provider, response) {
										if(provider != null) {
											if(provider.STATUS != null && provider.STATUS == "Start")	{
												alert("실행 중인 MRP 전개가 있습니다");
											}
											setTimeout(function(){
												Mrp115ukrvService.selectLog(param, function(provicer2, response2){
													
													mrpBatchView.loadData();
													clearInterval(chkinterval);
													chkinterval = setInterval(function(){ mrpBatchView.loadData(); }, 600000);
													var progressView = Ext.getCmp("progressView");
													progressView.show();
												
												})
											}, 1000)
										} 
			 							panelSearch.getEl().unmask();
									});
								} else {
							   		return false;
								}
								return rv;
				    		}
					      }
					  ]
			}],
			api: {
         		 submit: 'mrp115ukrvService.executeMrp'

				}
		, listeners : {
			dirtychange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
//					UniAppManager.setToolbarButtons('save', true);
			}
		},
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
					//this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});
	
	

	/**
     * Master Grid1 정의(Grid Panel)
     * @type
     */


    Unilite.Main( {
		id  : 'mrp115ukrvApp',
		items 	: [ panelSearch, mrpBatchView],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);

			panelSearch.setValue('MRP_DATE', baseDate[0].MRP_DATE);

			panelSearch.setValue('FIRM_DATE', baseDate[0].FIXDATE);
			panelSearch.setValue('PLAN_DATE', baseDate[0].INDIDATE);

			panelSearch.setValue('WH_STOCK_YN', baseYN[0].WH_STOCK_YN);
			panelSearch.setValue('SAFETY_STOCK_YN', baseYN[0].SAFETY_STOCK_YN);
			panelSearch.setValue('INSTOCK_PLAN_YN', baseYN[0].INSTOCK_PLAN_YN);
			panelSearch.setValue('OUTSTOCK_PLAN_YN', baseYN[0].OUTSTOCK_PLAN_YN);
			panelSearch.setValue('SUB_STOCK_YN', baseYN[0].SUB_STOCK_YN);
			panelSearch.setValue('REL_PLAN_YN', baseYN[0].REL_PLAN_YN);

			this.setToolbarButtons(['newData','reset', 'query'],false);
			setTimeout(function() {mrpBatchView.loadData();}, 1000);
			
		}
	});



};


</script>
