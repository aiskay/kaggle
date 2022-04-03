This is the base image for kaggle competitions on Linux with

- miniconda 
- Visual Studio Code

I use `flake8` as the python linter referencing [2021年Python開発リンター導入のベストプラクティス](https://zenn.dev/yhay81/articles/yhay81-202102-pythonlint).

# Usage

- `kaggle-api`  
To use [kaggle-api](https://github.com/Kaggle/kaggle-api), create `kaggle.json` in `.kaggle` directory following the official instructions.
- GitHub connection  
To push codes to GitHub with ssh in this image, save public and private keys in `.ssh`.
- competition directory  
All competition codes should be in the directory `competitions` which is mounted to the VSCode default workspace folder (see  `workspaceMount` and `workspaceFolder` in `devcontainer.json`).

**References**

- https://hub.docker.com/r/continuumio/miniconda3
- https://github.com/sorin-ionescu/prezto
- [Linting Python in Visual Studio Code](https://code.visualstudio.com/docs/python/linting)
- [シェルの変数展開](https://qiita.com/bsdhack/items/597eb7daee4a8b3276ba)
- [コマンドを組み合わせて実行する方法「;」「&&」「||」](https://news.mynavi.jp/techplus/article/20181126-728704/)