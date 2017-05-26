<?php
namespace app\home\validate;

use think\Validate;

class User extends Validate
{

    protected $rule = [
        'username' => 'require|unique:user',
        'password' => 'confirm:confirm_password',
        'confirm_password' => 'confirm:password',
        'email' => 'email'
    ];

    protected $message = [
        'username.require' => '请输入用户名',
        'username.unique' => '用户名已存在',
        'password.confirm' => '两次输入密码不一致',
        'confirm_password.confirm' => '两次输入密码不一致',
        'email.email' => '邮箱格式错误'
    ];
}