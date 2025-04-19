# Como rodar o código?

## Buildar a imagem do projeto

```bash
    docker build -t lp_app .
```

## Rodar o script

```bash
docker run --rm -v $(pwd)/src:/app/src lp_app
```
