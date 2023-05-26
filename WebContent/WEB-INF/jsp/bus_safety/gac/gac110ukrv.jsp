<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('gac110ukrvModel', {
	    fields: [
	    			{name: 'COMP_CODE',			text: '법인코드',	type: 'string'},
					{name: 'DIV_CODE',			text: '사업장',		type: 'string'	,comboType:'BOR120'},
					{name: 'GUBUN',				text: '구분',		type: 'string'	,comboType:'AU', comboCode:'GA14'},
					
					{name: 'DAMAGE_TYPE',		text: '형태',		type: 'string'	,comboType:'AU', comboCode:'GA15'},
					{name: 'VICTIM_NAME',		text: '이름',		type: 'string'},
					{name: 'REGIST_NO',			text: '주민번호',	type: 'string'	,convert:convertRefNo},
					{name: 'VICTIM_AGE',		text: '나이',		type: 'uniQty'}, 
					{name: 'SEX',				text: '성별',		type: 'string',comboType:'AU', comboCode:'GA25'},	
					{name: 'PHONE',				text: '연락처',		type: 'string'},
					{name: 'HOSPITAL',			text: '병원명',		type: 'string'},
					{name: 'HOSPITAL_PHONE',	text: '연락처',		type: 'string'},
					{name: 'DEGREE_INJURY',		text: '상해정도',	type: 'string'	,comboType:'AU', comboCode:'GA16'},			
					{name: 'TREATMENT_PERIOD',	text: '진단주',		type: 'uniQty'},		
					{name: 'PATIENT_CONDITION',	text: '환자상태',	type: 'string'},		
					
					{name: 'CLAIM_DATE',		text: '접보일',		type: 'string'},
					{name: 'CLAIM_NUM',			text: '사고번호(접보)',	type: 'string'},
					{name: 'TOTAL_EXPECT_AMOUNT',	text: '총추산액',	type: 'uniPrice'},
					{name: 'RESPONS_EXP_AMT',	text: '책임추산',	type: 'uniPrice'},
					{name: 'EXPECT_AMOUNT',		text: '임의추산',	type: 'uniPrice'},
					{name: 'TOTAL_AMOUNT',		text: '총지급액',	type: 'uniPrice'},
					{name: 'RESPONS_DEDUCTION',	text: '책임공제',	type: 'uniPrice'},
					{name: 'EXPECT_DEDUCTION',	text: '임의공제',	type: 'uniPrice'},
					{name: 'FAULTS_RATE',		text: '과실율',		type: 'uniPercent'},
					{name: 'SETTLEMENT_MONEY',	text: '합의금',		type: 'uniPrice'},
					{name: 'MEDICAL_EXPENSE',	text: '치료비',		type: 'uniPrice'},

					{name: 'ACCIDENT_NUM',		text: '사고번호',	type: 'string'},		
					{name: 'ACCIDENT_SEQ',		text: '순번',	type: 'int'},	
					{name: 'JOB',				text: '직업',		type: 'string'},		
					{name: 'ADDRESS',			text: '주소',		type: 'string'},	
					{name: 'END_YN',			text: '처리상태',	type: 'string'},		
					{name: 'END_DATE',			text: '처리일',		type: 'uniDate'}		
			]
	});	
	
	function convertRefNo(value, record)	{
		if(value != null && value.length ==13)	{
			return value.substring(0,6)+'-'+value.substring(6,13);
		}
		return value
	}
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read   : 'gac110ukrvService.selectList',
            update : 'gac110ukrvService.update',
            create : 'gac110ukrvService.insert',
            destroy: 'gac110ukrvService.delete',
			syncAll: 'gac110ukrvService.saveAll'
		}
	});
	var peopleDamageStore = Unilite.createStore('gac110ukrvMasterStore',{
			model: 'gac110ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy:directProxy  
			
			,loadStoreRecords : function(param)	{
				param['DIV_CODE']= panelSearch.getValue('DIV_CODE');			
				console.log( param );
				var me = this;
				this.load({
					params : param
				});
			},
			saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					var grid = Ext.getCmp('gac110ukrGrid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
			
            
		});	
		
	var peopleDamageGrid = Unilite.createGrid('gac110ukrGrid', {
		itemId:'gac110ukrGrid',
		height:250,
        store : peopleDamageStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: false,
                    onLoadSelectFirst: false
        },
        columns:  [     
        			{ dataIndex: 'ACCIDENT_SEQ'		,width: 40 }, 
               		{ dataIndex: 'DAMAGE_TYPE'		,width: 100 }, 
					{ dataIndex: 'VICTIM_NAME' 		,width: 100 }, 
					{ dataIndex: 'REGIST_NO'		,width: 110 },
					
					{ dataIndex: 'VICTIM_AGE'		,width: 60 },
					{ dataIndex: 'SEX'				,width: 60 },
					{ dataIndex: 'PHONE'			,width: 100 },
					
					{ dataIndex: 'HOSPITAL'			,width: 100 },
					{ dataIndex: 'HOSPITAL_PHONE'	,width: 100 },
					{ dataIndex: 'DEGREE_INJURY'	,width: 100 },
					
					{ dataIndex: 'TREATMENT_PERIOD'	,width: 100 },
					{ dataIndex: 'PATIENT_CONDITION',width: 100 },
					{ dataIndex: 'REMARK'	,flex: 1 }
				  ],
				  
		listeners: {
            selectionchange: function(model, selected ){ 
            	Ext.getCmp('gac110ukrvPeopleDamage').down('#peopleDamageForm').setActiveRecord(selected[0]);
            }
        }
        
	});
	

	var peopleDamage =	 {		         
	        title: '대인내역',	
	        id:'gac110ukrvPeopleDamage',
	        itemId: 'peopleDamage',
			//layout: {type:'uniTable', columns:'1'},
	        layout:{type:'vbox', align:'stretch'},
			autoScroll:true,	
			xtype:'container',			
			flex:1,
			padding:0,
			bodyCls: 'human-panel-form-background',
			disabled: false,
	        items:[ 
	        	peopleDamageGrid,
	        	{
	        		xtype:'uniDetailForm',
	        		layout:{type:'vbox', align:'stretch'},
	        		itemId: 'peopleDamageForm',
		        	items:[{
		        		xtype:'fieldset',
		        		defaultType: 'uniTextfield',
		        		title:'대인상세정보',		        		
		        		disabled: false,
		        		bodyCls: 'human-panel-form-background',			        
		        		layout: {type:'uniTable', columns:'3'},
		        		margin:'10 10 0 10',
		        		padding:'0 0 5 0',
		        		
		        		defaults: {
		        					width:250,
		        					labelWidth:80
		        		},
		        		items: [
		            		{
		            	  	 	fieldLabel: '구분',
							 	name:'GUBUN',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA14'
							},{
		            	  	 	fieldLabel: '형태',
							 	name:'DAMAGE_TYPE',
							 	colspan:2,
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA15'
							},{
		            	  	 	fieldLabel: '이름',
							 	name:'VICTIM_NAME'
							},{
		            	  	 	fieldLabel: '나이',
							 	name:'VICTIM_AGE',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '주민번호',
							 	name:'REGIST_NO'
							},{
		            	  	 	fieldLabel: '성별',
							 	name:'SEX',
							 	xtype: 'uniCombobox',
							 	comboType:'AU', 
							 	comboCode:'GA25'
							 	
							},{
		            	  	 	fieldLabel: '직업',
							 	name:'JOB'
							},{
		            	  	 	fieldLabel: '연락처',
							 	name:'PHONE'
							},{
		            	  	 	fieldLabel: '주소',
							 	name:'ADDRESS',
							 	colspan:3,
							 	width:750
							},{
		            	  	 	fieldLabel: '상해정도',
							 	name:'DEGREE_INJURY',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA16'
							},{
		            	  	 	fieldLabel: '병원명',
							 	name:'HOSPITAL'
							},{
		            	  	 	fieldLabel: '병원연락처',
							 	name:'HOSPITAL_PHONE'
							},{
		            	  	 	fieldLabel: '비고',
							 	name:'REMARK',
							 	colspan:3,
							 	width:750
							},{
		            	  	 	fieldLabel: '환자상태',
							 	name:'PATIENT_CONDITION'
							},{
		            	  	 	fieldLabel: '진단주',
							 	name:'TREATMENT_PERIOD',
							 	xtype:'uniNumberfield',
							 	colspan:2
							},{
		            	  	 	fieldLabel: '처리결과',
							 	name:'END_YN'
							},{
		            	  	 	fieldLabel: '처리일',
							 	name:'END_DATE',
							 	xtype:'uniDatefield',
							 	colspan:2
							}
	
						]
		    		},{
		        		disabled: false,
		        		flex:1,
		        		xtype:'fieldset',
		        		defaultType: 'uniTextfield',
		        		title:'접보',
		        		bodyCls: 'human-panel-form-background',			        
		        		layout: {type:'uniTable', columns:'3'},
		        		margin:'10 10 10 10',
		        		padding:'0 0 5 0',
		        		defaults: {
		        					width:250,
		        					labelWidth:80
		        		},
		        		items: [
		            		{
		            	  	 	fieldLabel: '접보일',
							 	name:'CLAIM_DATE',
							 	xtype:'uniDatefield'
							},{
		            	  	 	fieldLabel: '사고번호',
							 	name:'CLAIM_NUM',
							 	colspan:2
							},{
		            	  	 	fieldLabel: '총추산액',
							 	name:'TOTAL_EXPECT_AMOUNT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '책임추산',
							 	name:'RESPONS_EXP_AMT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '임의추산',
							 	name:'EXPECT_AMOUNT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '총지급액',
							 	name:'TOTAL_AMOUNT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '책임공제',
							 	name:'RESPONS_DEDUCTION',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '임의공제',
							 	name:'EXPECT_DEDUCTION',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '과실율',
							 	name:'FAULTS_RATE',
							 	xtype:'uniNumberfield',
							 	suffixTpl:'%'
							},{
		            	  	 	fieldLabel: '합의금',
							 	name:'SETTLEMENT_MONEY',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '치료비',
							 	name:'MEDICAL_EXPENSE',
							 	xtype:'uniNumberfield'
							}
						]
		    		}
			]}
		],
		
		loadData:function(param)	{
			var me = this;
			peopleDamageStore.loadStoreRecords(param)
			var form = Ext.getCmp('gac110ukrvPeopleDamage').down('#peopleDamageForm');
			form.clearForm();
			form.getForm().wasDirty = false;
			form.resetDirtyStatus();
		},
		saveData:function()	{
			var me = this;
			peopleDamageStore.saveStore();
		},
		newData:function()	{
			var me = this;
			var record = masterGrid.getSelectedRecord();
			if(record)	{
				peopleDamageGrid.createRow({
					'DIV_CODE' : panelSearch.getValue('DIV_CODE'),
					'ACCIDENT_NUM': record.get('ACCIDENT_NUM'),
					'ACCIDENT_SEQ': Ext.isEmpty(peopleDamageStore.max('ACCIDENT_SEQ')) ? 1 : peopleDamageStore.max('ACCIDENT_SEQ')+1
				})
			}else {
				alert("사고정보를 선택하세요.");
			}
		},
		deleteData:function()	{
			peopleDamageGrid.deleteSelectedRow();	
		},
		rejectChanges:function()	{
			peopleDamageStore.rejectChanges()
		}	        	
	};