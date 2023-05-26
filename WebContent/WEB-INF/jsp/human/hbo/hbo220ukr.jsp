<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbo220ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H007" /> <!-- 직종 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H029" /> <!-- 세액대상자구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' /> <!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /> <!-- 상여구분자 --> 
	<t:ExtComboStore comboType="AU" comboCode="H048" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B030" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var enableSaveBtn	= '';
	var gsRetrieved		= '';
	var sMgs			= '';
	var gCalFlag		= '';
	
	var gsList1 = '${gsList1}';					//지급구분 '1'이 아닌 것만 콤보에서 보이도록 설정
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hbo220ukrService.selectList1'//,
//			update	: 'hbo220ukrService.updateList',
//			create	: 'hbo220ukrService.insertList1',
//			destroy	: 'hbo220ukrService.deleteList1',
//			syncAll	: 'hbo220ukrService.saveAll'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hbo220ukrService.selectList2',
			update	: 'hbo220ukrService.updateList',
			create	: 'hbo220ukrService.insertList',
			destroy	: 'hbo220ukrService.deleteList',
			syncAll	: 'hbo220ukrService.saveAll'
		}
	});
	
	/* Model 정의  (데이터 저장용 Store)
	 * @type 
	 */
	Unilite.defineModel('Hbo220ukrModel', {
		fields: [
			{name: 'PAY_YYYYMM'			, text: '지급년월'				, type: 'string'},
			{name: 'SUPP_TYPE'			, text: '상여구분'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'WAGES_CODE'			, text: '지급내역코드'			, type: 'string'},
			{name: 'WAGES_NAME'			, text: '지급내역명'				, type: 'string'},
			{name: 'AMOUNT_I'			, text: '공제금액'				, type: 'uniPrice'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'}
		]
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hbo220ukrModel2', {
		fields: [
			{name: 'PAY_YYYYMM'			, text: '지급년월'				, type: 'string'},
			{name: 'SUPP_TYPE'			, text: '상여구분'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'DED_CODE'			, text: '공제코드'				, type: 'string'},
			{name: 'WAGES_NAME'			, text: '공제내역'				, type: 'string'},
			{name: 'DED_AMOUNT_I'		, text: '공제금액'				, type: 'uniPrice'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의 - 데이터 저장용)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hbo220ukrMasterStore1', {
		model: 'Hbo220ukrModel',
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function(person_numb, name) {
        	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelSearch.getForm().setValues({'NAME' : name});
			}
        	var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		}
	});//End of var masterStore = Unilite.createStore('hbo220ukrMasterStore1', {
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore2 = Unilite.createStore('hbo220ukrMasterStore2', {
		model: 'Hbo220ukrModel2',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords: function(person_numb, name) {
        	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelSearch.getForm().setValues({'NAME' : name});
			}
        	var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		
        saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
      	 	var toDelete = this.getRemovedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
        	
        	//주 데이터 저장용 파라미터
			var paramMaster			= panelResult.getValues();
			
			var payDate				= Ext.getCmp('PAY_YYYYMM').getValue();
			var mon					= payDate.getMonth() + 1;
			var dateString			= payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
			var searchParam			= Ext.getCmp('searchForm').getValues();			
			paramMaster.SUPP_TYPE	= searchParam.SUPP_TYPE;
			paramMaster.PERSON_NUMB	= searchParam.PERSON_NUMB;
			paramMaster.GSRETRIEVED	= gsRetrieved;

        	if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {		
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						if (gsRetrieved == 'D') {
							UniAppManager.app.onResetButtonDown();			        	
							
						} else {
							masterGrid.reset();
							UniAppManager.app.onQueryButtonDown();
						}
					} 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				// 소득세(INC),주민세(LOC), 고용보험(HIR)
				var incTax, locTax, hirTax = 0;
				if(records != null && records.length > 0 ){
					Ext.each(records, function(record,i) {
						//debugger;
					
						switch(record.data.DED_CODE)	{
						// 소득세
						case 'INC' :
							incTax = record.data.DED_AMOUNT_I
							break;
						// 주민서
						case 'LOC' :
							locTax = record.data.DED_AMOUNT_I
							break;
						// 고용보험
						case 'HIR' :
							hirTax = record.data.DED_AMOUNT_I
							break;
						}
					});
					
					// 소득세(INC)+주민세(LOC) > 0 경우 세액계산 한다로 표시
					if((incTax + locTax) > 0) {
						panelResult.getField('rdoTaxYn').setValue('Y');
					} else {
						panelResult.getField('rdoTaxYn').setValue('N');
					}
					
					// 고용보험(HIR) > 0 경우 고용보험계산 한다로 표시
					if(hirTax > 0){
						panelResult.getField('rdoHireYn').setValue('Y');
					} else {
						panelResult.getField('rdoHireYn').setValue('N');
					}
				}
			}
		}
	});//End of var masterStore = Unilite.createStore('hbo220ukrMasterStore1', {

	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm', {
        defaultType: 'uniTextfield',
		region:'north',
		padding:'1 1 1 1',
		border:true,
        layout: {type: 'uniTable', columns: 4,
        tableAttrs: {width: '100%'/*, align : 'left'*/}
//		tdAttrs: {style: 'border : 1px solid #ced9e7;',width:300/*, align : 'center'*/}
        },
        itemId: 'search_panel1',
        items: [{
				fieldLabel	: '지급년월',
				id			: 'PAY_YYYYMM',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',                    
				value		: new Date(),                    
		        tdAttrs		: {width: 300},  
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel	: '상여구분',
				name		: 'SUPP_TYPE',
				id			: 'SUPP_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H032',
				value		: '2',
		        tdAttrs		: {width: 300},  
				allowBlank	: false				
			},
				Unilite.popup('Employee', {
					fieldLabel		: '사원', 
					id				: 'PERSON_NUMB',
				    valueFieldName	: 'PERSON_NUMB',
				    textFieldName	: 'NAME',
					validateBlank	: false,
					allowBlank		: false,
					tdAttrs			: {width: 300}
			}),{
				xtype		: 'button',					
				text		: '상여재작업',
				width		: 120,
				margin 		: '0 0 2 0',
		        tdAttrs		: {align: 'right'},  
				handler		: function(btn) {     
					var formParam= Ext.getCmp('searchForm').getValues();
					var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
					var mon = payDate.getMonth() + 1;
					var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
					
					var params = {
						PGM_ID		: 'hbo220ukr',
						PAY_YYYYMM	: dateString,
						SUPP_TYPE	: Ext.getCmp('SUPP_TYPE').getValue()
					};
					var rec = {data : {prgID : 'hbo300ukr', 'text':'상여기초자료일괄등록'}};							
					parent.openTab(rec, '/human/hbo300ukr.do', params);
			}
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		defaultType	: 'uniTextfield',
    	region		: 'east',
    	border		: false,
		layout		: {type: 'uniTable', align: 'stretch', columns: 2},
		tableAttrs	: {width: '100%'/*, align : 'left'*/},
		tdAttrs		: {style: 'border : 1px solid #ced9e7;' ,width:250/*, align : 'center'*/},
	    api			: {
        	load	: 'hbo220ukrService.selectList3',
        	submit	: 'hbo220ukrService.form01Submit'
        },
	    padding		: '1 1 1 1',
	    flex		: 0.6,
        autoScroll	: true,  
	    items		: [{
			xtype		: 'panel',
			border		: 0
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '세액계산',
			id			: 'rdoSelect1',
		 	labelWidth	: 140,
			items		: [{
				boxLabel: '한다', 
				width	: 70, 
				name	: 'rdoTaxYn',
				inputValue: 'Y',
				readOnly: true
			},{
				boxLabel: '안한다', 
				width	: 70,
				name	: 'rdoTaxYn',
				inputValue: 'N',
				readOnly: true
			}]
		},{
			xtype		: 'panel',
			border		: 0
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '고용보험계산',
			id			: 'rdoSelect2',
		 	labelWidth	: 140,
			items		: [{
				boxLabel: '한다', 
				width	: 70, 
				name	: 'rdoHireYn',
				inputValue: 'Y',
				readOnly: true
			},{
				boxLabel: '안한다', 
				width	: 70,
				name	: 'rdoHireYn',
				inputValue: 'N' ,
				readOnly: true
			}]
		},Unilite.popup('DEPT',{
                    fieldLabel: '부서',
                    valueFieldName:'DEPT_CODE',
                    textFieldName:'DEPT_NAME',
                    selectChildren  :true,
                    allowBlank      :false,
                    validateBlank   :true,
                    autoPopup       :true,
                    useLike         :true,
                    labelWidth      :140,
                    readOnly        :true
        })
//		Unilite.treePopup('DEPTTREE',{
//			fieldLabel		: '부서',
//			valueFieldName	:'DEPT_CODE',
//			textFieldName	:'DEPT_NAME' ,
//			valuesName		:'DEPTS' ,
//			DBvalueFieldName:'TREE_CODE',
//			DBtextFieldName	:'TREE_NAME',
//			selectChildren	:true,
//			allowBlank		: false,
//			validateBlank	:true,
//			autoPopup		:true,
//			useLike			:true,
//		 	labelWidth		: 140,
//			readOnly		: true
//		})
		,{
			fieldLabel	: '지급차수',
			name		: 'PAY_PROV_FLAG', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031',  
			allowBlank	: false,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '직위',
			name		: 'POST_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H005',
			allowBlank	: false,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '급여지급방식',
			name		: 'PAY_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H028',
			allowBlank	: false,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '직책',
			name		: 'ABIL_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H006',
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '세액구분',
			name		: 'TAX_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H029',
			allowBlank	: false,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '사원구분',
			name		: 'EMPLOY_TYPE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H024',
			allowBlank	: false,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '지급일',
			id			: 'SUPP_DATE',
			name		: 'SUPP_DATE',
			xtype		: 'uniDatefield',                    
		 	labelWidth	: 140,
			readOnly	: true
		},{
			fieldLabel	: '상여구분자',
			name		: 'BONUS_KIND', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H037',
		 	labelWidth	: 140,
			readOnly	: true
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '배우자',
			id			: 'rdoSelect3',
		 	labelWidth	: 140,
			items: [{
				boxLabel	: '유', 
				width		: 70, 
				name		: 'SPOUSE',
				inputValue	: 'Y',
				readOnly	: true
			},{
				boxLabel	: '무', 
				width		: 70,
				name		: 'SPOUSE',
				inputValue	: 'N',
				readOnly	: true
			}]
		},{
			fieldLabel	: '입퇴사구분',
			name		: 'EXCEPT_TYPE', 
			id			: 'EXCEPT_TYPE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H048',
			allowBlank	: false,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			layout		: {type:'hbox'},
			xtype		: 'container',
			items		: [{
				fieldLabel	: '부양자.20세이하자녀 ',
			 	xtype		: 'uniNumberfield',
			 	name		: 'SUPP_AGED_NUM',
			 	flex		: 3,
			 	labelWidth	: 140,
				readOnly	: true,
			 	value		: 0
			},{
			 	xtype		: 'uniNumberfield',
			 	name		: 'CHILD_20_NUM',
			 	flex		: 1,
			 	value       : 0,
			 	suffixTpl	: '명',
				readOnly	: true
			}]
		},{
			fieldLabel	: '입사일',
			id			: 'JOIN_DATE',
			xtype		: 'uniDatefield',
			name		: 'JOIN_DATE',                    
		 	labelWidth	: 140,                    
			readOnly	: true
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '퇴직평균임금',
			id			: 'rdoSelect4',
		 	labelWidth	: 140,
			items		: [{
				boxLabel: '포함한다', 
				width	: 70, 
				name	: 'RETR_FLAG',
				inputValue: 'Y',
				readOnly: true
			},{
				boxLabel: '포함안한다', 
				width	: 80,
				name	: 'RETR_FLAG',
				inputValue: 'N',
				readOnly: true
			}]
		},{
			fieldLabel	: '퇴사일',
			id			: 'RETR_DATE',
			xtype		: 'uniDatefield',
			name		: 'RETR_DATE',                    
		 	labelWidth	: 140,                      
			readOnly	: true
		},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '월정급여액',				            		
			id			: 'rdoSelect5',
		 	labelWidth	: 140,
			items		: [{
				boxLabel: '포함한다', 
				width	: 70, 
				name	: 'COM_PAY_FLAG',
				inputValue: 'Y',
				readOnly: true
			},{
				boxLabel: '포함안한다', 
				width	: 80,
				name	: 'COM_PAY_FLAG',
				inputValue: 'N',
				readOnly: true
			}]
		}
		
		,{
			xtype	: 'component',
			colspan	: 2,
			height	: 20
		},{
			xtype	: 'container',
			tdAttrs	: {align: 'center'},
			layout	:{type : 'uniTable', columns : 1, tableAttrs: {width: '95%', align: 'right'}},
			margin: '0 5 0 0',
			colspan	: 2, 
			items	:[{
				xtype: 'component',
				tdAttrs: {style: 'border-bottom: 1.7px solid #cccccc;'}
			}]
		},{
			xtype	: 'component',
			colspan	: 2,
			height	: 20
		},{
			fieldLabel	: '근속개월수',
			name		: 'LONG_MONTH', 
			regex		: /^[0-9]*$/, 
			fieldStyle	: 'text-align:right',
		 	labelWidth	: 140,
		 	value       : 0,
			readOnly	: true  
		},{
			fieldLabel	: '상여총액',
			id			: 'BONUS_TOTAL_I', 
			name		: 'BONUS_TOTAL_I', 
			xtype		: 'uniNumberfield',
		 	labelWidth	: 140,
		 	value       : 0,
			readOnly	: true
		},{
			fieldLabel	: '상여기준금',
			xtype		: 'uniNumberfield',
			id			: 'BONUS_STD_I',
			name		: 'BONUS_STD_I',
		 	labelWidth	: 140,
		 	value       : 0,
			readOnly	: true,
			listeners	: {
    			blur: function(field) {
					Ext.getCmp('SUPP_RATE').setValue(calcSuppRate());
					Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotalI());
    			}
			}
		},{
			fieldLabel	: '공제총액',
			name		: 'DED_TOTAL_I',
			xtype		: 'uniNumberfield',
		 	labelWidth	: 140,
		 	value       : 0,
			readOnly	: true
		},{
			fieldLabel	: '상여율',
			id			: 'BONUS_RATE',
			name		: 'BONUS_RATE',
			fieldStyle	: 'text-align:right',
		 	labelWidth	: 140,
		 	value       : 0,
		 	suffixTpl   : '%',
			readOnly	: true, 
			listeners	: {
    			blur: function(field) {
					Ext.getCmp('SUPP_RATE').setValue(calcSuppRate());
					Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotalI());
    			}
			}
		},{
			fieldLabel	: '실지급액',
			name		: 'REAL_AMOUNT_I', 
			xtype		: 'uniNumberfield',
		 	labelWidth	: 140,
		 	value       : 0,
			readOnly	: true
		},{
			fieldLabel	: '사회보험사업자부담금',
			name		: 'BUSI_SHARE_I',
			xtype		: 'uniNumberfield',
			value       : 0,
		 	labelWidth	: 140,
			readOnly	: true
		},{
			xtype		: 'hiddenfield',
			id			: 'DIV_CODE',
			fieldLabel	: '사업장',
			name		: 'DIV_CODE'
		},{
			xtype		: 'hiddenfield',
			id			: 'SECT_CODE',
			fieldLabel	: '신고사업장',
			name		: 'SECT_CODE'
		},{
			xtype		: 'hiddenfield',
			id			: 'MAKE_SALE',
			fieldLabel	: '제조판관',
			name		: 'MAKE_SALE'
		},{
			xtype		: 'hiddenfield',
			id			: 'COST_KIND',
			fieldLabel	: '직간접',
			name		: 'COST_KIND'
		},{
			xtype		: 'hiddenfield',
			id			: 'PLUS_RATE',
			fieldLabel	: '가산율',
			value       : 0,
			name		: 'PLUS_RATE'
		},{
			xtype		: 'hiddenfield',
			id			: 'MINUS_RATE',
			fieldLabel	: '차감율',
			value       : 0,
			name		: 'MINUS_RATE'
		},{
			xtype		: 'hiddenfield',
			id			: 'SUPP_RATE',
			fieldLabel	: '지급율',
			value       : 0,
			name		: 'SUPP_RATE'
		},{
			fieldLabel	: '지급년월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',
			value		: new Date(),
			hidden		: true                  

		}
		
		,{
			xtype	: 'component',
			colspan	: 2,
			height	: 20
		}
				
		,{
			fieldLabel: '청년세액감면율',
			name: 'YOUTH_EXEMP_RATE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H179',
			readOnly: true,
			labelWidth: 140
		}
        ,{fieldLabel: '청년세액감면기간', name: 'YOUTH_EXEMP_DATE', readOnly: true, labelWidth: 140, hidden: false, readOnly: true, xtype: 'uniDatefield'}
        
		],
		listeners:{ 
           uniOnChange:function( form, field, newValue, oldValue ) { 
            if(form.isDirty())  { 
             UniAppManager.setToolbarButtons('save', true); 
            }else { 
             UniAppManager.setToolbarButtons('save', false); 
            } 
           } 
          }
    });
	
    /* Master Grid1 정의(masterStore2와 연계)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hbo220ukrGrid1', {
    	// for tab    	
		store: masterStore2,
		flex: 0.4,
    	height: '100%',
		uniOpt: {
			useMultipleSorting	: false,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: false,		
			useRowContext		: false,			
            userToolbar			: false,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}
		},
		features: [ {
    		id : 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		dock : 'bottom',
    		showSummaryRow: true ,
    		//컬럼헤더에서 그룹핑 사용 안 함
            enableGroupingMenu:false
    	},{
    		id : 'masterGridTotal',
    		itemID:	'test',
    		ftype: 'uniSummary',
			dock : 'bottom',
    		showSummaryRow: true,
            enableGroupingMenu:false
    	}],
		columns: [
			{dataIndex: 'PAY_YYYYMM',		width: 0,		hidden: true},
			{dataIndex: 'SUPP_TYPE',		width: 0,		hidden: true},
			{dataIndex: 'PERSON_NUMB', 		width: 0,		hidden: true},
			{dataIndex: 'DED_CODE',			width: 0,		hidden: true},
			{dataIndex: 'WAGES_NAME',		width: 146,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			}, 
			{dataIndex: 'DED_AMOUNT_I',		flex: 1,		summaryType:'sum'}, 
			{dataIndex: 'COMP_CODE',		width: 0,		hidden: true},
			{dataIndex: 'UPDATE_DB_USER',	width: 100,		hidden: true},
			{dataIndex: 'UPDATE_DB_TIME',	width: 100,		hidden: true}
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(UniUtils.indexOf(e.field, ['DED_AMOUNT_I'])){ 
					return true;
  				} else {
  					return false;
  				}
			}
		}
	});//End of var masterGrid = Unilite.createGr100id('hbo220ukrGrid1', {   
		
                                                 
	Unilite.Main( {
		 borderItems:[ 
	 		 {	
				layout:{type: 'hbox'},
				xtype: 'panel',
				region: 'center',
		    	items:[
			    	masterGrid,
			        panelResult
			    ]
			}, panelSearch
		],
		id: 'hbo220ukrApp',
		
		fnInitBinding: function(params) {
			panelSearch.setValue('PAY_YYYYMM',	UniDate.get('today'));
			panelResult.getField('rdoTaxYn').setValue('N');
			panelResult.getField('rdoHireYn').setValue('N');
			panelResult.getField('SPOUSE').setValue('N');
			panelResult.getField('RETR_FLAG').setValue('N');
			panelResult.getField('COM_PAY_FLAG').setValue('N');
				
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('save', false);
			
			var store = Ext.getStore('CBS_AU_H032');						
		    var selectedModel = store.getRange();
		    Ext.each(selectedModel, function(record,i){       
			   if (record.data.value == '1' || record.data.value == 'F'||record.data.value == 'G'||record.data.value == 'L'||record.data.value == 'M') {							    	
			    	store.remove(record);							    	  							    	  
		       }			       
			});
			var combo = Ext.getCmp('SUPP_TYPE');
			console.log("combo",combo);
			combo.bindStore('CBS_AU_H032');
			panelSearch.setValue('SUPP_TYPE',	2);


			if(params && params.PGM_ID) {
				this.processParams(params);
			}
			//초기화 시 지급년월로 포커스 이동
			panelSearch.onLoadSelectText('PAY_YYYYMM');

		},

		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			//masterGrid.reset();
			//masterStore.clearData();
			//masterStore2.clearData();
			masterStore.loadData({});
			masterStore2.loadData({});
			
			Ext.getCmp('PERSON_NUMB').setReadOnly(false);
			Ext.getCmp('PAY_YYYYMM').setReadOnly(false);
			Ext.getCmp('SUPP_TYPE').setReadOnly(false);
//			panelSearch.getForm().setValues({'PERSON_NUMB' : ''});
//			panelSearch.getForm().setValues({'NAME' : ''});
//			// data 초기화
//			masterStore.loadData([],false);
//			panelResult.getForm().getFields().each(function (field) {
//				 field.setValue('');
//				 field.setReadOnly(false);
//		     });

		     UniAppManager.app.fnInitBinding();			        	

		},
		
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			gCalFlag = 'true'
			loadRecord('');
		},
		
		onDeleteAllButtonDown : function()	{
			if(confirm('전체삭제 하시겠습니까?')) {
				var deletable = true;

//				panelSearch.getForm().setValues({'PERSON_NUMB' : ''});
//				panelSearch.getForm().setValues({'NAME' : ''});
//				panelResult.clearForm();
//				masterGrid.reset();
				if(deletable){		
					gsRetrieved = 'D'
					masterGrid.reset();	
					masterStore2.saveStore();
				}
			}
		},
		
		onSaveDataButtonDown: function(config) {
			if (!panelResult.getInvalidMessage()){
				return false;
			}
			if (gCalFlag ==	'false') {
				alert('상여계산을 먼저 해 주십시오');
				return false;
			} else {
				if (masterStore2.isDirty) {
	//				masterStore.saveStore();
					masterStore2.saveStore();
				}
				/*if (panelResult.isDirty) {								
					//form02 submit
					var param			= panelResult.getValues();
					
					var payDate			= Ext.getCmp('PAY_YYYYMM').getValue();
					var mon				= payDate.getMonth() + 1;
					var dateString		= payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
					var searchParam		= Ext.getCmp('searchForm').getValues();			
					param.PAY_YYYYMM	= dateString;
					param.SUPP_TYPE		= searchParam.SUPP_TYPE;
					param.PERSON_NUMB	= searchParam.PERSON_NUMB;
					param.GSRETRIEVED	= gsRetrieved;
					
					panelResult.getForm().submit({
						params : param,
						success : function(actionform, action) {
							panelResult.getForm().wasDirty = false;
	//						panelResult2.resetDirtyStatus();		alert('form02 done');									
	//						UniAppManager.setToolbarButtons('save', false);	
	//						UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
						}	
					});
				}*/
			}
		},
		
		onPrevDataButtonDown: function() {
			console.log('Go Prev > ' + data[0].PV_D + ', NAME > ' + data[0].PV_NAME);
			loadRecord(data[0].PV_D, data[0].PV_NAME);				
		},
		
		onNextDataButtonDown: function() {
			console.log('Go Next > ' + data[0].NX_D + ', NAME > ' + data[0].NX_NAME);
			loadRecord(data[0].NX_D, data[0].NX_NAME);
		},
		
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hpa950skr') {
				panelSearch.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelSearch.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelSearch.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelSearch.setValue('NAME'			,params.NAME);
				
				loadRecord('');			
			}
        }
	});//End of Unilite.Main( {
		
	// 그리드 및 폼의 데이터를 불러옴
	 function loadRecord(person_numb, name) {
	 	Ext.getCmp('PERSON_NUMB').setReadOnly(true);
	 	Ext.getCmp('SUPP_TYPE').setReadOnly(true);
		Ext.getCmp('PAY_YYYYMM').setReadOnly(true);
		UniAppManager.setToolbarButtons('reset',true);
		
		// grid 데이터 조회
		masterStore.loadStoreRecords(person_numb, name);
		masterStore2.loadStoreRecords(person_numb, name);
		
		// form 데이터 조회
		var param = Ext.getCmp('searchForm').getValues();
		panelResult.getForm().load({
			params : param, 	
			success: function(form, action){
				var suppDate = Ext.getCmp('SUPP_DATE').getValue();
				var exceptType = Ext.getCmp('EXCEPT_TYPE').getValue();
//				Ext.getCmp('rdoSelect3').setValue({SPOUSE : action.result.data.SPOUSE});
				// 20210825 세액계산, 고용보험 계산 값에따라 default 세팅 다르도록 수정
				//panelResult.getField('rdoTaxYn').setValue('N');
				//panelResult.getField('rdoHireYn').setValue('N');
				panelResult.getField('SPOUSE').setValue({SPOUSE : action.result.data.SPOUSE});
				panelResult.getField('RETR_FLAG').setValue({RETR_FLAG : action.result.data.RETR_FLAG});
				panelResult.getField('COM_PAY_FLAG').setValue({COM_PAY_FLAG : action.result.data.COM_PAY_FLAG});
				 
			 	if (typeof action.result.data.MON_YEAR_USE !== 'undefined') {
					form.getFields().each(function (field) {
				 		/* if (field.name == 'rdoTaxYn' || field.name == 'rdoHireYn') {
				 			field.setReadOnly(false);
				 		} else { */
				 			field.setReadOnly(true);
				 		//}
				    });
		 		} else {
		 			form.getFields().each(function (field) { 
		 				if (field.name == 'DED_TOTAL_I' || field.name == 'REAL_AMOUNT_I' || 
		 						field.name == 'BUSI_SHARE_I' || field.name == 'BONUS_TOTAL_I' || field.name == 'YOUTH_EXEMP_RATE' || field.name == 'YOUTH_EXEMP_DATE') {
				 			field.setReadOnly(true);
				 		} else {
				 			field.setReadOnly(false);
				 		}		 				
				    });	
				 	//급여지급일이 없을 경우 세팅
				 	
				 	if (Ext.isEmpty('suppDate') || suppDate == null ) {
				 		suppDate = UniDate.getDbDateStr(Ext.getCmp('PAY_YYYYMM').getValue()).substring(0, 6) + '01'
 					 	Ext.getCmp('SUPP_DATE').setValue(suppDate);
				 	}
				 	//입퇴사 구분이 값을 없을 경우 세팅
				 	
				 	if (Ext.isEmpty('exceptType') || exceptType == null ) {
 					 	Ext.getCmp('EXCEPT_TYPE').setValue(0);
				 	}
		 		}
		 		//HPA300T에 데이터가 없을 때 프로세스(save 버튼 비활성화, 상여기준금 ''로 세팅)
				enableSaveBtn = action.result.data.ENABLE_DELETE_YN
				if (!enableSaveBtn) {
					Ext.getCmp('BONUS_STD_I').setValue('');
					gCalFlag	=	'true';
					
					UniAppManager.setToolbarButtons('deleteAll', enableSaveBtn);
					
				} else {
			 		if (Ext.isEmpty(suppDate) || suppDate == null || suppDate == '00000000') {
			 			gCalFlag	=	'false';
			 		} else {
			 			gCalFlag	=	'true';
			 		}

					UniAppManager.setToolbarButtons('deleteAll', enableSaveBtn);
				}
				
				//조회한 데이터 값 보여주는 함수 호출
				var arsSheet = action.result.data
				fnDisplayBody(arsSheet, '')
				UniAppManager.setToolbarButtons('save',false);
				calcBonusTotalI();
				checkAvailableNavi();
			 },
			 
			 failure: function(form, action) {
				// form reset
				 form.getFields().each(function (field) {
					 field.setValue('');
			     });
			}
		});
		calcBonusTotalI();
		checkAvailableNavi();
	}
	
	//조회한 데이터 값 보여주는 함수
	function fnDisplayBody(arsSheet, sMsg){
		if ((sMgs == 'PV' || sMgs == 'NX') && enableSaveBtn) {
			alert(Msg.sMB015);
		} 
		if (!enableSaveBtn) {
			gsRetrieved = 'N'
			
		} else {
			gsRetrieved = 'U'
		}
		//이전, 이후 버튼 이벤트
		if (sMsg != '') {
			
		}
	}

	// 선택된 사원의 전후로 데이터가 있는지 검색함
	function checkAvailableNavi(){
		var param = Ext.getCmp('searchForm').getValues();
		console.log(param);
		Ext.Ajax.request({
			url: CPATH+'/human/checkAvailableNaviHpo220.do',
			params: param,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log(data);
				var prevBtnAvailable = (data[0].PV_D == 'BOF' ? false : true)
				var nextBtnAvailable = (data[0].NX_D == 'EOF' ? false : true)
				UniAppManager.setToolbarButtons('prev', prevBtnAvailable);
				UniAppManager.setToolbarButtons('next', nextBtnAvailable);
			},
			failure: function(response){
				console.log(response);
			}
		});
	}
	
	// 지급율을 계산함
	function calcSuppRate() {
		var suppRate = 0;
		if (Ext.getCmp('BONUS_RATE').getValue() != '' && Ext.getCmp('BONUS_RATE').getValue() != null) {
			suppRate = suppRate + Ext.getCmp('BONUS_RATE').getValue();
		}
		if (Ext.getCmp('PLUS_RATE').getValue() != '' && Ext.getCmp('PLUS_RATE').getValue() != null) {
			suppRate = suppRate + Ext.getCmp('PLUS_RATE').getValue();
		}
		if (Ext.getCmp('MINUS_RATE').getValue() != '' && Ext.getCmp('MINUS_RATE').getValue() != null) {
			suppRate = suppRate - Ext.getCmp('MINUS_RATE').getValue();
		}
		return suppRate;
	}
	
	// 상여총액 계산
	function calcBonusTotalI() {
		var bonusTotalI = 0;
		if (Ext.getCmp('BONUS_STD_I').getValue() != '' && Ext.getCmp('BONUS_STD_I').getValue() != null) {
			bonusTotalI = bonusTotalI + Ext.getCmp('BONUS_STD_I').getValue();
		}
		if (Ext.getCmp('SUPP_RATE').getValue() != '' && Ext.getCmp('SUPP_RATE').getValue() != null) {
			bonusTotalI = bonusTotalI * Ext.getCmp('SUPP_RATE').getValue() / 100;
		}
		return bonusTotalI;
	}
	
Unilite.createValidator('validator01', {
        store: masterStore2,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "DED_AMOUNT_I" :
                    var ded_total = masterStore2.sum('DED_AMOUNT_I');
                    if(!Ext.isEmpty(newValue) && oldValue == 0){
                        panelResult.setValue('DED_TOTAL_I', ded_total + newValue + oldValue );
                    }else if(newValue != oldValue){
                    	panelResult.setValue('DED_TOTAL_I', ded_total + newValue - oldValue );
                    }else{
                    	panelResult.setValue('DED_TOTAL_I', ded_total - oldValue);
                    }
                    panelResult.setValue('REAL_AMOUNT_I', panelResult.getValue('BONUS_TOTAL_I') - panelResult.getValue('DED_TOTAL_I') );
                    
                break;
                    
            }
            return rv;
        }
    });

};
</script>
