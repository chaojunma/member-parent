var options = {};

$.extend({

	/**
	 * 设置参数
	 * field 字段名称
	 * fn 方法名
	 */
	helper : function(field, fn) {
		// 将回调函数放入对象
		if(!options[field]){
			options[field] = fn;
		} else {
			var fns = options[field];
			if(fns instanceof Array){// 数组
				// 将回调函数放入数组
				fns.unshift(fn);
				options[field] = fns;
			} else {
				var arr = new Array();
				arr.push(fn);
				arr.push(fns);
				options[field] = arr;
			}
		}
	},

	/**
	 * 替换元素
	 * @param dataL 数据列表对象
	 * @param template 模板对象
	 * @param arr 数组
	 * @param item 数据对象
	 * @param last 是否是最后一条
	 */
	template : function(dataL, template, arr, item, last) {

		// 定义正则
		var reg = new RegExp(/^reg_.*$/);

		// 遍历数组
		for (var i = 0; i < arr.length; i++) {
			
			// 获取字段名称
			var field = arr[i];
			var regExp = null;
			var bool = false;

			if (reg.test(field)) { // 匹配正则
				// 获取对象名称
				var field = arr[i].split("_")[1];
				regExp = new RegExp("{" + field + "}", "g");
				bool = true;
			}

			// 获取字段数据
			var value = item[field];
			if (options[field]) { //若字段数据需要处理
				
				if(options[field] instanceof Array){
					var fns = options[field];
					var fn = fns.pop();
					fns.unshift(fn);
					if(fn){
						// 通过回调函数处理数据
						value = fn(value, item);
					}
				} else {
					// 通过回调函数处理数据
					value = options[field](value, item);
				}
				
			}

			// 待替换的元素
			var element = bool ? regExp : "{" + field + "}";

			// 替换模板数据
			template = template.replace(element, value);

		}// end for

		
		// 是否是最后一条
		if(last){
			for(var key in options){
				// 删除配置
				delete options[key];
			}
		}
		
		// 展示数据列表
		dataL.append(template);
	}
});
