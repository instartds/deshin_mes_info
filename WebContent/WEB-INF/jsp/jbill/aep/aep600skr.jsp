<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep600skr"  >
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aep600skrModel', {
	    fields: [
			{name: 'COMP_NM'			, text: '회사구분'		, type: 'string'},
			{name: 'CARDCO_NM'			, text: '카드사'		, type: 'string'},
			{name: 'CARD_TYPE'			, text: '카드구분'		, type: 'string'},
			{name: 'CARD_NO'			, text: '카드번호'		, type: 'string'},
			{name: 'CARD_NO_EXPOS'   	, text: '카드번호'  	, type: 'string'	, maxLength:20	, defaultValue:'***************'},
			{name: 'EMP_NM'				, text: '소유자'		, type: 'string'},
			{name: 'DEPT_NM'			, text: '부서'		, type: 'string'},
			{name: 'MERC_NM'			, text: '가맹점'		, type: 'string'},
			{name: 'AQUI_SUM'			, text: '금액'		, type: 'string'},
			{name: 'AQUI_AMT'			, text: '공급가액'		, type: 'string'},
			{name: 'AQUI_TAX'			, text: '부가세액'		, type: 'string'},
			{name: 'MCC_NM'				, text: '업종'		, type: 'string'},
			{name: 'VAT_STAT_NM'		, text: '과세유형'		, type: 'string'},
			{name: 'APPR_NO'			, text: '승인번호'		, type: 'string'},
			{name: 'SLIP_NO'			, text: '전표번호'		, type: 'string'},
			{name: 'SLIP_STAT_NM'		, text: '전표상태'		, type: 'string'},
			{name: 'AQUI_STAT'			, text: '매입상태'		, type: 'string'},
			{name: 'INV_YYMM'			, text: '청구년월'		, type: 'string'},
			{name: 'SEND_DTM'			, text: '전송일시'		, type: 'string'},
			{name: '???'				, text: '진행상태'		, type: 'string'}
	    ] 	
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep600skrMasterStore1',{
		model: 'Aep600skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'aep600skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var detailform = panelSearch.getForm();
        	
        	if (detailform.isValid()) {
        		var param = detailform.getValues();			
    			console.log( param );
    			this.load({
    				params : param
    			});
        	}else{
        		var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				    	
				if(invalid.length > 0)	{
					r = false;
					var labelText = ''
					    	
					if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					
					Ext.Msg.alert('확인', labelText+Msg.sMB083);
					invalid.items[0].focus();
				}
        	}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '청구년월',  
				name: 'invYymm',
				xtype : 'uniMonthfield',
				allowBlank: false,
				value: new Date(),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('invYymm', newValue);
					}
				}
			},{								
				fieldLabel: '카드사',
				name:'cardcoCd', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('cardcoCd', newValue);
					}
				}
			},Unilite.popup('',{
				fieldLabel: '카드번호',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
		}),{								
				fieldLabel: '카드사구분',
				name:'cardType', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('cardType', newValue);
					}
				}
			}]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '청구년월',  
			name: 'invYymm',
			xtype : 'uniMonthfield',
			allowBlank: false,
			value: new Date(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('invYymm', newValue);
				}
			}
		},{								
			fieldLabel: '카드사',
			name:'cardcoCd', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: '',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('cardcoCd', newValue);
				}
			}
		},Unilite.popup('',{
			fieldLabel: '카드번호',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
	}),{								
			fieldLabel: '카드사구분',
			name:'cardType', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: '',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('cardType', newValue);
				}
			}
		}]	
    });
	
    var southForm = Unilite.createSimpleForm('southForm', {
		region: 'north',
		xtype: 'container',
		layout: {type: 'uniTable', columns:5},
		items:[{
			 xtype: 'container',
			 html:'<b>■ 법인카드 대사내역</b>',
			 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
			 colspan: 5,
			 margin: '13 0 0 6'
		}, {
			xtype: 'container',
			margin: '5 0 0 0',
			padding: '0 7 20 7',
			colspan: 5,
			layout: {
				type: 'table',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align : 'center'}
			},
			defaults:{width: '100%', margin: '2 2 2 2'},
			items: [
				{ xtype: 'component', html:'구분', tdAttrs: {height: 40}, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
				{ xtype: 'component', html:'청구내역'},
				{ xtype: 'component', html:'대사내역'},
				{ xtype: 'component', html:'차이내역'},
				{ xtype: 'component', html:'경비처리내역'},
				{ xtype: 'component', html:'미처리내역'},
				
		    	{ xtype: 'component',  html:'&nbsp;건수', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '건', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '건', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '건', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '건', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '건', readOnly:true, name: ''},
				
				{ xtype: 'component',  html:'&nbsp;금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: ''},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: ''}
				
			]			
		},{
			 xtype: 'container',
			 html:'<b>■ 내역 상세조회</b>',
			 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
			 colspan: 5,
			 margin: '0 0 5 6'
		}]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aep600skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore,
        columns: [
        	{dataIndex: 'COMP_NM'			, width: 100},
        	{dataIndex: 'CARDCO_NM'			, width: 100},
        	{dataIndex: 'CARD_TYPE'			, width: 100},
        	{dataIndex: 'CARD_NO'			, width: 100, hidden: true},
        	{dataIndex: 'CARD_NO_EXPOS'    	, width: 120  , align:'center'}, 
        	{dataIndex: 'EMP_NM'			, width: 100},
        	{dataIndex: 'DEPT_NM'			, width: 100},
        	{dataIndex: 'MERC_NM'			, width: 100},
        	{dataIndex: 'AQUI_SUM'			, width: 100},
        	{dataIndex: 'AQUI_AMT'			, width: 100},
        	{dataIndex: 'AQUI_TAX'			, width: 100},
        	{dataIndex: 'MCC_NM'			, width: 100},
        	{dataIndex: 'VAT_STAT_NM'		, width: 100},
        	{dataIndex: 'APPR_NO'			, width: 100},
        	{dataIndex: 'SLIP_NO'			, width: 100},
        	{dataIndex: 'SLIP_STAT_NM'		, width: 100},
        	{dataIndex: 'AQUI_STAT'			, width: 100},
        	{dataIndex: 'INV_YYMM'			, width: 100},
        	{dataIndex: 'SEND_DTM'			, width: 100},
        	{dataIndex: '???'				, width: 100}
		],
        listeners:{
            onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="CARD_NO_EXPOS") {
                	grid.ownerGrid.openCryptCardNoPopup(record);      
				}	
			}	
        },
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CARD_NO'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CARD_NO', params);
			}
				
		}			
    });                          
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult,southForm
			]
		},
			panelSearch  	
		], 
		id : 'aep600skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('invYymm');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
};


</script>
