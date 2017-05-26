<?php
namespace app\home\controller;

use app\common\controller\HomeBase;
use app\common\model\User;
use think\Config;
use think\Db;
use think\Session;
use app\common\model\UserLoginLog;

class Index extends HomeBase
{

    private $log;

    public function _initialize()
    {
        parent::_initialize();
        $this->log = new UserLoginLog();
    }

    public function index()
    {
        return $this->fetch();
    }

    public function login()
    {
        if ($this->request->isPost()) {
            $data = $this->request->only([
                'username',
                'password',
                'verify'
            ]);
            $validate_result = $this->validate($data, 'Login');
            
            if ($validate_result !== true) {
                $this->error($validate_result);
            } else {
                $user_model = new User();
                $user = $user_model->where([
                    'username' => $data['username']
                ])->find();
                if (empty($user) || $user['password'] != md5($data['password'] . Config::get('salt'))) {
                    if (! empty($user)) {
                        $this->log->addLog($user['id'], 0, $this->request->ip(), $this->log->type['login'], $_SERVER['HTTP_USER_AGENT']);
                    }
                    return $this->error("用户名或密码错误");
                } else {
                    if ($user['status'] != 1) {
                        $this->error('当前用户已禁用');
                    } else {
                        Session::set('userid', $user['id']);
                        Session::set('username', $user['username']);
                        $this->log->addLog($user['id'], 1, $this->request->ip(), $this->log->type['login'], $_SERVER['HTTP_USER_AGENT']);
                        Db::name('user')->update([
                            'last_login_time' => date('Y-m-d H:i:s', time()),
                            'last_login_ip' => $this->request->ip(),
                            'id' => $user['id']
                        ]);
                        $this->success('登录成功');
                    }
                }
            }
        }
        return $this->error("请求错误");
    }

    /**
     * 退出登录
     */
    public function logout()
    {
        if (Session::has('userid')) {
            $this->log->addLog(Session::get('userid'), 1, $this->request->ip(), $this->log->type['logout'], $_SERVER['HTTP_USER_AGENT']);
            Session::delete('userid');
            Session::delete('username');
            $this->success('退出成功', 'home/index/index');
        } else {
            $this->error('操作错误', 'home/index/index');
        }
    }

    public function sign()
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            $validate_result = $this->validate($data, 'User');
            
            if ($validate_result !== true) {
                $this->error($validate_result);
            } else {
                $data['sign_ip'] = $this->request->ip();
                $data['password'] = md5($data['password'] . Config::get('salt'));
                $user_model = new User();
                $id = $user_model->allowField(true)->save($data);
                if ($id > 0) {
                    Session::set('userid', $id);
                    Session::set('username', $data['username']);
                    $this->success('注册成功');
                } else {
                    $this->error('注册失败');
                }
            }
        }
    }
}
