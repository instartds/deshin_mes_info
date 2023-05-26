<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm150ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	/* Cost Pool 정보 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'cbm150ukrvService.selectList',
			create  : 'cbm150ukrvService.insertDetail',
			update  : 'cbm150ukrvService.updateDetail',
			destroy : 'cbm150ukrvService.deleteDetail',
			syncAll : 'cbm150ukrvService.saveAll'
		}
 	});

	/* Cost Pool 정보 */
	//모델 정의
	Unilite.defineModel('cbm150ukrvModel', {
	    fields: [{name: 'DIV_CODE'			,text:'사업장'		,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'WORK_MONTH'		,text:'작업년월'		,type : 'string', allowBlank:false, editable:false},
	    		 {name: 'PROD_ITEM_CODE'	,text:'품목코드'		,type : 'string', allowBlank:false, isPk:true, pkGen:'user'},
	    		 {name: 'PROD_ITEM_NAME'	,text:'품목명'			,type : 'string', allowBlank:false, isPk:true, pkGen:'user'},
	    		 {name: 'DIST_RATE'     	,text:'가중치'			,type : 'float' , format : '0,000.00', decimalPrecision: 2,  allowBlank:false}
			]
	});

	//스토어 정의
	var cbm150ukrvStore = Unilite.createStore('cbm150ukrvStore',{
		model: 'cbm150ukrvModel',
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function()	{
        	panelResult.setValue('isCopy', 'N');
        	var chkValid = panelResult.isValid();
        	if(chkValid)	{
				var param= Ext.getCmp('resultForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
        	}
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();

			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					params: [panelResult.getValues()],
					success: function(batch, option) {
						panelResult.setValue('isCopy', 'N');
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			load:function(store, records){
				store.setCheckRecord(records);
			}
		},
		setCheckRecord:function(records)	{
			var chk = false
			var store = this;
			Ext.each(records, function(record, idx){
				if(!record.get('UPDATE_DB_TIME'))	{
					//store.insert(idx, record);
					var newRecord =  Ext.create (store.model);
					if(record.data)	{
						Ext.each(Object.keys(record.data), function(key, idx){
							newRecord.set(key, record.data[key]);
						});
					}
					newRecord.phantom = true;
					store.remove(record);
					store.insert(idx, newRecord);
					if(!chk)	{
						chk=true;
						setTimeout(function(){UniAppManager.setToolbarButtons('save', true);}, 1000);
					}
				}

			});
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		xtype: 'uniSearchForm',
		itemId:'calcuBasisSearch1',
		region:'north',
		layout:{type:'uniTable', columns:'4'},
		items:[{
			xtype:'uniCombobox',
			comboType:'BOR120',
			fieldLabel:'사업장',
			name:'DIV_CODE',
			allowBlank:false,
			value:UserInfo.divCode
		},{
			xtype:'uniMonthfield',
			fieldLabel:'기준년월',
			labelWidth:120,
			name:'WORK_MONTH',
			allowBlank:false,
			value:UniDate.get('today')
		},{
			xtype:'uniTextfield',
			fieldLabel:'전월복사여부',
			labelWidth:120,
			name:'isCopy',
			value:'N',
			hidden:true
		},{
			xtype:'button',
			text:'전월데이타복사',
			tdAttrs:{align:'right', width:200},
			handler:function(){
				var form  = panelResult;
				form.setValue('ALLOCATION_CODE', '');
				if(form.isValid())	{
					var param = form.getValues();
					Ext.getBody().mask("Loading...");
					cbm150ukrvStore.loadData({});
					cbm150ukrvService.selectCopy(param, function(responseText, response){

						cbm150ukrvStore.loadData(responseText);
						cbm150ukrvStore.setCheckRecord(cbm150ukrvStore.getData().items);
						form.setValue('isCopy', 'Y');
						Ext.getBody().unmask()
					});
				}
			}
		}]

	});

	var masterGrid = Unilite.createGrid('cbm150ukrvGrid', {
		itemId:'cbm150ukrvsGrid',
	    store : cbm150ukrvStore,
	    layout:'fit',
	    region:'center',
	    uniOpt: {
		    useMultipleSorting	: true,
		    useLiveSearch		: true,
		    onLoadSelectFirst	: true,
		    dblClickToEdit		: true,
		    useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
			copiedRow			: true,
		    filter: {
				useFilter		: false,
				autoCreate		: false
			}
		},
		columns: [{dataIndex: 'WORK_MONTH' 		, width: 150, hidden:true},
				  {dataIndex: 'PROD_ITEM_CODE'  	, width: 250, 
				    editor: Unilite.popup('ITEM_G',{
				    	   textFieldName:'PROD_ITEM_NAME',
				    	   listeners : {
				    		   onSelected : function(records, type) {
					                    	var me = this;
					                    	var grdRecord = Ext.getCmp('cbm150ukrvGrid').uniOpt.currentRecord;
					                    	grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
					                    	grdRecord.set('PROD_ITEM_NAME',records[0]['ITEM_NAME']);
					           },         
				    		   onClear : function(type) {
				    			   var me = this;
			                    	var grdRecord = Ext.getCmp('cbm150ukrvGrid').uniOpt.currentRecord;
			                    	grdRecord.set('PROD_ITEM_CODE','');
			                    	grdRecord.set('PROD_ITEM_NAME','');
				    		   }
				    	   }
				   })
				  },
			      {dataIndex: 'PROD_ITEM_NAME'  	, width: 250, 
				    editor: Unilite.popup('ITEM_G',{
				    	   textFieldName:'PROD_ITEM_NAME',
				    	   listeners : {
				    		   onSelected : function(records, type) {
					                    	var me = this;
					                    	var grdRecord = Ext.getCmp('cbm150ukrvGrid').uniOpt.currentRecord;
					                    	grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
					                    	grdRecord.set('PROD_ITEM_NAME',records[0]['ITEM_NAME']);
					           },         
				    		   onClear : function(type) {
				    			   var me = this;
			                    	var grdRecord = Ext.getCmp('cbm150ukrvGrid').uniOpt.currentRecord;
			                    	grdRecord.set('PROD_ITEM_CODE','');
			                    	grdRecord.set('PROD_ITEM_NAME','');
				    		   }
				    	   }
				   })
				  },
				  {dataIndex: 'DIST_RATE' 	        , width: 100}
		]
	});

	/* 기준코드등록	*/
	Unilite.Main( {
		id 			: 'cbm150ukrvApp',
		borderItems : [
			panelResult,
			masterGrid
		],
		fnInitBinding : function(param) {
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
			}
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
		},
		onQueryButtonDown : function()	{
			cbm150ukrvStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			if(panelResult.isValid())	{
				var divCode      = panelResult.getValue("DIV_CODE");
	            var workMonth    = UniDate.getMonthStr(panelResult.getValue("WORK_MONTH"));

				var r = {
					DIV_CODE	: divCode,
					WORK_MONTH  : workMonth
				}
				masterGrid.createRow(r);
			}

		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();
		},
		onSaveDataButtonDown: function () {
			cbm150ukrvStore.saveStore();
		}
	});
};
</script>