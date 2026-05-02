# Code Showcase

*Author: 0-0000*

---

> This is a collection of advanced projects for Forts, which comprehensively utilizes Forts mechanisms to achieve various functions and provides specific implementation examples that can be directly verified in the game(just load it as a mod).

## Projects

Each project `$p$`'s codes are in `projects/$p$` directory.

### LaserDamageScaler

A pair of example weapons which can spawn an area amplify or dampen lasers quantitatively at the pointed position.

#### Main Mechanism

1. (dlc2)Beam Block, the quantitative effects of `Block`.

2. Trigger `Age` at the pointed position 1:1 and spawn a still projectile.

### NonLinearFalloff

A pair of example weapons whose splash damage and force falloff non-linearly.

#### Main Mechanism

1. Use several linear falloff to fit a custom falloff.

### StructureBombPlacement

Two weapons which can place explosive barrels in the hitted structure, one place one randomly, the other fully fill it.

#### Main Mechanism

1. Place devices in dynamic scripts.

2. Enum all links in a structure. And randomly select a expected link with the linear complexity worst.

---

> 这是一个 Forts "高级代码"集合，综合运用了 Forts 机制实现各种功能，并提供了可直接在游戏中验证的具体实现样例（只需将其作为模组加载即可）。

## 项目

每个项目 `$p$` 所用代码分装在 `projects/$p$` 文件夹下。

### LaserDamageScaler

创建了一组样例武器，分别在指定位置创建定量增幅/削弱激光的区域。

#### 主要机制

1. (dlc2)激光阻挡机制，`Block`效果的定量计算

2. 在武器发射区域的 1:1 指定位置触发 `Age` 并生成静止弹射物

### NonLinearFalloff

创建了一组样例武器，其弹射物爆炸的范围伤害和冲击力以非线性形式衰减。

#### 主要机制

1. 用多个线性衰减的叠加拟合非线性衰减

### StructureBombPlacement

创建了两个可以给命中结构放置炸药桶装置的武器，一个会随机放置一个，一个会完全塞满。

#### 主要机制

1. 在动态脚本中放置装置

2. 枚举结构所有连接，最坏线性复杂度地随机选取可用连接
