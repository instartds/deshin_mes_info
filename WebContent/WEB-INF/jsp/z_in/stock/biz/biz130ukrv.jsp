<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="biv130ukrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="biv130ukrv"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B037" /> <!-- ABC구분 -->
//<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
<t:ExtComboStore comboType="OU" storeId="whList" />   <!--창고(사용여부 Y) -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	sWhCellFlagYN:		'${sWhCellFlagYN}'
};

/*var output ='';
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/

var outDivCode = UserInfo.divCode;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biz130ukrvService.insertMaster',
			//update: 'biv130ukrvService.updateDetail',
			create: 'biz130ukrvService.insertDetail',
			syncAll: 'biz130ukrvService.saveAll'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biz130ukrvService.selectMaster',
			//update: 'biv130ukrvService.updateDetail',
			create: 'biz130ukrvService.insertDetail',
			syncAll: 'biz130ukrvService.saveAll'
		}
	});

	var masterForm = Unilite.createForm('biv130ukrv', {
		disabled :false
        , flex:1
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank: false,
				child:'WH_CODE',
				holdable: 'hold'
			},Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
				textFieldWidth: 170,
				allowBlank:false
			}),{
    			fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
            	name: 'COUNT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				width: 200
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '<t:message code="system.label.inventory.stockcountingcycelapply" default="실사주기적용"/>',
			    items : [{
			    	boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
			    	name: 'QRY_TYPE',
			    	inputValue: '1',
			    	width:80,
			    	checked: true
			    }, {
			    	boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
			    	name: 'QRY_TYPE' ,
			    	inputValue: '2',
			    	width:80
			    }]
			},{
        		fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
        		name: 'ITEM_ACCOUNT',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
				comboCode: 'B020'
			},{
    			fieldLabel: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
    			name:'WH_CELL_CODE',
    			xtype: 'uniCombobox',
    			hidden: true,
    			comboType:'AU',
    			comboCode:'B037'
    		},{
    			fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
    			name: 'ITEM_LEVEL1' ,
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
    			child: 'ITEM_LEVEL2'
    		},{
    			fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>' ,
    			name: 'ITEM_LEVEL2' ,
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
    			child: 'ITEM_LEVEL3'
    		},{
    			fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
    			name: 'ITEM_LEVEL3' ,
    			xtype: 'uniCombobox' ,
		        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
		        levelType:'ITEM',
    			store: Ext.data.StoreManager.lookup('itemLeve3Store')
    		},{
    			fieldLabel: '<t:message code="system.label.inventory.abcclassification" default="ABC구분"/>',
    			name:'ABC_FLAG',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B037'
    		},{
	    		xtype: 'button',
	    		itemId: 'runButton',
	    		text: '<t:message code="system.label.inventory.execute" default="실행"/>',
	    		margin: '0 0 2 120',
	    		width: 60,
				handler : function(records) {
					var rv = true;
					if(masterForm.getForm().isValid()) {
						if(confirm('<t:message code="system.message.inventory.message007" default="실행하시겠습니까?"/>')) {
							var param= masterForm.getValues();
							var me = this;
							me.setDisabled(true);
							masterForm.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
							biz130ukrvService.selectMaster(param, function(provider, response) {
								if(!Ext.isEmpty(provider)) {
									if(provider[0].COUNT_FLAG == 'O' || provider[0].COUNT_FLAG == 'P') {
										if(confirm('<t:message code="system.message.inventory.message008" default="기존의 자료가 존재합니다. 기존자료를 삭제후 자료를 재생성 하시겠습니까?"/>')) {
											biz130ukrvService.insertMaster(param);
											directMasterStore.loadStoreRecords();
											//alert('<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
										} else {

										}
									} else {
										alert('<t:message code="system.message.inventory.message010" default="이미 실사조정을 하셨습니다. 조정할 수 없습니다."/>');	// 메시지코드 중복(unilite_ko.properties sMB400 코드 중복)
									}
								} else {
									biv130ukrvService.insertMaster(param);
									directMasterStore.loadStoreRecords();
									//alert('<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
								}
								//me.setDisabled(false);
  						 		//masterForm.getEl().unmask();
							});
						} else {

						}
					}
					return rv;
               	}
    	}],
		setAllFieldsReadOnly: function(b) {
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
			   		alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	Unilite.defineModel('biv130ukrvModel', {		// 메인
		fields: [
			{name: 'COMP_CODE'			  		     , text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'			  		     , text: '<t:message code="system.label.inventory.division" default="사업장"/>'			, type: 'string'},
			{name: 'WH_CODE'			  		     , text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'COUNT_DATE'			  		     , text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'			, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		  		     , text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'			, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_LEVEL1'		  		     , text: '<t:message code="system.label.inventory.large" default="대"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL2'		  		     , text: '<t:message code="system.label.inventory.middle" default="중"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL3'		  		     , text: '<t:message code="system.label.inventory.small" default="소"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL_NAME1'		  		 , text: '<t:message code="system.label.inventory.large" default="대"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL_NAME2'		  		 , text: '<t:message code="system.label.inventory.middle" default="중"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL_NAME3'		  		 , text: '<t:message code="system.label.inventory.small" default="소"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			  		     , text: '<t:message code="system.label.inventory.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			  		     , text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				  		     , text: '<t:message code="system.label.inventory.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			  		     , text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'UNIT_WGT'			  		     , text: '<t:message code="system.label.inventory.unitweight" default="단위중량"/>'			, type: 'string'},
			{name: 'WGT_UNIT'			  		     , text: '<t:message code="system.label.inventory.weightunit" default="중량단위"/>'			, type: 'string'},
			{name: 'WH_CELL_CODE'		  		     , text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		, type: 'string'},
			{name: 'WH_CELL_NAME'		  		     , text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'			, type: 'string'},
			{name: 'LOT_NO'				  		     , text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'GOOD_STOCK_BOOK_Q'	  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_BOOK_Q'	  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'uniQty'},
			{name: 'GOOD_STOCK_BOOK_W'	  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'string'},
			{name: 'BAD_STOCK_BOOK_W'	  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'string'},
			{name: 'GOOD_STOCK_Q'		  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'uniQty'},
			{name: 'GOOD_STOCK_W'		  		     , text: '<t:message code="system.label.inventory.good" default="양품"/>'				, type: 'string'},
			{name: 'BAD_STOCK_W'		  		     , text: '<t:message code="system.label.inventory.defect" default="불량"/>'				, type: 'string'},
			{name: 'COUNT_FLAG'			  		     , text: '<t:message code="system.label.inventory.processstatus" default="진행상태"/>'			, type: 'string'},
			{name: 'COUNT_CONT_DATE'	  		     , text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'			, type: 'uniDate'},
			{name: 'REMARK'			      		     , text: '<t:message code="system.label.inventory.remarks" default="비고"/>'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		  		     , text: '<t:message code="system.label.inventory.writer" default="작성자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		  		     , text: '<t:message code="system.label.inventory.writtentiem" default="작성시간"/>'			, type: 'uniDate'}
		]
	});//End of Unilite.defineModel('biv130ukrvModel', {

   /**
    * Store 정의(Service 정의)
    * @type
    */
	var directMasterStore = Unilite.createStore('biv130ukrvMasterStore1',{		// 메인
		model: 'biv130ukrvModel',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결
            editable: false,	// 수정 모드 사용
            deletable: false,	// 삭제 가능 여부
	        useNavi : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: directProxy,
        listeners: {
            write: function(proxy, operation){
                if (operation.action == 'destroy') {
                	Ext.getCmp('masterForm').reset();
                }
        	}
        },
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						alert('<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
						masterForm.setDisabled(false);
						masterForm.down('#runButton').setDisabled(false);
						masterForm.getEl().unmask();
					}
				}
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
       		if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {
						masterForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			}
		}
	});	//End of var directMasterStore = Unilite.createStore('biv130ukrvMasterStore1',{

	Unilite.Main({
		items:[masterForm],
		id: 'biv130ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);

		},
		setDefault: function() {		// 기본값
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();
         	UniAppManager.setToolbarButtons('save', false);
		}
	});//End of Unilite.Main( {
};


</script>
