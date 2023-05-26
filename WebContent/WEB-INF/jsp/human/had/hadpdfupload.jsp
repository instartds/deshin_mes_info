<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hadpdfupload"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>	<!-- 직위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	});
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('HadpdfUploadModel', {
	    fields: [
	    	{name: 'CHOICE'				,			text: '대상',				type: 'string'},
	    	{name: 'GUBUN_CODE'			,			text: '구분코드',				type: 'string'},
	    	{name: 'GUBUN_NAME'			,			text: '항목명',				type: 'string'},
	    	{name: 'D_NAME'				,			text: '대상자',				type: 'string'},
	    	{name: 'D_REPRE_NUM'		,			text: '주민번호',				type: 'string'},
	    	{name: 'DATA_CD'			,			text: 'DATA_CD',				type: 'string'},
	    	{name: 'DATA_NAME'			,			text: '유형',				type: 'string'},
	    	{name: 'CARD_TYPE_NAME'		,			text: '유형',				type: 'string'},
	    	{name: 'USE_AMT'			,			text: '금액',				type: 'string'},
	    	{name: 'D_RES_NO'			,			text: 'D_RES_NO',				type: 'string'}
	    		    			
		]
	});		// end of Unilite.defineModel('HadpdfUploadModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hadpdfUploadMasterStore1',{
		model: 'HadpdfUploadModel',
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
            	//비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'hadpdfUploadService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
			
		}			
	});		// end of var directMasterStore1 = Unilite.createStore('hadpdfUploadMasterStore1',{
	 		
	 var panelData = Unilite.createSearchForm('dataForm',{
    	region: 'north',
		layout : {type : 'vbox', align: 'stratch'},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 8},
			items:[{
				xtype: 'uniYearField',
				name: '',
				fieldLabel: '귀속년도',
				allowBlank: false
			},			
		     	Unilite.popup('Employee',{
				allowBlank: false,
				validateBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			})]
		},{
			xtype: 'container',
			layout: {type: 'hbox', align: 'stretch'},
			margin: '3 0 3 0',
			items:[{ 
	    		xtype: 'button',
	    		text: '1.부양가족 확인',
	    		width: 100,
	    		margin: '0 0 0 93',
//	    		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'left'},
	    		handler : function() {
	    			
   				}	    	
			},{
				xtype: 'component',
				html: '>>',
				padding: '3 0 0 26'
			},{
				fieldLabel:'PDF파일',
				name: 'excelupload',
				xtype: 'uniFilefield',
				buttonText : '찾아보기...',
				width: 410,
				labelWidth: 98
			},{ 
	    		xtype: 'button',
	    		text: '2.PDF 업로드',
	    		width: 100,
	    		margin: '0 0 0 10',
//	    		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'left'},
	    		handler : function() {
	    			
   				}	    	
			},{
				xtype: 'component',
				html: '>>',
				padding: '3 0 0 26'
			},{ 
	    		xtype: 'button',
	    		text: '3.PDF 자료확인',
	    		width: 100,
	    		margin: '0 0 3 20',
//	    		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'left'},
	    		handler : function() {
	    			
   				}	    	
			},{
				xtype: 'component',
				html: '>>',
				padding: '3 0 0 26'
			},{ 
	    		xtype: 'button',
	    		text: '4.PDF 자료반영',
	    		width: 100,
	    		margin: '0 0 3 20',
//	    		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'left'},
	    		handler : function() {
	    			
   				}	    	
			}]
		}]
    });
	
    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns: 6, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
//		bodyStyle: 'padding:5px 5px 0',
		defaults: {xtype: 'uniNumberfield'},
		items: [{
                xtype:'component',
                html: '보험',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '의료비',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '교육비',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '신용카드',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '직불카드',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '현금영수증',
                tdAttrs: {align: 'center', width: 300}
            },{                
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                xtype:'component',
                html: '개인연금저축/연금계좌',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '주택자금',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '주택마련저축',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '장기집합투자증권저축',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '소기업/소상공인 공제부금',
                tdAttrs: {align: 'center', width: 300}
            },{
                xtype:'component',
                html: '기부금',
                tdAttrs: {align: 'center', width: 300}
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            },{
                hideLabel: true,
                tdAttrs: {align: 'center', width: 300},
                value: 0
            }
		
		]
    });
    
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hadpdfUploadGrid2015', {
    	// for tab    	
    	flex: 6.5,
        layout : 'fit',
        region:'south',
        uniOpt:{	
        	expandLastColumn: true,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
            state: {					//그리드 설정 사용 여부
    			useState: false,
    			useStateList: false
    		}		
		},
        features: [{id : 'grid2015SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'grid2015Total', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore1,
    	columns: [
    		{ dataIndex: 'CHOICE'				,   				width: 41},
    		{ dataIndex: 'GUBUN_CODE'			,   				width: 115, hidden: true },
    		{ dataIndex: 'GUBUN_NAME'			,   				width: 230},
    		{ dataIndex: 'D_NAME'				,   				width: 192},
    		{ dataIndex: 'D_REPRE_NUM'			,   				width: 192},
    		{ dataIndex: 'DATA_CD'				,   				width: 192, hidden: true },
    		{ dataIndex: 'DATA_NAME'			,   				width: 230},
    		{ dataIndex: 'CARD_TYPE_NAME'		,   				width: 230, hidden: true },
    		{ dataIndex: 'USE_AMT'				,   				width: 192},
    		{ dataIndex: 'D_RES_NO'				,   				width: 192, hidden: true }  									
		] 
    });
	
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult, panelData
			]
		}],
		id  : 'hadpdfUploadApp',
		fnInitBinding : function() {			
			UniAppManager.setToolbarButtons('reset',false);			
			
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
//			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked : ",viewLocked);
//			console.log("viewNormal : ",viewNormal);
//		    viewLocked.getFeature('grid2015SubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('grid2015Total').toggleSummaryRow(true);
//		    viewNormal.getFeature('grid2015SubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('grid2015Total').toggleSummaryRow(true);
				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
