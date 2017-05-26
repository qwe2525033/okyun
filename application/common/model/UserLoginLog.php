<?php
namespace app\common\model;

use think\Model;

class UserLoginLog extends Model
{

    public $type = [
        'login' => 0,
        'logout' => 1
    ];

    public function addLog($userid, $status, $ip, $type, $device = null)
    {
        return $this->save([
            'userid' => $userid,
            'login_time' => date('Y-m-d H:i:s'),
            'login_status' => $status,
            'login_ip' => $ip,
            'login_type' => $type,
            'login_device' => $device
        ]);
    }
}