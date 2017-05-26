<?php
namespace app\common\model;

use think\Model;

class User extends Model
{

    protected $insert = [
        'create_time'
    ];

    /**
     * 创建时间
     *
     * @return bool|string
     */
    protected function setCreateTimeAttr()
    {
        return date('Y-m-d H:i:s');
    }

    /**
     * 获取GA验证码
     *
     * @param unknown $userid            
     * @return unknown|NULL
     */
    public function getGoogleAuthenticator($userid)
    {
        $ga = $this->field('google_authenticator')->find($userid);
        if (! empty($ga)) {
            $ga = $ga['google_authenticator'];
            $ga = json_decode($ga);
            return (array) $ga;
        }
        return [
            'secret' => null,
            'loginStatus' => 0,
            'withdrawStatus' => 0
        ];
    }

    /**
     * 更新GA验证码
     *
     * @param unknown $userid            
     * @param unknown $secret            
     * @param number $loginStatus            
     * @param number $withdrawStatus            
     */
    public function setGoogleAuthenticator($userid, $secret, $loginStatus = 0, $withdrawStatus = 0)
    {
        $ga = [
            'secret' => $secret,
            'loginStatus' => $loginStatus,
            'withdrawStatus' => $withdrawStatus
        ];
        return $this->where([
            'id' => $userid
        ])->setField('google_authenticator', json_encode($ga));
    }
}