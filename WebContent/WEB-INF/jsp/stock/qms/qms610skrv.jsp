<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms610skrv">
<t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	/**
	 * Model 정의
	 * @type
	 */

	Unilite.defineModel('qms610skrvModel', {
	    fields:[
				{name: 'INSPEC_DATE',		text: '검사일',				type: 'uniDate'},	   
				{name: 'ITEM_CODE',			text: '품목',					type: 'string'},	   
				{name: 'ITEM_NAME',			text: '품목명',				type: 'string'},	   
				{name: 'SPEC',				text: '규격',					type: 'string'},	   
				{name: 'LOT_NO',			text: 'LOT NO',				type: 'string'},	   
				{name: 'STOCK_UNIT',		text: '단위',					type: 'string'},	   
				{name: 'INSPEC_TYPE',		text: '검사유형',				type: 'string'},	   
				{name: 'INSPEC_Q',			text: '검사량',				type: 'uniQty'},	   
				{name: 'GOOD_INSPEC_Q',		text: '합격수량',				type: 'uniQty'},	   
				{name: 'BAD_INSPEC_Q',		text: '불량수량',				type: 'uniQty'},	   
				{name: 'INSPEC_PRSN',		text: '검사담당자',				type: 'string'},	   
				{name: 'GOODBAD_TYPE',		text: '합격여부',				type: 'string'},	   
				{name: 'WH_NAME',			text: '이동창고',				type: 'string'},	   
				{name: 'INSPEC_NUM',		text: '검사번호',				type: 'string'},	   
				{name: 'INSPEC_SEQ',		text: '검사순번',				type: 'string'},
				
				{name: 'DIV_CODE',			text: '사업장코드',				type: 'string'}, 
				{name: 'COMP_CODE',			text: '법인코드',				type: 'string'}
	    
	    ]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('qms610skrvMasterStore',{
		model: 'qms610skrvModel',
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
				read: 'qms610skrvService.selectList'
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
			items:[{
                fieldLabel:'사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                holdable: 'hold'            
            },{
				fieldLabel:'시험 출고일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				textFieldWidth: 150,
				allowBlank: false
			},{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        
                    }
                }
				
			},	Unilite.popup('DIV_PUMOK',{
				fieldLabel:'품목',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				valueFieldWidth:100,
				textFieldWidth:150,				
				validateBlank:false,
				autoPopup:true,
				listeners: {	//사업장번호에 01번 매핑하기
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': '01'});
					}
				}
				
			})
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

	var masterGrid = Unilite.createGrid('qms610skrvGrid', {
    	
		region: 'center',
        layout : 'fit',
    	store : directMasterStore,    	
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
		features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        	columns:[
        	{dataIndex: 'INSPEC_DATE',			width: 100},	//검사일
        	{dataIndex: 'ITEM_CODE',			width: 100},	//품목
        	{dataIndex: 'ITEM_NAME',			width: 250},	//품목명
        	{dataIndex: 'SPEC',					width: 100},	//규격
        	{dataIndex: 'LOT_NO',				width: 100},	//LOTNO
        	{dataIndex: 'STOCK_UNIT',			width: 100	,align:'center'},	//단위        	
        	{dataIndex: 'INSPEC_TYPE',			width: 150},	//검사유형
        	{dataIndex: 'INSPEC_Q',				width: 100},	//검사량
        	{dataIndex: 'GOOD_INSPEC_Q',		width: 100},	//합격수량
        	{dataIndex: 'BAD_INSPEC_Q',			width: 100},	//불량수량
        	{dataIndex: 'INSPEC_PRSN',			width: 100},	//검사담당자
        	{dataIndex: 'GOODBAD_TYPE',			width: 100},	//합격여부
        	{dataIndex: 'WH_NAME',				width: 200},	//이동창고
        	{dataIndex: 'INSPEC_NUM',			width: 200},	//검사번호
        	{dataIndex: 'INSPEC_SEQ',			width: 100 ,align:'right'},	//검사순번
        
        	]				
	});

    Unilite.Main( {
    	borderItems:[{
    		region: 'center' ,
            layout : 'border',
    		id : 'mainItem',
    		border : false,
    		items : [
    					panelResult, masterGrid 
    		         ]  	
        	}
        	],
        id : 'qms610skrvApp',
		
        fnInitBinding: function() {
        	panelResult.setValue('DIV_CODE','01');
            panelResult.setValue('INSPEC_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('INSPEC_DATE_TO', UniDate.get('today'));
        	UniAppManager.setToolbarButtons('save',false);
        },
        onQueryButtonDown: function()    {            
            var isTrue = panelResult.setAllFieldsReadOnly(true);
         	if(!isTrue){
        		return false;
        	}
        	masterGrid.getStore().loadStoreRecords();            
        },
		onResetButtonDown:function() {				//신규버튼클릭(초기화)
            masterGrid.reset();
            directMasterStore.clearData();
            panelResult.clearForm();
 			this.fnInitBinding();
		}
	});
    
 };

</script>
