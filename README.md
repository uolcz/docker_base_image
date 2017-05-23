# UOL Ruby imaged used for GitLab CI

## Building the container

1. clone repository

```
git clone https://github.com/ucetnictvi-on-line/docker_base_image.git
```

2. jump into it

```
cd docker_base_image
```

3. run docker build:

```
docker build -t uolcz/ruby .
```

## Enter built container

You have to build it first :)

1. run container

```
docker run -it -d uolcz/ruby
```

2. check out container ID

```
docker ps


CONTAINER ID        IMAGE               COMMAND             CREATED          STATUS              PORTS               NAMES
785d4e1ff4d1        uolcz/ruby          "bash"              3 seconds ago    Up 2 seconds                            elated_colden
```
3. run e.x. bash inside container (using container ID from above)

```
docker exec -it 785d4e1ff4d1 bash
```

4. run to kill the running container (also using container ID from above)

```
docker kill 785d4e1ff4d1
```
