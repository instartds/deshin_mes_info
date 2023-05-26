<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_qms400skrv_in">
<t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 사업장    -->	
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	/**
	 * Model 정의
	 * @type
	 */

	Unilite.defineModel('s_qms400skrv_inModel', {
	    fields:[
			{name: 'INOUT_DATE'			, text: '사용일'					, type: 'uniDate'},  
			{name: 'DEPT_NAME'			, text: '사용부서'				, type: 'string'},  
	    	{name: 'ITEM_CODE'				, text: '품목'						, type: 'string'},	    
	    	{name: 'ITEM_NAME'			, text: '품목명'					, type: 'string'},	    
	    	{name: 'SPEC'							, text: '규격'						, type: 'string'},	    
	    	{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},	   
	    	{name: 'WH_CODE'				, text: '출고창고코드'		, type: 'string'},	
	    	{name: 'WH_NAME'				, text: '출고창고'				, type: 'string'},	  
	    	{name: 'INOUT_Q'					, text: '출고량'					, type: 'uniQty'},	 
	    	{name: 'INOUT_I'					, text: '출고금액'				, type: 'uniPrice'},	
	    	{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},	
	    	{name: 'INOUT_PRSN'			, text: '출고담당자'			, type: 'string'			, comboType: 'AU'		, comboCode: 'B024'},
	    	{name: 'REMARK'					, text: '비고'						, type: 'string'}
	    ]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_qms400skrv_inMasterStore',{
		model: 's_qms400skrv_inModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_qms400skrv_inService.selectList'
				}
		},		
		loadStoreRecords: function(){                     
            var param= panelResult.getValues();           
            this.load({
             		params: param
            });        
        }
	});
	
	/**
	 * 검색조건 (Search Panel) panelResult
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,		
			items:[{
                fieldLabel:'사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                holdable: 'hold'            
            },{ 
				fieldLabel: '검사일',
				allowBlank: false,
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{
				fieldLabel: '출고담당자', 
				name: 'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024'
			},{
				fieldLabel: 'LOT NO',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        
                    }
                }
			},Unilite.popup('DIV_PUMOK',{
				fieldLabel:'품목',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				valueFieldWidth:70,
				textFieldWidth:150,				
				validateBlank:false,
				autoPopup:true,
				listeners: {	//사업장번호에 01번 매핑하기
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': '01'});
					}
				}
				
			}),{
				fieldLabel: '품목계정', 
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				multiSelect:true,
				comboCode: 'B020'
			}
		],setAllFieldsReadOnly: function(b) {//필수조건검색 공란일시 메시지출력
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                      return !field.validate();
                  });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }
                    alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } else {
                    // this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                // this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
   		 }
	});
    
	/**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('s_qms400skrv_inGrid', {    	
		region: 'center',
        layout : 'fit',
    	store : directMasterStore,    	
    	uniOpt:{	
        	expandLastColumn: true,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true} 
    	],
        	columns:[
				{dataIndex: 'INOUT_DATE'			, width: 100},
				{dataIndex: 'DEPT_NAME'	            , width: 120}, 
				{dataIndex: 'ITEM_CODE'	            , width: 100}, 
				{dataIndex: 'ITEM_NAME'	            , width: 240}, 
				{dataIndex: 'SPEC'		            , width: 160}, 
				{dataIndex: 'LOT_NO'		        , width: 90}, 
				{dataIndex: 'WH_CODE'	            , width: 100, hidden: true}, 
				{dataIndex: 'WH_NAME'	            , width: 150}, 
				{dataIndex: 'INOUT_Q'	            , width: 100, summaryType: 'sum' }, 
				{dataIndex: 'INOUT_I'	            , width: 100, summaryType: 'sum' }, 
				{dataIndex: 'INOUT_PRSN'	        , width: 90}, 
				{dataIndex: 'REMARK'		        , width: 350} 
        	]				
	});

    Unilite.Main({
    	borderItems:[{
    		region: 'center' ,
            layout : 'border',
    		id : 'mainItem',
    		border : false,
    		items : [
    					panelResult, masterGrid 
    		         ]  	
        	}],
       		id : 's_qms400skrv_inApp',
        fnInitBinding: function() {
        	panelResult.setValue('DIV_CODE','01');
            panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
        	UniAppManager.setToolbarButtons('save',false);
        },
        onQueryButtonDown: function()    {            
            var isTrue = panelResult.setAllFieldsReadOnly(true);
         	if(!isTrue){
        		return false;
        	}
        	masterGrid.getStore().loadStoreRecords();            
        },
		onResetButtonDown:function(){
            masterGrid.reset();
            directMasterStore.clearData();
            panelResult.clearForm();
 			this.fnInitBinding();
		}
	});
    
 };

</script>
