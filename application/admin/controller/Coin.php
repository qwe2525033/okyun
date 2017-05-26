<?php
namespace app\admin\controller;

use app\common\model\Coin as CoinModel;
use app\common\controller\AdminBase;
use org\Bitcoin;
use app\common\model\UserWithdraw;
use app\common\model\UserRecharge;
use app\common\model\User;
use think\Db;
use org\Ethereum;
use org\Ethereum_Transaction;

/**
 * 钱包管理
 * Class AdminUser
 *
 * @package app\admin\controller
 */
class Coin extends AdminBase
{

    protected $coin_model;

    protected function _initialize()
    {
        parent::_initialize();
        $this->coin_model = new CoinModel();
    }

    /**
     * 用户管理
     *
     * @param string $keyword            
     * @param int $page            
     * @return mixed
     */
    public function index()
    {
        $coin_list = $this->coin_model->order('id DESC')->select();
        
        return $this->fetch('index', [
            'coin_list' => $coin_list
        ]);
    }

    /**
     * 添加钱包
     *
     * @return mixed
     */
    public function add()
    {
        return $this->fetch();
    }

    /**
     * 编辑钱包
     *
     * @param
     *            $id
     * @return mixed
     */
    public function edit($id)
    {
        $coin = $this->coin_model->find($id);
        
        return $this->fetch('edit', [
            'coin' => $coin
        ]);
    }

    /**
     * 钱包信息
     *
     * @return mixed
     */
    public function info($id)
    {
        $coin = $this->coin_model->where([
            'id' => $id
        ])->find();
        $btc = new Bitcoin($coin['rpc_username'], $coin['rpc_password'], $coin['rpc_host'], $coin['rpc_port']);
        dump($btc->getinfo());
        // return $this->fetch();
    }

    /**
     * 保存用户
     */
    public function save()
    {
        if ($this->request->isPost()) {
            $data = $this->request->post();
            $validate_result = $this->validate($data, 'Coin');
            
            if ($validate_result !== true) {
                $this->error($validate_result);
            } else {
                if ($this->coin_model->allowField(true)->save($data)) {
                    $this->success('保存成功');
                } else {
                    $this->error('保存失败');
                }
            }
        }
    }

    /**
     * 更新钱包
     *
     * @param
     *            $id
     */
    public function update($id)
    {
        if ($this->request->isPost()) {
            $data = $this->request->param();
            $validate_result = $this->validate($data, 'Coin');
            
            if ($validate_result !== true) {
                $this->error($validate_result);
            } else {
                if ($this->coin_model->allowField(true)->save($data, $id) !== false) {
                    $this->success('更新成功');
                } else {
                    $this->error('更新失败');
                }
            }
        }
    }

    /**
     * 禁用钱包
     *
     * @param
     *            $id
     */
    public function disable($id)
    {
        if ($this->coin_model->save([
            'status' => 0
        ], [
            'id' => $id
        ])) {
            $this->success('禁用成功');
        } else {
            $this->error('禁用失败');
        }
    }

    /**
     * 启用钱包
     *
     * @param
     *            $id
     */
    public function enable($id)
    {
        if ($this->coin_model->save([
            'status' => 1
        ], [
            'id' => $id
        ])) {
            $this->success('启用成功');
        } else {
            $this->error('启用失败');
        }
    }

    /**
     * 虚拟币转出记录
     */
    public function withdraw($page = 1)
    {
        $withdraw_model = new UserWithdraw();
        $user_model = new User();
        $withdraws = $withdraw_model->order([
            'id' => 'DESC'
        ])->paginate(15, false, [
            'page' => $page
        ]);
        foreach ($withdraws as $withdraw) {
            $withdraw['username'] = $user_model->field('username')->find($withdraw['userid'])['username'];
        }
        return $this->fetch('withdraw', [
            'withdraw_list' => $withdraws
        ]);
    }

    public function withdraw_update($id, $status)
    {
        // 转出审核
        if (empty($id)) {
            $this->error('请选择要操作的记录');
        }
        if ($status == 0) {
            $this->error('状态错误');
        }
        if ($status == 2) {
            
            $withdraw_model = new UserWithdraw();
            Db::startTrans();
            $withdraw = Db::name('user_withdraw')->find([
                'id' => $id
            ]);
            if (empty($withdraw) || $withdraw['status'] == 1) {
                Db::rollback();
                $this->error('撤销失败');
            }
            $usercoin = Db::name('user_coin')->find([
                'userid' => $withdraw['userid'],
                'coinname' => $withdraw['coinname']
            ]);
            if (empty($usercoin)) {
                Db::rollback();
                $this->error('撤销失败');
            }
            $usercoin['available'] += $withdraw['amount'];
            $withdraw['status'] = 2;
            
            $rs[] = Db::name('user_coin')->update($usercoin);
            $rs[] = Db::name('user_withdraw')->update($withdraw);
            if (validateResult($rs)) {
                Db::commit();
                $this->success('撤销成功');
            } else {
                Db::rollback();
                $this->error('撤销失败');
            }
        }
        if ($status == 1) {
            // 转出操作
            $withdraw_model = new UserWithdraw();
            Db::startTrans();
            $withdraw = Db::name('user_withdraw')->find([
                'id' => $id
            ]);
            if (empty($withdraw) || $withdraw['status'] != 0) {
                Db::rollback();
                $this->error('审核失败');
            }
            
            $coins = $this->getAllCoin();
            $coin = $coins[$withdraw['coinname']];
            $rpc_host = $coin['rpc_host'];
            $rpc_port = $coin['rpc_port'];
            $rpc_username = $coin['rpc_username'];
            $rpc_password = $coin['rpc_password'];
            $withdraw_fee = $coin['withdraw_fee'];
            if (! empty($coin['type']) && $coin['type'] == 'btc') {
                // 比特币钱包类型
                $btc = new Bitcoin($rpc_username, $rpc_password, $rpc_host, $rpc_port);
                if (empty($btc->getinfo())) {
                    $this->error($coin['name'] . '钱包连接失败');
                }
                $balance = $btc->getbalance();
                if ($withdraw > $balance) {
                    $this->error($coin['name'] . '钱包余额不足，转出失败');
                }
                $txid = $btc->sendtoaddress($withdraw['address'], $withdraw['amount'] - $withdraw_fee);
                $withdraw['status'] = 1;
                $withdraw['fee'] = $withdraw_fee;
                $withdraw['txid'] = $txid;
                
                $rs = Db::name('user_withdraw')->update($withdraw);
                if (validateResult($rs)) {
                    Db::commit();
                    $this->success('审核转出成功');
                } else {
                    Db::rollback();
                    $this->error('转出失败');
                }
            } elseif (! empty($coin['type']) && $coin['type'] == 'eth') {
                // 以太坊钱包类型
                $eth = new Ethereum($rpc_host, $rpc_port);
                if (empty($eth->eth_protocolVersion())) {
                    $this->error($coin['name'] . '钱包连接失败');
                }
                $balance = $eth->eth_getBalance($rpc_username);
                if ($withdraw > $balance) {
                    $this->error($coin['name'] . '钱包余额不足，转出失败');
                }
                $send_transaction = new Ethereum_Transaction($rpc_username, $withdraw['address'], $eth->encode_dec($eth->to_real_value($withdraw['amount'] - $withdraw_fee))); // 减去0.00048作为手续费
                $sendrs = $eth->eth_sendTransaction($rpc_username, $rpc_password, $send_transaction);
                
                $withdraw['status'] = 1;
                $withdraw['fee'] = $withdraw_fee;
                $withdraw['txid'] = $sendrs;
                
                $rs = Db::name('user_withdraw')->update($withdraw);
                if (validateResult($rs)) {
                    Db::commit();
                    $this->success('审核转出成功');
                } else {
                    Db::rollback();
                    $this->error('转出失败');
                }
            }
        }
    }

    /**
     * 虚拟币转入记录
     */
    public function recharge($page = 1)
    {
        $recharge_model = new UserRecharge();
        $user_model = new User();
        $recharges = $recharge_model->order([
            'id' => 'DESC'
        ])->paginate(15, false, [
            'page' => $page
        ]);
        foreach ($recharges as $recharge) {
            $recharge['username'] = $user_model->field('username')->find($recharge['userid'])['username'];
        }
        return $this->fetch('recharge', [
            'recharge_list' => $recharges
        ]);
    }
    
    /*
     * public function recharge_update($id, $status)
     * {
     * // 转入手动确认
     * }
     */
}