<?php
namespace app\home\validate;

use think\Validate;

class UserWithdraw extends Validate
{

    protected $rule = [
        'userid' => 'require',
        'coinname' => 'require',
        'address' => 'require',
        'amount' => 'require|min:0'
    ];

    protected $message = [
        'userid.require' => '请输入用户id',
        'coinname.require' => '请输入币种名称',
        'address.require' => '请输入钱包地址',
        'amount.require' => '请输入金额'
    ];
}