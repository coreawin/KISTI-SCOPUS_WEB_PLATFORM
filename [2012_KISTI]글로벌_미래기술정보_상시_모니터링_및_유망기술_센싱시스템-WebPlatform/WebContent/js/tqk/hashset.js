function HashSet(){
	this._arr = new Array();
}

HashSet.prototype.add = function(e){
	var arr = this._arr;
	var i = arr[e];
	if(i==null) arr.push(e);
};

HashSet.prototype.get = function(i) {
    return this._arr[i];
};

HashSet.prototype.size = function(i) {
    return this._arr.length;
};

HashSet.prototype.remove = function(e) {
    var arr =this._arr;
    var i = arr.indexOf(e);
    if (i != -1) arr.splice(i, 1);
};

HashSet.prototype.toString = function() {
    return this._arr.join(' ');
};