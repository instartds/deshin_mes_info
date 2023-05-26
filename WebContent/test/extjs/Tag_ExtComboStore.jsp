<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%@page import="foren.unilite.modules.com.combo.ComboItemModel" %>
<%@ taglib prefix="t" uri="/WEB-INF/tld/tLab.tld"%>
<%
	// Controller에서 구현 
	List<ComboItemModel> list = new ArrayList<ComboItemModel>();
	for (int i=0, len = 10; i < len; i ++) {
		ComboItemModel item = new ComboItemModel("vxxasdasdasasdasdsas" + i , "tXs" + i,null);
		list.add(item);
	}
	request.setAttribute("list", list);

	List<ComboItemModel> listMaster = new ArrayList<ComboItemModel>();
	request.setAttribute("listMaster", listMaster);
	listMaster.add(new ComboItemModel("01", "한국",""));
	listMaster.add(new ComboItemModel("02", "캐나다",""));
	request.setAttribute("listMaster", listMaster);
	

	List<ComboItemModel> listDetail = new ArrayList<ComboItemModel>();
	listDetail.add(new ComboItemModel("011", "서울","01"));
	listDetail.add(new ComboItemModel("012", "경기","01"));
	listDetail.add(new ComboItemModel("021", "BC","02"));
	listDetail.add(new ComboItemModel("022", "Ontario","02"));
	listDetail.add(new ComboItemModel("023", "Quebec","02"));
	request.setAttribute("listDetail", listDetail);
	//model.add("customsList", list);

%>

<t:ExtComboStore comboType="AU" comboCode="CB20" />

<t:ExtComboStore items="${list}" storeId="CUS01" />
<t:ExtComboStore items="${listMaster}" storeId="CUS_M" />
<t:ExtComboStore items="${listDetail}" storeId="CUS_D" />

<script type="text/javascript">
	Ext.onReady(function() {
		var panelSearch = {
			xtype : 'uniSearchForm',
			id : 'searchForm',
			layout : {type : 'table',columns : 3},
			items : [  {
					fieldLabel : '고객구분(AU_CB20)',
					name : 'GUBUN',
					xtype : 'uniCombobox',
					store: Ext.data.StoreManager.lookup('CBS_AU_CB20'),
					comboType : 'AU',
					comboCode : 'CB20',
					allowBlank : true
				}, {
					fieldLabel : '유형분류(중)',
					name : 'LEVEL2',
					xtype : 'uniCombobox',
					comboType : 'AU',
					comboCode : 'CB20',
					allowBlank : false
				}, {
					fieldLabel : '유형분류(소)',
					name : 'LEVEL3',
					xtype : 'uniCombobox',
					comboType : 'AU',
					comboCode : 'CB22'
				}, {
					fieldLabel : '사용자 정의(alowBlank:true) ',
					name : 'LEVEL3',
					xtype : 'uniCombobox',
					allowBlank: true,
					store: Ext.data.StoreManager.lookup('CUS01')
				}, {
					fieldLabel : '국가 ',
					name : 'country',
					xtype : 'uniCombobox',
					allowBlank: false,
					store: Ext.data.StoreManager.lookup('CUS_M'),
					child:'cmbsec'
				} , {
					fieldLabel : '주 ',
					name : 'state',
					id: 'cmbsec',
					xtype : 'uniCombobox',
					allowBlank: false,
					store: Ext.data.StoreManager.lookup('CUS_D')
				}  ]
		};

		var app = Ext.create('Unilite.com.BaseApp', {
			items : [ panelSearch ]
			
		});

	});
</script>