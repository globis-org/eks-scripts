# eks-scripts
**注意: このリポジトリは、Public Repositoryです。機密情報は含めないでください。**

## Kustomize

Kustomizeの共通設定を格納しています。

### Rollout Integration

RolloutをKustomizeに正しく認識させるための設定をcomponentsとして切り出しています。

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - rollout.yaml

components:
  - https://github.com/globis-org/eks-scripts/kustomize/rollout-integration?ref=main
```

## SSM Agent

AWS Systems Managerエージェントをコンテナで実行するためのシェルスクリプト（`ssm-agent.sh`）が含まれています。

これにより、AWS Systems Managerを使用してコンテナにアクセスすることができます。

### 説明
- AWS Systems Managerエージェントをコンテナで実行します。
- AWS Systems Managerを使用して、コンテナにアクセスします。
- 各プロダクトのコンテナイメージから `ssm-agent.sh` を取り込んで使用します（下記「Dockerfileでの使用例」を参照）。

### 使用方法
2つの環境変数が必要となります。加えて、任意で以下の環境変数を指定できます。

|  環境変数名  |  説明  |
| ---- | ---- |
|  BASTION_ROLE_NAME  |  管理対象ノードに割り当てるIAMロールの名前。<br>詳細は[公式ドキュメント](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html)を確認してください。  |
|  BASTION_INSTANCE_NAME  |  管理対象ノードの名前。  |
|  PRODUCT  |  (任意) 指定するとアクティベーションに `Product=<値>` タグを付与し、登録されるマネージドノードに継承される。未指定なら従来どおりタグなし。  |

### Dockerfileでの使用例

`ssm-agent.sh` は AWS CLI、`jq`、`pgrep`（procps）、SSM Agent を使用します。これらをインストールしたイメージに `ssm-agent.sh` を追加し、起動コマンドに指定します。

```Dockerfile
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf install -y amazon-ssm-agent aws-cli jq procps

ADD https://raw.githubusercontent.com/globis-org/eks-scripts/main/ssm-agent.sh /usr/local/bin/ssm-agent.sh
RUN chmod +x /usr/local/bin/ssm-agent.sh

ENV AWS_DEFAULT_REGION=ap-northeast-1

WORKDIR /opt/amazon/ssm/
CMD ["/usr/local/bin/ssm-agent.sh"]
```

## License
このプロジェクトは [MIT License](https://github.com/globis-org/eks-ssm-agent-container/blob/main/LICENSE) に基づいています。
