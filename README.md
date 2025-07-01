# Open Mini Duck手搓

## 流程综述

### [placo](https://github.com/Rhoban/placo)(PlaCo is Rhoban's planning and control library)：生成步态相关参数的库

### [Open Duck Reference Motion Generator](https://github.com/apirrone/Open_Duck_reference_motion_generator)：使用placo，生成polynomial_coefficients.pkl用于后续训练
  - Generate motions（This will write in a directory called `recordings/`）
  ```bash
  uv run scripts/auto_waddle.py (-j?) --duck ["go_bdx", "open_duck_mini", "open_duck_mini_v2"] (--num <> / --sweep) --output_dir <>
  ```
	
  > 从`auto_waddle.py`源码中看到加载的参数文件和文件夹有`/open_duck_reference_motion_generator/robots/{args.duck}/auto_gait.json`和`/open_duck_reference_motion_generator/robots/{args.duck}/placo_presets`
  
  > 从`auto_waddle.py`源码中看到有调用`/open_duck_reference_motion_generator/gait_generator.py`去生成步态数据
  
  > 从`auto_waddle.py`源码中出现的`Generate AMP walking animations`中的`AMP`是Adversarial Motion Prior的缩写，是一种结合了对抗性学习和物理模拟的技术，主要用于生成自然和生动的物理角色动画。AMP通过一个训练好的判别器来指导策略学习，该判别器能够区分模拟角色的动作和参考运动数据集中的动作，从而为角色的动作提供风格奖励。这种方法不需要手动设计的模仿目标或者动作选择机制，也不需要对数据集进行任务特定的注释或分割‌。
  - Fit polynomials（This will generate `polynomial_coefficients.pkl` from data in `recordings/`）
  ```
  uv run scripts/fit_poly.py --ref_motion recordings/
  ```
### [Open Duck Playground](https://github.com/apirrone/Open_Duck_Playground)：训练和输出onnx模型（这一步是强化学习的关键步骤）
  - 添加一个新机器人，并进行配置和训练
	- Create a new directory in `playground` named after `<your robot>`. You can copy the `open_duck_mini_v2` directory as a starting point.
	- Edit `base.py`: Mainly renaming stuff to match you robot's name
	- Edit `constants.py`: specify the names of some important geoms, sensors etc
		- In your `mjcf`, you'll probably have to add some sites, name some bodies/geoms and add the sensors. Look at how we did it for `open_duck_mini_v2`
	- Add your `mjcf` assets in `xmls`. 
	- Edit `joystick.py` : to choose the rewards you are interested in
		- Note: for now there is still some hard coded values etc. We'll improve things on the way
	- Edit `runner.py` and then run it(mujoco will be lauched automatically?)
	```bash
	# in Windows(unsuccessful)
	pip install uv
	uv venv -p 3.12
	uv run playground/<robot>/runner.py #这一步还是会报You're on Windows (`win_amd64`), but `jax-cuda12-plugin` (v0.6.1) only has wheels for the following platforms: `manylinux2014_aarch64`, `manylinux2014_x86_64`; consider adding your platform to `tool.uv.required-environments` to ensure uv resolves to a version with compatible wheels
	
	# wsl2(ubuntu 22.04.5)
	conda env list
	conda create -n mujoco python=3.11
	conda activate mujoco
	pip install mujoco -i https://mirrors.aliyun.com/pypi/simple/
	git clone https://github.com/apirrone/Open_Duck_Playground.git
	cd Open_Duck_Playground
	curl -LsSf https://astral.sh/uv/install.sh | sh
	uv run playground/open_duck_mini_v2/runner.py
	
	# in linux(suppose to be ok)
	uv run playground/<robot>/runner.py 
	```
  - 在mujoco里跑onnx模型（即查看onnx模型）
  ```
  uv run playground/open_duck_mini_v2/mujoco_infer.py -o <path_to_.onnx> (-k)
  ```
  - 最新的onnx模型：[latest policy checkpoint](https://github.com/apirrone/Open_Duck_Mini/blob/v2/BEST_WALK_ONNX_2.onnx)
#### RL related stuff
  - Mujoco Playground

https://github.com/user-attachments/assets/ec04dde1-7c8b-477b-8bd8-60975ffa1930

  - Reference motion generation for imitation learning 

https://github.com/user-attachments/assets/7197f81b-ba7a-4c94-a2fc-c163c8b2312e

  - Actuator identification: We used Rhoban's [BAM: Better Actuator Models](https://github.com/Rhoban/bam)
### [Open Duck Mini Runtime](https://github.com/apirrone/Open_Duck_Mini_Runtime)：加载onnx模型，实物运行
  - onnx模型的实物加载使用：[Run the walk](https://github.com/apirrone/Open_Duck_Mini_Runtime?tab=readme-ov-file#run-the-walk-)
  - hardware
	- Raspberry Pi zero 2W
	- IMU: BNO055
	- Motor: Feetech 7.4v STS 3215
	- Charger: 2S2A(8.4V, 2A)
	  - 输入电压：DC 3-6V（推荐DC 3.7V 5V）
	  - 输入电流：1A（1A版）；2A（2A版）；4A（4A版）
	  - 充电电压：8.4V
	  - 充电电流：0.55A（1A版）；1.1A（2A版）；2.2A（4A版）
	- BMS: 7.4V(output)
	  - When charger is connected on P+/P- port( and power switch is off), it's for battery charging
	  - When charger is disconnected and power switch is on, it's for power output
	- Battery: 18650 x 2
  - OS: Raspberry Pi OS Lite (64-bit)

## Windows 10 WSL2方式安装ROS2 Humble和gazebo(mujoco可以在windows直接安装)
  - 硬件资源：RTX 5070ti 16G(NVIDIA-SMI：575.57.04，Driver version: 576.52，CUDA Version：12.9)
  - 软件环境：
    - 操作系统：Windows 10
	- WSL2安装的ubuntu系统：Ubuntu 22.04.5
	- ROS2 Humble版本：小鱼ROS
	- gazebo版本：Gazebo Classic Simulator (ROS2 Humble)，注意不是更新的Gazebo Harmonic Simulator (ROS2 Jazzy&Humble)版本
	- mujoco版本：3.3.3
	- Issac Sim及对应的Isaac Sim Assets版本：4.5.0
  - 各步骤参考：
    - [windows10 子系统Ubuntu环境安装 ROS2 humble](https://zhuanlan.zhihu.com/p/1897947859778769074)
	
	有条脚本要修订下：
	```bash
	wget http://fishros.com/install -O fishros && . fishros
	```
	- [WSL2的安装与配置（创建Anaconda虚拟环境、更新软件包、安装PyTorch、VSCode）](https://blog.csdn.net/weixin_44878336/article/details/133967607)
	- [Ubuntu 22.04（WSL2）安装Miniconda详细指南](https://juejin.cn/post/7503461855890931722)
	- [基于WSL2 & ROS2 humble上安装gazebo及调试](http://lvkedu.com.cn/detail/89)
	- [如何更改wsl2中的ubuntu默认安装位置](https://blog.csdn.net/luohaitao/article/details/147117915?fromshare=blogdetail&sharetype=blogdetail&sharerId=147117915&sharerefer=PC&sharesource=&sharefrom=from_link)
	- [mujoco](https://github.com/google-deepmind/mujoco)
	- [mujoco windows](https://mujoco.readthedocs.io/en/latest/programming/#getting-started)：直接运行windows版本的mujoco文件夹下/bin文件夹下的simulate.exe即可
	- [Issac Sim下载、安装和启动](https://docs.isaacsim.omniverse.nvidia.com/4.5.0/installation/download.html)：下载Isaac Sim包和关联资产包并设置后，解压直接运行Isaac Sim包下的isaac-sim.selector.bat

## Ubuntu 22.04.5安装Isaac Sim 4.5.0(直接上Isaac Sim 5.0 + Isaac Lab 2.2)
  - 硬件资源：RTX 5070ti 16G(NVIDIA-SMI：570.153.02，Driver version: 570.153.02，CUDA Version：12.8)
  - 软件环境：
    - 操作系统：Ubuntu 22.04.5 desktop
	- ROS2 Humble版本：小鱼ROS
	- gazebo版本：Gazebo Classic Simulator (ROS2 Humble)，注意不是更新的Gazebo Harmonic Simulator (ROS2 Jazzy&Humble)版本
	- mujoco版本：3.3.3
	- Issac Sim及对应的Isaac Sim Assets版本：[5.0](https://github.com/isaac-sim/IsaacSim?tab=readme-ov-file#quick-start)
        - Isaac Lab版本：[2.2](https://github.com/isaac-sim/IsaacLab/tree/feature/isaacsim_5_0?tab=readme-ov-file)
        ```bash
        # isaaclab install(https://isaac-sim.github.io/IsaacLab/main/source/setup/installation/pip_installation.html#installing-isaac-lab)
        conda create -n env_isaaclab python=3.10
        conda activate env_isaaclab
        pip install --upgrade --pre torch torchvision --index-url https://download.pytorch.org/whl/nightly/cu128
        ./isaaclab.sh --install  # cd isaaclab root directory
        source _isaac_sim/setup_conda_env.sh  # avoid ModuleNotFoundError: No module named 'isaacsim' error
        ./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py
        # or
        python scripts/tutorials/00_sim/create_empty.py
        ```
  - issues:
    - [GUI blur](https://forums.developer.nvidia.com/t/the-isaac-sim-gui-is-blurry/327759/11): Need to wait for the upgration of isaac sim (kit version should upper than 106.5.3, you can see the kit version in 'help'->'about'). You can try to upgrade issac sim from 4.5.0 to 5.0(not release the production version yet, you can build from github repository)?
    - [saac Sim ROS Workspace](https://docs.isaacsim.omniverse.nvidia.com/5.0.0/installation/install_ros.html#enabling-rclpy-custom-ros-2-packages-and-workspaces-with-python-3-11)
      - 先安装python 3.11
      - 执行`./build_ros.sh -d humble -v 22.04`可能下载有些包失败，直接修改对应的dockerfile（例如dockerfiles/ubuntu_22_humble_python_311_minimal.dockerfile），把python镜像源加入相应失败的下载指令后
    - [ROS on Ubuntu 20.04, No module named 'rclpy._rclpy_pybind11'](https://6fingers.me/ros-on-ubuntu-20-04-no-module-named-rclpy-_rclpy_pybind11)：切换默认的python的版本
  - [脚本记录(Isaac Sim和ROS2互相通讯，用h1跑强化学习policy)](https://docs.isaacsim.omniverse.nvidia.com/5.0.0/ros2_tutorials/tutorial_ros2_rl_controller.html#)：
  ```
# ros2 cmd init
source /opt/ros/humble/setup.bash

# ros2 cmd
ros topic list

ros2 run demo_nodes_cpp talker
ros2 run demo_nodes_py listener

# ros2 isaac sim workspace init(https://github.com/isaac-sim/IsaacSim-ros_workspaces)
source /opt/ros/humble/setup.bash
#cd repository/humble_ws, for example: ~/IsaacSim-ros_workspaces/humble_ws
cd ~/IsaacSim-ros_workspaces/humble_ws
source install/local_setup.bash
# cd the h1_fullbody_controller ROS2 package and then run the ROS2 policy
cd ~/IsaacSim-ros_workspaces/humble_ws/src/humanoid_locomotion_policy_example/h1_fullbody_controller/launch
ros2 launch h1_fullbody_controller h1_fullbody_controller.launch.py # run the ROS2 policy
  ```
  - [Isaac Sim倒入]
## 其他
  - Issac Sim导入urdf
    - [视频教程1](https://www.youtube.com/watch?v=AMfEtZ4hyLY)
      - [含urdf文件的示例项目：SO-ARM100](https://github.com/TheRobotStudio/SO-ARM100)
    - [视频教程2](https://www.youtube.com/watch?v=Ym5jav5scfA)
      - [Joint Physics: Computing Stiffness and Damping in URDF Importers](https://lycheeai-hub.com/project-so-arm101-x-isaac-sim-x-isaac-lab-tutorial-series/so-arm-import-urdf-to-isaac-sim)：带多个教程集锦，例如解释urdf导入时的刚度和阻尼参数含义。
  - Isaac Gym(RL)
    - [Installation](file:///home/jay/workspace/IsaacGym_Preview_4_Package/isaacgym/docs/install.html)
      - [python joint_monkey.py缺少libpython3.7m.so.1.0库](https://blog.csdn.net/weixin_45392674/article/details/126300556): `export LD_LIBRARY_PATH=/home/jay/miniconda3/envs/rlgpu/lib`
    - [robot project: OpenTinker-V2](https://github.com/golaced/OmniBotSeries-Tinker)
      - [开源双足机器人OpenTinker-V2，手把手制作迪士尼BDX入门强化学习！](https://www.bilibili.com/video/BV1FRZoY1ExW/?spm_id_from=333.1387.homepage.video_card.click)
      - [feishu document](https://hcn64ij2s2xr.feishu.cn/wiki/AZJxwlvEpiWnRrkeBbGc21U9n7f)
      - [error: undefined symbol: iJIT_NotifyEvent --- downgrade the mkl](https://blog.csdn.net/mr_hore/article/details/138961434): `pip install mkl=2024.0`

## Issues记录
  - Issac Sim导入open mini duck的urdf时，报accessed invalid null prim（未解决）
  - playground运行runner报错：jaxlib._jax.XlaRuntimeError：[已解决，更改pyproject.toml中nvidia-cublas-cu12的版本](https://github.com/apirrone/Open_Duck_Playground/issues/15#issuecomment-2945798975)
  - playground运行runner下载包超时：[已解决，设置clash的tun模式，见链接的评论区](https://zhuanlan.zhihu.com/p/153124468)
  - playground运行runner报错：'cuModuleLoadData(&module, data)' failed with 'CUDA_ERROR_INVALID_PTX'（未解决，[链接1](https://github.com/tensorflow/tensorflow/issues/90291) [链接2](https://github.com/tensorflow/tensorflow/issues/89272)）
