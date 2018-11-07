# WMScheduler
活用category的组件通信框架

对组件通信的思考。 使用category的方式实现 方法粒度的组件通信方，
主要内容是demo + 框架代码。  更想突出的是demo的实际操作。

**建议将仓库克隆后，分别打开两个文件夹下的workspace来查看两种组件通信代码的具体使用方法。**


### iOS Category功能简介

Category 是 Objective-C 2.0之后添加的语言特性。

> Category 就是对装饰模式的一种具体实现。它的主要作用是在不改变原有类的前提下，动态地给这个类添加一些方法。在 Objective-C（iOS 的开发语言，下文用 OC 代替）中的具体体现为：实例（类）方法、属性和协议。

除了引用中提到的添加方法，Category 还有很多优势，比如将一个类的实现拆分开放在不同的文件内，以及可以声明私有方法，甚至可以模拟多继承等操作，具体可参考官方文档[Category](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Category.html#//apple_ref/doc/uid/TP40008195-CH5-SW1)。

若 Category 添加的方法是基类已经存在的，则会覆盖基类的同名方法。本仓库将要提到的组件间通信都是基于这个特性实现的

### 组件通信的背景
随着移动互联网的快速发展，不断迭代的移动端工程往往面临着耦合严重、维护效率低、开发不够敏捷等常见问题，因此越来越多的公司开始推行“组件化”，通过解耦重组组件来提高并行开发效率。

但是大多数团队口中的“组件化”就是把代码分库，主工程使用 CocoaPods 工具把各个子库的版本号聚合起来。但能合理的把组件分层，并且有一整套工具链支撑发版与集成的公司较少，导致开发效率很难有明显地提升。

处理好各个组件之间的通信与解耦一直都是组件化的难点。诸如组件之间的 Podfile 相互显式依赖，以及各种联合发版等问题，若处理不当可能会引发“灾难”性的后果。

目前做到 ViewController （指iOS中的页面，下文用VC代替）级别解耦的团队较多，维护一套 mapping 关系并使用 scheme 进行跳转，但是目前仍然无法做到更细粒度的解耦通信，依然满足不了部分业务的需求。

### 实际业务案例

例1：外卖的首页的商家列表（WMPageKit），在进入一个商家（WMRestaurantKit）选择5件商品返回到首页的时候，对应的商家cell需要显示已选商品“5”。

例2：搜索结果（WMSearchKit）跳转到商超的容器页（WMSupermarketKit），需要传递一个通用Domain（也有的说法叫模型、Model、Entity、Object等等，下文统一用Domain表示）。

例3：做一键下单需求（WMPageKit），需要调用下单功能的一个方法（WMOrderKit）入参是一个订单相关 Domain 和一个 VC，不需要返回值。

这几种场景基本涵盖了组件通信所需的的基本功能，那么怎样才可以实现最优雅的解决方案？

很容易想到的应对方案有三种，第一是拷贝共同依赖代码，第二是直接依赖，第三是下沉公共依赖。

对于方案一，会维护多份冗余代码，逻辑更新后代码不同步，显然是不可取的。对于方案二，对于调用方来说，会引入较多无用依赖，且可能造成组件间的循环依赖问题，导致组件无法发布。对于方案三，其实是可行解，但是开发成本较大。对于下沉出来的组件来说，其实很难找到一个明确的定位，最终沦为多个组件的“大杂烩”依赖，从而导致严重的维护性问题。

那如何解决这个问题呢？根据面向对象设计的五大原则之一的“依赖倒置原则”（Dependency Inversion Principle），高层次的模块不应该依赖于低层次的模块，两者（的实现）都应该依赖于抽象接口。推广到组件间的关系处理，对于组件间的调用和被调用方，从本质上来说，我们也需要尽量避免它们的直接依赖，而希望它们依赖一个公共的抽象层，通过架构工具来管理和使用这个抽象层。这样我们就可以在解除组件间在构建时不必要的依赖，从而优雅地实现组件间的通讯。

<center><image src="img/1-1.png"/></center>

此仓库提供的两种组件通信方案：

#### Category+NSInvocation

UML图
<center><image src="img/3-1.png"/></center>

这个方案将其对 NSInvocation 功能容错封装、参数判断、类型转换的代码写在下层，提供简易万能的接口。并在上层创建通信调度器类提供常用接口，在调度器的的 Category 里扩展特定业务的专用接口。所有的上层接口均有规范约束，这些规范接口的内部会调用下层的简易万能接口即可通过NSInvocation 相关的硬编码操作调用任何方法。

核心代码在：[WMSchedulerCore 类](https://github.com/dsxNiubility/WMScheduler/blob/master/CategoryInvocation/Pods/WMPlatformPKit/Classes/WMSchedulerCore/WMSchedulerCore.m)
（因为这个类仅在这种方案下才需要使用，所以就没有提到仓库的最外部了，避免歧义）
<center><image src="img/3-2.png"/></center>


#### CategoryCoverOrigin

UML图
<center><image src="img/4-1.png"/></center>

首先说明下这个方案和 NSInvocation 没有任何关系，此方案与上一方案也是完全不同的两个概念，不要将上一个方案的思维带到这里。

此方案的思路是在平台层的 WMScheduler.h 提供接口方法，接口的实现只写空实现或者兜底实现（兜底实现中可根据业务场景在 Debug 环境下增加 toast 提示或断言），上层库的提供方实现接口方法并通过 Category 的特性，在运行时进行对基类同名方法的替换。调用方则正常调用平台层提供的接口。在 CategoryCoverOrigin 的方案中 WMScheduler 的 Category 在提供方仓库内部，因此业务逻辑的依赖可以在仓库内部使用常规的OC调用。

<center><image src="img/4-2.png"/></center>

