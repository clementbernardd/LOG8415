# TP 2 


## Setup 

The Dockerfile allows to launch java and hadoop inside the Docker. 

To build the image, please use : 

```
docker build -t log8415_tp2 .
```

And to run an image, use : 

```
docker run -it -p 50070:50070 -p 9000:9000   log8415_tp2 /bin/bash
```




