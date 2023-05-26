

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <title>TRA Cargo Management System (House Manifest)</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
    
    <script type="text/javascript">
        var CPATH ='/tra_cmi';
    </script>
    <link rel="stylesheet" type="text/css" href="/tra_cmi/css/co/default.css" />
    <link rel="stylesheet" type="text/css" href="/tra_cmi/css/co/jquery-ui-1.8.4.custom.css" />
    <link rel="stylesheet" type="text/css" href="/tra_cmi/css/co/jqueryLayout.css" />
    <link rel="stylesheet" type="text/css" href="/tra_cmi/css/cm/crg_common.css" />
    
    <link rel="stylesheet" type="text/css" href="/tra_cmi/css/jqgrid/ui.jqgrid.css" />

    <script type="text/javascript" src="/tra_cmi/js/jquery/jquery-1.6.2.js" ></script>

    <script type="text/javascript" charset="utf-8" src="/tra_cmi/js/lib/jquery-ui-1.8.6.custom.min.js"></script>
    <script type="text/javascript" src="/tra_cmi/js/lib/jquery.ui.datepicker-en-GB.js"></script>
    <script type="text/javascript" src="/tra_cmi/js/lib/jquery.layout.js" ></script>
    <!-- Input Mask -->
    <script type="text/javascript" src="/tra_cmi/js/jquery/jquery.inputmask.js" ></script>
    <script type="text/javascript" src="/tra_cmi/js/jquery/jquery.inputmask.extentions.js" ></script>
    <script type="text/javascript" src="/tra_cmi/js/jquery/jquery.maskMoney.js" ></script>
    <script type="text/javascript" src="/tra_cmi/js/jquery/jquery.inputmask.default.js" ></script>
    <!-- 
    <script type="text/javascript" src="/tra_cmi/js/lib/jquery.maskedinput-1.2.2.min.js" ></script>
     //-->
    <script type="text/javascript" src="/tra_cmi/js/cm/jqueryUiCustoms.js" ></script>
    <script type="text/javascript" src="/tra_cmi/js/cm/cm_common.js" ></script>
    <script type="text/javascript" src="/tra_cmi/js/cm/message_en.js" ></script>
    
    <script type="text/javascript" src="/tra_cmi/js/jqgrid/i18n/grid.locale-en.js" ></script>
    <script type="text/javascript" src="/tra_cmi/js/jqgrid/jquery.jqGrid.src.js"></script>

    
<script type="text/javascript">
	$(function() {
		$("#srchValAll").change(function() {
			//Check/uncheck all the list's checkboxes
			$(".select_one").attr("checked", $(this).is(":checked"));
			//Remove the faded state
			$(this).removeClass("some_selected");
		});

		$(".select_one").change(
				function() {
					if ($(".select_one:checked").length == 0) {
						$("#srchValAll").removeClass("some_selected").attr(
								"checked", false);
					} else if ($(".select_one:not(:checked)").length == 0) {
						$("#srchValAll").removeClass("some_selected").attr(
								"checked", true);
					} else {
						$("#srchValAll").addClass("some_selected").attr(
								"checked", true);
					}
				});
	});
</script>
<style>

</style>
    <!-- modal dialog -->
    <base target="_self"/>
</head>
<body id="body"     onload="">

    
    


    <div class="ui-layout-center">
        <div class="body_wrapper">
        
             <h1>
                 <strong>House Manifest</strong>
             </h1>                  
            <ul class="location"><li><a href="#">Cargo Mng.(External)</a></li><li><a href="#">Manifest Management</a></li><li><a href="#">Import Manifest</a></li><li>House Manifest</li></ul>        
        
        
















<!-- Tab -->
<div id="tabs">
    <ul>
        <li><a href="#tab-index">M B/L List</a></li>
    </ul>

    <!-- tab-index -->
    <div id="tab-index">
    <span class="ui-icon ui-icon-newwin" onclick="alert('x')"></span>
        <form name="formSearch" onsubmit="javascript:doSearch();" action="/tra_cmi/cme/manifest/Import/HouseManifest/selectMblList.do" method="post">
            <input type='hidden' name='miv_pageNo' value="1" />
            <input type='hidden' name='miv_pageSize' value="15" />
            <input type='hidden' name='LISTOP' value="%7B%22miv_end_index%22%3A%2215%22%2C%22srchVal4%22%3Anull%2C%22srchVal3%22%3Anull%2C%22srchStartDate%22%3Anull%2C%22srchVal2%22%3Anull%2C%22miv_pageSize%22%3A%2215%22%2C%22srchEndDate%22%3Anull%2C%22srchKey1%22%3Anull%2C%22miv_sort%22%3A%22%22%2C%22srchKey2%22%3Anull%2C%22miv_start_index%22%3A%220%22%2C%22miv_pageNo%22%3A%221%22%2C%22srchVal3Nm%22%3Anull%7D" /> 
            <input type='hidden' id="isFirst" name='isFirst' value="F" /> 
            <input type="hidden" id="mblNo" name="mblNo" /> 
            <input type="hidden" id="mrn" name="mrn" /> 
            <input type="hidden" id="itemSqnc" name="itemSqnc" /> 
            <input type="hidden" id="jobType" name="jobType" />
            <!-- Search Area  -->
            <div id="search" class="search_area">
                <div class="search_panel">
                    <fieldset>
                        <legend>
                            Search
                        </legend>
                        <table class="panel">
                            <colgroup>
                                <col width="15%" />
                                <col width="30%" />
                                <col width="15%" />
                                <col width="30%" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <!-- Date of Arrival, Date of Departure , Date of Submission -->
                                    <th><select name="srchKey1" class="srchBox">
                                            <option value="ARRVL_DT"
                                                >
                                                Date of Arrival
                                            </option>
                                            <option value="DPRTR_DT"
                                                >
                                                Date of Departure
                                            </option>
                                            <option value="SBMT_DT"
                                                >
                                                Date of Submission
                                            </option>
                                    </select></th>
                                    <td colspan="4">
                                       <input id="srchStartDate" name="srchStartDate" type="text" class="datepicker mask_date" value="" />
                                        - <input id="srchEndDate" name="srchEndDate" type="text" class="datepicker mask_date" value="" /> 
                                        <span><button type="button" class="date_button" title="Last Month" onclick="datepicker.controlDate('srchStartDate', 'srchEndDate', '-1m');">-1M</button><button type="button" class="date_button" title="Last Week" onclick="datepicker.controlDate('srchStartDate', 'srchEndDate', '-7d');">-1W</button><button type="button" class="date_button" title="Today" onclick="datepicker.controlDate('srchStartDate', 'srchEndDate', 'today');">Today</button><button type="button" class="date_button" title="Next Week" onclick="datepicker.controlDate('srchStartDate', 'srchEndDate', '+7d');">+1W</button></span> 
                                    </td>
                                </tr>
                                <tr>
                                    <!-- MRN, Voyage, Vessel Name -->
                                    <th><select name="srchKey2" class="srchBox">
                                            <option value="MBL"
                                                >
                                                M B/L
                                            </option>
                                            <option value="MRN"
                                                >
                                                MRN
                                            </option>
                                            
                                    </select></th>
                                    <td><input type="text" class="text" id="srchVal2" name="srchVal2" value="" /></td>

                                    <!-- Port of Departure -->
                                    <th>Port of Departure</th>
                                    <td colspan="2">
                                        <input type="text" class="text" id="srchVal3Nm" name="srchVal3Nm" value=""  />
                                        <input type="hidden" name="srchVal3" id="srchVal3"  value="" />
                                    </td>
                                </tr>
                                <tr>
                                    <!-- Status -->
                                    <th>Status</th>
                                    <td colspan="3">
   
<label>All : <input type="checkbox"   id="srchValAll" class="checkbox" value="CO"  safari=1   />  </label>  
<input type="checkbox"  name="srchVal4" id="srchVal4" class="checkbox select_one" value="CO"  checked="checked"  />&nbsp;CONSOLIDATING &nbsp;&nbsp;&nbsp;
<input type="checkbox"  name="srchVal4" id="srchVal4" class="checkbox select_one" value="CL"  checked="checked"  />&nbsp;CLOSED &nbsp;&nbsp;&nbsp;
<input type="checkbox"  name="srchVal4" id="srchVal4" class="checkbox select_one" value="SM"   />&nbsp;SUBMITTED &nbsp;&nbsp;&nbsp;
<input type="checkbox"  name="srchVal4" id="srchVal4" class="checkbox select_one" value="RE"  checked="checked"  />&nbsp;RECEIVED &nbsp;&nbsp;&nbsp;
<input type="checkbox"  name="srchVal4" id="srchVal4" class="checkbox select_one" value="ER"  checked="checked"  />&nbsp;ERROR &nbsp;&nbsp;&nbsp;
<input type="checkbox"  name="srchVal4" id="srchVal4" class="checkbox select_one" value="AP"  checked="checked"  />&nbsp;APPROVAL <br />
                                    </td>
                                    <td align="right">
                                        <div class="button_panel">
                                            <button class="button" type="submit"  onclick="javascript:doSearch();">
                                                Search
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </div>
            </div>
   
</form>

        </div><!-- body_wrapper -->
    </div><!-- ui-layout-center -->
</body>
</html>
