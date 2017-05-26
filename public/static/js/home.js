var element = layui.element();
var nav_login_index;
var nav_sign_index;


$('.layui-nav-item').find('a').removeClass('layui-this');
$('.layui-nav-tree').find('a[href*="' + GV.current_controller + '/'+GV.current_method + '"]').parent().addClass('layui-this').parents('.layui-nav-item').addClass('layui-nav-itemed');
$('.layui-nav-item').removeClass('layui-this');
$('.home-nav').find('a[href*="' + GV.current_controller + '"]').parent().addClass('layui-this');

layui.use('form', function(){
	  var form = layui.form();
	  //监听提交
	  form.on('submit(loginfilter)', function(data){
	    var username = $.trim(data.field.username);//获取用户名  
        var password = $.trim(data.field.password);  
        var verify = $.trim(data.field.verify);  

        var url = '/home/index/login';  
        var param = {"username": username, "password": password,"verify":verify};

        $.post(url, param, function(data) {  
            if (data.code == "1") {  
            	layer.msg(data.msg);
            	window.setTimeout(function(){
            		layer.close(nav_login_index);
            		window.location.reload();
            	},data.wait * 1000); 
                
            } else {
            	layer.msg(data.msg);
            }  
        }); 
	    return false;
	  });
	  
	  form.on('submit(signfilter)', function(data){
  	      var username = $.trim(data.field.username);//获取用户名  
          var email = $.trim(data.field.email);  
          var password = $.trim(data.field.password);  
          var confirm_password = $.trim(data.field.confirm_password);  

          var url = '/home/index/sign';  
          var param = {"username": username, "email":email,"password": password,"confirm_password":confirm_password};

          $.post(url, param, function(data) {  
              if (data.code == "1") {  
              	layer.msg(data.msg);
              	window.setTimeout(function(){
              		layer.close(nav_login_index);
              		window.location.reload();
              	},data.wait * 1000); 
                  
              } else {
              	layer.msg(data.msg);
              }  
          }); 
  	    return false;
  	  });
	  form.on('submit(change)', function(data){
		  var old_password = $.trim(data.field.old_password);//获取用户名  
	      var new_password = $.trim(data.field.new_password);  
	      var confim_password = $.trim(data.field.confim_password);  
	      var url = '/home/user/update_password';  
	      var param = {"old_password": old_password, "new_password": new_password,"confim_password":confim_password};

	      $.post(url, param, function(data) {  
	          if (data.code == "1") {  
	          	layer.msg(data.msg);
	          	window.setTimeout(function(){
	          		layer.close(nav_login_index);
	          		window.location = data.url;
	          	},data.wait * 1000); 
	          } else {
	          	layer.msg(data.msg);
	          }  
	      }); 
	    return false;
	  });
	  form.on('submit(withdrawfilter)', function(data){
		  var address = $.trim(data.field.address);//获取用户名  
		  var amount = $.trim(data.field.amount);  
		  var coinname = $.trim(data.field.coinname);  
		  var url = '/home/user/withdraw_update';  
		  var param = {"address": address, "amount": amount,'coinname':coinname};
		  
		  $.post(url, param, function(data) {  
			  if (data.code == "1") {  
				  layer.msg(data.msg);
				  window.setTimeout(function(){
					  layer.close(nav_login_index);
					  window.location = data.url;
				  },data.wait * 1000); 
			  } else {
				  layer.msg(data.msg);
			  }  
		  }); 
		  return false;
	  });
});
$(function(){  
	   $('#nav_login').on('click', function(){  
		   nav_login_index = layer.open({  
	           type: 1,  
	           title: '用户登录',  
	           skin: 'layui-layer-lan',  
	           shadeClose: true, //点击遮罩关闭层  
	           area : ['500px' , '300px'],  
	           content:$('#nav-login-box').html()
	       });  
	   });  
	   $('#nav_sign').on('click', function(){  
		   nav_sign_index = layer.open({  
	           type: 1,  
	           title: '用户注册',  
	           skin: 'layui-layer-lan',  
	           shadeClose: true, //点击遮罩关闭层  
	           area : ['500px' , '400px'],  
	           content:$('#nav-sign-box').html()
	       });  
	   }); 
});

function logout(){
	$.post('/home/index/logout', function(data) {
		if (data.code == "1") {  
          	layer.msg(data.msg);
          	window.setTimeout(function(){
          		window.location.reload();
          	},data.wait * 1000); 
              
          } else {
          	layer.msg(data.msg);
          }
	});
}