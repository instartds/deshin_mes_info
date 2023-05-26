<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="biv114ukrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="biv114ukrv"/> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var chkinterval ;
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Biv114ukrvModel', {		
	    fields: [
	    	{name: 'DIV_CODE' 			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'			,type: 'string'},
	    	{name: 'WH_CODE' 			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'				,type: 'string'},
	    	{name: 'LAST_YYYYMM' 		,text: '<t:message code="system.label.inventory.lastclosingyearmonth" default="최종마감년월"/>'		,type: 'string'},
	    	{name: 'CLOSE_YYYYMM' 		,text: '<t:message code="system.label.inventory.workyearmonth" default="작업년월"/>'			,type: 'string'},
			{name: 'BASIS_YYYYMM'		,text: '<t:message code="system.label.inventory.stockapplyyearmonth" default="기초재고반영년월"/>'		,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('biv114ukrvMasterStore1',{
			model: 'Biv114ukrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	read: 'biv114ukrvService.selectMaster'                	
                }
            },
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			saveStore: function(config) {	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);
				var rv = true;
       			if(inValidRecs.length == 0 ) {										
					config = {
						success: function(batch, option) {								
							panelSearch.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						} 
					};					
					this.syncAllDirect(config);
				} else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners: {
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					
				}	
			}
	});
	
	var panelSearch = Unilite.createForm('biv150ukrv', {
		disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							UniAppManager.app.fnYyyymmSet(newValue);
						}
					}
				},{
	            	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
	            	name: 'WH_CODE',
	            	xtype: 'uniCombobox',
					holdable: 'hold',
					hidden: true,
	            	store: Ext.data.StoreManager.lookup('whList')
				},{ 
					fieldLabel: '<t:message code="system.label.inventory.lastclosingyearmonth" default="최종마감년월"/>',
					name: 'LAST_YYYYMM',
	                xtype: 'uniTextfield',
	                width : 200,
	                readOnly: true,
					fieldStyle: 'text-align: center;'
	            },{ 
					fieldLabel: '<t:message code="system.label.inventory.workyearmonth" default="작업년월"/>',
					name: 'CLOSE_YYYYMM',
	                xtype: 'uniMonthfield',
	                width : 200,
	                readOnly: true,
	                allowBlank:false
	            },{ 
					fieldLabel: '<t:message code="system.label.inventory.stockyearmonth" default="기초재고년월"/>',
					name: 'BASIS_YYYYMM',
	                xtype: 'uniTextfield',
	                width : 200,
	                readOnly: true,
					fieldStyle: 'text-align: center;'
	            },{
					xtype: 'uniMonthfield',
					fieldLabel: '작업년월날자포멧용',
					name: 'TEMP_CLOSE_YYYYMM',
					hidden: true
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect',
				    name: 'CLOSED_RDO_YN',
				    fieldLabel: '<t:message code="system.label.inventory.workselection" default="작업선택"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.inventory.closing" default="마감"/>',
				    	name: 'PROCESS_TYPE',
				    	inputValue: '1',
				    	width:80,
				    	checked: true
				    }, {
				    	boxLabel: '<t:message code="system.label.inventory.cancel" default="취소"/>',
				    	name: 'PROCESS_TYPE' ,
				    	inputValue: '2',
				    	width:80
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelSearch.getField('PROCESS_TYPE').setValue(newValue.PROCESS_TYPE);
							UniAppManager.app.fnRadioSet(newValue);
						}
					}
				},{
			    	xtype: 'container',
			    	padding: '10 0 0 0',
			    	layout: {
			    		type: 'hbox',
						align: 'center',
						pack:'center'
			    	},
			    	items:[{
			    		xtype: 'button',
			    		text: '<t:message code="system.label.inventory.execute" default="실행"/>',		
		    			width: 60,							   	
						handler : function(records) {
							if(panelSearch.getForm().isValid()) {
								if(confirm('<t:message code="system.message.inventory.message007" default="실행하시겠습니까?"/>')) {
									var param= panelSearch.getValues();	
									var lastDate = panelSearch.getValue('LAST_YYYYMM').replace('.','');
									var basisDate = panelSearch.getValue('BASIS_YYYYMM').replace('.','');
									var me = this;
									param.LAST_YYYYMM = lastDate;
									param.BASIS_YYYYMM = basisDate;
									Ext.app.REMOTING_API['timeout'] = 1200000;// milliseconds
									biv114ukrvService.WhCodeSet(param, function(provider, response) {
										var count = provider.CNT;
										if(count == '') {
											alert('<t:message code="system.message.inventory.message016" default="해당사업장에 창고가 없습니다."/>')
										} else if(count > 1) {
											alert('<t:message code="system.message.inventory.message017" default="해당사업장의 창고들 마감정보가 일치하지 않습니다."/>');
										} else {
											panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
											biv114ukrvService.spCall(param, function(provider, response) {
												UniAppManager.app.fnYyyymmSet();
												UniAppManager.updateStatus('작업이 시작 되었습니다.');
												panelSearch.getEl().unmask()
											});
										};
									});
								} else {
						   			
								}
							}
						}
			    }]	
		}]
	});    
	var bivClosingBatchView =  {
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
			html :'<b>[ 월마감 Batch Status ]</b>'
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
				bivClosingBatchView.loadData();
				clearInterval(chkinterval);
				chkinterval = setInterval(function(){ bivClosingBatchView.loadData(); }, 600000);
			}
		}],
		loadData:function()	{
			var me = this;
			var param = {};
			var progressView = Ext.getCmp("progressView");
			progressView.mask("Refresh...");
			biv114ukrvService.selectLog(param, function(provider, response){
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
	Unilite.Main( {
		items:[panelSearch, bivClosingBatchView],
		id: 'biv114ukrvApp',
		fnInitBinding: function(params) {
			if(params && params.DIV_CODE)	{
				panelSearch.setValue('DIV_CODE', params.DIV_CODE);
				panelSearch.setValue('CLOSE_YYYYMM', params.CLOSE_YYYYMM);
			} else {			
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
				panelSearch.setValue('LAST_YYYYMM', '0000.00');
				panelSearch.setValue('CLOSE_YYYYMM', UniDate.get('today'));
				panelSearch.setValue('BASIS_YYYYMM', '0000.00');
			}
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			
		},
		fnYyyymmSet : function(divCode) {		// 사업장 선택에 따라 날짜 set
			panelSearch.setValue('LAST_YYYYMM', '');
			panelSearch.setValue('CLOSE_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('BASIS_YYYYMM', '');
			panelSearch.getField( 'PROCESS_TYPE').setValue('1');	// 마감으로 rdo 변경	
			
			var param = {"DIV_CODE": panelSearch.getValue('DIV_CODE')};
			biv114ukrvService.YyyymmSet(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)) {
					if(param.LAST_YYYYMM = '000000') {
						panelSearch.setValue('LAST_YYYYMM', '0000.00');
					}
					var lastDate = provider.LAST_YYYYMM;
					var basisDate = provider.BASIS_YYYYMM;
					lastDate = lastDate.substring(0,4) + '.' + lastDate.substring(4,6);
					basisDate = basisDate.substring(0,4) + '.' + basisDate.substring(4,6);
					if(provider.LAST_YYYYMM != '000000') panelSearch.setValue('LAST_YYYYMM', lastDate);
					if(provider.BASIS_YYYYMM != '000000') panelSearch.setValue('BASIS_YYYYMM', basisDate);
					panelSearch.setValue('TEMP_CLOSE_YYYYMM', provider['LAST_YYYYMM']);
					panelSearch.setValue('CLOSE_YYYYMM', UniDate.add(panelSearch.getValue('TEMP_CLOSE_YYYYMM'), {months:1}));
				} else {
					panelSearch.setValue('LAST_YYYYMM', '0000.00');
					panelSearch.setValue('BASIS_YYYYMM', '0000.00');
					panelSearch.setValue('TEMP_CLOSE_YYYYMM', '0000.00');
					panelSearch.setValue('CLOSE_YYYYMM', UniDate.get('today'));
					panelSearch.getField('CLOSE_YYYYMM').setReadOnly(false);
				}
				panelSearch.getField( 'PROCESS_TYPE').setValue('1');	// 마감으로 rdo 변경	
				if(panelSearch.getValue('LAST_YYYYMM') == '0000.00') {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);	//최종마감일이 없을시  rdo disabled 취소선택 못하게
				} else {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(false);
				}
			})
		},
		fnRadioSet: function(newValue) {		// radio 선택에 따라 날짜 set
			if(newValue.PROCESS_TYPE == '1') {	// 마감
				if(panelSearch.getValue('LAST_YYYYMM') == '0000.00') {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);	//최종마감일이 없을시  rdo disabled 취소선택 못하게
				} else {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(false);
					panelSearch.setValue('CLOSE_YYYYMM', UniDate.add(panelSearch.getValue('TEMP_CLOSE_YYYYMM'), {months:1}));  
				}
			}
			if(newValue.PROCESS_TYPE == '2') {	// 취소
				var StrDate1 = panelSearch.getValue('LAST_YYYYMM');
				var sBasisYyyymm = panelSearch.getValue('BASIS_YYYYMM');
				if(StrDate1 <= sBasisYyyymm){
					alert('<t:message code="system.message.inventory.message018" default="기초반영년월이"/>' + ' ' + sBasisYyyymm + '<t:message code="system.message.inventory.message019" default="월이므로 취소가 불가능합니다."/>')	//기초반영월이 ?월이므로 취소가 불가능합니다. 
					return false;
				}
				if(panelSearch.getValue('LAST_YYYYMM') == '0000.00') {
					//Ext.getCmp('rdo').setDisabled(true);	// 날짜가 없을시  rdodisabled
				} else {
					panelSearch.setValue('CLOSE_YYYYMM', panelSearch.getValue('LAST_YYYYMM'));  
				}
			}
		}
	});

};


</script>
