# Open Mini Duck手搓

## 流程综述
 - [placo](https://github.com/Rhoban/placo)(Planning & Control)：生成步态
 - [Open Duck Reference Motion Generator](https://github.com/apirrone/Open_Duck_reference_motion_generator)：生成polynomial_coefficients.pkl用于后续训练
	- Generate motions（This will write in a directory called `recordings/`）
	```bash
	uv run scripts/auto_waddle.py (-j?) --duck ["go_bdx", "open_duck_mini", "open_duck_mini_v2"] (--num <> / --sweep) --output_dir <>
	```
	从auto_waddle.py中看到加载的参数文件和文件夹有`/open_duck_reference_motion_generator/robots/{args.duck}/auto_gait.json`和`/open_duck_reference_motion_generator/robots/{args.duck}/placo_presets`
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