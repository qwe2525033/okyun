<?php
namespace app\admin\validate;

use think\Validate;

class Coin extends Validate
{

    protected $rule = [
        'name' => 'require|unique:coin',
        'type' => 'require',
        'title_cn' => 'require',
        'title_en' => 'require',
        'symbol' => 'require',
        'thumb' => 'require',
        'rpc_host' => 'require',
        'rpc_port' => 'require',
        'min_withdraw' => 'require',
        'status' => 'require'
    ];

    protected $message = [
        'name.require' => '请输入钱包名称',
        'type.require' => '请选择钱包类型',
        'title_cn.require' => '请输入钱包中文名',
        'title_en.require' => '请输入钱包英文名',
        'symbol.require' => '请输入钱包符号',
        'thumb.require' => '请上传钱包图标',
        'rpc_host.require' => '请输入钱包RPC服务器地址',
        'rpc_port.require' => '请输入钱包RPC服务器端口',
        'rpc_port.require' => '请输入最小转出金额',
        'status.require' => '请选择状态'
    ];
}