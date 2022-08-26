mergeInto(LibraryManager.library, {
	varcall: function(f, thisObj, args) {
		f = Emval.toValue(f);
		thisObj = Emval.toValue(thisObj);
		args = Emval.toValue(args);
		// console.log(thisObj + "." + (f.name.length > 0 ? f.name : "?") + "(" + JSON.stringify(args) + ")");
		let result = f.apply(thisObj, args);
		return Emval.toHandle(result);
	},
	wrapLuaFunction: function(statePtrHandle) {
		let statePtr = Emval.toValue(statePtrHandle);
		return Emval.toHandle(function(...args) {
			let resultValue = _callWrappedLuaFunction(Emval.toHandle(statePtr), Emval.toHandle(args));
			let value = Emval.toValue(resultValue);
			__emval_decref(resultValue);  // Increased on the C side manually
			return value;
		})
	},
});
