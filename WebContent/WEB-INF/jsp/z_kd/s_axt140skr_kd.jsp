<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt140skr_kd"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="s_axt140skr_kd"/>			 <!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B004" />				 <!--화폐단위-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-grid-row-odd  {background-color:#ffffff;}
.x-grid-row-even {background-color:#f8f8f8;}
</style>
<script type="text/javascript" >

function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_axt140skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'					,text:'법잉코드'		,type:'string'},
			{name: 'SORT_SEQ'					,text:'조회구분'		,type:'int'},
			{name: 'LOANNO'						,text:'차입번호'		,type:'string'},
			{name: 'LOAN_NAME'					,text:'차입금명'		,type:'string'},
			{name: 'ACCNT'						,text:'계정과목'		,type:'string'},
			{name: 'EXCHG_RATE_O'				,text:'차입환율'		,type:'uniER'},
			{name: 'FG_INT'						,text:'조건'			,type:'string'},
			{name: 'NOW_RATE'					,text:'현이율'			,type:'uniER'},
			{name: 'INT_RATE'					,text:'계약이율'		,type:'uniER'},
			{name: 'PUB_DATE'					,text:'차입일'			,type:'uniDate'},
			{name: 'MONEY_UNIT'					,text:'화폐단위'		,type:'string', comboType: 'AU', comboCode: 'B004'},
			{name: 'AMT_I'						,text:'당초대출금'		,type:'uniPrice'},
			{name: 'JAN_AMT_I'					,text:'잔액'			,type:'uniPrice'},
			{name: 'SORT_NAME'					,text:'계획'			,type:'string'},
			{name: 'DATA_MON_01'				,text:'월일'			,type:'string'},
			{name: 'DATA_MON_01_P_PRINCIPAL_AMT',text:'상환액'			,type:'uniPrice'},
			{name: 'DATA_MON_01_JAN_MAT_I'		,text:'잔액'			,type:'uniPrice'},
			{name: 'DATA_MON_02'				,text:'월일'			,type:'string'},
			{name: 'DATA_MON_02_P_PRINCIPAL_AMT',text:'상환액'			,type:'uniPrice'},
			{name: 'DATA_MON_02_JAN_MAT_I'		,text:'잔액'			,type:'uniPrice'},
			{name: 'DATA_MON_03'				,text:'월일'			,type:'string'},
			{name: 'DATA_MON_03_P_PRINCIPAL_AMT',text:'상환액'			,type:'uniPrice'},
			{name: 'DATA_MON_03_JAN_MAT_I'		,text:'잔액'			,type:'uniPrice'},
			{name: 'DATA_MON_04'				,text:'월일'			,type:'string'},
			{name: 'DATA_MON_04_P_PRINCIPAL_AMT',text:'상환액'			,type:'uniPrice'},
			{name: 'DATA_MON_04_JAN_MAT_I'		,text:'잔액'			,type:'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('s_axt140skr_kdMasterStore1',{
		model: 's_axt140skr_kdModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_axt140skr_kdService.selectList'
			}
		}
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
			
		},
		//groupField: 'LOANNO',
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0){
					Ext.getCmp('GW').setDisabled(false);
				}else{
					Ext.getCmp('GW').setDisabled(true);
				}
			}
		}
	});
	

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
			items: [{
					fieldLabel: '기준일',
					xtype: 'uniDatefield',
					name: 'ST_DATE',
					labelWidth:90,
					value: new Date(),
					allowBlank: false,
					listeners:{
					change:function(field, newValue, oldValue) {
						UniAppManager.app.fnSetGridHeaderMonth(newValue);
					}
				}
			},{
					fieldLabel: '사업장',
					name:'DIV_CODE', 
					xtype: 'uniCombobox',
					comboType:'BOR120'
			}, 
			Unilite.popup('DEBT_NO',{
					fieldLabel: '차입금',
					holdable: 'hold',
					valueFieldName:'LOANNO',
					textFieldName:'LOAN_NAME',
					validateBlank:false,
					autoPopup:true
			})
		  ]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var month1 =  '0000년 00월';
	
	var masterGrid = Unilite.createGrid('s_axt140skr_kdGrid1', {
		region: 'center',
		layout: 'fit',
		uniOpt:{	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		
		tbar: [{
				itemId : 'GWBtn',
				id:'GW',
				iconCls : 'icon-referance'  ,
				text:'기안',
				handler: function() {
					var param = panelResult.getValues();
					
					if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}

					if(confirm('기안 하시겠습니까?')) {
					   UniAppManager.app.requestApprove();
					}
				}
			}
		],
		
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(rowIndex % 4 <= 1) {
					cls = 'x-grid-row-odd';
				}
				else {
					cls = 'x-grid-row-even';
				}
				return cls;
			}
		},
		features: [ 
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		store: directMasterStore1,
		//selModel : 'rowmodel',
		columns: [
			{ dataIndex: 'COMP_CODE'			, width: 80, hidden: true},
			{ dataIndex: 'SORT_SEQ'				, width: 80, hidden: true},
			{ dataIndex: 'LOANNO'				, width: 80},
			{ dataIndex: 'LOAN_NAME'			, width: 150},
			{ dataIndex: 'ACCNT'				, width: 100 ,hidden: true},
			{ dataIndex: 'EXCHG_RATE_O'			, width: 100,hidden: true},
			{ dataIndex: 'FG_INT'				, width: 80, hidden: true},
			{ dataIndex: 'NOW_RATE'				, width: 70},
			{ dataIndex: 'INT_RATE'				, width: 70},
			{ dataIndex: 'PUB_DATE'				, width: 90, align: 'center'},
			{ dataIndex: 'MONEY_UNIT'			, width: 80, align: 'center'},
			{ dataIndex: 'AMT_I'				, width: 110},
			{ dataIndex: 'JAN_AMT_I'			, width: 110},
			{ dataIndex: 'SORT_NAME'			, width: 60, align: 'center'},
			{id: 'date1',
			 text: month1,
				columns:[
					{dataIndex: 'DATA_MON_01'						, width: 60,align:'center'},
					{dataIndex: 'DATA_MON_01_P_PRINCIPAL_AMT'		, width: 100 },
					{dataIndex: 'DATA_MON_01_JAN_MAT_I'				, width: 100 }
			]},
			{id: 'date2',
			 text: month1,
				columns:[
					{dataIndex: 'DATA_MON_02'						, width: 60,align:'center'},
					{dataIndex: 'DATA_MON_02_P_PRINCIPAL_AMT'		, width: 100 },
					{dataIndex: 'DATA_MON_02_JAN_MAT_I'				, width: 100 }
			]},
			{id: 'date3',
			 text: month1,
				columns:[
					{dataIndex: 'DATA_MON_03'						, width: 60,align:'center'},
					{dataIndex: 'DATA_MON_03_P_PRINCIPAL_AMT'		, width: 100 },
					{dataIndex: 'DATA_MON_03_JAN_MAT_I'				, width: 100 }
			]},
			{id: 'date4',
			 text: month1,
				columns:[
					{dataIndex: 'DATA_MON_04'						, width: 60,align:'center'},
					{dataIndex: 'DATA_MON_04_P_PRINCIPAL_AMT'		, width: 100 },
					{dataIndex: 'DATA_MON_04_JAN_MAT_I'				, width: 100 }
			]}
		]
	});
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					masterGrid, panelResult
				]
			}
		], 
		id  : 's_axt140skr_kdApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ST_DATE',UniDate.get('today'));
			this.fnSetGridHeaderMonth(UniDate.get('today'));
			
			var activeSForm = panelResult;
			//activeSForm.onLoadSelectText('PERSON_NUMB');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			Ext.getCmp('GW').setDisabled(true);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			
			var viewLocked = masterGrid.getView();
			var viewNormal = masterGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			
		},
		requestApprove: function(){	 //결재 요청
			var gsWin = window.open('about:blank','payviewer','width=500,height=500');
			
			var frm		 = document.f1;
			var compCode	= UserInfo.compCode;
			var divCode	 = panelResult.getValue('DIV_CODE');
			var userId	  = UserInfo.userID
			var stdate	  = UniDate.getDbDateStr(panelResult.getValue('ST_DATE'));
			var loanno	= panelResult.getValue('LOANNO');
			if(loanno == null){
				loanno = '';
			}
			
			
			//var record = masterGrid.getSelectedRecord();
			var groupUrl	= "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=axt140skr&draft_no=0&sp=EXEC " 
								   
			var spText	  = 'omegaplus_kdg.unilite.USP_ACCNT_AXT140SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
							+ ', ' + "'" + stdate + "'" + ', ' + "'" + loanno + "'" + ', ' + "''"
							+ ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
			var spCall	  = encodeURIComponent(spText); 
			

			frm.action   = groupUrl + spCall/* + Base64.encode()*/;
			frm.target   = "payviewer"; 
			frm.method   = "post";
			frm.submit();
		},
		fnSetGridHeaderMonth : function(dt) {
			dt = UniDate.getDbDateStr(dt);
			
			var month1 = this.addMonth(dt, 1);
			var month2 = this.addMonth(dt, 2);
			var month3 = this.addMonth(dt, 3);
			var month4 = this.addMonth(dt, 4);
			
			Ext.getCmp('date1').setText(month1.substring(0, 4) + '년 ' + month1.substring(4, 6)  + '월');
			Ext.getCmp('date2').setText(month2.substring(0, 4) + '년 ' + month2.substring(4, 6)  + '월');
			Ext.getCmp('date3').setText(month3.substring(0, 4) + '년 ' + month3.substring(4, 6)  + '월');
			Ext.getCmp('date4').setText(month4.substring(0, 4) + '년 ' + month4.substring(4, 6)  + '월');
		},
		addMonth : function(dt, m) {
			//dt = dt.substring(0, 4) + "-" + dt.substring(4, 6) + "-" + dt.substring(6, 8);
			dt = dt.substring(0, 4) + "-" + dt.substring(4, 6) + "-01";
			var newDt = new Date(dt);
			newDt.setMonth(newDt.getMonth() + m);
			return String(newDt.getFullYear()) + (newDt.getMonth() + 1 < 10 ? "0" : "") + String(newDt.getMonth() + 1) + (newDt.getDate() < 10 ? "0" : "") + String(newDt.getDate());
		}
		
	});
};


</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>