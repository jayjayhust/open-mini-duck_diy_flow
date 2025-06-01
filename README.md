# Open Mini Duck手搓

## 流程综述
 - [placo](https://github.com/Rhoban/placo)(Planning & Control)：生成步态
 - [Open Duck Reference Motion Generator](https://github.com/apirrone/Open_Duck_reference_motion_generator)：生成polynomial_coefficients.pkl用于后续训练
 - [Open Duck Playground](https://github.com/apirrone/Open_Duck_Playground)：训练和输出onnx模型
	- 在mujoco里跑onnx模型（即查看onnx模型）
	```
	uv run playground/open_duck_mini_v2/mujoco_infer.py -o <path_to_.onnx> (-k)
	```
	- 最新的onnx模型[latest policy checkpoint](https://github.com/apirrone/Open_Duck_Mini/blob/v2/BEST_WALK_ONNX_2.onnx)
 - [Open Duck Mini Runtime](https://github.com/apirrone/Open_Duck_Mini_Runtime)：加载onnx模型，实物运行