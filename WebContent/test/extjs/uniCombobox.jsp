<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr100ukrv"  >
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="BPR100ukrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="BPR100ukrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="BPR100ukrvLevel3Store" />
</t:appConfig>

<script type="text/javascript">

Ext.onReady(function() {
	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
	
    ///////////////////////////////
    // 영업 기회
	Ext.define('Cmb200skrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'customName', 	// 거래처명
	              'dvryCustNm',		// 배송처
	              'projectName', 	// 프로젝트 명
	              'projectNo'		// 프로젝트 No
	             ]
	});

	var customStore = Ext.create("Ext.data.DirectStore", {
			model : "Cmb200skrvModel",
			//autoLoad : true,
			proxy : {
				type : "direct",
				api : {
					read : 'cmb210skrvService.selectProjectList'
				},
				reader : {
					type : 'json',
					rootProperty : 'data',
					totalProperty : 'totalCount'
				}
			},
			 listeners: {
		        'load': function(store, rec) {
		           //console.log("rec is " + rec);
		        }
		    }
		});

		var fsf = {
			xtype : 'uniSearchForm',
			id : 'searchForm',
			items : [ {
				fieldLabel : '영업기회',
				name : 'projectNo',
				xtype : 'uniCombobox',
				//xtype : 'combo',
				store : customStore,
				displayField : 'projectName',
				valueField : 'projectNo',
				hiddenName : 'srchProjectNo',
				queryDelay : 1,

				listeners: {
					'select' : function(combo, record, index) {
						console.log( "Value : " + combo.getValue());
						console.log( record[0].data);
						
					}
				}
			} ]
		};


		Ext.create('Ext.Viewport', {
			layout : {
				type : 'vbox',
				pack : 'start',
				align : 'stretch'
			},

			items : [fsf ],
			renderTo : Ext.getBody()
		});

	});
</script>
<!-- Search Area  -->

<div id="elSearch" class="x-hide-display">
	<div id="elSearchCondition"></div>
</div>


<!-- //List Area -->
