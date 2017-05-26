<?php
namespace app\home\controller;

use app\common\controller\HomeBase;
use app\common\model\User;
use think\Session;
use think\Config;
use app\common\model\Coin;
use app\common\model\UserCoin;
use think\Loader;
use think\Db;

class User extends HomeBase
{

    private $user_model;

    /**
     * 初始化
     *
     * {@inheritDoc}
     *
     * @see \app\common\controller\HomeBase::_initialize()
     */
    public function _initialize()
    {
        parent::_initialize();
        if (! user_is_login()) {
            $this->error('请先登录', 'home/index/index');
        }
        $this->user_model = new User();
        $this->assign('controller', Loader::parseName($this->request->controller()));
        $this->assign('method', Loader::parseName($this->request->action()));
    }

    /**
     * 用户中心首页
     *
     * @return mixed
     */
    public function index()
    {
        return $this->fetch();
    }

    /**
     * 设置谷歌验证
     *
     * @return mixed
     */
    public function setga()
    {
        $ga = $this->user_model->getGoogleAuthenticator(Session::get('userid'));
        $ga_tmp = createGoogleAuthenticator($ga['secret']);
        $ga['secret'] = $ga_tmp['secret'];
        $ga['qrCodeUrl'] = $ga_tmp['qrCodeUrl'];
        return $this->fetch('setga', [
            'gacode' => $ga
        ]);
    }

    public function cancelga()
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            if (empty($data['ga'])) {
                $this->error('输入有误');
            }
            
            if (! validateGoogleAuthenticator(Session::get('secret'), $data['ga'])) {
                $this->error('谷歌验证失败');
            }
            
            if ($this->user_model->setGoogleAuthenticator(Session::get('userid'), null, 0, 0) !== false) {
                $this->success('取消成功');
            } else {
                $this->error('取消失败');
            }
        }
    }

    /**
     * 更新谷歌验证
     */
    public function upga()
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            if (empty($data['ga'])) {
                $this->error('输入有误');
            }
            
            if (! validateGoogleAuthenticator(Session::get('secret'), $data['ga'])) {
                $this->error('谷歌验证失败');
            }
            
            if ($data['ga_login'] != 1) {
                $data['ga_login'] = 0;
            }
            if ($data['ga_transfer'] != 1) {
                $data['ga_transfer'] = 0;
            }
            
            if ($this->user_model->setGoogleAuthenticator(Session::get('userid'), Session::get('secret'), $data['ga_login'], $data['ga_transfer']) !== false) {
                $this->success('设置成功');
            } else {
                $this->error('设置失败');
            }
        }
    }

    /**
     * 修改密码
     *
     * @return mixed
     */
    public function change_password()
    {
        return $this->fetch();
    }

    /**
     * 更新密码
     */
    public function update_password()
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            if (empty($data['old_password']) || empty($data['new_password']) || empty($data['confim_password'])) {
                $this->error('输入有误');
            }
            if ($data['new_password'] != $data['confim_password']) {
                $this->error('确认密码必须与新密码一致');
            }
            $userid = Session::get('userid');
            $user = $this->user_model->find($userid);
            
            if (empty($user)) {
                $this->error('系统错误');
            }
            
            if ($user['password'] != md5($data['old_password'] . Config::get('salt'))) {
                $this->error('旧密码错误');
            }
            $user['password'] = md5($data['new_password'] . Config::get('salt'));
            
            if ($this->user_model->where([
                'id' => $userid
            ])->setField('password', $user['password']) !== false) {
                Session::delete('userid');
                Session::delete('username');
                $this->success('修改成功，请重新登陆', 'home/index/index');
            } else {
                $this->error('系统错误');
            }
        }
    }

    /**
     * 虚拟币管理
     *
     * @return mixed
     */
    public function finance()
    {
        $coin_model = new Coin();
        $coins = $coin_model->where([
            'status' => 1
        ])->select();
        $usercoin_model = new UserCoin();
        $usercoin = $usercoin_model->where([
            'userid' => Session::get('userid')
        ])->select();
        foreach ($usercoin as $v) {
            $usercoin[$v['coinname']] = $v;
        }
        return $this->fetch('finance', [
            'coins' => $coins,
            'usercoin' => $usercoin
        ]);
    }

    /**
     * 虚拟币转出
     */
    public function withdraw()
    {
        $coin_model = new Coin();
        $usercoin_model = new UserCoin();
        $coinname = $this->request->param('coinname');
        $coins = $this->getAllCoin();
        if (isset($coins[$coinname])) {
            $coin = $coins[$coinname];
        } else {
            $coin = $coin_model->where([
                'status' => 1
            ])->find();
            if (! empty($coin)) {
                $coinname = $coin['name'];
            }
        }
        $usercoin = $usercoin_model->where([
            'userid' => Session::get('userid'),
            'coinname' => $coin['name']
        ])->find();
        return $this->fetch('withdraw', [
            'coins' => $coins,
            'usercoin' => $usercoin,
            'coinname' => $coinname
        ]);
    }

    /**
     * 转出更新
     */
    public function withdraw_update()
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            if (empty($data['address']) || empty($data['amount']) || empty($data['coinname'])) {
                $this->error('输入有误');
            }
            $coins = $this->getAllCoin();
            if (empty($coins[$data['coinname']])) {
                $this->error('币种错误');
            }
            if ($data['amount'] < $coins[$data['coinname']]['min_withdraw']) {
                $this->error('转出金额必须大于等于' . $coins[$data['coinname']]['min_withdraw']);
            }
            Db::startTrans();
            $usercoin = Db::name('user_coin')->where([
                'userid' => Session::get('userid'),
                'coinname' => $data['coinname']
            ])
                ->lock(true)
                ->find();
            if (empty($usercoin)) {
                // 用户没有充值地址，需要分配一个新的地址
                $usercoin_model = new UserCoin();
                $usercoin = $usercoin_model->createWalletAddress(Session::get('userid'), $coins[$data['coinname']]);
            }
            if ($data['amount'] > $usercoin['available']) {
                Db::rollback();
                $this->error('余额不足');
            }
            
            $rs[] = Db::name('user_coin')->where([
                'userid' => Session::get('userid')
            ])->setField('available', ($usercoin['available'] - $data['amount']));
            
            $rs[] = Db::name('user_withdraw')->insert([
                'userid' => Session::get('userid'),
                'coinname' => $data['coinname'],
                'address' => $data['address'],
                'amount' => $data['amount'],
                'create_time' => date('Y-m-d H:i:s'),
                'status' => 0
            ]);
            
            if (validateResult($rs)) {
                Db::commit();
                $this->success('转出申请提交成功，请等待审核');
            } else {
                Db::rollback();
                $this->success('转出失败');
            }
        }
        $this->error('操作错误');
    }

    /**
     * 虚拟币转入
     */
    public function recharge()
    {
        $coin_model = new Coin();
        $usercoin_model = new UserCoin();
        $coinname = $this->request->param('coinname');
        $coins = $this->getAllCoin();
        if (isset($coins[$coinname])) {
            $coin = $coins[$coinname];
        } else {
            $coin = $coin_model->where([
                'status' => 1
            ])->find();
            if (! empty($coin)) {
                $coinname = $coin['name'];
            }
        }
        $usercoin = $usercoin_model->where([
            'userid' => Session::get('userid'),
            'coinname' => $coin['name']
        ])->find();
        
        if (empty($usercoin)) {
            // 用户没有充值地址，需要分配一个新的地址
            $usercoin = $usercoin_model->createWalletAddress(Session::get('userid'), $coin);
        }
        
        return $this->fetch('recharge', [
            'coins' => $coins,
            'usercoin' => $usercoin,
            'coinname' => $coinname
        ]);
    }
}
