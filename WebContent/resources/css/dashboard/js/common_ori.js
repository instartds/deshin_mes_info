/**
 * 
 */
function fnBind(container, data) {
	if(container == null || typeof container == 'undefined') {
		alert('연결이 잘못되었습니다.1');
		return;
	}
	
	if(data == null || typeof data == 'undefined') {
		alert('연결이 잘못되었습니다.2');
		return;
	}
	
	var containerBody = container.getElementsByTagName('tbody')[0];
	for(var lRow = 0; lRow < data.length; lRow++) {
		var row = containerBody.insertRow(containerBody.rows.length);
		
		for(var lCol = 0; lCol < container.getElementsByTagName('th').length; lCol++) {
			var cellInfo = container.getElementsByTagName('th')[lCol];
			var cell = row.insertCell(lCol);
			
			if(cellInfo.hasAttribute('data-name')) {
				var dataName = cellInfo.getAttribute('data-name');
				
				if(data[lRow].hasOwnProperty(dataName)) {
					var cellValue = data[lRow][dataName];
					
					if(cellInfo.hasAttribute('cell-type')) {
						cellValue = fnFormatCellData(cellValue, cellInfo.getAttribute('cell-type'));
					}

					if(cellInfo.hasAttribute('cell-suffix')) {
						cellValue = cellValue + ' ' + cellInfo.getAttribute('cell-suffix');
					}
					
					cell.innerHTML = cellValue;
				}
				else {
					cell.innerHTML = '&nbsp;';
				}
			}
			else {
				cell.innerHTML = '&nbsp;';
			}

			if(cellInfo.hasAttribute('cell-align')) {
				cell.style.textAlign = cellInfo.getAttribute('cell-align');
			}
			
		}
	}
}

function fnBindCardView(container, data, titleField, fields) {
	if(fields == null || typeof fields == 'undefined') {
		fields = '';
	}
	
	if(data == null || data == '' || data.length < 1) {
		alert('연결이 잘못되었습니다.3');
		return;
	}
	
	if(fields == '') {
		var fieldsRef = data[0];
		var lLoop = 0;
		fields = [];
		for(var key in fieldsRef) {
			fields[lLoop++] = key;
		}
	}
	
	for(var lCard = 0; lCard < data.length; lCard++) {
		var newEl = document.createElement('li');
		newEl.id = 'liCardView_' + String(lCard);
		
		var elDiv = document.createElement('div');
		elDiv.id = 'divCardView_' + String(lCard);
		
		var divDl = document.createElement('dl');
		
		for(var lData = 0; lData < fields.length; lData++) {
			if(!data[lCard].hasOwnProperty(fields[lData])) {
				continue;
			}
			
			var dlDd = document.createElement('dd');
			var ddHeader = document.createElement('strong');
			var ddTextH = document.createTextNode(fields[lData]);
			var ddTextD = document.createTextNode(data[lCard][fields[lData]]);
			
			ddHeader.appendChild(ddTextH);

			dlDd.appendChild(ddHeader);
			dlDd.appendChild(ddTextD);
			
			divDl.appendChild(dlDd);
		}

		elDiv.appendChild(divDl);
		newEl.appendChild(elDiv);
		
		container.appendChild(newEl);
	}
}

function fnFormatCellData(val, formatType) {
	if(formatType == 'price') {
		val = val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	return val;
}

