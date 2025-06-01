# Open Mini Duck手搓

## 流程综述
- [placo](https://github.com/Rhoban/placo)(PlaCo is Rhoban's planning and control library)：生成步态相关参数的库
- [Open Duck Reference Motion Generator](https://github.com/apirrone/Open_Duck_reference_motion_generator)：利用步态参数生成的库placo，生成polynomial_coefficients.pkl用于后续训练
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
- [Open Duck Playground](https://github.com/apirrone/Open_Duck_Playground)：训练和输出onnx模型
  - 在mujoco里跑onnx模型（即查看onnx模型）
  ```
  uv run playground/open_duck_mini_v2/mujoco_infer.py -o <path_to_.onnx> (-k)
  ```
  - 最新的onnx模型：[latest policy checkpoint](https://github.com/apirrone/Open_Duck_Mini/blob/v2/BEST_WALK_ONNX_2.onnx)
- [Open Duck Mini Runtime](https://github.com/apirrone/Open_Duck_Mini_Runtime)：加载onnx模型，实物运行
  - onnx模型的实物加载使用：[Run the walk](https://github.com/apirrone/Open_Duck_Mini_Runtime?tab=readme-ov-file#run-the-walk-)
	