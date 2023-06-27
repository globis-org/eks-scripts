# eks-ssm-agent-container
**注意: このリポジトリは、Public Repositoryです。機密情報は含めないでください。**

このリポジトリには、AWS Systems Managerエージェントをコンテナで実行するためのシェルスクリプトおよびDockerfileにおける使用例が含まれています。

これにより、AWS Systems Managerを使用してコンテナにアクセスすることができます。

## 説明
- AWS Systems Managerエージェントをコンテナで実行します。
- AWS Systems Managerを使用して、コンテナにアクセスします。
- サンプルとしてDebianベースとAmazon Linuxベースのコンテナ用のDockerfileが格納されています。

## 使用方法
2つの環境変数が必要となります。

|  環境変数名  |  説明  |
| ---- | ---- |
|  BASTION_ROLE_NAME  |  管理対象ノードに割り当てるIAMロールの名前。<br>詳細は[公式ドキュメント](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html)を確認してください。  |
|  BASTION_INSTANCE_NAME  |  管理対象ノードの名前。  |

## License
このプロジェクトは [MIT License](https://github.com/globis-org/eks-ssm-agent-container/blob/main/LICENSE) に基づいています。
