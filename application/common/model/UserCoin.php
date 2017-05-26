<?php
namespace app\common\model;

use think\Model;
use org\Bitcoin;

class UserCoin extends Model
{

    public function createWalletAddress($userid, $coin)
    {
        $usercoin = $this->where([
            'userid' => $userid,
            'coinname' => $coin['name']
        ])->find();
        
        if (empty($usercoin)) {
            // 用户没有充值地址，需要分配一个新的地址
            if ($coin['type'] == 'btc') {
                // 币种为比特币类型
                $btc = new Bitcoin($coin['rpc_username'], $coin['rpc_password'], $coin['rpc_host'], $coin['rpc_port']);
                if ($btc->getinfo() == false) {
                    $this->error('钱包链接失败');
                }
                $address = $btc->getnewaddress();
            } elseif ($coin['type'] == 'eth') {
                // 币种为以太坊类型
            }
            $savedate = [
                'userid' => $userid,
                'coinname' => $coin['name'],
                'address' => $address,
                'available' => 0,
                'frozen' => 0
            ];
            $savedate['id'] = $this->save($savedate);
            if ($savedate['id'] !== false) {
                $usercoin = $savedate;
            }
        }
        return $usercoin;
    }
}