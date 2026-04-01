# langchain-agent-template
A template for creating langchain agents with assistance for installing dependencies. It will focus on running the llms locally for development purposes. Supports Mac Darwin and WSL on Windows

## Installing
To install run:
```
make install
```

Will install python3.13, ollama, a small llm(qwen3.52b) and the necessary python dependencies. It will create a virtual python environment to prevent breakage of any system version of python.

# Different llms
You may want to try a different model. The model included qwen3.5:2b is small(2.7gb) and lightweight, with support for calling tools but you might be happy with a larger and more capable one because you have cpu or disk to burn.

Ollama [publish a large list of models](https://ollama.com/search) that are open source and available to use.

For example, if we wanted to use openai's oss version of chatgpt, because we have a spare 14gb of disk, we could run:
```
ollama pull gpt-oss
```

Or we could go for a beefier version of qwen3.5 with:
```
ollama pull qwen3.5:9b
```

The :2b/:9b refer to the number of variables the model uses. The higher the number, the larger the model. It may reason better but will take more disk and cpu cycles to get a result.

To list all installed models run: 
```
ollama list
```

To remove a model run:
```
ollama rm <MODEL_NAME>
```

## Uninstall
To uninstall run:
```
make uninstall
```

Will remove the created python virtual environment, the qwen llm and ollama but will leave python3.13 in case it was already available and needed by other services.
