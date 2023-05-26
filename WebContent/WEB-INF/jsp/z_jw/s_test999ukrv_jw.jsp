
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_test999ukrv_jw"	>

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

</style>
<script type="text/javascript" >


var available_printers = null;
var selected_category = null;
var default_printer = null;
var selected_printer = null;
var format_start = "^XA";
var format_end = "^XZ";
var default_mode = true;

function setup_web_print()
{
//	$('#printer_select').on('change', onPrinterSelected);
//	showLoading("Loading Printer Information...");
	default_mode = true;
	selected_printer = null;
	available_printers = null;
	selected_category = null;
	default_printer = null;
	
	BrowserPrint.getDefaultDevice('printer', function(printer)
	{
		default_printer = printer
		if((printer != null) && (printer.connection != undefined))
		{
			selected_printer = printer;
//			var printer_details = $('#printer_details');
//			var selected_printer_div = $('#selected_printer');
//			
//			selected_printer_div.text("Using Default Printer: " + printer.name);
//			hideLoading();
//			printer_details.show();
//			$('#print_form').show();

		}
		BrowserPrint.getLocalDevices(function(printers)
			{
				available_printers = printers;
//				var sel = document.getElementById("printers");
				var printers_available = false;
//				sel.innerHTML = "";
				if (printers != undefined)
				{
					for(var i = 0; i < printers.length; i++)
					{
						if (printers[i].connection == 'usb')
						{
//							var opt = document.createElement("option");
//							opt.innerHTML = printers[i].connection + ": " + printers[i].uid;
//							opt.value = printers[i].uid;
//							sel.appendChild(opt);
							printers_available = true;
						}
					}
				}
				
				if(!printers_available)
				{
					alert('No Zebra Printers could be found!');
//					showErrorMessage("No Zebra Printers could be found!");
//					hideLoading();
//					$('#print_form').hide();
					return;
				}
				else if(selected_printer == null)
				{
					default_mode = false;
					changePrinter();
//					$('#print_form').show();
//					hideLoading();
				}
			}, undefined, 'printer');
	}, 
	function(error_response)
	{
		showBrowserPrintNotFound();
	});
};
function showBrowserPrintNotFound()
{
	alert('An error occured while attempting to connect to your Zebra Printer. You may not have Zebra Browser Print installed, or it may not be running. Install Zebra Browser Print, or start the Zebra Browser Print Service, and try again.');
//	showErrorMessage("An error occured while attempting to connect to your Zebra Printer. You may not have Zebra Browser Print installed, or it may not be running. Install Zebra Browser Print, or start the Zebra Browser Print Service, and try again.");
	
};
function sendData(value)
{
//	showLoading("Printing...");
	checkPrinterStatus( function (text){
		if (text == "Ready to Print")
		{
			selected_printer.send(format_start + value + format_end/*, printComplete, printerError*/);
		}
		else
		{
			printerError(text);
		}
	});
};
function checkPrinterStatus(finishedFunction)
{
	selected_printer.sendThenRead("~HQES", 
				function(text){
						var that = this;
						var statuses = new Array();
						var ok = false;
						var is_error = text.charAt(70);
						var media = text.charAt(88);
						var head = text.charAt(87);
						var pause = text.charAt(84);
						// check each flag that prevents printing
						if (is_error == '0')
						{
							ok = true;
							statuses.push("Ready to Print");
						}
						if (media == '1')
							statuses.push("Paper out");
						if (media == '2')
							statuses.push("Ribbon Out");
						if (media == '4')
							statuses.push("Media Door Open");
						if (media == '8')
							statuses.push("Cutter Fault");
						if (head == '1')
							statuses.push("Printhead Overheating");
						if (head == '2')
							statuses.push("Motor Overheating");
						if (head == '4')
							statuses.push("Printhead Fault");
						if (head == '8')
							statuses.push("Incorrect Printhead");
						if (pause == '1')
							statuses.push("Printer Paused");
						if ((!ok) && (statuses.Count == 0))
							statuses.push("Error: Unknown Error");
						finishedFunction(statuses.join());
			}, printerError);
};
function hidePrintForm()
{
	$('#print_form').hide();
};
function showPrintForm()
{
	$('#print_form').show();
};
function showLoading(text)
{
	$('#loading_message').text(text);
	$('#printer_data_loading').show();
	hidePrintForm();
	$('#printer_details').hide();
	$('#printer_select').hide();
};
function printComplete()
{
	hideLoading();
	alert ("Printing complete");
}
function hideLoading()
{
	$('#printer_data_loading').hide();
	if(default_mode == true)
	{
		showPrintForm();
		$('#printer_details').show();
	}
	else
	{
		$('#printer_select').show();
		showPrintForm();
	}
};
function changePrinter()
{
	default_mode = false;
	selected_printer = null;
	$('#printer_details').hide();
	if(available_printers == null)
	{
		showLoading("Finding Printers...");
		$('#print_form').hide();
		setTimeout(changePrinter, 200);
		return;
	}
	$('#printer_select').show();
	onPrinterSelected();
	
}
function onPrinterSelected()
{
	selected_printer = available_printers[$('#printers')[0].selectedIndex];
	//$('#printers')[0].selectedIndex 선택된 프린트 
}
//function showErrorMessage(text)
//{
//	$('#main').hide();
//	$('#error_div').show();
//	$('#error_message').html(text);
//}
function printerError(text)
{
	alert('An error occurred while printing. Please try again.'+ text);
//	showErrorMessage("An error occurred while printing. Please try again." + text);
}
function trySetupAgain()
{
	$('#main').show();
	$('#error_div').hide();
	setup_web_print();
	//hideLoading();
}


function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 6},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'component',
			width: 50
		},{
			xtype	: 'button',
			text	: '라벨출력',
			id		: 'btnPrint',
			width	: 80,
			handler	: function() {

			var ZPLString = "";
//				ZPLString += "^XA";
            ZPLString += "^SEE:UHANGUL.DAT^FS";
            ZPLString += "^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
            ZPLString +="^PW550";		//라벨 가로 크기관련

            ZPLString +="^LH45,20^FS";
			ZPLString +="^FO0,0^GB500,370,4^FS";
            
            ZPLString +="^FO0,50^GB500,0,4^FS";
            ZPLString +="^FO0,120^GB500,0,4^FS";
            ZPLString +="^FO0,170^GB500,0,4^FS";
            ZPLString +="^FO0,220^GB500,0,4^FS";
            ZPLString +="^FO0,270^GB500,0,4^FS";
            
            ZPLString +="^FO150,50^GB0,220,4^FS";
            
            ZPLString +="^FO120,5^ATN,8,8^FD"+"Item Description"+"^FS";
            
            ZPLString +="^FO20,75^A1N,25,25^FD"+"Item Name"+"^FS";
            
            
            var itemCode = "T001";
            var itemName = "ABCDEFGHIJKLMNOPQRSTUVWXYZ가나다라마바사";
            var spec = "테스트스펙";
            var strTrnsRate = "1";
            var stockUnit = "EA";
            var inoutDate = "2018-06-20";
            var endDate = "2018-12-20";
            var lotNo = "A18062000037";
            
            var DataMatrix = itemCode + "|" + lotNo + "|" + "1";//String.format("%."+ nvl(paramData.get("QTY_FORMAT")) +"f",orderUnitQ);
            
            if(itemName.length > 17){
	            ZPLString +="^FO180,65^A1N,25,25^FD"+itemName.substring(0, 17)+"^FS";

	            ZPLString +="^FO180,90^A1N,25,25^FD"+itemName.substring(17)+"^FS";
            }else{
	            ZPLString +="^FO180,75^A1N,25,25^FD"+itemName+"^FS";
            }
            ZPLString +="^FO20,137^A1N,25,25^FD"+"Spec"+"^FS";
            ZPLString +="^FO180,137^A1N,25,25^FD"+spec+ "*" + strTrnsRate + stockUnit + "^FS";
            
            ZPLString +="^FO20,187^A1N,25,25^FD"+"In.Date"+"^FS";
            ZPLString +="^FO180,187^A1N,25,25^FD"+inoutDate+"^FS";
            
            ZPLString +="^FO20,237^A1N,25,25^FD"+"Exp.Date"+"^FS";
            ZPLString +="^FO180,237^A1N,25,25^FD"+endDate+"^FS";

            ZPLString +="^FO45,285^BXN,4,200^FD"+DataMatrix+"^FS";
            ZPLString +="^FO170,290^AUN,25,25^FD"+lotNo+"^FS";
            
            
//				setup_web_print();
				sendData(ZPLString);
			}
		}]
	});


	
	Unilite.Main({
		id: 's_test999ukrv_jwApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}],
		fnInitBinding: function(){
			setup_web_print();
		},
		onQueryButtonDown: function() {
		},
		onNewDataButtonDown: function()	{
		},

		onResetButtonDown: function() {
		},
		onSaveDataButtonDown: function(config) {
		},
		onDeleteDataButtonDown: function() {
		},
		onDeleteAllButtonDown: function() {
		},
		checkForNewDetail:function() {
		},
		setDefault: function() {
		}
	});
};
</script>