<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl100ukrv"  >

	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'templateService.selectDetail',
			update: 'templateService.updateDetail',
			create: 'templateService.insertDetail',
			destroy: 'templateService.deleteDetail',
			syncAll: 'templateService.saveAll'
		}
	});	

	Unilite.defineModel('Tpl100ukrvModel', {
	    fields: [
	    	/**	   		 
	   		 * type:
	   		 * 		uniQty		   -      수량
			 *		uniUnitPrice   -      단가
			 *		uniPrice	   -      금액(자사화폐)
			 *		uniPercent	   -      백분율(00.00)
			 *		uniFC          -      금액(외화화폐)
			 *		uniER          -      환율
			 *		uniDate        -      날짜(2999.12.31)
			 * maxLength: 입력가능한 최대 길이
			 * editable: true	수정가능 여부
	   		 * allowBlank: 필수 여부
	   		 * defaultValue: 기본값
	   		 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
			*/
	    	{name: 'SEQ'			, text: '순번'					, type: 'int', maxLength: 200, allowBlank: false},							//시퀀스 (editable: false)
	    	{name: 'COL1'			, text: '컬럼1'					, type: 'string', maxLength: 200},											//일반텍스트 Type
	    	{name: 'COL2'			, text: '컬럼2'					, type: 'string', maxLength: 200},											//팝업Type
	    	{name: 'COL3'			, text: '컬럼3'					, type: 'string', maxLength: 200, comboType: 'AU', comboCode: 'M103'},		//콤보박스Type
	    	{name: 'COL4'			, text: '컬럼4'					, type: 'uniDate', maxLength: 200},											//날짜Type
	    	{name: 'COL5'			, text: '컬럼5'					, type: 'uniPrice', maxLength: 200}											//금액Type
//	    	{name: 'tempDate'		,text: '변경일자' 				,type: 'uniDate'},
//	    	{name: 'temp4'			,text: '사업자번호' 			,type: 'string'},
//	    	{name: 'temp6'			,text: '상호' 				,type: 'string'},
//	    	{name: 'temp10'			,text: '대표자' 				,type: 'string'},
//	    	{name: 'temp7'			,text: '업태' 				,type: 'string'},
//	    	{name: 'temp9'			,text: '종목' 				,type: 'string'}
		]
	});
	
	var directDetailStore = Unilite.createStore('tpl100ukrvDetailStore',{
		model: 'Tpl100ukrvModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('tpl100ukrvMasterForm').getValues();
			
			this.load({
				params : param
			});
		},
		saveStore : function()	{						//저장시 호출
			var paramMaster= masterForm.getValues();
			
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						directDetailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				subDetailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
    var subDetailGrid = Unilite.createGrid('tpl100ukrvGrid', {
    	height: 230,
    	width: 800,
    	store: directDetailStore,
    	excelTitle: '거래선 관리',
        uniOpt: {
    		useLiveSearch		: true,//내용검색 버튼 사용 여부
    		onLoadSelectFirst	: true, //조회시 첫번째 레코드 select 사용여부
    		useGroupSummary		: false,//그룹핑 버튼 사용 여부
			useContextMenu		: true,//Context 메뉴 자동 생성 여부 
			useRowNumberer		: true,//번호 컬럼 사용 여부	
			expandLastColumn	: true//마지막컬럼 빈컬럼 사용여부
		},
    	
		columns:  [
			{dataIndex: 'SEQ'			, width: 60},
    		{dataIndex: 'COL1'			, width: 120},
    		{dataIndex: 'COL2'			, width: 120, 
			  	editor: UniTempPopup.popup('TEMPLATE_G', {	
			  		DBtextFieldName: 'TEMPLATE_CODE',	//CODE를 조회하는 팝업 일시에는 정의를 해줘야함..	
			   	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..				   	 	
	 				listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    Ext.each(records, function(record,i) {		//팝업창에서 선택된 레코드 처리											                   
				        			if(i==0) {
										masterGrid.uniOpt.currentRecord.set('COL2', record['TMP_CD']);	//masterGrid에 팝업에서 선택된 record를 SET
				        			} else {

				        			}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
//								masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = UserInfo.divCode;
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				 })
			},        		
    		{dataIndex: 'COL3'			, width: 120},
    		{dataIndex: 'COL4'			, width: 120},
    		{dataIndex: 'COL5'			, width: 120}
//			{dataIndex: 'tempDate'				, width: 100},
//			{dataIndex: 'temp4'					, width: 150},
//			{dataIndex: 'temp6'					, width: 180},
//			{dataIndex: 'temp10'				, width: 100},
//			{dataIndex: 'temp7'					, width: 120},
//			{dataIndex: 'temp9'					, width: 120}
        ],
		listeners:{
			beforeedit : function( editor, e, eOpts ) {	//그리드 레코드 edit 전
				return false;
			},
			selectionchangerecord : function(selected)	{	//로우 선택 변경시
          		masterForm.setActiveRecord(selected);
          	}
		}
    });   
	var masterForm = Unilite.createSearchForm('tpl100ukrvMasterForm',{		
    	region: 'center',		
    	autoScroll: true,  		
    	border:true,			
    	padding:'1 1 1 1',		
    	masterGrid:subDetailGrid,	//폼 필드와 그리드 컬럼 연동 관련	
    	layout : {type : 'uniTable', columns : 1}, //레이아웃   테이블 형식, 1열 종대
    	items:[{
    		xtype: 'container',	
    		margin: '0 0 0 10',	
    		layout : {type : 'uniTable', columns : 1/*,
	    		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}*/
			},			
			items: [{
				title:'거래선 정보',
	        	xtype: 'fieldset',
	        	padding: '0 10 10 10',
	        	margin: '0 0 0 0',
	        	defaults: {readOnly: true},
	 		    layout : {
	 		    	type: 'uniTable', 
	 		    	columns: 3,
	 		    	tableAttrs: {width: '100%'},
					tdAttrs: {align : 'left'}
	 		    },
	        	items: [{
	        		xtype:'uniTextfield',
	        		fieldLabel:'업체코드',
	        		name:'',
	        		colspan:3
	        	},{
	        		xtype: 'uniCombobox',
					fieldLabel: '업체구분',
					name:''
				},{
	        		xtype: 'component',  
	        		width: 200
	        	},{
					xtype: 'uniDatefield',
		    		fieldLabel: '등록일자',
		    		name: ''
				},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'등록번호',
	        		name:'SEQ',
	        		readOnly: false
	        	},{
	        		xtype: 'component',  
	        		width: 200
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'주민번호',
	        		name:''
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'상호',
	        		name:'COL1',
	        		readOnly: false
	        	},{
	        		xtype: 'component',  
	        		width: 200
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'업태',
	        		name:'temp7'
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'거래선명',
	        		name:'COL2',
	        		readOnly: false
	        	},{
	        		xtype: 'component',  
	        		width: 200
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'종목',
	        		name:'temp9'
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'대표자명',
	        		name:'COL3',
	        		readOnly: false
	        	},{
	        		xtype: 'component',  
	        		width: 200
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'전화번호',
	        		name:''
	        	},{
	        		xtype:'uniTextfield',
	        		fieldLabel:'우편번호',
	        		name:'COL4',
	        		readOnly: false
	        	},{
	        		xtype: 'component',  
	        		width: 200
	        	},{
		    		xtype: 'uniCheckboxgroup',		            		
		    		fieldLabel: '거래여부',
		    		items: [{
		    			boxLabel: '거래중지',
		    			width: 100,
		    			name: ''
		    		}]
		        },{
	        		xtype:'uniTextfield',
	        		fieldLabel:'주소',
	        		name:'COL5',
	        		width:750,
	        		colspan:3
	        	}]
			},{
				xtype: 'component',
				width: 10
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				tdAttrs: {align : 'left',width:'100%'},
				items :[{
					title:'대금 지급기준 및 계좌 정보',
		        	xtype: 'fieldset',
		        	padding: '0 10 10 10',
		        	margin: '0 0 0 0',
		        	defaults: {readOnly: true},
		 		    layout : {
		 		    	type: 'uniTable', 
		 		    	columns: 2,
		 		    	tableAttrs: {width: '100%'},
						tdAttrs: {align : 'left'}
		 		    },
		        	items: [{
		        		xtype: 'uniCombobox',
						fieldLabel: '지급방법',
						name:''
					},{
		        		xtype: 'component',  
		        		width: 200
		        	},{
		        		xtype: 'uniTextfield',
						fieldLabel: '결제예정',
						name:''
					},{
		        		xtype: 'component',  
		        		width: 200
		        	},
		        	UniTempPopup.popup('TEMPLATE', {
						fieldLabel: '어음발행', 
						valueFieldName: 'TEMPLATE_CODE',
			    		textFieldName: 'TEMPLATE_NAME',
			    		valueFieldWidth: 50,
						textFieldWidth: 100
					}),	
					{
						xtype: 'container',
						layout: {type : 'uniTable', columns : 4},
//						tdAttrs: {align : 'left',width:120},
						items :[{ 
							xtype: 'component',  
							html:'&nbsp;기일'
						},{ 
							xtype: 'uniTextfield', 
							name: '',
							width:80,
							readOnly:true
						},{ 
							xtype: 'component',  
							html:'&nbsp;지정일'
						},{ 
							xtype: 'uniTextfield', 
							name: '',
							width:80,
							readOnly:true
						}]
					},
					UniTempPopup.popup('TEMPLATE', {
						fieldLabel: '은행코드', 
						valueFieldName: 'TEMPLATE_CODE',
			    		textFieldName: 'TEMPLATE_NAME',
			    		valueFieldWidth: 50,
						textFieldWidth: 100
					}),	
					{
						xtype: 'component',
						width: 200
					},{
		        		xtype:'uniTextfield',
		        		fieldLabel:'계좌번호',
		        		name:''
		        	},{
		        		xtype: 'component',  
		        		width: 200
		        	},{
		        		xtype:'uniTextfield',
		        		fieldLabel:'예금주명',
		        		name:''
		        	},{
		        		xtype: 'component',  
		        		width: 200
		        	},{
		        		xtype:'uniTextfield',
		        		fieldLabel:'주민번호',
		        		name:''
		        	},{
		        		xtype: 'component',  
		        		width: 200
		        	}]
				},{
					xtype: 'component',
					width: 10
				},{
					title:'원천세 개인정보',
		        	xtype: 'fieldset',
		        	padding: '0 10 10 10',
		        	margin: '0 0 0 0',
		        	defaults: {readOnly: true},
		 		    layout : {
		 		    	type: 'uniTable', 
		 		    	columns: 1,
		 		    	tableAttrs: {width: '100%'},
						tdAttrs: {align : 'left'}
		 		    },
		        	items: [{
		        		xtype: 'uniCombobox',
						fieldLabel: '소득구분',
						name:''
					},{
		        		xtype: 'uniCombobox',
						fieldLabel: '직업구분',
						name:''
					},{
		        		xtype: 'uniCombobox',
						fieldLabel: '거주구분',
						name:''
					},
					UniTempPopup.popup('TEMPLATE', {
						fieldLabel: '계정코드', 
						valueFieldName: 'TEMPLATE_CODE',
			    		textFieldName: 'TEMPLATE_NAME',
			    		valueFieldWidth: 50,
						textFieldWidth: 100
					}),
					{
						xtype: 'container',
						layout: {type : 'uniTable', columns : 2},
//						tdAttrs: {align : 'left',width:120},
						items :[{
			        		xtype:'uniTextfield',
			        		fieldLabel:'소득세율',
			        		name:'',
			        		width:145,
			        		readOnly: true
				        },{
			        		xtype:'uniTextfield',
			        		fieldLabel:'공제율',
			        		name:'',
			        		labelWidth:45,
			        		width:100,
			        		readOnly: true
			        	}]
					},{
						xtype: 'radiogroup',
						fieldLabel:'국적구분',
						items: [{
							boxLabel: '내국인', 
							name: '',
							width:95,
							checked: true  
						},{
							boxLabel : '외국인', 
							name: '',
							width:80
						}]
					},
					
					UniTempPopup.popup('TEMPLATE', {
						fieldLabel: '거주국가', 
						valueFieldName: 'TEMPLATE_CODE',
			    		textFieldName: 'TEMPLATE_NAME',
			    		valueFieldWidth: 50,
						textFieldWidth: 100
					})]
				}]
			},{
				xtype: 'component',
				width: 10
			},{
				title:'History (거래처 History)',
	        	xtype: 'fieldset',
	        	padding: '0 0 0 0',
	        	margin: '0 0 0 0',
	 		    layout: {
	 		    	type: 'uniTable', 
	 		    	columns: 1, 
	 		    	tdAttrs: {valign:'top'}
	 		    },
	        	items: [
	        		subDetailGrid
	        	]
			}]			
    	}],
		api: {
			load: 'templateService.selectForm',
			submit: 'templateService.syncForm'				
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	});
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterForm
			]	
		}],
		id  : 'tpl100ukrvApp',
		fnInitBinding : function() {			//화면 초기화시			
			this.setDefault();
		},
		onQueryButtonDown : function()	{		//상위 버튼 중 조회 관련
			directDetailStore.loadStoreRecords();
			var param =  {COMP_CODE: UserInfo.compCode};
			Ext.getBody().mask('로딩중...', 'loading')
			masterForm.getForm().load({
					params: param,
					success:function(form, action)	{
						Ext.getBody().unmask();
					},
					failure: function(form, action) {
						Ext.getBody().unmask();
					}
				})
			
		},
		onResetButtonDown: function() {			//상위 버튼 중 리셋 관련
			
			subDetailGrid.reset();			
			masterForm.clearForm();
			directDetailStore.clearData();
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {		//상위 버튼 중 저장 관련
			var param = masterForm.getValues();
			Ext.getBody().mask('로딩중...', 'loading')
			masterForm.submit({
				params: param,
				success:function(comp, action)	{
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);
					Ext.getBody().unmask();
				},
				failure: function(form, action){
					Ext.getBody().unmask();
				}
			});
//			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {			//상위 버튼 중 삭제 관련
			var selRow = subDetailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				subDetailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					subDetailGrid.deleteSelectedRow();
			}
		},
		setDefault: function() {
			
		}
	});
	Unilite.createValidator('validator01', {		//그리드 벨리데이터 관련		
		store : directDetailStore,
		grid: subDetailGrid,
		forms: {'formA:':masterForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName){
			
			}
			return rv;
		}
	});
};


</script>
