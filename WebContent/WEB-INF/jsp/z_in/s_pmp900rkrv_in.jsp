<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp900rkrv_in">
<t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- 사업장    -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
var count = 0;
	/**
	 * Model 정의
	 * @type
	 */

	Unilite.defineModel('s_pmp900rkrv_inModel', {
	    fields:[
	    	{name: 'DIV_CODE',				text: '사업장',				type: 'string'	,editable: false},
	    	{name: 'WORK_SHOP_NAME',		text: '작업장',				type: 'string'	,editable: false},
	    	{name: 'WKORD_NUM',				text: '작업지시번호',			type: 'string'	,editable: false},
	    	{name: 'PROD_ITEM_CODE',		text: '제품코드',				type: 'string'	,editable: false},
	    	{name: 'ITEM_NAME',				text: '제품명',				type: 'string'	,editable: false},
	    	{name: 'PROG_UNIT',				text: '규격',					type: 'string'	,editable: false},
	    	{name: 'LOT_NO',				text: 'LOT NO',				type: 'string'	,editable: false},
	    	{name: 'PRINT_Q',				text: '출력수량',				type: 'uniQty'},
	    	{name: 'PRODT_DATE',			text: '제조일자',				type: 'uniDate'	,editable: false},
	    	{name: 'EXPIRATION_DATE',		text: '유효기간',				type: 'uniDate'	,editable: false},
	    	{name: 'PACK_QTY',				text: '포장수량',				type: 'uniQty'	,editable: false},
	    	{name: 'KEEP_TEMPER',			text: '냉장온도',				type: 'string'	,editable: false},
	    	]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_pmp900rkrv_inMasterStore',{
		model: 's_pmp900rkrv_inModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: true,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false,			// prev | newxt 버튼 사용

		},
		autoLoad: false,

		proxy: {
			type: 'direct',
			api: {
				read: 's_pmp900rkrv_inService.selectList'

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
				comboType: 'AU',
				comboCode: 'B001',
				allowBlank: false,
				value: '01'
			},{
			    fieldLabel: '생산일'  ,
                xtype:'uniDatefield',
                name: 'PRODT_DATE',
				Date: UniDate.get('today'),
				width: 200,
				allowBlank: false
			},{
				 text: '출력',
	             xtype: 'button',
	             id: 'btnPrint1',
	             width: 100,
	             margin: '0 0 0 520',
	         	 handler: function(){

	         	 var records = masterGrid.getSelectedRecords();
	         	 var msg = "";

	         	 Ext.each(records, function(record, index){

	         		msg = record.get('ITEM_CODE') + '|' +
	         						record.get('ITEM_NAME') + '|' +
	         						record.get('LOT_NO') + '|' +
	         						record.get('PACK_QTY') + '|' +
	         					    UniDate.getDbDateStr(record.get('PRODT_DATE')).substring(0,4) + "." +
									UniDate.getDbDateStr(record.get('PRODT_DATE')).substring(4,6) + "." +
           							UniDate.getDbDateStr(record.get('PRODT_DATE')).substring(6,8) + '|' +
           							UniDate.getDbDateStr(record.get('EXPIRATION_DATE')).substring(0,4) + "." +
									UniDate.getDbDateStr(record.get('EXPIRATION_DATE')).substring(4,6) + "." +
        							UniDate.getDbDateStr(record.get('EXPIRATION_DATE')).substring(6,8) + '|' +
        							record.get('KEEP_TEMPER') + '|' +
        							record.get('PRINT_Q') + '\r\n';

	             	writeFile(record.get('WKORD_NUM') + '.txt' ,msg);
	             	++i;
	         	 });
	         	 }
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
	* 파일읽고쓰기 FSO 정의
	*
	*/

	function writeFile(name, msg){
        if(name == "") return false;

        var defaultpath = "C:\\label\\order"; // 기록하고자 하는 경로. ex) C:\\Program
												// Files\\logs
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var fullpath = defaultpath+"\\"+name;


        // 파일삭제
         if(fso.FileExists(fullpath)){
             fso.DeleteFile(fullpath);
        }

        // 파일이 생성되어있지 않으면 새로 만들고 기록
        if(!fso.FileExists(fullpath)){
            // var fWrite = fso.CreateTextFile(fullpath,false);
	    var fWrite = fso.CreateTextFile(fullpath ,false,false); // [파일이름], [덮어쓰기], [유니코드]
            fWrite.write(msg);
            fWrite.close();
        }else{
        // 파일이 이미 생성되어 있으면 appending 모드로 파일 열고 기록
            var fWrite = fso.OpenTextFile(fullpath, 8);
            fWrite.write(msg);
            fWrite.close();
        }
    }
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('s_pmp900rkrv_inGrid', {

		region: 'center',
        layout : 'fit',
    	store : directMasterStore,
    	//그리드 체크박스 정의 및 활성화
    	selModel: Ext.create('Ext.selection.CheckboxModel',{ checkOnly: true,  toggleOnClick: false, //checkOnly : false 체크문제있으니 true로 설정하였다.
    		listeners: {
    				select: function(grid, selectRecord, index, rowIndex, eOpts){

                           Ext.getCmp('btnPrint1').setDisabled(false);

    				},
    				deselect: function(grid, selectRecord, index, eopts){

    				var records = masterGrid.getSelectedRecords();

   					if(Ext.isEmpty(records)) {
                           Ext.getCmp('btnPrint1').setDisabled(true);
                       } else {
                           Ext.getCmp('btnPrint1').setDisabled(false);
                       }
    				}
		   		}
    	}),

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
        	{dataIndex: 'WORK_SHOP_NAME',			width: 150},
        	{dataIndex: 'WKORD_NUM'	,				width: 150},
        	{dataIndex: 'PROD_ITEM_CODE'	,		width: 100},
        	{dataIndex: 'ITEM_NAME'	,				width: 200},
        	{dataIndex: 'PROG_UNIT'	,				width: 100},
        	{dataIndex: 'LOT_NO'	,				width: 100},
        	{dataIndex: 'PRINT_Q'	,				width: 100},
        	{dataIndex: 'PRODT_DATE'	,			width: 100},
        	{dataIndex: 'EXPIRATION_DATE'	,		width: 100},
        	{dataIndex: 'PACK_QTY'	,				width: 100},
        	{dataIndex: 'KEEP_TEMPER'	,			width: 100}
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
        fnInitBinding: function() {
        	panelResult.setValue('DIV_CODE','01');
            panelResult.setValue('PRODT_DATE', UniDate.get('today'));
        	UniAppManager.setToolbarButtons('save',false);
        	UniAppManager.setToolbarButtons('reset',false);
        	Ext.getCmp('btnPrint1').disable();

        },
        onQueryButtonDown: function()    {
            var isTrue = panelResult.setAllFieldsReadOnly(true);
         	if(!isTrue){
        		return false;
        	}
        	masterGrid.getStore().loadStoreRecords();
         	UniAppManager.setToolbarButtons('reset',true);
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
