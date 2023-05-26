<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa350ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 						<!-- 직위코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 						<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 						<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 						<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 						<!-- 지급일구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' /> 		<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H153" /> 						<!-- 마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 						<!-- 사원그룹 -->
	<t:ExtComboStore items="${COMBO_DEPTS2}" storeId="authDeptsStore" />        <!--권한부서-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var yearEndWindow ;
	var gsList1 = '${gsList1}';
	var colData = ${colData};
// 	console.log(colData);
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa350ukrService.selectList',
			update	: 'hpa350ukrService.updateList',
			destroy	: 'hpa350ukrService.deleteList',
			syncAll	: 'hpa350ukrService.saveAll'
		}
	});

	/*   Model 정의
	 * @type
	 */
	Unilite.defineModel('Hp350ukrModel', {
		fields : fields
	});

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }

	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('hp350ukrMasterStore',{
		model: 'Hp350ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결
            editable	: true,			// 수정 모드 사용
            deletable	: true,			// 삭제 가능 여부
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad		: false,
        proxy			:directProxy,
		loadStoreRecords: function()	{
			var param= Ext.getCmp('resultForm').getValues();
				console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		console.log("toUpdate",toUpdate);

       		var rv = true;

        	if(inValidRecs.length == 0 )	{
				config = {
					params:[panelResult.getValues()],
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						masterStore.loadStoreRecords();
					 }
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners : {
			load:function( store, records, successful, operation, eOpts ){
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
	            if (store.getCount() > 0) {
					Ext.getCmp('resultForm').getForm().findField('PAY_YYYYMM').setReadOnly(true);
	            	UniAppManager.setToolbarButtons('deleteAll', true);
	            } else {
					Ext.getCmp('resultForm').getForm().findField('PAY_YYYYMM').setReadOnly(false);
		        	UniAppManager.setToolbarButtons('deleteAll', false);
	            }
	        },
	        update:function( store, record, operation, modifiedFieldNames, details, eOpts )	{
	        	/*
	        	 * {name: 'SUPP_TOTAL_I'		, text: '지급총액'		  	, type:'uniPrice'},
				{name: 'DED_TOTAL_I'		, text: '공제총액'		  	, type:'uniPrice'},
			    {name: 'REAL_AMOUNT_I'		, text: '실지급액'		  	, type:'uniPrice'},
	        	 *
	        	 **/
	        	Ext.each(modifiedFieldNames, function(field, idx){
	        		if(store.getModel().getField(field) != null){
	        			var code_gubun = store.getModel().getField(field).CODE_GUBUN;
		        		if(code_gubun == "WAGES_PAY")	{
		        			var SUPP_TOTAL_I =  record.get("SUPP_TOTAL_I");
		        			SUPP_TOTAL_I = SUPP_TOTAL_I - record.previousValues[field] + record.get(field);
		        			record.set("SUPP_TOTAL_I", SUPP_TOTAL_I);
		        			record.set("REAL_AMOUNT_I", (record.get("SUPP_TOTAL_I")-record.get("DED_TOTAL_I")));
		        		}else if(code_gubun == "WAGES_DED")	{
		        			var DED_TOTAL_I =  record.get("DED_TOTAL_I");
		        			DED_TOTAL_I = DED_TOTAL_I - record.previousValues[field] + record.get(field);
		        			record.set("DED_TOTAL_I", DED_TOTAL_I);
		        			record.set("REAL_AMOUNT_I", (record.get("SUPP_TOTAL_I")-record.get("DED_TOTAL_I")));
		        		}
	        		}
	        	});


	        }
	    }
	});


	/* 검색조건 (Search Panel)
	 * @type
	 */

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        name:'DIV_CODE',
	        labelWidth:110,
	        xtype: 'uniCombobox',
	        comboType:'BOR120',
	        tdAttrs: {width: 380}
	    },{
        	fieldLabel: '<t:message code="system.label.human.payyyyymm1" default="귀속년월"/>',
        	xtype: 'uniMonthfield',
        	allowBlank:false,
        	name: 'PAY_YYYYMM',
			value: UniDate.get('startOfMonth'),
//			colspan: 2,
	        tdAttrs: {width: 380}
       	},{
	        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
	        name:'SUPP_TYPE',
	        xtype: 'uniCombobox',
	        comboType: 'AU',
	        comboCode:'H032',
	        tdAttrs: {width: 380},
        	allowBlank:false,
			value: 1,
			colspan : 2
	    },{
            fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
            name: 'DEPTS2',
            xtype: 'uniCombobox',
            labelWidth:110,
            width:300,
            multiSelect: true,
            store:  Ext.data.StoreManager.lookup('authDeptsStore'),
            disabled:true,
            hidden:false,
            allowBlank:false
        },
    	Unilite.treePopup('DEPTTREE',{
    		itemId: 'deptstree',
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			labelWidth:110,
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
//			textFieldWidth:89,
//			textFieldWidth: 159,
			validateBlank:true,
//			width:300,
			autoPopup:true,
			useLike:true
		}),
	      	Unilite.popup('Employee',{
	      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
		    autoPopup:true
  		}),{
            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
            name:'PAY_GUBUN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H011'
        },{
        	xtype: 'container',
			layout: {type : 'hbox'},
	        tdAttrs: {width: 180},
			items :[{
				xtype: 'radiogroup',
				fieldLabel: '',
				itemId: 'RADIO2',
				labelWidth: 35,
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
					width: 50,
					name: 'rdoSelect' ,
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.human.general" default="일반"/>',
					width: 50,
					name: 'rdoSelect' ,
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/>',
					width: 50,
					name: 'rdoSelect' ,
					inputValue: '1'
				}]
			}]
		},{
            fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
            name:'PAY_PROV_FLAG',
            labelWidth:110,
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031'
        }, {
            fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
            name:'PAY_CODE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H028',
			colspan: 3
        },{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.taxcalculation" default="세액계산"/>',
			labelWidth:110,
			name : 'CALC_TAX_YN',
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_TAX_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_TAX_YN',
				checked: true,
				inputValue: 'N'
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>',
			name : 'CALC_HIR_YN',
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_HIR_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_HIR_YN',
				checked: true,
				inputValue: 'N'}
		]},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.workconpenyn" default="산재보험계산"/>',
			name : 'CALC_IND_YN',
			colspan:2,
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_IND_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_IND_YN',
				checked: true,
				inputValue: 'N'
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.anuhealthinsursum" default="국민/건강보험계산"/>',
			name : 'CALC_MED_YN',
			labelWidth:110,
			colspan:3,
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_MED_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_MED_YN',
				checked: true,
				inputValue: 'N'}
			],
			listeners: {
				specialkey: function(field, event){
					if(event.getKey() == event.ENTER){
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}}]
	});

    /* Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('hp350ukrGrid1', {
		layout	: 'fit',
		region	: 'center',
    	store	: masterStore,
		columns : columns,
        uniOpt : {
			useMultipleSorting	: true,
	    	useLiveSearch		: false,
	    	onLoadSelectFirst	: true,			//체크박스모델은 false로 변경
	    	dblClickToEdit		: true,
	    	useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,			// rink 항목이 있을경우만 true
	    	filter: {
				useFilter	: false,
				autoCreate	: true
			}
		},
		tbar : [
			'->',
			{
	  			xtype	: 'button',
				text	: '연말정산분납조회',
				rowspan : 4,
				width	: 140,
		        tdAttrs	: {align: 'right', style : 'padding-right : 10px;'},
				itemId 	: 'yearEndWinBtn',
				handler	: function(btn) {

		        	var selRecord = masterGrid.getSelectedRecord();
					if(!UniAppManager.app.isValidSearchForm() || Ext.isEmpty(selRecord)){
						if(Ext.isEmpty(selRecord))	{
							Unilite.messageBox("조회할 사원을 선택하세요.")		
						}
						return false;
					} else {
						openYearEndWindow(selRecord);
					}
				}
			}
			,'-'
		],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: true
		},{
    		id : 'masterGridTotal',
    		ftype: 'uniSummary',
    		dock : 'top',
    		showSummaryRow: true
    	}],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				var record = masterGrid.getSelectedRecord();
				if(record.get('CLOSE_YN') == 'Y'){
						return false;
				} else	{
					if(UniUtils.indexOf(e.field, ['GUBUN', 'SUPP_TYPE', 'COMP_CODE', 'DIV_CODE', 'DEPT_CODE', 'DEPT_NAME', 'POST_CODE', 'NAME', 'PERSON_NUMB', 'PAY_YYYYMM', 'JOIN_DATE', 'YOUTH_EXEMP_RATE', 'YOUTH_EXEMP_DATE', 'TAX_AMOUNT_I', 'TAX_EXEMPTION_I', 'SUPP_TOTAL_I', 'DED_TOTAL_I', 'REAL_AMOUNT_I'])){
						return false;
					} else {
						return true;
					}
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(record)	{
					var param = {
            			'PGM_ID'		: 'hpa350ukr',
						'PAY_YYYYMM' 	: panelResult.getValue('PAY_YYYYMM'),
						'PERSON_NUMB'	: record.get('PERSON_NUMB'),
						'NAME'			: record.get('NAME'),
						'SUPP_TYPE'		: panelResult.getValue('SUPP_TYPE')
            		};
            		masterGrid.gotoHpa330ukr(param);
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
      		//menu.showAt(event.getXY());
			return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text	: '<t:message code="system.label.human.payserchview" default="급여조회및조정 보기"/>',
	            	itemId	: 'linkHpa330ukr',
	            	handler	: function(menuItem, event) {
						var record = masterGrid.getSelectedRecord();
						var param = {
	            			'PGM_ID'		: 'hpa350ukr',
							'PAY_YYYYMM' 	: panelResult.getValue('PAY_YYYYMM'),
							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
							'NAME'			: record.data['NAME'],
							'SUPP_TYPE'		: panelResult.getValue('SUPP_TYPE')
	            		};
	            		masterGrid.gotoHpa330ukr(param);
	            	}
	        	}
	        ]
	    },
		gotoHpa330ukr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'hpa330ukr', 'text':''}};
			parent.openTab(rec1, '/human/hpa330ukr.do', params);
    	}
    });

	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}],
		id: 'hp350ukrApp',

		fnInitBinding: function() {
			UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");

        	var radio2 = panelResult.down('#RADIO2');
			radio2.hide();
			radio2.setValue('');

			/*masterGrid.on('edit', function(editor, e) {
				var record = e.grid.getSelectionModel().getSelection()[0];
				var supp_type_value = Ext.getCmp('SUPP_TYPE').getValue();
				record.set('GUBUN', 'U');
				record.set('SUPP_TYPE', supp_type_value);
			});*/

		    panelResult.setValue('DIV_CODE',UserInfo.divCode);
		    panelResult.setValue('SUPP_TYPE','1');

			UniAppManager.setToolbarButtons(['newData','save'],false);

			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown : function() {
            if(!panelResult.getInvalidMessage()) return;
				// query 작업
				masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown:function () {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid.getStore().sorters.clear();
			Ext.getCmp('resultForm').getForm().findField('PAY_YYYYMM').setReadOnly(false);
			Ext.getCmp('resultForm').getForm().findField('PAY_YYYYMM').setValue(UniDate.get('startOfMonth'));
        	UniAppManager.setToolbarButtons('deleteAll', false);
			this.fnInitBinding();

		},
		onDeleteDataButtonDown : function()	{
			if(confirm('<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		},
 		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message043" default="전체행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					masterStore.removeAll();
					UniAppManager.app.onSaveDataButtonDown();
				}
			});
		}
	});


	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
          	{name: 'GUBUN'						, text: '<t:message code="system.label.human.gubunvalue" default="구분값"/>'			, type:'string', defaultValue: 'D'},
      		{name: 'SUPP_TYPE'				, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'			, type:'string'},
      		{name: 'DIV_CODE'				, text: '<t:message code="system.label.human.division" default="사업장"/>'			, type:'string', comboType:'BOR120'},
			{name: 'CLOSE_YN'				, text: '<t:message code="system.label.human.personaldeadline" default="개인별마감"/>' 	  	, type:'string', comboType:'AU', comboCode:'H153'},
		    {name: 'COMP_CODE'			, text: '<t:message code="system.label.human.compcode" default="법인코드"/>' 	  	 	, type:'string'},
            {name: 'DEPT_CODE'				, text: '<t:message code="system.label.human.deptcode" default="부서코드"/>' 	  	 	, type:'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'      	  	, type:'string'},
			{name: 'POST_CODE'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'			, type:'string', comboType:'AU', comboCode:'H005'},
			{name: 'NAME'						, text: '<t:message code="system.label.human.name" default="성명"/>'      	  	, type:'string'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'			, type:'string'},
			{name: 'JOIN_DATE'				, text: '<t:message code="system.label.human.joindate" default="입사일"/>'		  	, type:'string'},
			
			{name: 'YOUTH_EXEMP_RATE'				, text: '청년세액감면율'		  	, type:'string', comboType:'AU', comboCode:'H179'},
			{name: 'YOUTH_EXEMP_DATE'				, text: '청년세액감면기간'		  	, type: 'uniDate'},
			
			{name: 'TAX_AMOUNT_I'					, text: '과세총액'		  	, type:'uniPrice'},
			{name: 'TAX_EXEMPTION_I'				, text: '비과세총액'		  	, type:'uniPrice'},
			
			{name: 'PAY_YYYYMM'			, text: '<t:message code="system.label.human.payyyyymm1" default="귀속년월"/>'		, type:'string'},
			{name: 'SUPP_TOTAL_I'			, text: '<t:message code="system.label.human.payamounti" default="지급총액"/>'		  	, type:'uniPrice'},
			{name: 'DED_TOTAL_I'			, text: '<t:message code="system.label.human.dedtotali" default="공제총액"/>'		  	, type:'uniPrice'},
		    {name: 'REAL_AMOUNT_I'	, text: '<t:message code="system.label.human.realamounti" default="실지급액"/>'		  	, type:'uniPrice'},
		    {name: 'PAY_CODE'				, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>'		, type:'string'},
		    {name: 'PAY_PROV_FLAG'		, text: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>'			, type:'string'},
		    {name: 'SUPP_DATE'				, text: '<t:message code="system.label.human.salarysuppdate" default="급여지급일"/>'		, type:'string'}

		];
		Ext.each(colData, function(item, index){
	    //    if (index == 0) return '';
			fields.push({name: item.WAGES_CODES, text: item.WAGES_NAME, type:'uniPrice' , CODE_GUBUN:item.CODE_GUBUN});
		});
		console.log(fields);
		return fields;
	}
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
/*			{dataIndex: 'GUBUN'						   , locked: false, hidden:true},
			{dataIndex: 'SUPP_TYPE'					   , locked: false, hidden:true},
			{dataIndex: 'COMP_CODE',		width: 100,  locked: false, hidden:true},*/
//			{dataIndex: 'CLOSE_YN',			width: 75,   locked: false,
			{dataIndex: 'CLOSE_YN',			width: 75,   locked: true,  hidden:true},
			{dataIndex: 'DIV_CODE',			width: 120,  locked: true,
            //원하는 컬럼 위치에 소계, 총계 타이틀 넣는다.
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.totwagesi" default="합계"/>', '<t:message code="system.label.human.totwagesi" default="합계"/>');
            }},
	        {dataIndex: 'DEPT_CODE',		width: 80,   locked: true},
	        {dataIndex: 'PAY_PROV_FLAG',       width: 80,   locked: true},
			{dataIndex: 'DEPT_NAME',		width: 100,  locked: true},
			{dataIndex: 'POST_CODE',		width: 80,   locked: true},
			{dataIndex: 'NAME',				width: 80,   locked: true, summaryType: 'count'
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) 
				{
			        return '<div align="right">'+value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+' 명</div>';
            	}},
			{dataIndex: 'PERSON_NUMB',		width: 80,   locked: true},
//			{dataIndex: 'PAY_YYYYMM',		width: 80,   locked: false, hidden: true},
			{dataIndex: 'JOIN_DATE',		width: 80,   locked: false},
			{dataIndex: 'YOUTH_EXEMP_RATE',	width: 100,  locked: false},
			{dataIndex: 'YOUTH_EXEMP_DATE',	width: 120,  locked: false},
			{dataIndex: 'TAX_AMOUNT_I',		width: 100,  locked: false, align : 'right',	summaryType: 'sum'},
			{dataIndex: 'TAX_EXEMPTION_I',	width: 100,  locked: false, align : 'right',	summaryType: 'sum'},
			{dataIndex: 'SUPP_TOTAL_I',		width: 100,  locked: false, align : 'right',	summaryType: 'sum'},
			{dataIndex: 'DED_TOTAL_I',		width: 100,  locked: false, align : 'right',	summaryType: 'sum'},
			{dataIndex: 'REAL_AMOUNT_I',	width: 100,  locked: false, align : 'right',	summaryType: 'sum'}
		];
		Ext.each(colData, function(item, index){
			//if (index == 0) return '';
			columns.push({dataIndex: item.WAGES_CODES,	width: 110, align : 'right',  summaryType: 'sum'});
		});
// 		console.log(columns);
		return columns;
	}
			
	// 연말정산데이터 조회
	Unilite.defineModel('yearEndModel', {
	    fields: [  	    
              {name : 'DIV_CODE'        , text : '<t:message code="system.label.human.division" default="사업장"/>'			, type : 'string'       , comboType : 'BOR120'		}
	    	, {name : 'YEAR_YYYY'       , text : '<t:message code="system.label.human.reportyear" default="신고연도"/>'		, type : 'string'     	         								}
	    	, {name : 'PERSON_NUMB'     , text : '<t:message code="system.label.human.employeenumber" default="사원번호"/>'	, type : 'string' 	  	         								}
	    	, {name : 'NAME'     		, text : '<t:message code="system.label.human.employeename" default="사원명"/>'		, type : 'string'  		         								}
	    	// 연말정산
	    	, {name : 'IN_TAX_I'        , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'    	            													}
	    	, {name : 'SP_TAX_I'        , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'      										}
	    	, {name : 'LOCAL_TAX_I'     , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'   											}
	    	// 1차분납
	    	, {name : 'PAY_YYYYMM_01'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'   											}
	    	, {name : 'PAY_MM_01'   	, text : ' 귀속월'		, type : 'string'   	            													}
	    	, {name : 'IN_TAX_I_01'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                  																	}
	    	, {name : 'SP_TAX_I_01'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                          											}
	    	, {name : 'LOCAL_TAX_I_01'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                          											}
	    	, {name : 'PAY_APPLY_YN_01' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'     	, store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	// 2차분납
	    	, {name : 'PAY_YYYYMM_02'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'     											}
	    	, {name : 'PAY_MM_02'   	, text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'    	              												}
	    	, {name : 'IN_TAX_I_02'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'         									}
	    	, {name : 'SP_TAX_I_02'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                        												}
	    	, {name : 'LOCAL_TAX_I_02'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                         											}
	    	, {name : 'PAY_APPLY_YN_02' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'      	, store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	// 3차분납
	    	, {name : 'PAY_YYYYMM_03'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'             									}
	    	, {name : 'PAY_MM_03'   	, text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'    											}
	    	, {name : 'IN_TAX_I_03'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                                           											}
	    	, {name : 'SP_TAX_I_03'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                            											}
	    	, {name : 'LOCAL_TAX_I_03'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                           											}
	    	, {name : 'PAY_APPLY_YN_03' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'      	, store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	, {name : 'OPR_FLAG' 			, text : '신규여부'	   															, type : 'string'      	    												}
	    	
		         
	    ]
	});
	var yearEndStore = Unilite.createStore('yearEndStore',{
		model : 'yearEndModel',
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {
                read: 'hpa330ukrService.selectYearEndList'
            }
        },
        loadStoreRecords: function(personNumb) {
        	var param = panelResult.getValues();
        	param.PERSON_NUMB = personNumb;
			this.load({
				params : param
			});
		},
		listeners :{
			load : function(store, records) {
				if(records && records.length > 0 )	{
					var headers = yearEndGrid.headerCt.items.items;
					Ext.each(headers, function(header){
						if(header.itemId == 'yearEndHeader1')	{
							header.setText("1차분납("+records[0].get("PAY_MM_01")+"월)")
						}
						if(header.itemId == 'yearEndHeader2')	{
							header.setText("3차분납("+records[0].get("PAY_MM_02")+"월)")
						}
						if(header.itemId == 'yearEndHeader3')	{
							header.setText("3차분납("+records[0].get("PAY_MM_03")+"월)")
						}
					});
				} else {
					Unilite.messageBox('데이터가 없습니다');
					yearEndWindow.hide();
				}
			}
		}
	});
	var yearEndGrid = Unilite.createGrid('YearEndGrid', {
        store: yearEndStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		userToolbar :false,
    		expandLastColumn: false
    	},
        columns:  [     
        	  {dataIndex : 'PERSON_NUMB'     	, width : 100  	}
        	, {dataIndex : 'NAME'        		, width : 100 	}
        	, {
        		text:'<t:message code="system.label.human.yearEndTax" default="연말정산"/>',
        	   	columns :[
        		  {dataIndex : 'IN_TAX_I'    	, width : 80  	}
               	, {dataIndex : 'LOCAL_TAX_I'  	, width : 100   }
        	   ]
        	},{
        	   text:'<t:message code="system.label.human.firstInstallmentPayment" default="1차분납"/>',
        	   itemId : 'yearEndHeader1',
         	   columns :[
              	  {dataIndex : 'IN_TAX_I_01'   	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_01'	, width : 100  	}
         	   ]
         	},{
        	   text:'<t:message code="system.label.human.secondInstallmentPayment" default="2차분납"/>',
        	   itemId : 'yearEndHeader2',
         	   columns :[
         		  {dataIndex : 'IN_TAX_I_02'  	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_02'	, width : 100  	}
         	   ]
         	},{
        	   text:'<t:message code="system.label.human.thridInstallmentPayment" default="3차분납"/>',
        	   itemId : 'yearEndHeader3',
         	   columns :[
         		  {dataIndex : 'IN_TAX_I_03'  	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_03'	, width : 100	}
         	   ]
         	}
		]
    });  
	function openYearEndWindow(selRecord) {
		if (!yearEndWindow) {
			
			yearEndWindow = Ext.create('widget.uniDetailWindow', {
                title: '연말정산분납조회',
                width: 1000,
                height: 150,
                items: [yearEndGrid],
                tbar:  [
                	'->',
                	{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.human.close" default="닫기"/>',
					handler: function() {
						yearEndWindow.hide();
					},
					disabled: false
				}],
                listeners : {
          			 beforeshow: function ( me, eOpts )	{
          				yearEndStore.loadStoreRecords(yearEndWindow.selRecord.get('PERSON_NUMB'));
          			 },
          			 hide :function()	{
          				yearEndWindow.selRecord = null;
          			 }
                }
			});
		}
		yearEndWindow.selRecord = selRecord;
		yearEndWindow.center();
		yearEndWindow.show();

	}
};


</script>
