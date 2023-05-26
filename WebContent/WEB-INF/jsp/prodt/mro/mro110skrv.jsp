<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mro110skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var outDivCode=UserInfo.divCode;

function appMain() {
	var SUM_REQ_O = 0;
	var REQ_O01 = 0;
	var REQ_O02 = 0;
	var REQ_O03 = 0;
	var REQ_O04 = 0;
	var REQ_O05 = 0;
	var REQ_O06 = 0;
	var REQ_O07 = 0;
	var REQ_O08 = 0;
	var REQ_O09 = 0;
	var REQ_O10 = 0;
	var REQ_O11 = 0;
	var REQ_O12 = 0;
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mro110skrvService.selectDetailList'
		}
	});

	/**
	 * main Model 정의
	 * @type
	 */
	Unilite.defineModel('mro110skrvModel', {
	    fields: [
			{name:'GROUP1'     			,text: '<t:message code="system.label.product.classfication" default="구분"/>'		    ,type:'string' },
			{name:'GROUP2'     			,text: '<t:message code="system.label.product.classfication" default="구분"/>1'		    ,type:'string' },
			{name:'ITEM_CODE'     		,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'	},
			{name:'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'	},
			{name:'SPEC'       			,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type:'string'	},
			{name:'REQ_DATE'			,text: '<t:message code="system.label.product.requestdate" default="요청일"/>'			,type: 'uniDate'},
			//全部
			{name:'SUM_REQ_Q'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'SUM_REQ_P'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'SUM_REQ_O'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//1月 1월
			{name:'REQ_Q01'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P01'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O01'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//2月 2월
			{name:'REQ_Q02'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P02'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O02'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},


			//3月 3월
			{name:'REQ_Q03'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P03'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O03'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//4月 4월
			{name:'REQ_Q04'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P04'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O04'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//5月 5월
			{name:'REQ_Q05'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P05'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O05'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//6月 6월
			{name:'REQ_Q06'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P06'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O06'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//7月 7월
			{name:'REQ_Q07'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P07'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O07'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//8月 8월
			{name:'REQ_Q08'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P08'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O08'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//9月 9월
			{name:'REQ_Q09'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P09'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O09'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//10月 10월
			{name:'REQ_Q10'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P10'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O10'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//11月 11월
			{name:'REQ_Q11'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P11'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O11'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'},

			//12月 12월
			{name:'REQ_Q12'			,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'			,type: 'uniQty'},
			{name:'REQ_P12'			,text: '<t:message code="system.label.product.price" default="단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O12'			,text: '<t:message code="system.label.product.amount" default="금액"/>'		,type: 'uniPrice'}
		]
	});

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mro110skrvMasterStore1',{
		model: 'mro110skrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param,
				callback: function(){
					 masterGrid1.getStore().filterBy(function(record) {
						if(record.data.GROUP_FLG == '0'){
							return false;
						}
					    return true;
					});
				}
			});

		},
		saveStore: function() {

		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				Ext.each(records, function(record, rowIndex){
					if(record.get("GROUP_FLG") == '0'){
						 SUM_REQ_O = record.get("SUM_REQ_O");
						 REQ_O01 = record.get("REQ_O01");
						 REQ_O02 = record.get("REQ_O02");
						 REQ_O03 = record.get("REQ_O03");
						 REQ_O04 = record.get("REQ_O04");
						 REQ_O05 = record.get("REQ_O05");
						 REQ_O06 = record.get("REQ_O06");
						 REQ_O07 = record.get("REQ_O07");
						 REQ_O08 = record.get("REQ_O08");
						 REQ_O09 = record.get("REQ_O09");
						 REQ_O10 = record.get("REQ_O10");
						 REQ_O11 = record.get("REQ_O11");
						 REQ_O12 = record.get("REQ_O12");
					}
				});
			}
		}
	});


	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
    	defaultType: 'uniSearchSubPanel',
    	listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);

					}
				}
				},
				{
                fieldLabel: '<t:message code="system.label.product.baseyear" default="기준년도"/>',
                //xtype     : 'numberfield',
                xtype: 'uniMonthfield',
                format: 'Y',
                name      : 'REQ_YYYY',
                style:'text-align:center',
                allowBlank: false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('REQ_YYYY', newValue);
			     	}
			    }
             }]
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
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 3},
	        items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);

					}
				}
				},{
                fieldLabel: '<t:message code="system.label.product.baseyear" default="기준년도"/>',
                //xtype     : 'numberfield',
                xtype: 'uniMonthfield',
                format: 'Y',
                name      : 'REQ_YYYY',
                style:'text-align:center',
                allowBlank: false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelSearch.setValue('REQ_YYYY', newValue);
			     	}
			    }
             }]
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
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
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
    var masterGrid1 = Unilite.createGrid('mro110skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
        			excel: {
        				useExcel: true,			//엑셀 다운로드 사용 여부
        				exportGroup : true, 		//group 상태로 export 여부
        				onlyData:false,
        				summaryExport:false
        			},
			state: {
		    	useState: false,	//그리드 설정 버튼 사용 여부 
		   		useStateList: false	//그리드 설정 목록 사용 여부 
			}
        },
    	store: directMasterStore1,
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],
        viewConfig: {
        	markDirty: false,
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GROUP_FLG')  == 2||record.get('GROUP_FLG')  == 3){
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
        columns: [
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.iteminfo" default="품목정보"/>',
				locked:true,
				columns:[
					{dataIndex: 'GROUP1'      	, width: 100,
		                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '','<t:message code="system.label.product.accounttotal" default="계정계"/>');
				        }},
					{dataIndex: 'GROUP2'      	, width: 100},
					{dataIndex: 'ITEM_CODE'     , width: 120},
					{dataIndex: 'ITEM_NAME'     , width: 150},
					{dataIndex: 'SPEC'      	, width: 150}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.whole" default="전체"/>',
				locked:true,
				columns:[
					{dataIndex: 'SUM_REQ_Q'      		, width: 120},
					{dataIndex: 'SUM_REQ_P'      		, width: 120},
					{dataIndex: 'SUM_REQ_O'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(SUM_REQ_O,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.january" default="1월"/>',
				columns:[
					{dataIndex: 'REQ_Q01'      		, width: 120},
					{dataIndex: 'REQ_P01'      		, width: 120},
					{dataIndex: 'REQ_O01'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O01,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.february" default="2월"/>',
				columns:[
					{dataIndex: 'REQ_Q02'      		, width: 120},
					{dataIndex: 'REQ_P02'      		, width: 120},
					{dataIndex: 'REQ_O02'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O02,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.march" default="3월"/>',
				columns:[
					{dataIndex: 'REQ_Q03'      		, width: 120},
					{dataIndex: 'REQ_P03'      		, width: 120},
					{dataIndex: 'REQ_O03'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O03,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.april" default="4월"/>',
				columns:[
					{dataIndex: 'REQ_Q04'      		, width: 120},
					{dataIndex: 'REQ_P04'      		, width: 120},
					{dataIndex: 'REQ_O04'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O04,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.may" default="5월"/>',
				columns:[
					{dataIndex: 'REQ_Q05'      		, width: 120},
					{dataIndex: 'REQ_P05'      		, width: 120},
					{dataIndex: 'REQ_O05'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O05,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.june" default="6월"/>',
				columns:[
					{dataIndex: 'REQ_Q06'      		, width: 120},
					{dataIndex: 'REQ_P06'      		, width: 120},
					{dataIndex: 'REQ_O06'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O06,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.july" default="7월"/>',
				columns:[
					{dataIndex: 'REQ_Q07'      		, width: 120},
					{dataIndex: 'REQ_P07'      		, width: 120},
					{dataIndex: 'REQ_O07'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O07,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.august" default="8월"/>',
				columns:[
					{dataIndex: 'REQ_Q08'      		, width: 120},
					{dataIndex: 'REQ_P08'      		, width: 120},
					{dataIndex: 'REQ_O08'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O08,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.september" default="9월"/>',
				columns:[
					{dataIndex: 'REQ_Q09'      		, width: 120},
					{dataIndex: 'REQ_P09'      		, width: 120},
					{dataIndex: 'REQ_O09'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O09,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.october" default="10월"/>',
				columns:[
					{dataIndex: 'REQ_Q10'      		, width: 120},
					{dataIndex: 'REQ_P10'      		, width: 120},
					{dataIndex: 'REQ_O10'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O10,UniFormat.Price)+'</div>');
			            	}}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.november" default="11월"/>',
				columns:[
					{dataIndex: 'REQ_Q11'      		, width: 120},
					{dataIndex: 'REQ_P11'      		, width: 120},
					{dataIndex: 'REQ_O11'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O11,UniFormat.Price)+'</div>');
			            	}
					}
				]
			},
			{
				dataIndex:'',
				text:'<t:message code="system.label.product.december" default="12월"/>',
				columns:[
					{dataIndex: 'REQ_Q12'      		, width: 120},
					{dataIndex: 'REQ_P12'      		, width: 120},
					{dataIndex: 'REQ_O12'      		, width: 120, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(REQ_O12,UniFormat.Price)+'</div>');
			            	}
					}
				]
			}


		],
        listeners: {
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {

			    });
			}
           ,beforeedit  : function( editor, e, eOpts ) {
			},
        	selectionchange:function( model1, selected, eOpts ){
          	}
        },
       	returnCell: function(record){
        }
    });

    Unilite.Main( {
    	borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[panelResult,
					{
						region : 'west',
						xtype : 'container',
						layout : 'fit',
//						width : 1000,
						flex : 200,
						items : [ masterGrid1 ]
					}
				]
			}
			,panelSearch
		],
		id: 'mro110skrvApp',
		fnInitBinding: function(params) {
			panelSearch.setValue('REQ_YYYY',UniDate.get('startOfMonth').substr(0,4));
			panelResult.setValue('REQ_YYYY',UniDate.get('startOfMonth').substr(0,4));
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData','reset'], false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){return};
			directMasterStore1.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
			panelSearch.setValue('REQ_YYYY',UniDate.get('startOfMonth').substr(0,4));
			panelResult.setValue('REQ_YYYY',UniDate.get('startOfMonth').substr(0,4));
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.loadData({});
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown: function()	{

				 var REQ_YYYYMM		 =  UniDate.get('startOfMonth').substr(0,6);
				 var seq = directMasterStore1.max('SER_NO');
	        	 if(!seq) seq = 1;
	        	 else  seq += 1;
	        	 var REQ_DATE		 =  dateToString(new Date());
                 var TREE_CODE       =  '';
                 var TREE_NAME     	 =  '';
                 var SPEC     		 =  '';
                 var REQ_Q      	 =   0;
                 var REQ_P      	 =   0;
                 var REQ_O      	 =   0;
                 var WORKSHOP      	 =   '';
                 var PJT_CODE      	 =   '';
                 var remark          =  '';

                 var r = {
                		 DIV_CODE		 : UserInfo.divCode,
                		 REQ_YYYYMM		 : REQ_YYYYMM,
                		 REQ_DATE		 : REQ_DATE,
                		 SER_NO		 	 : seq,
                		 TREE_CODE       : TREE_CODE,
                		 TREE_NAME       : TREE_NAME,
                		 SPEC      		 : SPEC,
                		 REQ_Q      	 : REQ_Q,
                		 REQ_P      	 : REQ_P,
                		 REQ_O      	 : REQ_O,
                		 WORKSHOP      	 : WORKSHOP,
                		 PJT_CODE        : PJT_CODE,
                   		 REMARK          : remark
                };
                masterGrid1.createRow(r, masterGrid1.getStore().getCount() - 1);
		},
        checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {
		},
		rejectSave: function() {
			var rowIndex = masterGrid1.getSelectedRowIndex();
				masterGrid1.select(rowIndex);
				directMasterStore1.rejectChanges();

				if(rowIndex >= 0){
					masterGrid1.getSelectionModel().select(rowIndex);
					var selected = masterGrid1.getSelectedRecord();
				}
				directMasterStore1.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('mro110skrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {

		},
		fnCalOrderAmt: function(rtnRecord, sType, nValue) {
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('REQ_Q'),0);
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('REQ_P'),0);
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('REQ_O'),0);
			var dOrderQ;
			var dOrderP;

			if(sType == 'P' || sType == 'Q'){
				dOrderO = (dOrderUnitQ * (dOrderUnitP * 1000)) / 1000
				dOrderO = dOrderO.toFixed(3);
				rtnRecord.set('REQ_O', dOrderO);

				dOrderQ = dOrderUnitQ;
				rtnRecord.set('REQ_Q', dOrderQ);

				dOrderP = dOrderUnitP ;
				rtnRecord.set('REQ_P', dOrderP);

			}else if(sType == 'O'){
				if(Math.abs(dOrderUnitQ) > '0'){
					rtnRecord.set('REQ_P', dOrderUnitP);
				}else{
					rtnRecord.set('ORDER_P', '0');
				}
			}
		}
	});
    Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "REQ_Q" : //발주순번
					if(newValue < 0){
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
				break;

				case "REQ_P" :
					if(newValue < 0){
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
					break;

				case "REQ_O":
					if(newValue < 0){
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
					break;
			}
			return rv;
		}
	});

};

</script>
