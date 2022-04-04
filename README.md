This is the base image for kaggle competitions on Linux with

- miniconda 
- Visual Studio Code

I use `flake8` as the python linter referencing [2021年Python開発リンター導入のベストプラクティス](https://zenn.dev/yhay81/articles/yhay81-202102-pythonlint).

# Usage

- `kaggle-api`  
To use [kaggle-api](https://github.com/Kaggle/kaggle-api), create `kaggle.json` in `.kaggle` directory following the official instructions.
- GitHub connection  
Remote-Containers extension automatically out of box support for using local Git credentials from inside a container. See and follow [Sharing Git credentials with your container](https://code.visualstudio.com/docs/remote/containers#_sharing-git-credentials-with-your-container) to communicate to GitHub with ssh.
- competition directory  
All competition codes should be in the directory `competitions` which is mounted to the VSCode default workspace folder (see  `workspaceMount` and `workspaceFolder` in `devcontainer.json`).

**References**

- https://hub.docker.com/r/continuumio/miniconda3
- https://github.com/sorin-ionescu/prezto
- [Linting Python in Visual Studio Code](https://code.visualstudio.com/docs/python/linting)
- [シェルの変数展開](https://qiita.com/bsdhack/items/597eb7daee4a8b3276ba)
- [コマンドを組み合わせて実行する方法「;」「&&」「||」](https://news.mynavi.jp/techplus/article/20181126-728704/)
- [Add a non-root user to a container](https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user)
- [Dockerfile reference - USER](https://docs.docker.com/engine/reference/builder/#user)