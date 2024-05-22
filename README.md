# Class-test

**注：本仓库仅用于测试**

项目结构

```shell
.
├── exercises //所有习题都在此文件夹下
├── LICENSE
├── Makefile 
├── README.en.md
├── README.md
└── test //所有测例都在此文件夹下
```

本地测试

```makefile
make test-output
```

会对所有题目进行测试。

生成测例

```makefile
make generate-test-cases
```

生成测例前请确保 exercises 目录下的题目代码均已完成且正确。

运行此会构建所有题目代码，并将其标准输出保存在 test 目录下。

测试并保存结果

```makefile
mkdir build
make save-test-results 
```

运行此会创建 build 目录，并在 build 目录下生成 test_results.json 文件保存测试结果。

该文件格式如下：

```json
{
  "channel": "gitee",//提交渠道
  "courseId": 1558,//课程ID
  "ext": "aaa",
  "name": "xukunyuan-star",//提交者信息
  "score": 5,//提交者当前分数
  "totalScore": 100//当前实验总分
  }

```

在线的自动测试会在每次向仓库提交内容后自动运行，测试结果可以流水线页面查阅。

