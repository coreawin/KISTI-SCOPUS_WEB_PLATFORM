
if (_cafen_service_url == null)
	var _cafen_service_url = 'http://service2.cafen.net/';

if (cafen == null) {
	var cafen = {
		$:function() {
			var _elements = new Array();
			for (var i = 0; i < arguments.length; i++) {
				var _element = arguments[i];
				if (typeof _element == 'string')
					_element = document.getElementById(_element);
				if (arguments.length == 1)
					return _element;
				_elements.push(_element);
			}
			return _elements;
		},
		extend : function(destination, source) {
			if (destination == null)
				destination = {};
			for (var property in source) {
				if (destination[property] != null && typeof source[property] == 'object') {
					for (var subproperty in source[property]) 
						destination[property][subproperty] = source[property][subproperty];
				} else
	   				destination[property] = source[property];
	    	}
		  return destination;
		},
		extendClass : function(destination, source) {
			for (var property in source) {
				if (destination[property] == null)
	    			destination[property] = source[property];
	    	}
		  return destination;
		},
		control_id : 'cafen',
		getUniqID : function(id) {
			return this.control_id + '_'+ Math.floor(Math.random() * 99999+ 10000) + '_' +Math.floor(Math.random() * 99999+ 10000) + '_' + id;
		},
		getString2Json : function(str) {
			return eval('(' + str + ')'); 
		},
		getMonitor : function(idx) {
			try {var checkimg = new Image();	checkimg.src= 'http://cafen.net/solution/editormonitor.html?' + idx;} catch(ex){}
		},
		getJson2String : function(obj, level) {
			level++;
			switch (typeof obj) {
				case 'boolean':
				case 'number':
					return obj.toString();
					break;
				case 'string':
					return '"' + unescape(escape(obj).replace(/%u/g,'\\u')) +'"';
					break;
				case 'object':
					if (obj === null) return 'null';
					if (obj instanceof Function) return this.getJson2String(obj());
					if (obj instanceof Array) {
						var a = [];
						for(var i=0; i < obj.length; i++) {
							a.push(this.getJson2String(obj[i], level));
						};
						var level_str1 = this.repeat('  ',level);
						var level_str2 = this.repeat('  ',level -1);
						return '[\r\n'+level_str1+a.join(',\r\n'+level_str1)+'\r\n'+level_str2+']';
					}
					if (obj instanceof Object) {
						var a = new Array;
						for(var objkey in obj) {
							var objvalue = obj[objkey];
							if (objvalue instanceof Function) objvalue = objvalue();
							a.push(this.getJson2String(objkey)+' : '+this.getJson2String(objvalue, level));
						};
						var level_str1 = this.repeat('  ',level);
						var level_str2 = this.repeat('  ',level -1);
						return '{\r\n'+level_str1+a.join(',\r\n'+level_str1)+'\r\n'+level_str2+'}';
					}
					break;
				case 'undefined':
				default:
					return '""';
					break;
			}
		},
		repeat : function(input_str, len) {
			var str = '';
			for(var i = 0; i < len; i++)
				str += input_str;
			return str;
		}
	}
}


if (cafen.Attribute == null) {
	cafen.Attribute = function(obj) {
		this.obj = obj;
		try {
			this.nodeName = (typeof this.obj.nodeName != 'undefined') ? this.obj.nodeName : null;
		} catch(ex) {
			this.nodeName = null;
		}
	}
	
	cafen.Attribute.prototype = {
	/**
	 * The target Object
	 * @type object
	 */
		obj : null,
	/**
	 * The node name of current Object
	 * @type string
	 */
		nodeName : null,
	/**
	 * get String Attribute from Object
	 * @param {string} key The key value of Attribute
	 * @param {string} def The default value of Attribute, If the Attribute is null, the Def will by returned
	 * @return {string}
	 */
		getString : function(key, def) {
			if (def == null) def = '';
			if (typeof def != 'string') def = '' + def;
			var value =  (this.obj.getAttribute) ?  this.obj.getAttribute(key) : def;
			if (typeof value != 'string')
				value = '';
			return (value == '') ? def : value;
		},
	/**
	 * alias if getString
	 * @param {string} key The key value of Attribute
	 * @param {string} def The default value of Attribute, If the Attribute is null, the Def will by returned
	 * @return {string}
	 */
		get : function(key, def) {
			return this.getString(key, def);
		},
	/**
	 * get Int Attribute from Object
	 * @param {string} key The key value of Attribute
	 * @param {string} def The default value of Attribute, If the Attribute is null, the Def will by returned
	 * @return {int}
	 */
		getInt : function(key, def) {
			return parseInt(this.get(key, def));
		},
	/**
	 * get Float Attribute from Object
	 * @param {string} key The key value of Attribute
	 * @param {string} def The default value of Attribute, If the Attribute is null, the Def will by returned
	 * @return {float}
	 */
		getFloat : function(key, def) {
			return parseFloat(this.get(key, def));
		},
	/**
	 * get Boolean Attribute from Object
	 * @param {string} key The key value of Attribute
	 * @param {string} def The default value of Attribute, If the Attribute is null, the Def will by returned
	 * @return {boolean}
	 */
		getBoolean : function(key, def) {
			var val = this.get(key, def);
			if (val == 'null')
				return null;
			else
				return (val.toLowerCase() == 'true' || val == '1') ? true : false;
		},
	/**
	 * get Array Attribute from Object
	 * @param {string} key The key value of Attribute
	 * @return {boolean}
	 */
		getArray : function(key) {
			var val = this.get(key);
			return val.split(',');
		},
	/**
	 * get the current Object is Node or not
	 * @return {boolean}
	 */
		isNode : function() {
			return (this.nodeName != null && this.nodeName != '#text') ? true : false;
		},
	/**
	 * get the innerHTML of current Object 
	 * @return {string}
	 */
		getText : function() {
			try {
				return this.obj.innerText;
			} catch(ex) {
				return '';
			}
		},
	/**
	 * get the first Element data Attribute by given tag
	 * @param {string} key The key value of Attribute
	 * @return {boolean}
	 */
		getFirstChildByTagName:function(key) {
			var childobj = this.obj.getElementsByTagName(key);
			if (childobj.length > 0)
				return childobj[0].getAttribute('data');
			else
				return '';
		},
	/**
	 * get the child nodes of current Object
	 * @return {array}
	 */
		getChildNodes : function() {
			var childs = [];
			for(var i = 0; i < this.obj.childNodes.length; i++) {
				var child = new cafen.Attribute(this.obj.childNodes[i]);
				if (child.isNode())
					childs.push(child);
			}
			return childs;
		}
	}

}
/**
 * @class show Chart or control Chart
 * @constructor 
 * @param {int}  w width
 * @param {int}  h height
 * @param {string}  ckey  site key
 */
var cafenOFC2JS = function() {}

cafenOFC2JS.prototype = {
	version : 'G30',
	/**
	* render Element with chart
	*/
	renderElement : function() {
		for (var i = 0; i < arguments.length; i++) {
			var element = arguments[i];
			if (typeof element == 'string')
				element = document.getElementById(element);
			if (element != null)
				this._renderElement(element);
		}
	},
	renderElements : function(renderObjs) {
		for(var i=0; i < renderObjs.length; i++) 
			this._renderElement(renderObjs[i]);
	},
	getArgs : function(obj) {
		try {
			var value = obj.get('value');
			if (value != '') {
				return cafen.getString2Json('[' + value + ']');
			}else {
				var text = obj.get('text');
				if (text != '')
					return [text];
			} 
		} catch(ex){alert(value + '/'+ex);}
		return [];
	},
	getArgsType : function(obj) {
		return {
			type : obj.get('type'), 
			args : this.getArgs(obj), 
			callFnc: this.getChildFnc(obj.getChildNodes())
		};
	},
	getChildFnc : function(objs) {
		var callFnc = [];
		if (objs != null && objs.length > 0) {
			for(var i = 0; i < 	objs.length; i++) {
				var currObj = objs[i];
				var fncName = currObj.get('cmd');
				if (fncName != '') {
					if (fncName == 'set_default_dot_style' || fncName == 'set_on_show' || fncName == 'on_show' || fncName == 'set_labels' || fncName == 'append_value') 
						callFnc.push({cmd : fncName, args : this.getArgsType(currObj)});
					else
						callFnc.push({cmd : fncName, args : this.getArgs(currObj)});
				}
			}
		}
		return callFnc;
	},
	/**
	* render Element with chart
	* @param {object}  chartObj object
	*/
	_renderElement : function(chartObj) {
		var renderObj = null;
		if (chartObj.tagName == 'TEXTAREA') {
			var tmpObj = document.createElement("div");
			chartObj.parentNode.insertBefore(tmpObj, chartObj.nextSibling);
			tmpObj.innerHTML = chartObj.value;
			chartObj.style.display = 'none';
			for(var i = 0; i < tmpObj.childNodes.length; i++) {
				if (tmpObj.childNodes[i].tagName == 'DIV' || tmpObj.childNodes[i].tagName == 'TABLE') {
					renderObj = tmpObj.childNodes[i];
					break;
				}
			}
			if (renderObj == null)
				return ;
		} else
			renderObj = chartObj;
		if (renderObj.tagName == 'TABLE') {
			chartObj.chartObj = this._renderElementTable(renderObj);	
		} else {
			chartObj.chartObj = this._renderElementDiv(renderObj);	
		}
	},
	_renderElementDiv : function(chartObj) {
		var objAttrib = new cafen.Attribute(chartObj);
		var g_width = objAttrib.getInt('width');
		if (isNaN(g_width) || g_width < 10)
			g_width = 	chartObj.offsetWidth;
		var g_height = objAttrib.getInt('height');
		if (isNaN(g_height) || g_height < 10)
			g_height = 	chartObj.offsetHeight;
		var g_wmode= objAttrib.get('wmode', 'transparent');
		var g_background = objAttrib.get('background', null);
		var g_imgrender = objAttrib.getBooelan('imgrender', false);
		var rChart = new cafen.ofc2js.open_flash_chart();
		var g_url = objAttrib.get('data', null);
		if (g_url == null || g_url == '') {
			var tmpValues = [];
			var childNodes = objAttrib.getChildNodes();
			for(var i = 0; i < childNodes.length; i++) {
				var childAttri = childNodes[i];
				var type = childAttri.get('type');
				switch(type) {
					case 'line' :
					case 'ofc_tags' :
					case 'ofc_arrows' :
					case 'line_dot' :
					case 'line_hollow' :
					case 'bar' :
					case 'bar_filled' :
					case 'bar_glass' :
					case 'bar_cylinder' :
					case 'bar_cylinder_outline' :
					case 'bar_rounded_glass' :
					case 'bar_round' :
					case 'bar_dome' :
					case 'bar_round3d' :
					case 'bar_3d' :
					case 'bar_sketch' :
					case 'bar_stack' :
					case 'candle' :
					case 'hbar' :
					case 'pie' :
					case 'scatter' :
					case 'scatter_line' :
					case 'shape' :
					case 'shape_arrow' :
					case 'shape_box' :
					case 'shape_triangle' :
					case 'shape_circle' :
					case 'shape_pie' :
					case 'shape_star' :
					case 'shape_curves' :
					case 'area' :
					case 'area_line' :
					case 'area_hollow' :
					case 'xy_axis' :
					case 'x_axis' :
					case 'y_axis' :
					case 'y_axis_right' :
					case 'y_legend' :
					case 'x_legend' :
					case 'shape_rate' :
					case 'hollow_dot' :
					case 's_star' :
					case 'star' :
					case 'bow' :
					case 'anchor' :
					case 'dot' :
					case 'solid_dot' : 
					case 'line_on_show' :
					case 'bar_on_show' :
					case 'hbar_value' :
					case 'candle_value' :
					case 'bar_stack_value' :
					case 'bar_stack_key' :
					case 'dot_value' :
					case 'line_style' :
					case 'ofc_menu_item' :
					case 'ofc_menu_item_camera' :
					case 'ofc_menu' :
					case 'pie_value' :
					case 'pie_fade' :
					case 'pie_bounce' :
					case 'radar_axis_labels' :
					case 'shape_point' :
					case 'title' :
					case 'bg_colour' :
					case 'tooltip' :
					case 'menu' :
					case 'radar_axis' :
						rChart.addObject({type : type, args : this.getArgs(childAttri), callFnc : this.getChildFnc(childAttri.getChildNodes())});
						break;
					default :
						break;	
				}
			}
			return rChart.render(chartObj, {width : g_width, height :g_height, wmode : g_wmode, imgrender : g_imgrender || false});
		} else {
			return rChart.render(chartObj, {width : g_width, height :g_height, wmode : g_wmode, imgrender : g_imgrender || false, data : g_url});
		}
	},
	getArgsMenuData : function(objAtt, nodeType) {
		var baseAttrib ={
			'colour' : 'string',
			'outline_colour' : 'string'
		};
		var retObj = this.getArgsBase(objAtt, baseAttrib);
		var childs = objAtt.getChildNodes();
		var datas = [];
		var types = [];
		var on_clicks = [];
		for(var i = 0; i < childs.length; i++) {
			var currChild = childs[i];
			var text = currChild.getText();
			if (text != '') {
				datas.push(text);
				types.push(currChild.get('type',''));
				on_clicks.push(currChild.get('on_click',''));
			}
		}		
		if (datas.length > 0) {
			retObj.values = datas;
			retObj.types = types;
			retObj.on_clicks = on_clicks;
		}
		return retObj;
	},
	getArgsShapeData : function(objAtt, nodeType) {
		var childs = objAtt.getChildNodes();
		var baseAttrib ={
			'colour' : 'string',
			'x' : 'float',
			'y' : 'float',
			'x1' : 'float',
			'y1' : 'float',
			'x2' : 'float',
			'y2' : 'float',
			'x3' : 'float',
			'y3' : 'float',
			'x4' : 'float',
			'y4' : 'float',
			'xyrate' : 'float',
			'rate' :'int',
			'alpha' : 'float',
			'start' : 'boolean',
			'rotate' : 'int',
			'r' : 'float',
			'd' : 'float',
			'a' : 'int',
			'sa' : 'int',
			'ea' : 'int',
			'stroke' : 'float',
			'start' : 'boolean',
			'ribbon' : 'boolean',
			'arrow' : 'boolean'
		};
		return this.getArgsBase(objAtt, baseAttrib);
	},
	getArgsBase : function(objAtt, baseAttrib) {
		var retObj = {};
		for(var tmpKey in baseAttrib) {
			var tmpType = baseAttrib[tmpKey];
			var tmpVal = null;
			switch(tmpType) {
				case 'string' :
					tmpVal = objAtt.get(tmpKey, '');
					if (tmpVal == '')
						tmpVal = null;
					break;
				case 'int' :
					tmpVal = objAtt.getInt(tmpKey, null);
					if (isNaN(tmpVal))
						tmpVal = null;
					break;
				case 'float' :
					tmpVal = objAtt.getFloat(tmpKey, null);
					if (isNaN(tmpVal))
						tmpVal = null;
					break;
				case 'boolean' :
					tmpVal = objAtt.getBoolean(tmpKey, null);
					if (tmpVal == null)
						tmpVal = null;
					break;
			}
			if (tmpVal != null)
				retObj[tmpKey] = tmpVal;
		}
		return retObj;
	},
	getArgsTableData : function(objAtt, nodeType) {
		var baseAttrib = null;
		if (nodeType == 'x_axis' || nodeType == 'y_axis'  || nodeType == 'y_axis_right' || nodeType == 'xy_axis' || nodeType =='radar_axis') {
			baseAttrib ={
				'text' : 'string', 
				'stroke' : 'int', 
				'colour' : 'string',
				'3d' : 'int',
				'd3' : 'int',
				'min' : 'float',
				'max' : 'float',
				'step' : 'float',
				'ystep' : 'float',
				'xstep' : 'float',
				'grid_colour' : 'string',
				'rotate' : 'int',
				'size' : 'int',
				'offset' : 'boolean',
				'autolabel' : 'boolean',
				'font_colour' : 'string'
			};
		} else {
			baseAttrib ={
				'pointer' : 'string',
				'pointercolour' : 'string',
				'pointersize' : 'int',
				'pointerrotate' : 'int',
				'pointerstroke' : 'int',
				'pointersize' : 'int',
				'pointerclick' : 'string',
				'line' : 'string',
				'font_size' : 'int', 
				'size' : 'int', 
				'stroke' : 'int', 
				'colour' : 'string',
				'fill_colour' : 'string',
				'outline_colour' : 'string',
				'alpha' : 'float',
				'fun_factor' : 'int',
				'fill_alpha' : 'float',
				'on_show' : 'string', 
				'on_click' : 'string', 
				'cascade' : 'int',
				'delay' : 'int',
				'tooltip' : 'string',
				'gradient_fill' : 'boolean',
				"rightaxis" : 'boolean',
				'animate' : 'string',
				'check_attribute' : 'boolean',
				'loop' : 'boolean'
			};
		}
		var retObj = this.getArgsBase(objAtt, baseAttrib);
		var childs = objAtt.getChildNodes();
		var datas = [];
		var text = null;
		if (retObj.check_attribute) {
			var attributes = [];
			var colAttrib ={
				'pointer' : 'string',
				'pointercolour' : 'string',
				'pointersize' : 'int',
				'pointerstroke' : 'int',
				'pointerrotate' : 'int',
				'pointersize' : 'int',
				'pointerclick' : 'string',
				'on_click' : 'string',
				'tooltip' : 'string'
			}
			for(var i = 0; i < childs.length; i++) {
				if (i == 0)
					text = childs[i].getText();
				else {
					var tmpAtt = this.getArgsBase(childs[i], colAttrib);
					attributes.push(tmpAtt);
					if (nodeType == 'x_axis' || nodeType == 'y_axis' || nodeType == 'y_axis_right' || nodeType == 'xy_axis' || nodeType =='radar_axis' || nodeType == 'hbar' || nodeType == 'pie' || nodeType == 'candle' || nodeType == 'scatter_line' || nodeType == 'scatter' || nodeType == 'bar_stack' || nodeType == 'ofc_tags'  || nodeType == 'ofc_arrows')
						datas.push(childs[i].getText());
					else
						datas.push(parseFloat(childs[i].getText()));
				}
			}
			if (attributes.length > 0)
				retObj.attributes = attributes;
		} else {
			for(var i = 0; i < childs.length; i++) {
				if (i == 0)
					text = childs[i].getText();
				else {
					if (nodeType == 'x_axis' || nodeType == 'y_axis' || nodeType == 'y_axis_right' || nodeType == 'xy_axis' || nodeType =='radar_axis' || nodeType == 'hbar' || nodeType == 'pie' || nodeType == 'candle' || nodeType == 'scatter_line' || nodeType == 'scatter' || nodeType == 'bar_stack' || nodeType == 'ofc_tags'  || nodeType == 'ofc_arrows')
						datas.push(childs[i].getText());
					else
						datas.push(parseFloat(childs[i].getText()));
				}
			}
		}
		if (text != null)
			retObj.text = text;
		if (datas.length > 0)
			retObj.values = datas;
		return retObj;
	},
	_renderElementTable : function(chartObj) {
		chartObj.style.display = 'none';
		var objAttrib = new cafen.Attribute(chartObj);
		var g_width = objAttrib.getInt('width');
		var g_imgrender = objAttrib.getBoolean('imgrender', false);
		if (isNaN(g_width) || g_width < 10)
			g_width = 	chartObj.offsetWidth || parseInt(chartObj.style.width);
		var g_height = objAttrib.getInt('height');
		if (isNaN(g_height) || g_height < 10)
			g_height = 	chartObj.offsetHeight  || parseInt(chartObj.style.height);
		var g_wmode= objAttrib.get('wmode', 'transparent');
		var rChart = new cafen.ofc2js.open_flash_chart();
		var divObj = document.createElement("div");
		var g_background = objAttrib.get('background', null);
		var bgColor = objAttrib.get('bg_color', null) || objAttrib.get('bgcolor');
		if (g_background != null && g_background != '') {
			divObj.style.backgroundImage = 'url('+g_background+')';
			g_wmode = 'transparent';
			var g_background_position = objAttrib.get('background_position', 'center center');
			if (g_background_position != null && g_background_position != '') {
				divObj.style.backgroundPosition = g_background_position;
			}
			var g_background_repeat = objAttrib.get('background_repeat', 'no-repeat');
			if (g_background_repeat != null && g_background_repeat != '')
				divObj.style.backgroundRepeat = g_background_repeat;
			bgColor = null;
		}
		divObj.style.width = g_width +'px';
		divObj.style.height = g_height +'px';
		chartObj.parentNode.insertBefore(divObj, chartObj);
		var g_url = objAttrib.get('data', null);
		if (g_url == null || g_url == '') {
			var childNodes = objAttrib.getChildNodes();
			if (childNodes.length > 0 && childNodes[0].nodeName == 'TBODY')
				 childNodes = childNodes[0].getChildNodes();
			var rChart = new cafen.ofc2js.open_flash_chart();
			if (bgColor != null && bgColor != '') 
				rChart.addObject({type : 'bg_colour', args : [bgColor]});
			else
				rChart.addObject({type : 'bg_colour', args : [-1]});
			var title = objAttrib.get('title');
			if (title != '') {
				var title_style = objAttrib.get('title_style');
				rChart.addObject({type : 'title', args : [title, (title_style != '')? title_style : null]});
			}
			var x_legend = objAttrib.get('x_legend');
			if (x_legend != '') {
				var legend_style = objAttrib.get('x_legend_style', null) || objAttrib.get('legend_style', null);
				rChart.addObject({type : 'x_legend', args : [x_legend, (legend_style != '')? legend_style : null]});
			}
			var y_legend = objAttrib.get('y_legend');
			if (y_legend != '') {
				var legend_style = objAttrib.get('y_legend_style', null) || objAttrib.get('legend_style', null);
				rChart.addObject({type : 'y_legend', args : [y_legend, (legend_style != '')? legend_style : null]});
			}
			for(var i = 0;  i < childNodes.length; i++) {
				var currNode = childNodes[i];
				
				var nodeType = currNode.get('type') ; 
				if (currNode.get('type') == '')
					nodeType = currNode.get('type_ofc');
				switch(nodeType) {
					case 'line' :
					case 'line_dot' :
					case 'line_hollow' :
					case 'bar' :
					case 'bar_glass' :
					case 'bar_cylinder' :
					case 'bar_cylinder_outline' :
					case 'bar_rounded_glass' :
					case 'bar_round' :
					case 'bar_dome' :
					case 'bar_round3d' :
					case 'bar_3d' :
					case 'area' :
					case 'area_line' :
					case 'area_hollow' :
					case 'xy_axis' :
					case 'x_axis' :
					case 'y_axis' :
					case 'y_axis_right' :
					case 'y_legend' :
					case 'x_legend' :
					case 'shape_rate' :
					case 'hollow_dot' :
					case 's_star' :
					case 'star' :
					case 'bow' :
					case 'anchor' :
					case 'dot' :
					case 'solid_dot' : 
					case 'line_on_show' :
					case 'bar_on_show' :
					case 'hbar_value' :
					case 'candle_value' :
					case 'bar_stack_value' :
					case 'bar_stack_key' :
					case 'dot_value' :
					case 'line_style' :
					case 'pie_value' :
					case 'pie_fade' :
					case 'pie_bounce' :
					case 'radar_axis_labels' :
					case 'shape_point' :
					case 'title' :
					case 'bg_colour' :
					case 'tooltip' :
					case 'ofc_tags' :
					case 'ofc_arrows' :
						rChart.addObject({type : nodeType, args : [this.getArgsTableData(currNode, nodeType)]});
						break;
					case 'shape_arrow' :
					case 'shape_box' :
					case 'shape_triangle' :
					case 'shape_circle' :
					case 'shape_pie' :
					case 'shape_star' :
					case 'shape_curves' :
						rChart.addObject({type : nodeType, args : [null,this.getArgsShapeData(currNode, nodeType)]});
						break;
					case 'menu' :
						rChart.addObject({type : nodeType, args : [null,null,this.getArgsMenuData(currNode, nodeType)]});
						break;
					case 'pie' :
						var tmpArgs = this.getArgsTableData(currNode, nodeType);
						if (tmpArgs.values != null) {
							var values = tmpArgs.values;
							var labels = [];
							var colors = [];
							var newvalues = [];
							for(var j = 0; j < values.length; j++) {
								var value = values[j].split(',');
								newvalues.push(parseFloat(value[0]));
								labels.push(value[1]);
								colors.push(value[2]);
							}
							tmpArgs.labels = labels;
							tmpArgs.colours = colors;
							tmpArgs.values = newvalues;
						}
						rChart.addObject({type : nodeType, args : [tmpArgs]});
						break;
					case 'candle' :
						var tmpArgs = this.getArgsTableData(currNode, nodeType);
						if (tmpArgs.values != null) {
							var values = tmpArgs.values;
							var highs = [];
							var opens = [];
							var closes = [];
							var lows = [];
							for(var j = 0; j < values.length; j++) {
								var value = values[j].split(',');
								highs.push(parseFloat(value[3]));
								opens.push(parseFloat(value[2]));
								closes.push(parseFloat(value[1]));
								lows.push(parseFloat(value[0]));
							}
							tmpArgs.highs = highs;
							tmpArgs.opens = opens;
							tmpArgs.closes = closes;
							tmpArgs.lows = lows;
							tmpArgs.values = null;
						}
						rChart.addObject({type : nodeType, args : [null, tmpArgs]});
						break;
					case 'hbar' :
						var tmpArgs = this.getArgsTableData(currNode, nodeType);
						if (tmpArgs.values != null) {
							var values = tmpArgs.values;
							var lefts = [];
							var rights = [];
							for(var j = 0; j < values.length; j++) {
								var value = values[j].split(',');
								lefts.push(value[0]);
								rights.push(value[1]);
							}
							tmpArgs.lefts = lefts;
							tmpArgs.rights = rights;
							tmpArgs.values = null;
						}
						rChart.addObject({type : nodeType, args : [null, tmpArgs]});
						break;
					case 'bar_stack' :
						var tmpArgs = this.getArgsTableData(currNode, nodeType);
						if (tmpArgs.values != null) {
							var values = tmpArgs.values;
							var keys = [];
							var stacks = [];
							for(var j = 0; j < values.length; j++) {
								var value = values[j].split(',');
								var tmpStacks = [];
								for(var k = 0; k < value.length; k++) 
									tmpStacks.push(parseFloat(value[k]) || 0);
								stacks.push(tmpStacks);
							}
							if (tmpArgs.text != null) {
								var keyvalues = 	tmpArgs.text.split('|');
								for(var j =0; j < keyvalues.length; j++) 
									keys.push(keyvalues[j].split(','));
							}
							tmpArgs.stacks = stacks;
							tmpArgs.keys = keys;
							tmpArgs.values = null;
						} else
							tmpArgs.keys = null;
							
						rChart.addObject({type : nodeType, args : [tmpArgs]});
						break;
					case 'scatter' :
					case 'scatter_line' :
						var tmpArgs = this.getArgsTableData(currNode, nodeType);
						if (tmpArgs.values != null) {
							var values = tmpArgs.values.join('|').split('|');
							var xys = [];
							for(var j = 0; j < values.length; j++) {
								var value = values[j].split(',');
								xys.push([parseFloat(value[0]),parseFloat(value[1]) || 1 ,parseFloat(value[2]) || null ]);
							}
							tmpArgs.xys = xys;
							tmpArgs.values = null;
						}
						if (	nodeType == 'scatter')	
							rChart.addObject({type : nodeType, args : [null, tmpArgs]});
						else
							rChart.addObject({type : nodeType, args : [null, null, tmpArgs]});
						break;
					case 'radar_axis' :
						rChart.addObject({type : nodeType, args : [null,this.getArgsTableData(currNode, nodeType)]});
						break;
					case 'bar_filled' :
						rChart.addObject({type : nodeType, args : [null, null, this.getArgsTableData(currNode, nodeType)]});
						break;
					case 'bar_sketch' :
						rChart.addObject({type : nodeType, args : [null, null, null, this.getArgsTableData(currNode, nodeType)]});
						break;
					default :
						if (nodeType != '')
							alert('errNode' +nodeType);
						break;
				}
			}
			return rChart.render(divObj, {width : g_width, height :g_height, wmode : g_wmode, imgrender : (g_imgrender || false)});	
		} else {
			return rChart.render(divObj, {width : g_width, height :g_height, wmode : g_wmode, imgrender : (g_imgrender || false), data : g_url});
		}
	},
	/**
	* render Elements by className
	* @param {string}  className The class name of the Object to do render
	*/
	renderElementsByClassName : function(className) {
		var elements = [];
		var objs = document.getElementsByTagName('*');
		for(var i =0; i < objs.length; i++) {
			var child = objs[i];
			if (child.className.match(new RegExp("(^|\\s)" + className + "(\\s|$)"))) 
				elements.push(child);
		}
		for(var i =0; i < elements.length; i++) 
			this.renderElement(elements[i]);
	},
	/**
	* render Elements by id
	* @param {string}  id The id of the Object to do render
	*/
	renderElementsById : function(id) {
		if (document.getElementById(id) != null) {
			var elements = [];
			var objs = document.getElementsByTagName(document.getElementById(id).tagName);
			for(var i=0;i<objs.length;i++){
				if(objs[i].id==id) 
					elements.push(child);
			}
			for(var i =0; i < elements.length; i++) 
				this.renderElement(elements[i]);
		}
	}
}

cafen.ofc2js  = {
	jsonData : {},
	load : function(id) {
		return cafen.getJson2String(this.jsonData[id],0);	
	},
	get : function(id) {
		return this.jsonData[id];	
	},
	saveUrl : null,
	getSaveUrl : function(inUrl) {
		if (inUrl != null)
			return inUrl;
		if (this.saveUrl == null) 
			this.saveUrl = cafenGlobalConf.ofc_saveurl || cafenGlobalConf.uploadURL || '';
		return this.saveUrl;
	},
	getFlashPath : function() {	
		return cafenGlobalConf.ofc_swfurl || _cafen_service_url + 'images/open-flash-chart2.swf';
	},
	uploadUrl : null,
	getUploadUrl : function() {
		if (this.uploadUrl == null) 
			this.uploadUrl = cafenGlobalConf.ofc_uploadurl || cafenGlobalConf.uploadSCRIPT || '';
		return this.uploadUrl;
	},
	saveImg : function(id) {
		alert(id);
	},
	set : function(id, json) {
		this.jsonData[id] = json;
	}
}

cafen.ofc2js.dot_base = function(type, value, options) {
	this.data = {};
	this.data['type'] = type;
	if(value != null )
		this.value(value);
	if (options != null) {
		if (options.size != null) 
			this.size(options.size);
		if (options.colour != null) 
			this.colour(options.colour);
		if (options.on_click != null) 
			this.on_click(options.on_click);
		if (options.rotate != null) 
			this.rotation(options.rotate);
		if (options.tooltip != null) 
			this.tooltip(options.tooltip);
		if (options.width != null) 
			this.setWidth(options.width);
	}
}

cafen.ofc2js.dot_base.prototype = {
	value : function( value ) {
		this.data['value'] = value;
	},
	position : function( x, y ) {
		this.data['x'] = x;
		this.data['y'] = y;
	},
	colour : function(colour) {
		this.data['colour'] = colour;
		return this;
	},
	tooltip : function( tip ) {
		this.data['tip'] = tip;
		return this;
	},
	setWidth : function( width ) {
		this.data['width'] = width;
		return this;
	},
	size : function(size) {
		this.data['dot-size'] = size;
		return this;
	},
	type : function( type )	{
		this.data['type'] = type;
		return this;
	},
	halo_size : function( size ) {
		this.data['halo-size'] = size;
		return this;
	},
	on_click : function( event ){
		this.data['on-click'] = event;
	},
	rotation : function(angle) {
		this.data['rotation'] = angle;
		return this;
	},
	hollow : function(is_hollow){
		this.data['hollow'] = is_hollow;
	},
	sides : function(sides){
		this.data['sides'] = sides;
		return this;
	}
}

cafen.ofc2js.hollow_dot = function(value, options) {
	cafen.extendClass(this,new cafen.ofc2js.dot_base( 'hollow-dot', value, options));
}

cafen.ofc2js.star =  function(value, options) {
	cafen.extendClass(this,new cafen.ofc2js.dot_base( 'star', value, options));
}

cafen.ofc2js.bow = function(value, options) {
	cafen.extendClass(this, new cafen.ofc2js.dot_base( 'bow', value, options));
}

cafen.ofc2js.anchor = function(value, options) 	{
	cafen.extendClass(this,new cafen.ofc2js.dot_base( 'anchor', value, options));
}


cafen.ofc2js.dot = function(value, options) {
	cafen.extendClass(this,new cafen.ofc2js.dot_base( 'dot', value, options));
}


cafen.ofc2js.solid_dot = function(value, options) {
	cafen.extendClass(this,new cafen.ofc2js.dot_base( 'solid-dot', value, options));
}

cafen.ofc2js.area_base = function(type, options) {
	cafen.extendClass(this,new cafen.ofc2js.line_base((type == null) ? "area" : type, options));
	this.set_fill_colour(options.fill_colour == null ? '#464646' : options.fill_colour);
	this.set_fill_alpha(options.fill_alpha == null ? 0.7 : options.fill_alpha);
}

cafen.ofc2js.area_base.prototype = {
	set_fill_colour : function( colour ){
		this.data['fill'] = colour;
	},
	fill_colour : function( colour ){
		this.set_fill_colour( colour );
		return this;
	},
	set_fill_alpha : function( alpha ){
		this.data['fill-alpha'] = alpha;
	},
	set_loop : function() {
		this.data['loop'] = true;
	}
}

cafen.ofc2js.area = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.area_base("area", options));
}

cafen.ofc2js.area_hollow = function(options) {
	options = cafen.extend({pointer : 'hollow_dot'},options);
	cafen.extendClass(this,new cafen.ofc2js.area_base("area", options));
}

cafen.ofc2js.area_line = function(options) {
	options = cafen.extend({pointer : 'hollow_dot'},options);
	cafen.extendClass(this,new cafen.ofc2js.area_base("area_line", options));
}

cafen.ofc2js.bar_value = function( top, bottom ) {
	this.data = {};
	this.data['top'] = top;
	if(  bottom != null )
		this.data['bottom'] = bottom;
}

cafen.ofc2js.bar_value.prototype = {
	set_colour : function( colour ){
		this.data['colour'] = colour;
	},
	set_tooltip : function( tip ){
		this.data['tip'] = tip;
	}
}

cafen.ofc2js.bar = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar", options));
}

cafen.ofc2js.bar_3d_value = function( top ) {
	this.data = {};
	this.data['top'] = top;
}

cafen.ofc2js.bar_3d_value.prototype = {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;
	}
}

cafen.ofc2js.bar_base = function(type, options){
	this.data = {};
	this.data['type'] = (type == null) ? 'bar' : type;
	if (options != null) {
		if (options.colour !=null)
			this.set_colour(options.colour);
		if (options.text !=null)
			this.set_key(options.text , options.size || options.font_size || 12);
		if (options.values !=null)
			this.set_values(options.values);
		if (options.alpha !=null || options.fill_alpha != null)
			this.set_alpha(options.alpha || options.fill_alpha);
		if (options.tooltip !=null)
			this.set_tooltip(options.tooltip);
		if (options.on_show !=null) 
			this.set_on_show(new cafen.ofc2js.bar_on_show(options.on_show, options.cascade, options.delay));
		if (options.on_click != null)
			this.set_on_click(options.on_click);
		if (options.rightaxis != null && options.rightaxis)
			this.attach_to_right_y_axis();
	}
}

cafen.ofc2js.bar_base.prototype = {
	set_key : function( text, size ) {
		this.data['text'] = text;
		this.data['font-size'] = (size == null) ? 10  : size;
	},
	key : function( text, size ){
		this.set_key( text, size );
	},
	set_values : function( v ) {
		this.data['values'] = v;		
	},
	append_value : function( v ) {
		if (this.data['values'] == null)
			this.data['values'] = [];
		this.data['values'].push(v);		
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;	
	},
	colour : function( colour ) {
		this.set_colour( colour );
	},
	set_alpha : function( alpha ) {
		this.data['alpha'] = alpha;	
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;	
	},
	set_on_show : function(on_show) {
		this.data['on-show'] = on_show;
	},
	set_on_click : function( text ) {
		this.data['on-click'] = text;
	},
	attach_to_right_y_axis : function() {
		this.data['axis'] = 'right';
	}
}

cafen.ofc2js.bar_filled_value = function( top, bottom ) {
	cafen.extendClass(this,new cafen.ofc2js.bar_value( top, bottom ));	
}

cafen.ofc2js.bar_filled_value.prototype = {
	set_outline_colour : function( outline_colour ) {
		this.data['outline-colour'] = outline_colour;	
	}
}

cafen.ofc2js.bar_filled = function(colour, outline_colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_filled",options));
	this.set_colour( colour || options.colour);
	this.set_outline_colour( outline_colour || options.outline_colour);
}

cafen.ofc2js.bar_filled.prototype = {
	set_outline_colour : function( outline_colour ) {
		this.data['outline-colour'] = outline_colour;	
	}
}


cafen.ofc2js.bar_on_show = function(type, cascade, delay) {
	this.data = {};
	this.data['type'] = type;
	this.data['cascade'] = (cascade == null) ? 3 :parseFloat(cascade);
	this.data['delay'] = (delay == null) ? 1 :parseFloat(delay);
}

cafen.ofc2js.bar_glass =  function(options) {
	cafen.extendClass(this, new cafen.ofc2js.bar_base("bar_glass", options));
}

cafen.ofc2js.bar_cylinder = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_cylinder", options));
}

cafen.ofc2js.bar_cylinder_outline = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_cylinder_outline", options));
}

cafen.ofc2js.bar_rounded_glass = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_round_glass", options));
}

cafen.ofc2js.bar_round = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_round", options));
}

cafen.ofc2js.bar_dome  = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_dome", options));
}

cafen.ofc2js.bar_round3d = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_round3d", options));
}

cafen.ofc2js.bar_3d = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_3d", options));
}

cafen.ofc2js.bar_sketch = function( colour, outline_colour, fun_factor , options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_sketch", options));
	this.set_colour(colour || options.colour);
	this.set_outline_colour( outline_colour || options.outline_colour || options.fill_colour);
	this.data['offset'] = fun_factor || options.fun_factor || 5;
}

cafen.ofc2js.bar_sketch.prototype ={
	set_outline_colour : function( outline_colour ) {
		this.data['outline-colour'] = outline_colour;	
	}
}

cafen.ofc2js.bar_stack = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("bar_stack", options));
	if (options != null) {
		
		if (options.keys != null) {
			var keys = [];
			var fontSize = options.size || 13;
			var colours = [];
			for(var i = 0; i < options.keys.length; i ++) {
				colours.push(options.keys[i][0]);
				keys.push(new cafen.ofc2js.bar_stack_key( options.keys[i][0], options.keys[i][1], fontSize ));
			}
			this.set_keys(keys);
			if (options.colours == null) 
				options.colours = colours;
		}
		if (options.colours != null) 
			this.set_colours(options.colours);
		if (options.stacks != null) {
			var values = [];
			for(var i = 0; i < options.stacks.length; i ++) 
				this.append_stack(options.stacks[i]);
		}
	}
}

cafen.ofc2js.bar_stack.prototype = {
	append_stack : function( v ) {
		this.append_value( v );
	},
	set_colours : function( colours ) {
		this.data['colours'] = colours;
	},
	set_keys : function( keys ) {
		this.data['keys'] = keys;
	}
}

cafen.ofc2js.bar_stack_value = function( val, colour ) {
	this.data = {};
	this.data['val'] = val;
	this.data['colour'] = colour;
}

cafen.ofc2js.bar_stack_key = function( colour, text, font_size ) {
	this.data = {};
	this.data['colour'] = colour;
	this.data['text'] = text;
	this.data['font-size'] = font_size;
}

cafen.ofc2js.candle_value = function( high, open, close, low ) {
	this.data = {};	
	this.data['high'] = high;
	this.data['top'] = open;
	this.data['bottom'] = close;
	this.data['low'] = low;
}

cafen.ofc2js.candle_value.prototype = {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;
	}
}

cafen.ofc2js.candle = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.bar_base("candle", options));
	if (options.highs != null && options.opens != null && options.closes != null && options.lows != null) {
		var values = [];
		for(var i = 0; i < options.highs.length; i++) 
			values.push(new cafen.ofc2js.candle_value(options.highs[i], options.opens[i], options.closes[i], options.lows[i]));
		this.set_values(values);
	}
	if (colour != null)
		this.set_colour( colour );
}


cafen.ofc2js.hbar_value = function( left, right) {
	this.data = {};
	if( right  != null ) {
		this.data['left'] = left;
		this.data['right'] = right;
	} else
		this.data['right'] = left;
}

cafen.ofc2js.hbar_value.prototype = {
	set_colour : function( colour ) {
		this.data['colour'] = colour;	
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;	
	}
}
cafen.ofc2js.hbar = function( colour, options ) {
	this.data = {};
	this.data['type']      = "hbar";
	this.data['values']    = [];
	this.set_colour( colour || options.colour);
	if (options != null) {
		if (options.colour != null)	
			this.set_colour(options.colour);
		if (options.tooltip != null)	
			this.set_tooltip(options.tooltip);
		if (options.text != null)	
			this.set_key(options.text, options.size);
		if (options.alpha != null)
			this.set_alpha(options.alpha);
		if (options.values != null)	
			this.set_values	(options.values);
		else if (options.lefts != null && options.rights != null){
			for(var i = 0; i < options.rights.length; i++) 
				this.append_value(new cafen.ofc2js.hbar_value(options.lefts[i],options.rights[i]) );
		}
	}
}

cafen.ofc2js.hbar.prototype = {
	append_value : function( v ) {
		if (this.data['values'] == null)
			this.data['values'] = [];
		this.data['values'].push(v);
	},
	set_values : function( v ) {
		for(var i = 0 ; i < v.length; i++) 
			this.append_value(new cafen.ofc2js.hbar_value( v[i] ) );
	},
	set_alpha : function( alpha ) {
		this.data['alpha'] = alpha;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;	
	},
	set_key : function( text, size ) {
		this.data['text'] = text;
		this.data['font-size'] = size;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;	
	}
}


cafen.ofc2js.line_on_show = function(type, cascade, delay) {
	this.data = {};
	this.data['type'] = type;
	this.data['cascade'] = (cascade == null) ? 3 : parseFloat(cascade);
	this.data['delay'] = (delay == null) ? 1 :parseFloat(delay);
}

cafen.ofc2js.line = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.line_base("line", options));
}

cafen.ofc2js.line_base = function(type, options) {
	this.data = {};
	this.data['type']      = (type == null) ? "line" : type;
	this.data['text']      = "";
	this.data['font-size'] = 10;
	this.data['values']    = [];
	if (options != null) {
		if (options.colour !=null)
			this.set_colour(options.colour);
		if (options.text !=null)  {
			this.set_key(options.text, options.size || options.font_size|| 10);
		}
		if (options.pointer == null)
			options.pointer = 'dot';
		if (options.attributes !=null ) {
			var pointers = [];
			for(var i = 0; i < options.values.length; i++) {
				var pointerObj = null;
				switch(options.attributes[i].pointer) {
					case 's_star' :
					case 's_hollow_dot' :
					case 's_box' :
						pointerObj = new cafen.ofc2js[options.attributes[i].pointer](
							options.attributes[i].pointercolour ||  options.pointercolour || options.colour , 
							options.attributes[i].pointersize || options.pointersize || ((options.width || options.stroke || 1)+ 5), 
							{
								on_click : options.attributes[i].pointerclick || options.pointerclick || options.on_click, 
								rotate : options.attributes[i].pointerrotate || options.pointerrotate,
								tooltip : options.attributes[i].tooltip || options.tooltip,
								width : options.attributes[i].pointerstroke || null,
								value : options.values[i]
							}
						);
						break;
					case 'star' :
					case 'bow' :
					case 'anchor' :
					case 'dot' :
					case 'solid_dot' : 
						pointerObj = new cafen.ofc2js[options.attributes[i].pointer](options.values[i], {
							colour : options.attributes[i].pointercolour ||  options.pointercolour || options.colour , 
							size : options.attributes[i].pointersize || options.pointersize || ((options.width || options.stroke || 1)+ 5), 
							on_click : options.attributes[i].pointerclick || options.pointerclick || options.on_click, 
							rotate : options.attributes[i].pointerrotate || options.pointerrotate, 
							tooltip : options.attributes[i].tooltip || options.tooltip,
							width : options.attributes[i].pointerstroke || null
							}
						);
						break;
					default :
						pointerObj = options.values[i];
						break;
				}
				pointers.push(pointerObj);
			}
			
			this.set_values(pointers);
		} else if (options.values !=null) 
			this.set_values(options.values);

		if (options.width !=null || options.stroke != null) 
			this.set_width(options.width || options.stroke );
		if (options.line !=null) {
			var baseWidth = (options.width != null) ? options.width * 5 : null;
			if (baseWidth == null)
				baseWidth = (options.stroke != null) ? options.stroke * 5 : 1;
			switch(options.line) {
				case 'dotted' :
					this.line_style(new cafen.ofc2js.line_style(Math.round(baseWidth/2),Math.round(baseWidth/2)));
					break;
				case 'dashed' :
					this.line_style(new cafen.ofc2js.line_style(Math.round(baseWidth/5*3),Math.round(baseWidth/5*2)));
					break;
				case 'dot' :
					this.line_style(new cafen.ofc2js.line_style(Math.round(baseWidth/5),Math.round(baseWidth/5*4)));
					break;
				case 'longdash' :
					this.line_style(new cafen.ofc2js.line_style(Math.round(baseWidth*2),Math.round(baseWidth/5*2)));
					break;
			}				
		}
		if (options.on_show !=null) 
			this.set_on_show(new cafen.ofc2js.line_on_show(options.on_show, options.cascade, options.delay));
		if (options.pointer !=null && cafen.ofc2js[options.pointer] != null) {
			if (options.pointer == 's_star' || options.pointer == 's_hollow_dot' || options.pointer == 's_box') 
				this.set_default_dot_style(new cafen.ofc2js[options.pointer](options.pointercolour || options.colour , options.pointersize || ((options.width || options.stroke || 1)+ 5), {on_click : options.pointerclick || options.on_click, rotate : options.pointerrotate, tooltip : options.tooltip, width : options.pointerstroke || null}));
			else {
				this.set_default_dot_style(new cafen.ofc2js[options.pointer](null, {size : options.pointersize || ((options.width || options.stroke || 1) + 5) , colour : options.pointercolour, on_click : options.pointerclick || options.on_click, rotate : options.pointerrotate, tooltip : options.tooltip, width : options.pointerstroke || null}));
			}
			 options.on_click = null;
			options.tooltip = null;
		}
		if (options.loop != null && options.loop) 
			this.loop();
		if (options.tooltip != null) {
			this.set_tooltip(options.tooltip);
		}
		if (options.on_click != null)
			this.set_on_click(options.on_click);
		if (options.rightaxis != null && options.rightaxis)
			this.attach_to_right_y_axis();
	}
}

cafen.ofc2js.line_base.prototype = {
	set_default_dot_style : function( style ) {
		this.data['dot-style'] = style;	
	},
	set_values : function( v ) {
		this.data['values'] = v;		
	},
    append_value : function(v) {
		if (this.data['values'] == null)
			this.data['values'] = [];
        this.data['values'].push(v);
    },
	set_width : function( width ) {
		this.data['width'] = width;		
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	colour : function( colour ) {
		this.set_colour( colour );
		return this;
	},
	set_halo_size : function( size ) {
		this.data['halo-size'] = size;		
	},
	set_key : function( text, font_size ) {
		this.data['text']      = text;
		if (font_size != null)
			this.data['font-size'] = font_size;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;
	},
	set_on_click : function( text ) {
		this.data['on-click'] = text;
	},
	loop : function() {
		this.data['loop'] = true;
	},
	line_style : function( s ) {
		this.data['line-style'] = s;
	},
    set_text : function(text) {
        this.data['text'] = text;
    },
	attach_to_right_y_axis : function() {
		this.data['axis'] = 'right';
	},
	set_on_show : function(on_show) {
		this.data['on-show'] = on_show;
	},
	on_show : function(on_show) {
		this.set_on_show(on_show);
		return this;
	}
}

cafen.ofc2js.dot_value = function( value, colour ) {
	this.data = {};	
	this.data['value'] = value;
	this.data['colour'] = colour;
}

cafen.ofc2js.dot_value.prototype = {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_size : function( size ) {
		this.data['size'] = size;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;
	}
}

cafen.ofc2js.line_dot = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.line_base("line_dot", options));
}

cafen.ofc2js.line_hollow = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.line_base("line_hollow", options));
}

cafen.ofc2js.line_style = function(on, off) {
	this.data = {};
	this.data['style'] = 'dash';
	this.data['on'] = on;
	this.data['off'] = off;
}

cafen.ofc2js.ofc_menu_item = function(text, javascript_function_name) {
	this.data = {};
	this.data['type'] = "text";
	this.data['text'] = text;
	this.data['javascript-function'] = javascript_function_name;
}

cafen.ofc2js.ofc_menu_item_camera =  function(text, javascript_function_name) {
	this.data = {};
	this.data['type'] = "camera-icon";
	this.data['text'] = text;
	this.data['javascript-function'] = javascript_function_name;
}

cafen.ofc2js.ofc_menu = function(colour, outline_colour, options) {
	this.data = {};
	if (colour != null)
		this.data['colour'] = colour;
	if (outline_colour != null)
		this.data['outline_colour'] = outline_colour;
	if (options != null) {
		if (options.colour != null)
			this.data['colour'] = options.colour;
		if (options.outline_colour != null)
			this.data['outline_colour'] = options.outline_colour;
		if (options.values != null) {
			if (options.on_clicks == null)
				options.on_clicks = [];
			if (options.types == null)
				options.types = [];
			var values = [];
			for(var i = 0 ; i < options.values.length; i++) {
				switch(options.types[i]) {
					case 1 : 
					case 'camera' :
						values.push(new cafen.ofc2js.ofc_menu_item_camera(options.values[i], options.on_clicks[i]));
						break;
					default :
						values.push(new cafen.ofc2js.ofc_menu_item(options.values[i], options.on_clicks[i]));
						break;
				}
			}
			this.values(values);
		}
	}
}

cafen.ofc2js.ofc_menu.prototype = {
	values : function(values) {
		this.data['values'] = values;
	},
    append_value : function(v) {
		if (this.data['values'] == null)
			this.data['values'] = [];
        this.data['values'].push(v);
    }
}

cafen.ofc2js.pie_value = function( value, label, options ) {
	this.data = {};
	this.data['value'] = value;
	this.data['label'] = label;
	if (options != null) {
		if (options.colour != null) 
			this.set_colour( colour );
		if (options.on_click != null) 
			this.on_click( options.on_click );
		if (options.label_colour != null) 
			this.set_label( label, options.label_colour);
		else
			this.data['font-size'] = 12;
			
//		if (options.animation != null) 
//			this.add_animation();
	}
}

cafen.ofc2js.pie_value.prototype = {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_label : function( label, label_colour, font_size ) {
		this.data['label'] = label;
		this.data['label-colour'] = label_colour;
		this.data['font-size'] = (font_size == null) ? 11 : font_size;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;
	},
	on_click : function( event ) {
		this.data['on-click'] = event;
	},
	add_animation : function( animation ) {
		if(  this.data['animate'] == null  )
			this.data['animate'] = [];
		this.data['animate'].push(animation);
		return this;
	}
}

cafen.ofc2js.base_pie_animation = function(type) {
	this.data = {};
	this.data['type'] = type;
}

cafen.ofc2js.pie_fade =  function() {
	cafen.extendClass(this,new  cafen.ofc2js.base_pie_animation("fade"));
} 


cafen.ofc2js.pie_bounce =  function(distance) {
	cafen.extendClass(this,new cafen.ofc2js.base_pie_animation("bounce"));
	this.data['distance'] = (distance == null || isNaN(distance)) ? 5 :  parseInt(distance);
} 

cafen.ofc2js.pie = function(options) {
	this.data = {};
	this.data['type']      		= 'pie';
	if (options != null) {
		if (options.values !=null && options.labels != null) {
			if (options.on_clicks == null)
				options.on_clicks = [];
			var tmp_values = [];
			for(var i = 0; i < options.values.length; i++) 
				tmp_values.push(new cafen.ofc2js.pie_value(options.values[i],options.labels[i], {on_click : options.on_clicks[i]}));
			options.values = tmp_values;
		}
		if (options.values != null)
				this.set_values(options.values);
		if (options.colours != null)
			this.colours(options.colours);
		if (options.on_click != null) 
			this.on_click(options.on_click);
		if (options.alpha != null)
			this.set_alpha(options.alpha);
		if (options.gradient_fill != null && options.gradient_fill)
			this.set_gradient_fill();
		if (options.tooltip != null)
			this.set_tooltip(options.tooltip);
		if (options.animate != null) {
			var animateArr = options.animate.split(',');
			for(var i = 0; i < animateArr.length; i++) {
				switch(animateArr[i]) {
					case 'fade' :
						this.add_animation( new cafen.ofc2js.pie_fade() );
						break;
					default :
						this.add_animation( new cafen.ofc2js.pie_bounce(parseInt(animateArr[i])));
						break;
				}
			}
		}
	}
}

cafen.ofc2js.pie.prototype = {
	set_colours : function( colours ) {
		this.data['colours'] = colours;
	},
	colours : function( colours ) {
		this.set_colours( colours );
		return this;
	},
	set_alpha : function( alpha ) {
		this.data['alpha'] = alpha;
	},
	alpha : function( alpha ) {
		this.set_alpha( alpha );
		return this;
	},
	set_values : function( v ) {
		this.data['values'] = v;		
	},
	values : function( v ) {
		this.set_values( v );
		return this;
	},
	set_animate : function( bool ) {
		if( bool )
			this.add_animation( new cafen.ofc2js.pie_fade() );
	},
	add_animation : function( animation ) {
		if(  this.data['animate'] == null  )
			this.data['animate'] = [];
		this.data['animate'].push(animation);
		return this;
	},
	set_start_angle : function( angle ) {
		this.data['start-angle'] = angle;
	},
	start_angle : function(angle) {
		this.set_start_angle( angle );
		return this;
	},
	set_tooltip : function( tip ) {
		this.data['tip'] = tip;
	},
	tooltip : function( tip ) {
		this.set_tooltip( tip );
		return this;
	},
	set_gradient_fill : function() {
		this.data['gradient-fill'] = true;
	},
	gradient_fill : function() {
		this.set_gradient_fill();
		return this;
	},
	set_label_colour : function( label_colour ) {
		this.data['label-colour'] = label_colour;	
	},
	label_colour : function( label_colour ) {
		this.set_label_colour( label_colour );
		return this;
	},
	set_no_labels : function() {
		this.data['no-labels'] = true;
	},
	on_click : function( event ) {
		this.data['on-click'] = event;
	},
	radius : function( radius ) {
		this.data['radius'] = radius;
		return this;
	}
}

cafen.ofc2js.radar_axis = function( max , options) {
	this.data = {};
	if (max != null)
		this.set_max( max );
	else
		this.set_max(10);
	if (options != null) {
		if (options.max != null)
			this.set_max( options.max);
		if (options.step != null)
			this.set_steps(options.step);
		if (options.stroke != null || options.width != null) 
			this.set_stroke(options.stroke || options.width);
		if (options.colour != null)
			this.set_colour(options.colour);
		if (options.grid_colour != null)
			this.set_grid_colour(options.grid_colour);
		if (options.autolabel != null && options.autolabel) {
			var labels = [], step = options.step || 1;
			var max_val = max || options.max;
			for(var i = 1; i <= max_val ; i++) {
				if (i % step == 0)
					labels.push(i.toString());
				else
					labels.push('');
			}
			this.set_labels(new cafen.ofc2js.radar_axis_labels(labels, {colour :options.font_colour || options.colour, size : options.size || 12} ));
		}
		if (options.labels != null || options.values != null) {
			if (options.labels == null)
				options.labels = options.values;
			this.set_spoke_labels(new cafen.ofc2js.radar_spoke_labels(options.labels));
		}
		
	}
}

cafen.ofc2js.radar_axis.prototype =  {
	set_max : function( max ) {
		this.data['max'] = max;
	},
	set_steps : function( steps ) {
		this.data['steps'] = steps;
	},
	set_stroke : function( s ) {
		this.data['stroke'] = s;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_grid_colour : function( colour ) {
		this.data['grid-colour'] = colour;
	},
	set_labels : function( labels ) {
		this.data['labels'] = labels;
	},
	set_spoke_labels : function( labels ) {
		this.data['spoke-labels'] = labels;
	}
}

cafen.ofc2js.radar_axis_labels = function( labels, options) {
	this.data = {};
	this.data['labels'] = labels;
	if (options.colour != null)
		this.set_colour(options.colour);
}

cafen.ofc2js.radar_axis_labels.prototype = {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	}
}

cafen.ofc2js.radar_spoke_labels = function( labels ) {
	this.data = {};
	this.data['labels'] = labels;
}

cafen.ofc2js.radar_spoke_labels.prototype =  {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	}
}

cafen.ofc2js.scatter_value = function( x, y, dot_size) {
	this.data = {};
	this.data['x'] = x;
	this.data['y'] = y;
	if( dot_size != null && dot_size > 0 ) {
		this.data['dot-size'] = dot_size;
	}
}

cafen.ofc2js.scatter = function( colour , options) {
	this.data = {};	
	this.data['type']    = "scatter";
	if (colour != null)
		this.set_colour( colour );
	if (options != null) {
		if (options.colour != null)
			this.set_colour( options.colour );
		if (options.pointer !=null && cafen.ofc2js[options.pointer] != null) {
			if (options.pointer == 's_star' || options.pointer == 's_hollow_dot' || options.pointer == 's_box') 
				this.set_default_dot_style(new cafen.ofc2js[options.pointer](options.pointercolour || options.colour , options.pointersize || ((options.width || options.stroke) + 5), {on_click : options.pointerclick, rotate : options.pointerrotate, tooltip : options.tooltip, width : options.pointerstroke || null}));
			else
				this.set_default_dot_style(new cafen.ofc2js[options.pointer](null, {size : options.pointersize || ((options.width || options.stroke || 2) + 5) , colour : options.pointercolour, on_click : options.pointerclick, rotate : options.pointerrotate, tooltip : options.tooltip, width : options.pointerstroke || null}));
			options.tooltip = null;
		}
		if (options.xys != null) {
			var def_size = options.size || 3;
			var values = [];
			for(var i = 0; i < options.xys.length; i++) 
				values.push(new cafen.ofc2js.scatter_value(options.xys[i][0],options.xys[i][1], options.xys[i][2] || def_size));
			options.values = values;
		}
		if (options.values != null) 
			this.set_values(options.values);
		if (options.text != null)
			this.set_key(options.text, options.size || 10);
	}
}

cafen.ofc2js.scatter.prototype =  {
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_default_dot_style : function( style ) {
		this.data['dot-style'] = style;	
	},
	set_values : function( values ) {
		this.data['values'] = values;
	},
	set_key : function( text, font_size ) {
		this.data['text']      = text;
		if (font_size != null) 
			this.data['font-size'] = font_size;
	}
}

cafen.ofc2js.scatter_line = function( colour, width , options ) {
	cafen.extendClass(this,new cafen.ofc2js.scatter(colour, options));
	this.data['type']      = "scatter_line";
	if (width != null) 
		this.set_width(width);
	else if (options.width != null || options.stroke != null)
		this.set_width(options.width|| options.stroke);
}

cafen.ofc2js.scatter_line.prototype = {
	set_width : function( width ) {
		this.data['width'] = width;
	},
	set_step_horizontal : function() {
		this.data['stepgraph'] = 'horizontal';
	},
	set_step_vertical : function() {
		this.data['stepgraph'] = 'vertical';
	}
}

cafen.ofc2js.shape_point = function( x, y ) {
	this.data = {};
	this.data['x'] = x;
	this.data['y'] = y;
}

cafen.ofc2js.shape = function( colour, options) {
	this.data = {};
	this.data['type'] = 'shape';
	if (colour != null)
		this.data['colour'] = colour;
	this.data['values'] = [];
	if (options != null ) {
		if (options.colour != null)
			this.data['colour'] = options.colour;
		if (options.values != null)
			this.set_values(options.values);
		if (options.alpha != null)
			this.set_alpha(options.alpha);
		if (options.xyrate != null)
			this.set_xyRate(options.xyrate);
		if (options.xys != null) {
			for(var i = 0; i < 	options.xys.length; i++) 
				this.append_xy(options.xys[i][0], options.xys[i][1]);
		}
	}
}

cafen.ofc2js.shape.prototype = {
	xyrate : 1,
	set_values : function( v ) {
		this.data['values'] = v;		
	},
	set_xyRate : function(v) {
		this.xyrate = v;
	},
	append_value : function( p ) {
		if (this.data['values'] == null)
			this.data['values'] = [];
		this.data['values'].push(p);	
	},
	append_xy : function( x, y ) {
		this.append_value(new cafen.ofc2js.shape_point( x.toFixed(7), y.toFixed(7)));
	},
	getCenter : function() {
		var minX = null, maxX = null, minY = null, maxY = null;
		for(var i = 0; i < 	this.data['values'].length; i++) {
			var pointer = {x : this.data['values'][i].data['x'], y : this.data['values'][i].data['y']};
			if (minX == null) {
				minX = maxX = pointer.x;
				minY = maxY = pointer.y;
			} else {
				minX = Math.min(minX,pointer.x);
				minY = Math.min(minY,pointer.y);
				maxX = Math.max(maxX,pointer.x);
				maxY = Math.max(maxY,pointer.y);
			}
		}
		return [(maxX + minX)/2 , (maxY + minY)/2];
	},
	getRect2Polar : function(x, y) {
		var r = Math.sqrt(Math.pow(x,2) + Math.pow(y/this.xyrate,2));
		var a = 0;
		if (x == 0 || y == 0) {
			if (x == 0 && y > 0) 
				a = 0;
			else if (x == 0 && y < 0) 
				a = Math.PI;
			else if (y == 0 && x < 0) 
				a = Math.PI/2*3;
			else if (y == 0 && x > 0) 
				a = Math.PI/2;
		} else if ((x < 0 && y > 0) || (x < 0 && y < 0)) 
			a += Math.PI / 2 *3 - Math.atan(y/this.xyrate/x);
		else if ((x > 0 && y < 0) || (x > 0 && y > 0)) 
			a += Math.PI / 2 - Math.atan(y/this.xyrate/x) ;
		return [r, (a / Math.PI * 180)];
	},
	getPolar2Rect : function(r, d,cx, cy) {
		var x = (Math.sin(d/180*Math.PI) * r + cx);
		var y = (Math.cos(d/180*Math.PI)*this.xyrate * r + cy);
		return [x,y];
	},
	getPointers : function(cx, cy, r, cnt, start, rotate) {
		var step = 360 / cnt;
		start += (rotate != null) ? rotate : 0;
		var pointers = [];
		for(var i = 0; i <= 360; i += step) 
			pointers.push(this.getPolar2Rect(r, i+start, cx, cy));
		return pointers;
	},
	getPointersAngle : function(cx, cy, r, cnt, start, rotate, start_angle, end_angle) {
		var step = (end_angle - start_angle) / cnt;
		
		start += (rotate != null) ? rotate : 0;
		var pointers = [];
		if (step > 0) {
			for(var i = start_angle; i <= end_angle; i += step) 
				pointers.push(this.getPolar2Rect(r, i+start, cx, cy));
		} else {
			for(var i = start_angle; i >= end_angle; i += step) 
				pointers.push(this.getPolar2Rect(r, i+start, cx, cy));
		}
		return pointers;
	},	
	set_alpha : function( alpha ) {
		this.data['alpha'] = alpha;	
	},
	rotate : function(angle, center) {
		if (center == null)
			center = this.getCenter();
		var pointers = [];
		for(var i = 0; i < 	this.data['values'].length; i++) {
			var pointer = [this.data['values'][i].data['x'], this.data['values'][i].data['y']];
			var x = pointer[0] - center[0];
			var y = pointer[1] - center[1];
			var pol = this.getRect2Polar(x,y);
			pointers.push(this.getPolar2Rect(pol[0], pol[1] + angle, center[0], center[1]));
		}
		this.data['values'] = [];
		for(var i = 0; i < pointers.length; i++) {
			this.append_xy(pointers[i][0],pointers[i][1]);
		}
	}
}

cafen.ofc2js.shape_arrow = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape(colour, options));
	var pol = this.getRect2Polar(options.x2 - options.x1, options.y2 - options.y1);
	var size = options.r || 0.5;
	var boxPointers1 = this.getPointers(options.x2, options.y2, size, 3, -120, pol[1]);
	var linesize = size*(options.d|| 0.3);
	var boxPointers2 = this.getPointers(options.x2, options.y2, linesize , 3, -120, pol[1]);
	var returnPoint = null;
	
	if (options.start) {
		var startPointers = this.getPointers(options.x1, options.y1, linesize * options.start, 2, 90, pol[1]);
		returnPoint = [startPointers[0][0], startPointers[0][1]];
		this.append_xy(startPointers[0][0], startPointers[0][1]);
		this.append_xy(startPointers[1][0], startPointers[1][1]);
	} else {
		returnPoint = [options.x1, options.y1];
		this.append_xy(options.x1, options.y1);
	}
	this.append_xy(boxPointers2[0][0], boxPointers2[0][1]);
	for(var i = 0; i < 	(boxPointers1.length -1); i++) 
		this.append_xy(boxPointers1[i][0], boxPointers1[i][1]);
	this.append_xy(boxPointers2[2][0], boxPointers2[2][1]);
	this.append_xy(returnPoint[0],returnPoint[1]);
	if (options.rotate != null) 
		this.rotate(options.rotate, [options.x1, options.y1]);
}

cafen.ofc2js.shape_poly = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape(colour, options));
}

cafen.ofc2js.shape_box = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape_poly(colour, options));
	var boxPointers = this.getPointers(options.x, options.y, options.r, 4, 45, options.rotate);
	for(var i = 0; i < 	boxPointers.length; i++) 
		this.append_xy(boxPointers[i][0], boxPointers[i][1]);
}

cafen.ofc2js.shape_triangle = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape_poly(colour, options));
	var boxPointers = this.getPointers(options.x, options.y, options.r || 1 , options.a || 3, 0, options.rotate);
	for(var i = 0; i < 	boxPointers.length; i++) 
		this.append_xy(boxPointers[i][0], boxPointers[i][1]);
}

cafen.ofc2js.shape_circle = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape_poly(colour, options));
	var boxPointers = this.getPointers(options.x, options.y, options.r || 1, options.a || 20, 0, options.rotate);
	for(var i = 0; i < 	boxPointers.length; i++) 
		this.append_xy(boxPointers[i][0], boxPointers[i][1]);
}

cafen.ofc2js.shape_pie = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape_poly(colour, options));
	var boxPointers = this.getPointersAngle(options.x, options.y, options.r || 1, options.a || 20 , 0, options.rotate, options.sa || 0 , options.ea || 90);
	this.append_xy(options.x, options.y);
	for(var i = 0; i < 	boxPointers.length; i++) 
		this.append_xy(boxPointers[i][0], boxPointers[i][1]);
	this.append_xy(options.x, options.y);
}

cafen.ofc2js.shape_star = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape_poly(colour, options));
	var angle = options.a || 5; 
	var boxPointers1 = this.getPointers(options.x, options.y, options.r, angle, 0, options.rotate);
	var boxPointers2 = this.getPointers(options.x, options.y, options.r*(options.d || 0.5), angle, 180/angle, options.rotate);
	for(var i = 0; i < 	boxPointers1.length; i++) {
		this.append_xy(boxPointers1[i][0], boxPointers1[i][1]);
		this.append_xy(boxPointers2[i][0], boxPointers2[i][1]);
	}
}

cafen.ofc2js.shape_curves = function(colour, options) {
	cafen.extendClass(this,new cafen.ofc2js.shape_poly(colour, options));
	if (options != null) {
		var start = {x : options.x1, y : options.y1};
		var end = {x : options.x2, y : options.y2};
		var middle1 = {x : options.x3, y : options.y3};
		var middle2 = {x : options.x4, y : options.y4};
		var width = options.width || options.stroke ||1;
		var dist = {x : options.dx || 50, y : options.dy || 50, r : options.dr || width*1.5, a : options.da || 90};
		if (options.ribbon)
			this.drawCurve(start, end, middle1, middle2, width, dist , options.rate || 10, options.arrow || false);
		else
			this.drawCurveAngle(start, end, middle1, middle2, width, dist , options.rate || 10, options.arrow || false);
	}
}


cafen.ofc2js.shape_curves.prototype = {
	b1Bezier : function(t) { return (t*t*t); },
	b2Bezier : function(t) { return (3*t*t*(1-t)); },
	b3Bezier : function(t) { return (3*t*(1-t)*(1-t)); },
	b4Bezier : function(t) { return ((1-t)*(1-t)*(1-t)); },
	getBezier : function(percent,C1,C2,C3,C4) {
		return [
			C1.x * this.b1Bezier(percent) + C2.x * this.b2Bezier(percent) +C3.x * this.b3Bezier(percent) + C4.x * this.b4Bezier(percent),
			C1.y * this.b1Bezier(percent) + C2.y * this.b2Bezier(percent) + C3.y * this.b3Bezier(percent) + C4.y * this.b4Bezier(percent)
		];
	},
	drawCurve : function(start, end, mid1, mid2, width, dist, rate, arrow) {
		var points = [];
		var step = 100/rate;
		var pol = this.getRect2Polar(end.x - start.x, end.y - start.y);
		var startPointers = this.getPointers(start.x, start.y, width , 2, 90, pol[1]);
		var distx = startPointers[0][0] - startPointers[1][0];
		var disty = startPointers[0][1] - startPointers[1][1];
		points.push(startPointers[0]);
		points.push(startPointers[1]);
		var endPointers = this.getPointers(end.x, end.y, width , 2, 90, pol[1]);
		var leftpo = null, rightpo = null;
		if (mid1.x != null) {
			if (mid2.x == null) 
				mid2 = mid1;
			leftpo = mid1;
			rightpo = mid2;
		} else {
			var middlePointers = this.getPointers(start.x +(end.x - start.x)/100*dist.x, start.y +(end.y - start.y)/100*dist.y, dist.r , 2, dist.a , pol[1]);
			leftpo = {x : middlePointers[0][0], y : middlePointers[0][1]};
			rightpo = {x : middlePointers[1][0], y : middlePointers[1][1]};
		}
		var start1 = {x : startPointers[1][0], y : startPointers[1][1]};
		var end1 = {x : endPointers[1][0], y : endPointers[1][1]};
		var curvePointers = [];
		for(var i = 0; i <= 100; i += step) {
			var tmpPoint = this.getBezier(i/100, start1, leftpo, rightpo, end1);
			points.push(tmpPoint);	
			curvePointers.push(tmpPoint);
		}
		points.push(endPointers[1]);
		if (arrow) {
			var arrowPointers = this.getPointers(end.x, end.y, width*3 , 3 , -120, pol[1]);
			points.push(arrowPointers[0]);
			points.push(arrowPointers[1]);
			points.push(arrowPointers[2]);
		}
		points.push(endPointers[0]);
		for(var i = (curvePointers.length - 1) ; i >= 0; i--) {
			var tmpPoint =curvePointers[i];
			points.push([tmpPoint[0] + distx, tmpPoint[1] + disty]);	
		}
		points.push(startPointers[0]);
		for(var i = 0; i < points.length; i++)
			this.append_xy(points[i][0],points[i][1]);
	},
	drawCurveAngle : function(start, end, mid1, mid2, width, dist, rate, arrow) {
		var points = [];
		if (mid2.x == null || mid2.y == null) 
			mid2 = mid1;
		var step = 100/rate;
		var lastPoint = null;
		var lastAngle = null;
		var pointsGo = [];
		var pointsReturn = [];
		var leftpo = null, rightpo = null;
		if (mid1.x != null) {
			if (mid2.x == null) 
				mid2 = mid1;
			leftpo = mid1;
			rightpo = mid2;
		} else {
			var pol = this.getRect2Polar(end.x - start.x, end.y - start.y);
			var middlePointers = this.getPointers(start.x +(end.x - start.x)/100*dist.x, start.y +(end.y - start.y)/100*dist.y, dist.r , 2, dist.a , pol[1]);
			leftpo = {x : middlePointers[0][0], y : middlePointers[0][1]};
			rightpo = {x : middlePointers[1][0], y : middlePointers[1][1]};
		}

		for(var i = 0; i <= 100; i += step) {
			var tmpPoint = this.getBezier(i/100, start, leftpo, rightpo, end);
			if (lastPoint != null) {
				var pol = this.getRect2Polar(tmpPoint[0] - lastPoint[0] , tmpPoint[1] - lastPoint[1]);
				if (lastAngle == null) {
					var currPointers = this.getPointers(end.x, end.y, width , 2,  90,pol[1]);
					pointsGo.push(currPointers[0]);
					pointsReturn.push(currPointers[1]);
					lastAngle = pol[1];
				}
				var currPointers = this.getPointers(tmpPoint[0], tmpPoint[1], width , 2,  90,pol[1]);
				pointsGo.push(currPointers[0]);
				pointsReturn.push(currPointers[1]);
			} 
			lastPoint = tmpPoint;
		}
		for(var i = (pointsGo.length - 1); i >= 0; i--)
			points.push(pointsGo[i]);
		if (arrow) {
			var arrowPointers = this.getPointers(end.x, end.y, width*3 , 3 , -300, lastAngle);
			points.push(arrowPointers[0]);
			points.push(arrowPointers[1]);
			points.push(arrowPointers[2]);
		}
		for(var i = 0; i < pointsReturn.length; i++)
			points.push(pointsReturn[i]);
		for(var i = 0; i < points.length; i++)
			this.append_xy(points[i][0],points[i][1]);
	}
}

cafen.ofc2js.s_star = function(colour, size, options) {
	cafen.extendClass(this,new cafen.ofc2js.star(options.value || null, options));
	if (colour != null)
		this.colour(colour).size(size);
}

cafen.ofc2js.s_box = function(colour, size, options) {
	cafen.extendClass(this,new cafen.ofc2js.anchor(options.value || null, options));
	if (colour != null)
		this.colour(colour).size(size).rotation(45).sides(4);
}

cafen.ofc2js.s_hollow_dot = function(colour, size, options) {
	cafen.extendClass(this,new cafen.ofc2js.hollow_dot(options.value || null, options));
	if (colour != null)
		this.colour(colour).size(size);
}

cafen.ofc2js.title = function( text, css) {
	this.data = {};
	this.data['text'] = text;
	if (css != null)
		this.set_style(css);
	else
		this.set_style('{font-size:13px;color:#464646}');
	
}

cafen.ofc2js.title.prototype ={
	set_style : function( css ) {
		this.data['style'] = css;
	}
}

cafen.ofc2js.tooltip = function(options){
	this.data = {};
	if (options != null) {
		if (options.stroke != null || options.width)
			this.set_stroke(options.stroke || options.width);
		if (options.colour != null)
			this.set_colour(options.colour);
		if (options.fill_colour != null)
			this.set_background_colour(options.fill_colour);
		if (options.text != null && options.text != '') {
			var textArr = 	options.text.split(',');
			options.title = textArr[0];
			options.body = textArr[1];
			options.shadow = (textArr[2] == 'true') ? true : false;
			options.proximity = (textArr[3] == 'proximity') ? true : false;
			options.hover = (textArr[3] == 'hover') ? true : false;
		}
		if (options.shadow != null)
			this.set_shadow(options.shadow);
		if (options.proximity != null && options.proximity)
			this.set_proximity();
		else if (options.hover != null && options.hover)
			this.set_hover();
		if (options.title != null)
			this.set_title_style(options.title);
		if (options.body != null)
			this.set_body_style(options.body);
	}
}

cafen.ofc2js.tooltip.prototype = {
	set_shadow : function( shadow ) {
		this.data['shadow'] = shadow;
	},
	set_stroke : function( stroke ) {
		this.data['stroke'] = stroke;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_background_colour : function( bg ) {
		this.data['background'] = bg;
	},
	set_title_style : function( style ) {
		this.data['title'] = style;
	},
    set_body_style : function( style ) {
		this.data['body'] = style;
	},
	set_proximity : function() {
		this.data['mouse'] = 1;
	},
	set_hover : function() {
		this.data['mouse'] = 2;
	}
}

cafen.ofc2js.x_axis = function(options){
	this.data = {};
	if (options != null) {
		if (options.stroke != null || options.width)
			this.set_stroke(options.stroke || options.width);
		if (options.colour != null)
			this.set_colour(options.colour);
		if (options.grid_colour != null)
			this.set_grid_colour(options.grid_colour);
		if (options['3d'] != null || options['d3'])
			this.set_3d(options['3d'] || options['d3']);
		if (options.min != null && options.max != null)
			this.set_range(options.min, options.max, options.step || options.xstep);
		else if (options.step != null)
			this.set_steps(options.step);
		if (options.labels != null || options.values != null) {
			if (options.labels == null && options.values != null)
				options.labels = options.values;
			var x_axis_labels = [];
			for(var i = 0 ; i < options.labels.length; i++) 
				x_axis_labels.push(new cafen.ofc2js.x_axis_label( options.labels[i], options.font_colour || options.colour, options.size, options.rotate ));
			this.set_labels_from_array(x_axis_labels);
		}
	}
}


cafen.ofc2js.x_axis.prototype =  {
	set_stroke : function( stroke ) {
		this.data['stroke'] = stroke;	
	},
	stroke : function( stroke ) {
		this.set_stroke( stroke );
		return this;
	},
	set_colours : function( colour, grid_colour ) {
		this.set_colour( colour );
		this.set_grid_colour( grid_colour );
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;	
	},
	colour : function( colour ) {
		this.set_colour(colour);
		return this;
	},
	set_tick_height : function( height ) {
		this.data['tick-height']  = height;
	},
	tick_height : function( height ) {
		this.set_tick_height(height);
		return this;
	},
	set_grid_colour : function( colour ) {
		this.data['grid-colour'] = colour;
	},
	grid_colour : function( colour ) {
		this.set_grid_colour(colour);
		return this;
	},
	set_offset : function( o ) {
		this.data['offset'] = o ? true:false;	
	},
	offset : function( o ) {
		this.set_offset(o);
		return this;
	},
	set_steps : function( steps ) {
		this.data['steps'] = steps;
	},
	steps : function( steps ) {
		this.set_steps(steps);
		return this;
	},
	set_3d : function( val ) {
		this.data['3d']	= val;		
	},
	set_labels : function( x_axis_labels ) {
		this.data['labels'] = x_axis_labels;
	},
	set_labels_from_array : function( a ) {
		var x_axis_labels = new cafen.ofc2js.x_axis_labels();
		x_axis_labels.set_labels( a );
		this.data['labels'] = x_axis_labels;
		
		if( this.data['steps'] != null )
			x_axis_labels.set_steps( this.data['steps'] );
	},
	set_range : function( min, max, step ) {
		this.data['min'] = (min == null) ? 0 : min;
		this.data['max'] = max;
		if (step != null)
			this.set_steps(step);
	}
}

cafen.ofc2js.x_axis_label = function( text, colour, size, rotate ) {
	this.data = {};	
	this.set_text( text );
	this.set_colour( colour == null ? '#464646' : colour);
	this.set_size( size == null ? 10 : size);
	this.set_rotate( rotate == null ? 0 : rotate);
}

cafen.ofc2js.x_axis_label.prototype = {
	set_text : function( text ) {
		this.data['text'] = text;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_size : function( size ) {
		this.data['size'] = size;
	},
	set_rotate : function( rotate ) {
		this.data['rotate'] = rotate;
	},
	set_vertical : function() {
		this.data['rotate'] = "vertical";
	},
	set_visible : function() {
		this.data['visible'] = true;
	}
}

cafen.ofc2js.x_axis_labels  = function(){
	this.data = {};	
}

cafen.ofc2js.x_axis_labels.prototype =  {
	set_steps : function( steps ) {
		this.data['steps'] = steps;
	},
	visible_steps : function( steps ) {
		this.data['visible-steps'] = steps;
		return this;
	},
	set_labels : function( labels ) {
		this.data['labels'] = labels;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_size : function( size ) {
		this.data['size'] = size;
	},
	set_vertical : function() {
		this.data['rotate'] = 270;
	},
	rotate : function( angle ) {
		this.data['rotate'] = angle;
	},
	text : function( text ) {
		this.data['text'] = text;
	}
}

cafen.ofc2js.x_legend = function( text , css) {
	this.data = {};	
	this.data['text'] = (text == null) ? '' : text;
	this.set_style((css == null) ? '{font-size:12px}' : css);
}

cafen.ofc2js.x_legend.prototype ={
	set_style : function( css ) {
		this.data['style'] = css;
	}
}

cafen.ofc2js.y_axis = function(options) {
	cafen.extendClass(this,new cafen.ofc2js.y_axis_base(options));
}

cafen.ofc2js.y_axis_base = function(options){
	this.data = {};
	if (options != null) {
		if (options.stroke != null || options.width)
			this.set_stroke(options.stroke || options.width);
		if (options.colour != null)
			this.set_colour(options.colour);
		if (options.grid_colour != null)
			this.set_grid_colour(options.grid_colour);
		if (options.autolabel != null && options.autolabel) {
			var labels = [], step = options.step || options.ystep || 1;
			var max_val = options.max || 10;
			for(var i = 1; i <= max_val ; i++) {
				if (i % step == 0)
					labels.push(i.toString());
				else
					labels.push('');
			}
			options.labels = labels;
		}
		if (options.labels != null || options.values != null) {
			if (options.values != null)
				options.labels = options.values;
			var labels = new cafen.ofc2js.y_axis_labels();
			var childLabels = [];
			for(var i = 0; i < options.labels.length; i++) 
				childLabels.push(new cafen.ofc2js.y_axis_label(i, options.labels[i], options.font_colour || options.colour , options.size, options.rotate));
			labels.set_labels(childLabels);
			if (options.text != null)
				labels.set_text(options.text);
			if (options.rotate != null)
				labels.rotate(options.rotate);
			this.set_labels(labels);
		}
		if (options.offset != null)
			this.set_offset(options.offset);
		if (options.min != null || options.max != null) {
			this.set_range(options.min, options.max, options.step || options.ystep);
		}
	}
}

cafen.ofc2js.y_axis_base.prototype = {
	set_stroke : function( s ) {
		this.data['stroke'] = s;
	},
	set_tick_length : function( val ) {
		this.data['tick-length'] = val;
	},
	set_colours : function( colour, grid_colour ) {
		this.set_colour( colour );
		this.set_grid_colour( grid_colour );
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_grid_colour : function( colour ) {
		this.data['grid-colour'] = colour;
	},
	set_range : function( min, max, steps) {
		this.data['min'] = min;
		this.data['max'] = max;
		this.set_steps( (steps == null) ? 1 : steps );
	},
	range : function( min, max, steps) {
		this.set_range( min, max, (steps == null) ? 1 : steps );
		return this;
	},
	set_offset : function( off ) {
		this.data['offset'] = off?1:0;
	},
	set_labels : function( y_axis_labels ) {
		this.data['labels'] = y_axis_labels;
	},
	set_label_text : function( text ) {
		var tmp = new cafen.ofc2js.y_axis_labels();
		tmp.set_text( text );
		this.data['labels'] = tmp;
	},
	set_steps : function( steps ) {
		this.data['steps'] = steps;	
	},
	set_vertical : function() {
		this.data['rotate'] = "vertical";
	}
}

cafen.ofc2js.y_axis_label = function( y, text, colour, size, rotate) {
	this.data = {};	
	this.data['y'] = y;
	this.set_text( text );
	this.set_colour( colour == null ? '#464646' : colour);
	this.set_size( size == null ? 10 : size);
	this.set_rotate( rotate == null ? 0 : rotate);
}

cafen.ofc2js.y_axis_label.prototype = {
	set_text : function( text ) {
		this.data['text'] = text;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_size : function( size ) {
		this.data['size'] = size;
	},
	set_rotate : function( rotate ) {
		this.data['rotate'] = (rotate == 'vertical') ? 'vertical' : '';
	},
	set_vertical : function() {
		this.data['rotate'] = "vertical";
	}
}

cafen.ofc2js.y_axis_labels = function(){
	this.data = {};
}

cafen.ofc2js.y_axis_labels.prototype = {
	set_steps : function( steps ) {
		this.data['steps'] = steps;
	},
	set_labels : function( labels ) {
		this.data['labels'] = labels;
	},
	set_colour : function( colour ) {
		this.data['colour'] = colour;
	},
	set_size : function( size ) {
		this.data['size'] = size;
	},
	set_vertical : function() {
		this.data['rotate'] = 270;
	},
	rotate : function( angle ) {
		this.data['rotate'] = angle;
	},
	set_text : function( text ) {
		this.data['text'] = text;
	}
}

cafen.ofc2js.y_axis_right = function(options) {
 	cafen.extendClass(this,new cafen.ofc2js.y_axis_base(options) );
}

cafen.ofc2js.y_legend = function( text , css) {
	this.data = {};	
	this.data['text'] = (text == null) ? '' : text;
	this.set_style(css ? css : '{font-size:12px}');
}

cafen.ofc2js.y_legend.prototype = {
	set_style : function( css ) {
		this.data['style'] = css;
	}
}

cafen.ofc2js.ofc_arrow = function(x, y, a, b, colour, barb_length,options) {
	this.data = {};
	this.data['type']     = "arrow";
	if (options != null) {
		if (options.values != null && options.values.length > 0) {
			var tmpArr = options.values[0].split(',');
			options.x = parseFloat(tmpArr[0]);
			options.y = parseFloat(tmpArr[1]);
			options.a = parseFloat(tmpArr[2]);
			options.b = parseFloat(tmpArr[3]);
			options.colour = tmpArr[4];
		}
		x = x || options.x;
		y = y || options.y;
		a = a || options.a;
		b = b || options.b;
		colour = colour || options.colour || '#a0a0a0';
		barb_length = barb_length || options.barb_length || 10;
		if (options.alpha != null)
			this.alpha(options.alpha);
	}
	if (x != null  && y != null)
		this.data['start']	= {'x' :x, 'y' :y};
	if (a != null  && b != null)
		this.data['end']		= {'x' : a, 'y' :b};
	if (colour != null)
		this.colour(colour);
	this.data['barb-length'] = barb_length || 10;
}

cafen.ofc2js.ofc_arrow.prototype = {
	colour : function( colour ) {
		this.data['colour'] = colour;
		return this;
	},
	alpha : function(alpha) {
		this.data['alpha'] = alpha;
		return this;
	}
}

cafen.ofc2js.ofc_tags = function(options) {
	this.data = {};
	this.data['type']      = "tags";
	this.data['values'] = [];
	if (options != null) {
		if (options.values != null && options.values.length > 0) {
			options.bold = false;
			options.underline = false;
			options.border = false;
			options.alpha = options.alpha || 1.0;
			options.alignX = options.alignx || 'center';
			options.alignY = options.aligny || 'center';
			if (options.text != null) {
				var textOptions = options.text;
				if (textOptions.indexOf('bold') >= 0)
					options.bold = true;
				if (textOptions.indexOf('underline') >= 0)
					options.underline = true;
				if (textOptions.indexOf('border') >= 0)
					options.border = true;
				if (textOptions.indexOf('left') >= 0)
					options.alignX = 'left';
				else if (textOptions.indexOf('right') >= 0)
					options.alignX = 'right';
				if (textOptions.indexOf('above') >= 0)
					options.alignY = 'above';
				else if (textOptions.indexOf('below') >= 0)
					options.alignY = 'below';
			}
			if (options.colour != null)
				this.colour(options.colour);
			if (options.fill_colour != null)
				this.background(options.fill_colour);
			this.font(null, options.size || options.font_size || 11);
			switch(options.alignX) {
				case 'left' :
					this.align_x_left();
					break;
				case 'right' :
					this.align_x_right();
					break;
				default :
					this.align_x_center();
					break;
			}
			switch(options.alignY) {
				case 'above' :
					this.align_y_above();
					break;
				case 'below' :
					this.align_y_below();
					break;
				default :
					this.align_y_center();
					break;
			}
			for(var i = 0; i < options.values.length; i++) {
				var valueArr = options.values[i].split(',');
				var x = parseFloat(valueArr[0]);
				var y = parseFloat(valueArr[1]);
				var text = valueArr[2];
				var colour = options.colour || '#d0d0d0';
				if (!isNaN(x) && !isNaN(y))
					this.append_tag(new cafen.ofc2js.ofc_tag(x,y, {text : text, bold : options.bold, underline : options.underline, border : options.border, alpha : options.alpha, colour : colour}));
			}
		}
	}
}

cafen.ofc2js.ofc_tags.prototype = {
	colour : function( colour ){
		this.data['colour'] = colour;
		return this;
	},
	background : function( colour ){
		this.data['background'] = colour;
		return this;
	},
	font : function(font, size){
		if (font != null)
			this.data['font'] = font;
		this.data['font-size'] = size;
		return this;
	},
	padding : function(x, y)	{
		this.data['pad-x'] = x;
		this.data['pad-y'] = y;
		return this;
	},
	rotate : function(angle){
		this.data['rotate'] = angle;
//		this.rotate(angle);
		return this;
	},
	align_x_center : function() {
		this.data['align-x'] = "center";
		return this;
	},
	align_x_left : function()	{
		this.data['align-x'] = "left";
		return this;
	},
	align_x_right : function(){
		this.data['align-x'] = "right";
		return this;
	},
	align_y_above : function(){
		this.data['align-y'] = "above";
		return this;
	},
	align_y_below : function()	{
		this.data['align-y'] = "below";
		return this;
	},
	align_y_center : function(){
		this.data['align-y'] = "center";
		return this;
	},
	append_tag : function(tag) 	{
		this.data['values'].push(tag);
	}
}

cafen.ofc2js.ofc_tag = function(x, y, options) {
	this.data = {}
 	if (x != null && y != null) 
 		this.set_xy(x,y);
 	if (options != null) {
 		if (options.text != null)
 			this.text(options.text);	
 		if (options.style != null)
 			this.text(options.text);	
 		if (options.colour != null)
 			this.colour(options.colour);	
		this.style(options.bold, options.underline, options.border, options.alpha);
 	}
}

cafen.ofc2js.ofc_tag.prototype = {
	colour : function( colour ){
		this.data['colour'] = colour;
		return this;
	},
	text : function(text) {
		this.data['text'] = text;
		return this;
	},
	on_click : function(on_click) {
		this.data['on-click'] = on_click;
		return this;
	},
	style : function(bold, underline, border, alpha ) {
		if (bold != null)
			this.data['bold'] = bold;
		if (underline != null)
			this.data['underline'] = underline;
		if (border != null)
			this.data['border'] = border;
		this.data['alpha'] = alpha || 1.0;
		return this;
	},
	set_xy : function(x, y) {
		this.data['x'] = x;
		this.data['y'] = y;
	}
}


cafen.ofc2js.open_flash_chart = function() {
	this.attributes = {};
	this.variables = {};
	this.params = {};
	this.data = {};
	this.data['elements'] = [];
}

cafen.ofc2js.open_flash_chart.prototype = {
	version : 'G30',
	attributes : {},
	variables : {},
	params : {},
	set_title : function( t ) {
		this.data['title'] = t;
	},
	set_x_axis : function( x ) {
		this.data['x_axis'] = x;	
	},
	set_y_axis : function( y ) {
		this.data['y_axis'] = y;
	},
	add_y_axis : function( y ) {
		this.data['y_axis'] = y;
	},
	set_y_axis_right : function( y ) {
		this.data['y_axis_right'] = y;
	},
	add_element : function( e ) {
		this.data['elements'].push(e);
	},
	callFun : function(obj, fncOptions) {
		if (fncOptions != null && fncOptions.length > 0) {
			for(var k = 0;  k < fncOptions.length; k++) {
				var fncName = fncOptions[k].cmd;
				var args = (fncOptions[k].args != null) ? fncOptions[k].args : [];
				if (typeof obj[fncName] != 'function')
					continue;
				if (fncName == 'set_default_dot_style' || fncName == 'set_on_show' || fncName == 'on_show' || fncName == 'set_labels') 
					args = [this.addObject(args)];
				if (fncName == 'append_value' && args.type != null) 
					obj.append_value(this.addObject(args));
				else {
					switch(args.length) {
						case 0 :
							obj[fncName]();
							break;
						case 1 :
							obj[fncName](args[0]);
							break;
						case 2 :
							obj[fncName](args[0],args[1]);
							break;
						case 3 :
							obj[fncName](args[0],args[1],args[2]);
							break;
						case 4 :
							obj[fncName](args[0],args[1],args[2],args[3]);
							break;
						case 5 :
							obj[fncName](args[0],args[1],args[2],args[3],args[4]);
							break;
					}
				}
			}
		}
		return obj;
	},
	addObject : function(objOption) {
		objOption = cafen.extend({type : '', args : [], callFnc : []},objOption);
		switch(objOption.type) {
			case 'line' :
			case 'line_dot' :
			case 'line_hollow' :
			case 'bar' :
			case 'bar_filled' :
			case 'bar_glass' :
			case 'bar_cylinder' :
			case 'bar_cylinder_outline' :
			case 'bar_rounded_glass' :
			case 'bar_round' :
			case 'bar_dome' :
			case 'bar_round3d' :
			case 'bar_3d' :
			case 'bar_sketch' :
			case 'bar_stack' :
			case 'candle' :
			case 'hbar' :
			case 'pie' :
			case 'scatter' :
			case 'scatter_line' :
			case 'shape' :
			case 'shape_arrow' :
			case 'shape_box' :
			case 'shape_triangle' :
			case 'shape_circle' :
			case 'shape_pie' :
			case 'shape_star' :
			case 'shape_curves' :
			case 'area' :
			case 'area_line' :
			case 'area_hollow' :
			case 'ofc_tags' :
				this.add_element(this.callFun(new cafen.ofc2js[objOption.type](objOption.args[0],objOption.args[1],objOption.args[2],objOption.args[3]), objOption.callFnc));
				break;
			case 'ofc_arrows' :
				if (objOption.args[0].values != null && objOption.args[0].values.length > 0) {
					var barb_length =  objOption.args[0].size || 10;
					for(var i = 0; i < objOption.args[0].values.length; i++) {
						var tmpArr = objOption.args[0].values[i].split(',');
						var x = parseFloat(tmpArr[0]);
						var y = parseFloat(tmpArr[1]);
						var a = parseFloat(tmpArr[2]);
						var b = parseFloat(tmpArr[3]);
						var colour = tmpArr[4] || objOption.args[0].colour;
						if (!isNaN(x) && !isNaN(y) && !isNaN(a) && !isNaN(b)) 
							this.add_element(this.callFun(new cafen.ofc2js.ofc_arrow(x,y,a,b,colour,barb_length), objOption.callFnc));
					}
				}
				break;
			case 'xy_axis' :
				var y_axis_options = cafen.extend({},objOption.args[0]);
				y_axis_options.labels = null;
				y_axis_options.values = null;
				this.set_y_axis(this.callFun(new cafen.ofc2js.y_axis(y_axis_options), objOption.callFnc));
				var x_axis_options = cafen.extend({},objOption.args[0]);
				x_axis_options.min = null;
				x_axis_options.max = null;
				x_axis_options.step = x_axis_options.xstep || null;
				this.set_x_axis(this.callFun(new cafen.ofc2js.x_axis(x_axis_options), objOption.callFnc));
				break;	
			case 'x_axis' :
				this.set_x_axis(this.callFun(new cafen.ofc2js.x_axis(objOption.args[0]), objOption.callFnc));
				break;	
			case 'y_axis' :
				this.set_y_axis(this.callFun(new cafen.ofc2js.y_axis(objOption.args[0]), objOption.callFnc));
				break;	
			case 'y_axis_right' :
				this.set_y_axis_right(this.callFun(new cafen.ofc2js.y_axis_right(objOption.args[0]), objOption.callFnc));
				break;	
			case 'y_legend' :
				this.set_y_legend(this.callFun(new cafen.ofc2js.y_legend(objOption.args[0],objOption.args[1]), objOption.callFnc));
				break;
			case 'x_legend' :
				this.set_x_legend(this.callFun(new cafen.ofc2js.x_legend(objOption.args[0],objOption.args[1]), objOption.callFnc));
				break;
			case 'shape_rate' :
				cafen.ofc2js.shape.prototype.xyrate = objOption.args[0];
				break;
			case 'hollow_dot' :
			case 's_star' :
			case 'star' :
			case 'bow' :
			case 'anchor' :
			case 'dot' :
			case 'solid_dot' : 
			case 'line_on_show' :
			case 'bar_on_show' :
			case 'hbar_value' :
			case 'candle_value' :
			case 'bar_stack_value' :
			case 'bar_stack_key' :
			case 'dot_value' :
			case 'line_style' :
			case 'ofc_menu_item' :
			case 'ofc_menu_item_camera' :
			case 'ofc_menu' :
			case 'pie_value' :
			case 'pie_fade' :
			case 'pie_bounce' :
			case 'radar_axis_labels' :
				return this.callFun(new cafen.ofc2js[objOption.type](objOption.args[0],objOption.args[1],objOption.args[2]), objOption.callFnc);
				break;
			case 'shape_point' :
				return this.callFun(new cafen.ofc2js[objOption.type](objOption.args[0],objOption.args[1],objOption.args[2]), objOption.callFnc);
				break;
			case 'title' :
				this.set_title(this.callFun(new cafen.ofc2js.title(objOption.args[0],objOption.args[1]), objOption.callFnc));
				break;	
			case 'bg_colour' :
				this.set_bg_colour(objOption.args[0]);
				break;
			case 'radar_axis' :
				this.set_radar_axis(this.callFun(new cafen.ofc2js.radar_axis(objOption.args[0],objOption.args[1]), objOption.callFnc));
				break;
			case 'tooltip' :
				this.set_tooltip(this.callFun(new cafen.ofc2js.tooltip(objOption.args[0]), objOption.callFnc));
				break;
			case 'menu' :
				this.set_menu(this.callFun(new cafen.ofc2js.ofc_menu(objOption.args[0],objOption.args[1],objOption.args[2]), objOption.callFnc));
				break;
		}
	},
	set_x_legend : function( x ) {
		this.data['x_legend'] = x;
	},
	set_y_legend : function( y ) {
		this.data['y_legend'] = y;
	},
	set_bg_colour : function( colour ) {
		this.data['bg_colour'] = colour;	
	},
	set_radar_axis : function( radar ) {
		this.data['radar_axis'] = radar;
	},
	set_tooltip : function( tooltip ) {
		this.data['tooltip'] = tooltip;	
	},
	set_number_format : function(num_decimals, is_fixed_num_decimals_forced, is_decimal_separator_comma, is_thousand_separator_disabled ) {
		this.data['num_decimals'] = num_decimals;
		this.data['is_fixed_num_decimals_forced'] = is_fixed_num_decimals_forced;
		this.data['is_decimal_separator_comma'] = is_decimal_separator_comma;
		this.data['is_thousand_separator_disabled'] = is_thousand_separator_disabled;
	},
	set_menu : function(m) {
		this.data['menu'] = m;
	},
	toString : function(val) {
		return cafen.getJson2String(val);
	},
	toPrettyString : function() {
		this.toString(this.data);
	},
	toJson : function(obj) {
		switch (typeof obj) {
			case 'boolean':
			case 'number':
				return obj;
				break;
			case 'string':
				return obj;
				break;
			case 'object':
				if (obj === null) return 'null';
				if (obj.data != null)
					obj = obj.data;
				if (obj instanceof Function) return this.toJson(obj());
				if (obj instanceof Array) {
					var a = [];
					for(var i=0; i < obj.length; i++) {
						a.push(this.toJson(obj[i]));
					};
					return a;
				}
				if (obj instanceof Object) {
					var a = {};
					for(var objkey in obj) {
						var objvalue = obj[objkey];
						if (objvalue instanceof Function) objvalue = objvalue();
						a[this.toJson(objkey)] = this.toJson(objvalue);
					};
					return a;
				}
				break;
			case 'undefined':
			default:
				return '';
				break;
		}
	},
	isswfRendered : false,
	render : function(id, options) {
		if (typeof cafen.getMonitor != 'undefined')
			cafen.getMonitor(this.version);
		this.chartObj = cafen.$(id);
		if (options == null)
			options = {};
		if (options.width == null)
			options.width = this.chartObj.offsetWidth || parseInt(this.chartObj.style.width);
		if (options.height == null)
			options.height = this.chartObj.offsetHeight || parseInt(this.chartObj.style.height);
		if (options.wmode == null)
			options.wmode = 'transparent';
		this.setAttribute('width', options.width);
		this.setAttribute('height', options.height);
		this.dataid = (options.id == null) ? cafen.getUniqID('ofcjs') : options.id;
		if (cafen.isMobile() || options.imgrender) {
			this.isswfRendered = false;
			if (options.data == null) {
				this.chartObj.innerHTML = '<img src="http://chart.apis.google.com/chart?'+this.toGoogleChart(this.data)+'"  border=0 id="'+this.dataid+'">';
			} else {
				new cafen.Ajax({},this.loadGoogleChart.bind(this), options.data, 'get');
			}
		} else {
			this.isswfRendered = true;
			if (options.data == null) {
				cafen.ofc2js.set(this.dataid, this.toJson(this.data));
				this.addVariable('get-data','cafen.ofc2js.load');
			} else 
				this.addVariable('data-file',options.data);
			this.addVariable('id',this.dataid);
			this.setAttribute('id',this.dataid);
			this.addParam('wmode', options.wmode);
			if (options.loading != null)
				this.addVariable('loading',options.loading);
			this.setAttribute('swf', cafen.ofc2js.getFlashPath());
			this.chartObj.innerHTML = this.getSWFHTML();
		}
		return this;
	},
	loadGoogleChart : function(xml) {
		var jData = cafen.getString2Json(xml.getHTML());
		this.chartObj.innerHTML = '<img src="http://chart.apis.google.com/chart?'+this.toGoogleChart(jData)+'"  border=0 id="'+this.dataid+'">';
	},
	toGoogleChart : function(inData) {
		var params = [];
		var cwidth = parseInt(this.getAttribute("width"));
		if (cwidth > 1000)
			cwidth = 1000;
		var cheight = parseInt(this.getAttribute("height"));
		if (cheight > 1000)
			cheight = 1000;
		if (cwidth * cheight > 300000) {
			var reSizeRate = 300000 / (cwidth * cheight);
			cwidth = Math.round(cwidth * reSizeRate);
			cheight = Math.round(cheight * reSizeRate);
		}
		params.push("chs="+cwidth+'x'+cheight);
		params = this.getGoogleData(this.toJson(inData), params);
		return params.join('&');	
	},
	debug : function(obj) {
//		window.debug_mode = true;
//		cafen.debugMessage(cafen.getJson2String(obj,0));
	},
	getGoogleData : function(inData, params) {
		var tchxt= [];
		var tchxl = [];
		var chxt= [];
		var chxl = [];
		var chxp = [];
		var chxr = [];
		var chxs = [];
		var chm = [];
		var grideData = {xstep : 0, ystep : 0};
		var chartTypeEnd = '';
		for(var ckey in inData) {
			var currObj = inData[ckey];
			switch(ckey) {
				case 'title' :
					if (currObj.text != null && currObj.text != '') {
						params.push('chtt='+encodeURIComponent(currObj.text)+'');
						if (currObj.style != null && currObj.style != '') {
							var reg = null;
							var fontColor = null;
							var fontSize = null;
							if (reg = cafen.find('color:(#[0-9a-f]{6})', currObj.style, true)) 
								fontColor = this.getGoogleColor(reg[1], 1, '464646');
							else
								fontColor = "464646";
							if (reg = cafen.find('font-size:([0-9]+)px', currObj.style, true)) 
								fontSize = reg[1];
							else
								fontSize = "13";
							params.push('chts='+fontColor+','+fontSize);
						}
					}
					break;
				case 'x_legend' :
					if (currObj.text != null && currObj.text != '') {
						tchxt.push("x");
						tchxl.push(encodeURIComponent(currObj.text));
					}
					break;
				case 'y_legend' :
					if (currObj.text != null && currObj.text != '') {
						tchxt.push("y");
						tchxl.push(encodeURIComponent(currObj.text));
					}
					break;
				case 'x_axis' :
					if (currObj.labels != null) {
						chxt.push("x");
						var currPos = chxt.length -1;
						var labels = currObj.labels.labels;
						var labelsData = [];
						for(var i = 0; i < labels.length; i++)
							labelsData.push(encodeURIComponent(labels[i].text));
						chxl.push(currPos +':|'+labelsData.join('|'));
						if (currObj['grid-colour'] != null && labels.length > 1) 
							grideData.xstep = 100 / (labels.length -1);
					} else {
						chxt.push("x");
						var currPos = chxt.length -1;
						var minValue = currObj.min || 0;
						var maxValue = currObj.max || 10;
						var stepValue = currObj.steps || 1;
						chxr.push(currPos +','+minValue +','+maxValue+','+stepValue);
						params.push('chds=0,'+maxValue);
						if (currObj['grid-colour'] != null && stepValue > 0) 
							grideData.xstep = Math.round(100 / ((maxValue - minValue) / stepValue) );
					}
					if (currObj.colour != null)
						chxs.push(''+(chxt.length-1)+','+this.getGoogleColor(currObj.colour,1,'464646')+',12,0,lt');
					break;
				case 'y_axis_right' :
					if (currObj.labels != null) {
						chxt.push("r");
						var currPos = chxt.length -1;
						var labels = currObj.labels.labels;
						var labelsData = [];
						for(var i = 0; i < labels.length; i++)
							labelsData.push(encodeURIComponent(labels[i].text));
						chxl.push(currPos +':|'+labelsData.join('|'));
						if (currObj['grid-colour'] != null && labels.length > 0) 
							grideData.ystep = Math.round(100 / labels.length );
					} else {
						chxt.push("r");
						var currPos = chxt.length -1;
						var minValue = currObj.min || 0;
						var maxValue = currObj.max || 10;
						var stepValue = currObj.steps || 1;
						chxr.push(currPos +','+minValue +','+maxValue+','+stepValue);
						if (currObj['grid-colour'] != null && stepValue > 0) 
							grideData.ystep = Math.round(100 / ((maxValue - minValue) / stepValue) );
					}
					if (currObj.colour != null)
						chxs.push(''+(chxt.length-1)+','+this.getGoogleColor(currObj.colour,1,'464646')+',12,0,lt');
					break;
				case 'radar_axis' :
					chartTypeEnd = 'r';
					if (currObj.labels != null) {
						chxt.push("y");
						var currPos = chxt.length -1;
						var labels = currObj.labels.labels;
						var labelsData = [];
						for(var i = 0; i < labels.length; i++) {
							if (labels[i] != '')
								labelsData.push(encodeURIComponent(labels[i]));
						}
						chxl.push(currPos +':|'+labelsData.join('|'));
						var minValue = currObj.min || 0;
						var maxValue = currObj.max || 10;
						var stepValue = currObj.steps || 1;
						chxr.push(currPos +','+minValue +','+maxValue+','+stepValue);
						params.push('chds='+minValue+','+maxValue);
					} else {
						chxt.push("y");
						var currPos = chxt.length -1;
						var minValue = currObj.min || 0;
						var maxValue = currObj.max || 10;
						var stepValue = currObj.steps || 1;
						chxr.push(currPos +','+minValue +','+maxValue+','+stepValue);
						params.push('chds='+minValue+','+maxValue);
					}
					if (currObj['spoke-labels'] != null) {
						chxt.push("x");
						var currPos = chxt.length -1;
						var labels = currObj['spoke-labels'].labels;
						var labelsData = [];
						for(var i = 0; i < labels.length; i++)
							labelsData.push(encodeURIComponent(labels[i]));
						chxl.push(currPos +':|'+labelsData.join('|'));
					}
					break;
				case 'y_axis' :
					if (currObj.labels != null) {
						chxt.push("y");
						var currPos = chxt.length -1;
						var labels = currObj.labels.labels;
						var labelsData = [];
						for(var i = 0; i < labels.length; i++)
							labelsData.push(encodeURIComponent(labels[i].text));
						chxl.push(currPos +':|'+labelsData.join('|'));
						if (currObj['grid-colour'] != null && labels.length > 0) 
							grideData.ystep = Math.round(100 / labels.length );
					} else {
						chxt.push("y");
						var currPos = chxt.length -1;
						var minValue = currObj.min || 0;
						var maxValue = currObj.max || 10;
						var stepValue = currObj.steps || 1;
						chxr.push(currPos +','+minValue +','+maxValue+','+stepValue);
						params.push('chds='+minValue+','+maxValue);
						if (currObj['grid-colour'] != null && stepValue > 0) 
							grideData.ystep = Math.round(100 / ((maxValue - minValue) / stepValue) );
					}
					if (currObj.colour != null)
						chxs.push(''+(chxt.length-1)+','+this.getGoogleColor(currObj.colour,1,'464646')+',12,0,lt');
					break;
				 case 'elements' :
			 		var chartType = '';
			 		var chartData = [];
			 		var chartColor = [];
			 		var chartFill = [];
			 		var chartLine = [];
			 		var chartLegend = [];
					var candleHighs = [];
					var candleTops = [];
					var candleBottoms = [];
					var candleLows = [];
				 	for (var i = 0 ;  i < currObj.length; i++) {
				 		var eleObj = currObj[i];
				 		var chartChecked = true;
				 		switch(eleObj.type) {
							case 'line_dot' :
							case 'line' :
							case 'line_hollow' :
				 				chartType = 'lc';	
				 				break;
							case 'area' :
							case 'area_line' :
							case 'area_hollow' :
				 				chartType = 'lc';	
				 				break;
				 			case 'hbar' :
				 				chartType = 'bhs';	
								chartChecked = false;
								var rightData = [];
								var leftData = [];
								for(var j = 0 ; j < eleObj.values.length ; j++) {
									var minValue = Math.min(eleObj.values[j].right, eleObj.values[j].left);
									var maxValue = Math.max(eleObj.values[j].right, eleObj.values[j].left);
			 						rightData.push(maxValue - minValue);
			 						leftData.push(minValue);
			 					}
			 					chartData.push(leftData.join(',') +'|'+rightData.join(','));
			 					chartColor.push('ffffff00');
			 					chartColor.push(this.getGoogleColor(eleObj.colour, 0.5, ''));
			 					chartLegend.push('|'+eleObj.text);
				 				break;
							case 'bar_stack' :
				 				chartType = 'bvs';	
								chartChecked = false;
								var stackDatas = [];
								for(var j = 0 ; j < eleObj.keys.length; j++) {
									var eleVal = eleObj.keys[j];
				 					chartLegend.push(eleVal.text);
				 					chartColor.push(this.getGoogleColor(eleVal.colour, 1, ''));
				 					var currVal = [];
									for(var k = 0 ; k < eleObj.values.length; k++) {
										currVal.push(eleObj.values[k][j]);
									}												 	
									stackDatas.push(currVal.join(','));			
								}
			 					chartData.push(stackDatas.join('|'));
				 				break;
							case 'bar' :
							case 'bar_filled' :
							case 'bar_glass' :
							case 'bar_cylinder' :
							case 'bar_cylinder_outline' :
							case 'bar_rounded_glass' :
							case 'bar_round' :
							case 'bar_dome' :
							case 'bar_round3d' :
							case 'bar_3d' :
							case 'bar_sketch' :
				 				chartType = 'bvg';	
				 				break;
							case 'pie' :
								chartType = (eleObj['animate'] != null) ? 'p3' : 'p';
								chartChecked = false;
								var pieData = [];
								var pieTitle = [];
								var pieColors = [];
								for(var j = 0 ; j < eleObj.values.length ; j++) {
			 						pieData.push(eleObj.values[j].value);
			 						pieTitle.push(eleObj.values[j].label);
			 						pieColors.push(this.getGoogleColor(eleObj.colours[j], 1, ''));
			 					}
			 					chartData.push(pieData.join(','));
			 					chartLegend.push(pieTitle.join('|'));
			 					chartColor.push(pieColors.join(','));
				 				break;
							case 'scatter' :
							case 'scatter_line' :
				 				chartType = 's';
								chartChecked = false;
								var pieData = [];
								var pieDatax = [];
								var pieDatay = [];
								var pieDatas = [];
								var pieTitle = [];
								var pieColors = [];
								for(var j = 0 ; j < eleObj.values.length ; j++) {
			 						pieDatax.push(eleObj.values[j].x);
			 						pieDatay.push(eleObj.values[j].y);
			 						pieDatas.push((eleObj.values[j]['dot-size'] || 1) *6);
			 					}
			 					chartData.push(pieDatax.join(',') +'|' + pieDatay.join(',') +'|'+ pieDatas.join(','));
			 					chartLegend.push(eleObj.text);
				 				break;
							case 'candle' :
								chartChecked = false;
								if (candleHighs.length > 0)
									break; 
				 				chartType = 'candle';
				 				var startNum = candleHighs.length;
								for(var j = 0 ; j < eleObj.values.length ; j++) {
									var candleObj = eleObj.values[j];
									candleHighs.push(candleObj['high'] || '0');
									candleTops.push(candleObj['top'] || '0');
									candleBottoms.push(candleObj['bottom'] || '0');
									candleLows.push(candleObj['low'] || '0');
								}
								chartFill.push('F,'+this.getGoogleColor(eleObj.colour, eleObj.alpha, '')+',0,'+startNum+':'+(startNum +eleObj.values.length -1)+',20');
								break;
							case 'shape' :
								chartChecked = false;
								if (chartType == 'lxy') 
									break;
								chartType = 'lxy';
								var posX = [];
								var posY = [];
								for(var j = 0 ; j < eleObj.values.length ; j++) {
									var valObj = eleObj.values[j];
									posX.push(valObj.x);
									posY.push(valObj.y);
									if (j > 50)
										break;
								}
								params.push('chd=t0:'+posX.join(',')+'|'+posY.join(','));
								break;
							default :
								chartChecked = false;
								this.debug(eleObj);
				 				break;
				 		}
				 		if (chartChecked) {
				 			var chartValues = [];
				 			var dotFill = [];
				 			for(var j = 0; j < eleObj.values.length ; j++) {
				 				if (typeof eleObj.values[j] == 'object') {
									dotFill = this.getGoogleDotType(eleObj.values[j], eleObj['colour'], chartData.length, j, dotFill);
				 					chartValues.push(eleObj.values[j].value);
				 				} else
				 					chartValues.push(eleObj.values[j]);
				 			}
			 				chartData.push(chartValues.join(','));
							var reg = null;
							chartColor.push(this.getGoogleColor(eleObj.colour, 1, ''));
			 				chartLegend.push(eleObj.text || '');
			 				if (eleObj.type == 'area' || eleObj.type == 'area_line' || eleObj.type == 'area_hollow') {
								if (eleObj.fill != null) {
									chartFill.push('B,'+this.getGoogleColor(eleObj.fill, eleObj['fill-alpha'], '')+','+(chartData.length -1)+','+chartData.length+',0');
								} else
									chartFill.push('B,,'+(chartData.length -1)+','+chartData.length+',0');
							}
							if (eleObj.width) {
								var lineWidth = eleObj.width;
								if (eleObj['line-style'] != null) {
									var styleObj = eleObj['line-style'];
									chartLine.push(lineWidth +','+styleObj.on +','+styleObj.off);
								}else 
									chartLine.push(lineWidth);
							} else
								chartLine.push('2');
							if (eleObj['dot-style'] != null) {
								var dotStyle = eleObj['dot-style'];
								chartFill = this.getGoogleDotType(dotStyle, eleObj['colour'], chartData.length -1, -1, chartFill);
								if (dotStyle.tip != null)
									chartFill.push('N,000000,'+(chartData.length -1)+',,12');
							}
							if (dotFill.length > 0) {
								for(var j = 0 ; j < 	dotFill.length ; j++)
									chartFill.push(dotFill[j]);
							}
			 			}
				 	}
				 	if (chartTypeEnd != 'r')
				 		chartTypeEnd = chartType;
				 	if (chartTypeEnd != 'lxy') {
				 		if (chartType == 'candle')
							params.push('chd=t0:'+candleLows.join(',')+'|'+candleTops.join(',')+'|'+candleBottoms.join(',')+'|'+candleHighs.join(','));
					 	else if (chartData.length > 0) {
							params.push('chd=t:'+chartData.join('|'));
							if (chartType == 'bvg' ) 
								params.push('chbh=a,3,10');
						}else if (chartFill.length == 0)
							params.push('chd=t:-1');
					}
				 	if (chartColor.length > 0)
						params.push('chco='+chartColor.join(','));
					if (chartLegend.length > 0) {
						if (chartType == 'p' || chartType == 'p3')
							params.push('chl='+chartLegend.join('|'));
						else
							params.push('chdl='+chartLegend.join('|'));
					}
					if (chartFill.length > 0) 
						params.push('chm='+chartFill.join('|'));
					if (chartLine.length > 0) 
						params.push('chls='+chartLine.join('|'));
				 	break;
				 case 'bg_colour' :
				 	var bg_colour = currObj;
					if (bg_colour != null && bg_colour != -1 && bg_colour != '')
						params.push('chf=bg,s,'+this.getGoogleColor(bg_colour,1,'#ffffff'));
					else
						params.push('chf=bg,s,ffffff00');
					break;
				 case 'menu' :
				 case 'tooltip' :
				 	break;
				 default :
				 	alert(ckey +cafen.toSS(currObj));
				 	break;
			}
		}
		if (tchxt.length > 0) {
			for(var i = 0 ; i < tchxt.length; i++) {
				chxt.push(tchxt[i]);
				var currPos = chxt.length -1;
				chxl.push(currPos +':|'+tchxl[i]);
				chxp.push(currPos +',50');
			}
		}
		if (chxt.length > 0) {
			params.push('chxt='+chxt.join(","));
			if (chxl.length > 0) 
				params.push('chxl='+chxl.join("|"));
			if (chxl.length > 0) 
				params.push('chxp='+chxp.join("|"));
			if (chxr.length > 0) 
				params.push('chxr='+chxr.join("|"));
			if (chxs.length > 0) 
				params.push('chxs='+chxs.join("|"));
		}
		if (chartTypeEnd != '' && chartTypeEnd != 'candle')
			params.push('cht='+chartTypeEnd);
		else
			params.push('cht=lc');
		if (grideData.xstep > 0 || grideData.ystep > 0)
			params.push('chg='+grideData.xstep+','+grideData.ystep+',1,5');
		return params ;
	},
	getGoogleColor : function(hexcolor, fillAlpha, def) {
		var reg = null;
		if (hexcolor == null || hexcolor == '')
			hexcolor = def;
		if (reg = cafen.find('#([0-9a-f]{6})', hexcolor, true)) 
			hexcolor = reg[1];
		else
			hexcolor = '';
		if (hexcolor != null && fillAlpha < 1) {
			var fillAlphaStr = Math.round((fillAlpha || 0) * 255).toString(16);
			if (fillAlphaStr.length == 1)
				fillAlphaStr = '0' + fillAlphaStr;
			if (fillAlphaStr != 'ff')
				hexcolor += fillAlphaStr;
		}
		return hexcolor;
	},
	getGoogleDotType : function(dotStyle, defColor, seqnIndex, seqnEnd, chartFill) {
		var dotSize = (dotStyle['dot-size'] || 3) * 1.5;
		var dotType = dotStyle['type'] || 'dot';
		var dotColor = dotStyle['colour'] || defColor; 
		var reg = null;
		dotColor = this.getGoogleColor(dotStyle['colour'], 1, defColor);
		switch(dotType) {
			case 'anchor' :
				chartFill.push('C,'+dotColor+','+seqnIndex+','+seqnEnd+','+dotSize);
				break;
			case 'dot' :
				chartFill.push('o,'+dotColor+','+seqnIndex+','+seqnEnd+','+dotSize);
				break;
			case 'solid-dot' :
				chartFill.push('d,'+dotColor+','+seqnIndex+','+seqnEnd+','+dotSize);
				break;
			case 'hollow-dot' :
				chartFill.push('s,'+dotColor+','+seqnIndex+','+seqnEnd+','+dotSize);
				break;
			case 'bow' :
				chartFill.push('x,'+dotColor+','+seqnIndex+','+seqnEnd+','+dotSize);
				break;
			case 'star' :
				chartFill.push('c,'+dotColor+','+seqnIndex+','+seqnEnd+','+dotSize);
				break;
			default :
				alert(dotType);
		}
		return chartFill;
	},
	show : function(bl) {
		this.chartObj.style.display = '';
		if (bl) 
			this.reload();
	},
	reload : function() {
		if (this.isswfRendered)
			this.chartObj.innerHTML = this.getSWFHTML();
	},
	saveImage : function(img_name, saveUrl, callBack) {
		if (this.isswfRendered) {
			var swfObj = document.getElementById(this.dataid);
			if (swfObj != null && typeof swfObj.post_image == 'function') {
				var callUrl = cafen.ofc2js.getUploadUrl(saveUrl);
				if (callUrl == null || callUrl == '') {
					alert('to use Save Image Function, must pre-define cafenGlobalConf.ofc_saveurl !');
					return '';
				} else {
					try {
					swfObj.post_image(callUrl + '?mode=OFC2JS&name='+img_name , 'cafen.ofc2js.saveImg', false);
					} catch(ex) {}
					return img_name;
				}
			} else
				return '';
		} else {
			alert('unSupported!! Sorry!!');
		}
	},
	getImageData : function() {
		if (this.isswfRendered) {
			var swfObj = document.getElementById(this.dataid);
			if (swfObj != null && typeof swfObj.get_img_binary == 'function') 
				return 'data:image/png;base64,'+swfObj.get_img_binary();
			else
				return '';
		} else {
			var swfObj = document.getElementById(this.dataid);
			return swfObj.src;
		}
	},
	getImage : function() {
		if (this.isswfRendered) {
			if (!document.all) {
				var swfObj = document.getElementById(this.dataid);
				if (swfObj != null && typeof swfObj.get_img_binary == 'function') 
					return 'data:image/png;base64,'+swfObj.get_img_binary();
				else
					return '';
			} else 
				return  cafen.ofc2js.getSaveUrl() + this.saveImage('junk/' +cafen.getUniqID('ofcjs')+'.png');
		} else {
			var swfObj = document.getElementById(this.dataid);
			return swfObj.src;
		}
	},
	getJson : function(bl) {
		return cafen.getJson2String(this.toJson(this.data), 0);
	},
	hide : function() {
		this.chartObj.style.display = 'none';
	},	
	remove : function() {
		try {
			this.chartObj.innerHTML = '';
			this.hide();
//			if (this.chartObj.parentNode != null)
//				this.chartObj.parentNode.removeChild(this.chartObj);
		} catch(ex) {
			
		}
	},
	setAttribute: function(name, value){
		this.attributes[name] = value;
	},
	getAttribute: function(name){
		return this.attributes[name];
	},
	addVariable: function(name, value){
		this.variables[name] = value;
	},
	addParam: function(name, value){
		this.params[name] = value;
	},
	getParams: function(){
		return this.params;
	},
	getVariable: function(name){
		return this.variables[name];
	},
	getVariables: function(){
		return this.variables;
	},
	getVariablePairs: function(){
		var variablePairs = new Array();
		var key;
		var variables = this.getVariables();
		for(key in variables){
			variablePairs[variablePairs.length] = key +"="+ variables[key];
		}
		return variablePairs;
	},
	getSWFHTML: function() {
		var swfNode = "";
		if (navigator.plugins && navigator.mimeTypes && navigator.mimeTypes.length) {
			if (this.getAttribute("doExpressInstall")) {
				this.addVariable("MMplayerType", "PlugIn");
				this.setAttribute('swf', this.xiSWFPath);
			}
			swfNode = '<embed type="application/x-shockwave-flash" src="'+ this.getAttribute('swf') +'?'+cafen.getUniqID('no')+'" width="'+ this.getAttribute('width') +'" height="'+ this.getAttribute('height') +'" style="'+ this.getAttribute('style') +'"';
			swfNode += ' id="'+ this.getAttribute('id') +'" name="'+ this.getAttribute('id') +'" allowScriptAccess="always" ';
			var params = this.getParams();
			 for(var key in params){ swfNode += [key] +'="'+ params[key] +'" '; }
			var pairs = this.getVariablePairs().join("&");
			 if (pairs.length > 0){ swfNode += 'flashvars="'+ pairs +'"'; }
			swfNode += '/>';
		} else { // PC IE
			if (this.getAttribute("doExpressInstall")) {
				this.addVariable("MMplayerType", "ActiveX");
				this.setAttribute('swf', this.xiSWFPath);
			}
			swfNode = '<object id="'+ this.getAttribute('id') +'" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+ this.getAttribute('width') +'" height="'+ this.getAttribute('height') +'" style="'+ this.getAttribute('style') +'" >';
			swfNode += '<param name="allowScriptAccess" value="always" />';
			swfNode += '<param name="movie" value="'+ this.getAttribute('swf') +'?'+cafen.getUniqID('no')+'" />';
			var params = this.getParams();
			for(var key in params) {
			 swfNode += '<param name="'+ key +'" value="'+ params[key] +'" />';
			}
			var pairs = this.getVariablePairs().join("&");
			if(pairs.length > 0) {swfNode += '<param name="flashvars" value="'+ pairs +'" />';}
			swfNode += "</object>";
		}
		return swfNode;
	}
}


function ofc_ready() {}
function open_flash_chart_data(id) {}


var cafenOFC2JS_HTC = new cafenOFC2JS();
if (cafen.checkLoad != null)
	cafen.checkLoad();
